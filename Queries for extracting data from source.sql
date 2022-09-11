USE WorldWideImporters
GO

/*#######################################################################
						First data extraction
#######################################################################*/

/*#####
	Querry for extracting customers data -> dimCustomers
####*/

SELECT
	MC.CustomerID
	,MC.CustomerName
	,PC.CustomerName [ParentCompany]
	,CC.CustomerCategoryName [CustomerCategory]
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
	C.DeliveryCityID [LocationID],
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
	C.CityID [LocationID],
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
	PT.PackageTypeName [UnitPackage],
	PTO.PackageTypeName [OuterPackage],
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
	ST.SupplierTransactionID [PurchaseID],
	ST.SupplierID,
	PO.OrderDate [PurchaseDate],
	PO.ExpectedDeliveryDate,
	POL.StockItemID,
	POL.OrderedOuters [QuantityOrdered],
	POL.ReceivedOuters [QuantityReceived],
	ST.AmountExcludingTax,
	ST.TaxAmount,
	ExpectedUnitPricePerOuter,
	PO.IsOrderFinalized
FROM Purchasing.SupplierTransactions ST
JOIN Purchasing.PurchaseOrders PO
	ON ST.PurchaseOrderID = PO.PurchaseOrderID
JOIN Purchasing.PurchaseOrderLines POL
	ON PO.PurchaseOrderID = POL.PurchaseOrderID



GO
/*#################################################################
						Next data extractions
#################################################################*/

/*#####
	Querry for extracting customers data -> dimCustomers
####*/

CREATE OR ALTER PROCEDURE dimCustomersIncremental (
	@fromDate DATETIME,
	@toDate DATETIME
)
AS
BEGIN
	DECLARE
		@fromLSN BINARY(10) = sys.fn_cdc_map_time_to_lsn('smallest greater than', @fromDate),
		@toLSN BINARY(10) = sys.fn_cdc_map_time_to_lsn('largest less than or equal', @toDate)

	IF @fromLSN IS NULL OR @toLSN IS NULl
	BEGIN
		SELECT DISTINCT
			MC.[CustomerID],
			MC.[CustomerName],
			PC.[CustomerName] [ParentCompany],
			CC.[CustomerCategoryName] [CustomerCategory],
			0 [IsDeleted]
		FROM Sales.Customers MC
		JOIN Sales.Customers PC
			ON MC.BillToCustomerID = PC.CustomerID
		JOIN Sales.CustomerCategories CC
			ON MC.CustomerCategoryID = CC.CustomerCategoryID
		WHERE 0=1
	END
	ELSE
		SELECT DISTINCT
			MC.[CustomerID],
			MC.[CustomerName],
			PC.[CustomerName] [ParentCompany],
			CC.[CustomerCategoryName] [CustomerCategory],
			CASE
				WHEN __$operation = 1 THEN 1
				ELSE 0
			END [IsDeleted]
		FROM cdc.fn_cdc_get_net_changes_Sales_Customers(@fromLSN, @toLSN, 'all') MC
		JOIN Sales.Customers PC
			ON MC.BillToCustomerID = PC.CustomerID
		JOIN Sales.CustomerCategories CC
			ON MC.CustomerCategoryID = CC.CustomerCategoryID
END
GO 

/*####
	Querry for extracting sale data -> factSale
####*/
CREATE OR ALTER PROCEDURE factSalesIncremental (
	@fromDate DATETIME,
	@toDate DATETIME
)
AS
BEGIN
	DECLARE
		@fromLSN BINARY(10) = sys.fn_cdc_map_time_to_lsn('smallest greater than', @fromDate),
		@toLSN BINARY(10) = sys.fn_cdc_map_time_to_lsn('largest less than or equal', @toDate)
	
	IF @fromLSN IS NULL OR @toLSN IS NULl
	BEGIN
		SELECT DISTINCT
			I.InvoiceID,
			I.CustomerID,
			I.SalespersonPersonID,
			C.DeliveryCityID [LocationID],
			I.InvoiceDate,
			O.OrderDate,
			O.ExpectedDeliveryDate,
			I.ConfirmedDeliveryTime,
			IL.StockItemID,
			IL.Quantity,
			IL.UnitPrice,
			IL.TaxAmount,
			IL.LineProfit,
			0 [IsDeleted]
		FROM Sales.Invoices I
		JOIN Sales.InvoiceLines IL
			ON I.InvoiceID = IL.InvoiceID
		JOIN Sales.Orders O
			ON I.OrderID = O.OrderID
		JOIN Sales.Customers C
			ON I.CustomerID = C.CustomerID
		WHERE 0=1
	END
	ELSE
		SELECT DISTINCT
			I.InvoiceID,
			I.CustomerID,
			I.SalespersonPersonID,
			C.DeliveryCityID [LocationID],
			I.InvoiceDate,
			O.OrderDate,
			O.ExpectedDeliveryDate,
			I.ConfirmedDeliveryTime,
			IL.StockItemID,
			IL.Quantity,
			IL.UnitPrice,
			IL.TaxAmount,
			IL.LineProfit,
			CASE
				WHEN __$operation = 1 THEN 1
				ELSE 0
			END [IsDeleted]
		FROM cdc.fn_cdc_get_net_changes_Sales_Invoices(@fromLSN, @toLSN, N'all') I
		JOIN Sales.InvoiceLines IL
			ON I.InvoiceID = IL.InvoiceID
		JOIN Sales.Orders O
			ON I.OrderID = O.OrderID
		JOIN Sales.Customers C
			ON I.CustomerID = C.CustomerID
