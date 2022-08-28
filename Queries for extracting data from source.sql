USE WorldWideImporters
GO

/*#######################################################################
						First data extraction
#######################################################################*/

/*#####
	Querry for extracting customers data -> dimCustomers
####*/

SELECT
	MC.[CustomerID]
	,MC.[CustomerName]
	,PC.[CustomerName] [ParentCompany]
	,CC.[CustomerCategoryName] [CustomerCategory]
FROM Sales.Customers MC
JOIN Sales.Customers PC
	ON MC.BillToCustomerID = PC.CustomerID
JOIN Sales.CustomerCategories CC
	ON MC.CustomerCategoryID = CC.CustomerCategoryID


/*####
	Querry for extracting sale data -> factSale
####*/
SELECT 
	I.InvoiceID,
	I.CustomerID,
	I.SalespersonPersonID,
	C.DeliveryCityID 'LocationID',
	I.InvoiceDate,
	O.OrderDate,
	O.ExpectedDeliveryDate,
	I.ConfirmedDeliveryTime,
	IL.StockItemID,
	IL.Quantity,
	IL.UnitPrice,
	IL.TaxAmount,
	IL.LineProfit
FROM Sales.Invoices I
JOIN Sales.InvoiceLines IL
	ON I.InvoiceID = IL.InvoiceID
JOIN Sales.Orders O
	ON I.OrderID = O.OrderID
JOIN Sales.Customers C
	ON I.CustomerID = C.CustomerID

/*####
	Querry for extracting employee data -> dimEmployee
####*/

SELECT 
	PersonID,
	FullName,
	IsSalesperson
FROM Application.People
WHERE IsEmployee = 1


/*####
	Querry for extracting location data -> dimLocation
####*/
SELECT 
	C.CityID 'LocationID',
	C.CityName,
	SP.StateProvinceName,
	SP.SalesTerritory,
	CO.CountryName,
	CO.Continent,
	CO.Region,
	CO.Subregion
FROM Application.Cities C
JOIN Application.StateProvinces SP
	ON C.StateProvinceID = SP.StateProvinceID
JOIN Application.Countries CO
	ON SP.CountryID = CO.CountryID


/*####
	Querry for extracting stock items data -> dimStockItem
####*/

SELECT 
	SI.StockItemID,
	SI.StockItemName,
	C.ColorName,
	PT.PackageTypeName 'UnitPackage',
	PTO.PackageTypeName 'OuterPackage',
	SI.Size
FROM Warehouse.StockItems SI
LEFT JOIN Warehouse.Colors C
	ON SI.ColorID = C.ColorID
JOIN Warehouse.PackageTypes PT
	ON SI.UnitPackageID = PT.PackageTypeID
	JOIN Warehouse.PackageTypes PTO
	ON SI.OuterPackageID = PTO.PackageTypeID


/*####
	Querry for extracting suppliers data -> dimSuppliers
####*/

SELECT
	S.SupplierID,
	S.SupplierName,
	SC.SupplierCategoryName,
	S.PaymentDays
FROM Purchasing.Suppliers S
JOIN Purchasing.SupplierCategories SC
	ON S.SupplierCategoryID = SC.SupplierCategoryID


/*####
	Querry for extracting purchase data -> factPurchase
####*/

SELECT
	ST.SupplierTransactionID 'PurchaseID',
	ST.SupplierID,
	PO.OrderDate 'PurchaseDate',
	PO.ExpectedDeliveryDate,
	POL.StockItemID,
	POL.OrderedOuters 'QuantityOrdered',
	POL.ReceivedOuters 'QuantityReceived',
	ST.AmountExcludingTax,
	ST.TaxAmount,
	ExpectedUnitPricePerOuter,
	PO.IsOrderFinalized
FROM Purchasing.SupplierTransactions ST
JOIN Purchasing.PurchaseOrders PO
	ON ST.PurchaseOrderID = PO.PurchaseOrderID
JOIN Purchasing.PurchaseOrderLines POL
	ON PO.PurchaseOrderID = POL.PurchaseOrderID



/*#################################################################
						Next data extractions
#################################################################*/

/*#####
	Querry for extracting customers data -> dimCustomers
####*/

DECLARE 
	@fromLSN binary(10) = sys.fn_cdc_get_min_lsn('Sales_Customers'), 
	@toLSN binary(10) = sys.fn_cdc_get_max_lsn()

SELECT 
	MC.[CustomerID]
	,MC.[CustomerName]
	,PC.[CustomerName] [ParentCompany]
	,CC.[CustomerCategoryName] [CustomerCategory]
FROM cdc.fn_cdc_get_all_changes_Sales_Customers(@fromLSN, @toLSN, N'all') MC
JOIN Sales.Customers PC
	ON MC.BillToCustomerID = PC.CustomerID
JOIN Sales.CustomerCategories CC
	ON MC.CustomerCategoryID = CC.CustomerCategoryID
GO  


