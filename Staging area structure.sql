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
	CustomerID INT IDENTITY(1,1),
	CustomerBK INT,
	CustomerName NVARCHAR(MAX),
	ParentCompany NVARCHAR(MAX),
	CustomerCategory NVARCHAR(MAX),
	IsDeleted BIT DEFAULT 0
)


CREATE TABLE [raw].factSale (
	InvoiceID INT IDENTITY(1,1),
	InvoiceBK INT,
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
	LineProfit DECIMAL(16,2),
	IsDeleted BIT DEFAULT 0
)


CREATE TABLE [raw].dimEmployee (
	PersonID INT IDENTITY(1,1),
	PersonBK INT,
	FullName NVARCHAR(MAX),
	IsSalesPerson BIT,
	IsDeleted BIT DEFAULT 0
)


CREATE TABLE [raw].dimLocation (
	LocationID INT  IDENTITY(1,1),
	LocationBK INT,
	CityName NVARCHAR(MAX),
	StateProvinceName NVARCHAR(MAX),
	SalesTerritory NVARCHAR(MAX),
	CountryName NVARCHAR(MAX),
	Continent NVARCHAR(MAX),
	Region NVARCHAR(MAX),
	Subregion NVARCHAR(MAX),
	IsDeleted BIT DEFAULT 0
)


CREATE TABLE [raw].dimStockItem (
	StockItemID INT IDENTITY(1,1),
	StockItemBK INT,
	StockItemName NVARCHAR(MAX),
	ColorName NVARCHAR(MAX),
	UnitPackage NVARCHAR(MAX),
	OuterPackage NVARCHAR(MAX),
	Size NVARCHAR(MAX),
	IsDeleted BIT DEFAULT 0
)


CREATE TABLE [raw].dimSuppliers (
	SupplierID INT IDENTITY(1,1),
	SupplierBK INT,
	SupplierName NVARCHAR(MAX),
	SupplierCategoryName NVARCHAR(MAX),
	PaymentDays INT,
	IsDeleted BIT DEFAULT 0
)

CREATE TABLE [raw].factPurchase (
	PurchaseID INT IDENTITY(1,1),
	PurchaseBK INT,
	SupplierID INT,
	StockItemID INT,
	OrderDate DATE,
	ExpectedDeliveryDate DATE,
	OrderedOuters INT,
	ReceivedOuters INT,
	AmountExcludingTax DECIMAL(16,2),
	TaxAmount DECIMAL(16,2),
	ExpectedUnitPricePerOuter DECIMAL(16,2),
	IsOrderFinalized BIT,
	IsDeleted BIT DEFAULT 0
)

/*####
	/*####  STAGING AREA STRUCTURE - SILVER  ####*/
####*/

CREATE TABLE [clean].dimCustomers (
	CustomerID INT IDENTITY(1,1),
	CustomerBK INT,
	CustomerName NVARCHAR(MAX),
	ParentCompany NVARCHAR(MAX),
	CustomerCategory NVARCHAR(MAX),
	IsDeleted BIT DEFAULT 0
)


CREATE TABLE [clean].factSale (
	InvoiceID INT IDENTITY(1,1),
	InvoiceBK INT,
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
	LineProfit DECIMAL(16,2),
	IsDeleted BIT DEFAULT 0
)


CREATE TABLE [clean].dimEmployee (
	PersonID INT IDENTITY(1,1),
	PersonBK INT,
	FullName NVARCHAR(MAX),
	IsSalesPerson BIT,
	IsDeleted BIT DEFAULT 0
)


CREATE TABLE [clean].dimLocation (
	LocationID INT  IDENTITY(1,1),
	LocationBK INT,
	CityName NVARCHAR(MAX),
	StateProvinceName NVARCHAR(MAX),
	SalesTerritory NVARCHAR(MAX),
	CountryName NVARCHAR(MAX),
	Continent NVARCHAR(MAX),
	Region NVARCHAR(MAX),
	Subregion NVARCHAR(MAX),
	IsDeleted BIT DEFAULT 0
)


CREATE TABLE [clean].dimStockItem (
	StockItemID INT IDENTITY(1,1),
	StockItemBK INT,
	StockItemName NVARCHAR(MAX),
	ColorName NVARCHAR(MAX),
	UnitPackage NVARCHAR(MAX),
	OuterPackage NVARCHAR(MAX),
	Size NVARCHAR(MAX),
	IsDeleted BIT DEFAULT 0
)


CREATE TABLE [clean].dimSuppliers (
	SupplierID INT IDENTITY(1,1),
	SupplierBK INT,
	SupplierName NVARCHAR(MAX),
	SupplierCategoryName NVARCHAR(MAX),
	PaymentDays INT,
	IsDeleted BIT DEFAULT 0
)

CREATE TABLE [clean].factPurchase (
	PurchaseID INT IDENTITY(1,1),
	PurchaseBK INT,
	SupplierID INT,
	StockItemID INT,
	OrderDate DATE,
	ExpectedDeliveryDate DATE,
	OrderedOuters INT,
	ReceivedOuters INT,
	AmountExcludingTax DECIMAL(16,2),
	TaxAmount DECIMAL(16,2),
	ExpectedUnitPricePerOuter DECIMAL(16,2),
	IsOrderFinalized BIT,
	IsDeleted BIT DEFAULT 0
)


/*####
	Log table with date of last etl run
####*/

CREATE TABLE EtlLog (
	LogID INT IDENTITY(1,1),
	LastExtract DATETIME,
)


DROP DATABASE STAG_WWI