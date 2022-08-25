/*#####
	Querry for extracting customers data -> dimCustomers
####*/
SELECT
	MC.[CustomerID]
	,MC.[CustomerName]
	,PC.[CustomerName] [ParentCompany]
	,CC.[CustomerCategoryName] [CustomerCategory]
	,MC.[DeliveryCityID]
	,MC.[PostalCityID]
	,MC.[DeliveryAddressLine1]
	,MC.[DeliveryAddressLine2]
	,MC.[DeliveryPostalCode]
	--,MC.[DeliveryLocation]
	,MC.[PostalAddressLine1]
	,MC.[PostalAddressLine2]
	,MC.[PostalPostalCode]
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
SELECT * FROM Purchasing.PurchaseOrderLines
SELECT * FROM Purchasing.SupplierTransactions
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