/*####
	Querry for extracting sale data -> factSale
####*/
DECLARE 
	@fromLSN binary(10) = sys.fn_cdc_get_min_lsn('Sales_Invoices'), 
	@toLSN binary(10) = sys.fn_cdc_get_max_lsn()

SELECT 
	I.InvoiceID,
	I.CustomerID,
	I.SalespersonPersonID,
	C.DeliveryCityID 'LocationID',
	I.InvoiceDate,
	O.OrderDate,
	O.ExpectedDeliveryDate,
	I.ConfirmedDeliveryTime,
	IL.StockItemID,
	IL.Quantity,
	IL.UnitPrice,
	IL.TaxAmount,
	IL.LineProfit
FROM cdc.fn_cdc_get_all_changes_Sales_Invoices(@fromLSN, @toLSN, N'all') I
JOIN Sales.InvoiceLines IL
	ON I.InvoiceID = IL.InvoiceID
JOIN Sales.Orders O
	ON I.OrderID = O.OrderID
JOIN Sales.Customers C
	ON I.CustomerID = C.CustomerID
GO

/*####
	Querry for extracting employee data -> dimEmployee
####*/
DECLARE 
	@fromLSN binary(10) = sys.fn_cdc_get_min_lsn('Application_People'), 
	@toLSN binary(10) = sys.fn_cdc_get_max_lsn()

SELECT 
	PersonID,
	FullName,
	IsSalesperson
FROM cdc.fn_cdc_get_all_changes_Application_People(@fromLSN, @toLSN, N'all') 
WHERE IsEmployee = 1
GO

/*####
	Querry for extracting location data -> dimLocation
####*/
DECLARE 
	@fromLSN binary(10) = sys.fn_cdc_get_min_lsn('Application_Cities'), 
	@toLSN binary(10) = sys.fn_cdc_get_max_lsn()

SELECT 
	C.CityID 'LocationID',
	C.CityName,
	SP.StateProvinceName,
	SP.SalesTerritory,
	CO.CountryName,
	CO.Continent,
	CO.Region,
	CO.Subregion
FROM cdc.fn_cdc_get_all_changes_Application_Cities(@fromLSN, @toLSN, N'all')  C
JOIN Application.StateProvinces SP
	ON C.StateProvinceID = SP.StateProvinceID
JOIN Application.Countries CO
	ON SP.CountryID = CO.CountryID
GO

/*####
	Querry for extracting stock items data -> dimStockItem
####*/
DECLARE 
	@fromLSN binary(10) = sys.fn_cdc_get_min_lsn('Warehouse_StockItems'), 
	@toLSN binary(10) = sys.fn_cdc_get_max_lsn()

SELECT 
	SI.StockItemID,
	SI.StockItemName,
	C.ColorName,
	PT.PackageTypeName 'UnitPackage',
	PTO.PackageTypeName 'OuterPackage',
	SI.Size
FROM cdc.fn_cdc_get_all_changes_Warehouse_StockItems(@fromLSN, @toLSN, N'all') SI
LEFT JOIN Warehouse.Colors C
	ON SI.ColorID = C.ColorID
JOIN Warehouse.PackageTypes PT
	ON SI.UnitPackageID = PT.PackageTypeID
	JOIN Warehouse.PackageTypes PTO
	ON SI.OuterPackageID = PTO.PackageTypeID
GO

/*####
	Querry for extracting suppliers data -> dimSuppliers
####*/
DECLARE 
	@fromLSN binary(10) = sys.fn_cdc_get_min_lsn('Purchasing_Suppliers'), 
	@toLSN binary(10) = sys.fn_cdc_get_max_lsn()

SELECT
	S.SupplierID,
	S.SupplierName,
	SC.SupplierCategoryName,
	S.PaymentDays
FROM cdc.fn_cdc_get_all_changes_Purchasing_Suppliers(@fromLSN, @toLSN, N'all') S
JOIN Purchasing.SupplierCategories SC
	ON S.SupplierCategoryID = SC.SupplierCategoryID
GO

/*####
	Querry for extracting purchase data -> factPurchase
####*/
DECLARE 
	@fromLSN binary(10) = sys.fn_cdc_get_min_lsn('Purchasing_SupplierTransactions'), 
	@toLSN binary(10) = sys.fn_cdc_get_max_lsn()

SELECT
	ST.SupplierTransactionID 'PurchaseID',
	ST.SupplierID,
	PO.OrderDate 'PurchaseDate',
	PO.ExpectedDeliveryDate,
	POL.StockItemID,
	POL.OrderedOuters 'QuantityOrdered',
	POL.ReceivedOuters 'QuantityReceived',
	ST.AmountExcludingTax,
	ST.TaxAmount,
	ExpectedUnitPricePerOuter,
	PO.IsOrderFinalized
FROM cdc.fn_cdc_get_all_changes_Purchasing_SupplierTransactions(@fromLSN, @toLSN, N'all') ST
JOIN Purchasing.PurchaseOrders PO
	ON ST.PurchaseOrderID = PO.PurchaseOrderID
JOIN Purchasing.PurchaseOrderLines POL
	ON PO.PurchaseOrderID = POL.PurchaseOrderID

