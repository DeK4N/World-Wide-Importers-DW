/*####  STAGING AREA STRUCTURE - BRONZE  ####*/


IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'STAG_WWI')
	CREATE DATABASE STAG_WWI
GO


USE STAG_WWI
GO

CREATE SCHEMA [raw]
GO

CREATE SCHEMA [clean]
GO

CREATE TABLE [raw].dimCustomers (
	CustomerID INT,
	CustomerName NVARCHAR(MAX),
	ParentCompany NVARCHAR(MAX),
	CustomerCategory NVARCHAR(MAX)
)


CREATE TABLE [raw].factSale (
	InvoiceID INT,
	CustomerID INT,
	SalespersonPersonID INT,
	LocationID INT,
	StockItemID INT,
	InvoiceDate DATE,
	OrderDate DATE,
	ExpectedDeliveryDate DATE,
	ConfirmedDeliveryDate DATE,
	Quantity INT,
	UnitPrice DECIMAL(16,2),
	TaxAmount DECIMAL(16,2),
	LineProfit DECIMAL(16,2)
)


CREATE TABLE [raw].dimEmployee (
	PersonID INT,
	FullName NVARCHAR(MAX),
	IsSalesPerson BIT,
)


CREATE TABLE [raw].dimLocation (
	LocationID INT,
	CityName NVARCHAR(MAX),
	StateProvinceName NVARCHAR(MAX),
	SalesTerritory NVARCHAR(MAX),
	CountryName NVARCHAR(MAX),
	Continent NVARCHAR(MAX),
	Region NVARCHAR(MAX),
	Subregion NVARCHAR(MAX)
)


CREATE TABLE [raw].dimStockItem (
	StockItemID INT,
	StockItemName NVARCHAR(MAX),
	ColorName NVARCHAR(MAX),
	UnitPackage NVARCHAR(MAX),
	OuterPackage NVARCHAR(MAX),
	Size NVARCHAR(MAX)
)


CREATE TABLE [raw].dimSuppliers (
	SupplierID INT,
	SupplierName NVARCHAR(MAX),
	SupplierCategoryName NVARCHAR(MAX),
	PaymentDays INT
)

CREATE TABLE [raw].factPurchase (
	PurchaseID INT,
	SupplierID INT,
	StockItemID INT,
	OrderDate DATE,
	ExpectedDeliveryDate DATE,
	OrderedOuters INT,
	ReceivedOuters INT,
	AmountExcludingTax DECIMAL(16,2),
	TaxAmount DECIMAL(16,2),
	ExpectedUnitPricePerOuter DECIMAL(16,2),
	IsOrderFinalized BIT
)

/*####
	/*####  STAGING AREA STRUCTURE - SILVER  ####*/
####*/

CREATE TABLE [clean].dimCustomers (
	CustomerID INT,
	CustomerName NVARCHAR(50),
	ParentCompany NVARCHAR(30),
	CustomerCategory NVARCHAR(20)
)


CREATE TABLE [clean].factSale (
	InvoiceID INT,
	CustomerID INT,
	SalespersonPersonID INT,
	LocationID INT,
	StockItemID INT,
	InvoiceDate DATE,
	OrderDate DATE,
	ExpectedDeliveryDate DATE,
	ConfirmedDeliveryDate DATE,
	Quantity INT,
	UnitPrice DECIMAL(16,2),
	TaxAmount DECIMAL(16,2),
	LineProfit DECIMAL(16,2)
)


CREATE TABLE [clean].dimEmployee (
	PersonID INT,
	FullName NVARCHAR(24),
	IsSalesPerson BIT,
)


CREATE TABLE [clean].dimLocation (
	LocationID INT,
	CityName NVARCHAR(40),
	StateProvinceName NVARCHAR(30),
	SalesTerritory NVARCHAR(15),
	CountryName NVARCHAR(15),
	Continent NVARCHAR(15),
	Region NVARCHAR(10),
	Subregion NVARCHAR(20)
)


CREATE TABLE [clean].dimStockItem (
	StockItemID INT,
	StockItemName NVARCHAR(90),
	ColorName NVARCHAR(15),
	UnitPackage NVARCHAR(10),
	OuterPackage NVARCHAR(10),
	Size NVARCHAR(15)
)


CREATE TABLE [clean].dimSuppliers (
	SupplierID INT,
	SupplierName NVARCHAR(30),
	SupplierCategoryName NVARCHAR(30),
	PaymentDays INT
)

CREATE TABLE [clean].factPurchase (
	PurchaseID INT,
	SupplierID INT,
	StockItemID INT,
	OrderDate DATE,
	ExpectedDeliveryDate DATE,
	OrderedOuters INT,
	ReceivedOuters INT,
	AmountExcludingTax DECIMAL(16,2),
	TaxAmount DECIMAL(16,2),
	ExpectedUnitPricePerOuter DECIMAL(16,2),
	IsOrderFinalized BIT
)


/*####
	Log table with date of last etl run
####*/

CREATE TABLE EtlLog (
	LogID INT IDENTITY(1,1),
	LastExtract DATETIME
)