END
GO

/*####
	Querry for extracting employee data -> dimEmployee
####*/
CREATE OR ALTER PROCEDURE dimEmployeeIncremental (
	@fromDate DATETIME,
	@toDate DATETIME
)
AS
BEGIN
	DECLARE
		@fromLSN BINARY(10) = sys.fn_cdc_map_time_to_lsn('smallest greater than', @fromDate),
		@toLSN BINARY(10) = sys.fn_cdc_map_time_to_lsn('largest less than or equal', @toDate)
	IF @fromLSN IS NULL OR @toLSN IS NULL
	BEGIN
		SELECT DISTINCT 
			PersonID,
			FullName,
			IsSalesperson,
			0 [IsDeleted]
		FROM Application.People
		WHERE IsEmployee = 1 AND 1=0
	END
	ELSE
	BEGIN
		SELECT DISTINCT 
			PersonID,
			FullName,
			IsSalesperson,
			CASE
				WHEN __$operation = 1 THEN 1
				ELSE 0
			END [IsDeleted]
		FROM cdc.fn_cdc_get_net_changes_Application_People(@fromLSN, @toLSN, N'all') 
		WHERE IsEmployee = 1
	END
END
GO

/*####
	Querry for extracting location data -> dimLocation
####*/
CREATE OR ALTER PROCEDURE dimLocationIncremental (
	@fromDate DATETIME,
	@toDate DATETIME
)
AS
BEGIN
	DECLARE
		@fromLSN BINARY(10) = sys.fn_cdc_map_time_to_lsn('smallest greater than', @fromDate),
		@toLSN BINARY(10) = sys.fn_cdc_map_time_to_lsn('largest less than or equal', @toDate)

	IF @fromLSN IS NULL OR @toLSN IS NULl
	BEGIN
		SELECT DISTINCT
			C.CityID [LocationID],
			C.CityName,
			SP.StateProvinceName,
			SP.SalesTerritory,
			CO.CountryName,
			CO.Continent,
			CO.Region,
			CO.Subregion,
			0 [IsDeleted]
		FROM Application.Cities C
		JOIN Application.StateProvinces SP
			ON C.StateProvinceID = SP.StateProvinceID
		JOIN Application.Countries CO
			ON SP.CountryID = CO.CountryID
		WHERE 1=0
	END
	ELSE
		SELECT DISTINCT
			C.CityID [LocationID],
			C.CityName,
			SP.StateProvinceName,
			SP.SalesTerritory,
			CO.CountryName,
			CO.Continent,
			CO.Region,
			CO.Subregion,
			CASE
				WHEN __$operation = 1 THEN 1
				ELSE 0
			END [IsDeleted]
		FROM cdc.fn_cdc_get_net_changes_Application_Cities(@fromLSN, @toLSN, N'all')  C
		JOIN Application.StateProvinces SP
			ON C.StateProvinceID = SP.StateProvinceID
		JOIN Application.Countries CO
			ON SP.CountryID = CO.CountryID
END
GO

/*####
	Querry for extracting stock items data -> dimStockItem
####*/
CREATE OR ALTER PROCEDURE dimStockItemIncremental (
	@fromDate DATETIME,
	@toDate DATETIME
)
AS
BEGIN
	DECLARE
		@fromLSN BINARY(10) = sys.fn_cdc_map_time_to_lsn('smallest greater than', @fromDate),
		@toLSN BINARY(10) = sys.fn_cdc_map_time_to_lsn('largest less than or equal', @toDate)

	IF @fromLSN IS NULL OR @toLSN IS NULl
	BEGIN
		SELECT DISTINCT
			SI.StockItemID,
			SI.StockItemName,
			C.ColorName,
			PT.PackageTypeName [UnitPackage],
			PTO.PackageTypeName [OuterPackage],
			SI.Size,
			0 [IsDeleted]
		FROM Warehouse.StockItems SI
		LEFT JOIN Warehouse.Colors C
			ON SI.ColorID = C.ColorID
		JOIN Warehouse.PackageTypes PT
			ON SI.UnitPackageID = PT.PackageTypeID
			JOIN Warehouse.PackageTypes PTO
			ON SI.OuterPackageID = PTO.PackageTypeID
		WHERE 1=0
	END
	ELSE
		SELECT DISTINCT
			SI.StockItemID,
			SI.StockItemName,
			C.ColorName,
			PT.PackageTypeName [UnitPackage],
			PTO.PackageTypeName [OuterPackage],
			SI.Size,
			CASE
				WHEN __$operation = 1 THEN 1
				ELSE 0
			END [IsDeleted]
		FROM cdc.fn_cdc_get_net_changes_Warehouse_StockItems(@fromLSN, @toLSN, N'all') SI
		LEFT JOIN Warehouse.Colors C
			ON SI.ColorID = C.ColorID
		JOIN Warehouse.PackageTypes PT
			ON SI.UnitPackageID = PT.PackageTypeID
			JOIN Warehouse.PackageTypes PTO
			ON SI.OuterPackageID = PTO.PackageTypeID
END
GO

/*####
	Querry for extracting suppliers data -> dimSuppliers
####*/
CREATE OR ALTER PROCEDURE dimSuppliersIncremental (
	@fromDate DATETIME,
	@toDate DATETIME
)
AS
BEGIN
	DECLARE
		@fromLSN BINARY(10) = sys.fn_cdc_map_time_to_lsn('smallest greater than', @fromDate),
		@toLSN BINARY(10) = sys.fn_cdc_map_time_to_lsn('largest less than or equal', @toDate)

	IF @fromLSN IS NULL OR @toLSN IS NULl
	BEGIN
		SELECT DISTINCT
			S.SupplierID,
			S.SupplierName,
			SC.SupplierCategoryName,
			S.PaymentDays,
			0 [IsDeleted]
		FROM Purchasing.Suppliers S
		JOIN Purchasing.SupplierCategories SC
			ON S.SupplierCategoryID = SC.SupplierCategoryID
		WHERE 1=0
	END
	ELSE
		SELECT DISTINCT
			S.SupplierID,
			S.SupplierName,
			SC.SupplierCategoryName,
			S.PaymentDays,
			CASE
				WHEN __$operation = 1 THEN 1
				ELSE 0
			END [IsDeleted]
		FROM cdc.fn_cdc_get_net_changes_Purchasing_Suppliers(@fromLSN, @toLSN, N'all') S
		JOIN Purchasing.SupplierCategories SC
			ON S.SupplierCategoryID = SC.SupplierCategoryID
END
GO

/*####
	Querry for extracting purchase data -> factPurchase
####*/
CREATE OR ALTER PROCEDURE factPurchaseIncremental (
	@fromDate DATETIME,
	@toDate DATETIME
)
AS
BEGIN
	DECLARE
		@fromLSN BINARY(10) = sys.fn_cdc_map_time_to_lsn('smallest greater than', @fromDate),
		@toLSN BINARY(10) = sys.fn_cdc_map_time_to_lsn('largest less than or equal', @toDate)

	IF @fromLSN IS NULL OR @toLSN IS NULl
	BEGIN
		SELECT DISTINCT
			ST.SupplierTransactionID [PurchaseID],
			ST.SupplierID,
			PO.OrderDate [PurchaseDate],
			PO.ExpectedDeliveryDate,
			POL.StockItemID,
			POL.OrderedOuters [QuantityOrdered],
			POL.ReceivedOuters [QuantityReceived],
			ST.AmountExcludingTax,
			ST.TaxAmount,
			ExpectedUnitPricePerOuter,
			PO.IsOrderFinalized,
			0 [IsDeleted]
		FROM Purchasing.SupplierTransactions ST
		JOIN Purchasing.PurchaseOrders PO
			ON ST.PurchaseOrderID = PO.PurchaseOrderID
		JOIN Purchasing.PurchaseOrderLines POL
			ON PO.PurchaseOrderID = POL.PurchaseOrderID
		WHERE 1=0
	END
	ELSE
		SELECT DISTINCT
			ST.SupplierTransactionID [PurchaseID],
			ST.SupplierID,
			PO.OrderDate [PurchaseDate],
			PO.ExpectedDeliveryDate,
			POL.StockItemID,
			POL.OrderedOuters [QuantityOrdered],
			POL.ReceivedOuters [QuantityReceived],
			ST.AmountExcludingTax,
			ST.TaxAmount,
			ExpectedUnitPricePerOuter,
			PO.IsOrderFinalized,
			CASE
				WHEN __$operation = 1 THEN 1
				ELSE 0
			END [IsDeleted]
		FROM cdc.fn_cdc_get_net_changes_Purchasing_SupplierTransactions(@fromLSN, @toLSN, N'all') ST
		JOIN Purchasing.PurchaseOrders PO
			ON ST.PurchaseOrderID = PO.PurchaseOrderID
		JOIN Purchasing.PurchaseOrderLines POL
			ON PO.PurchaseOrderID = POL.PurchaseOrderID
END
GO