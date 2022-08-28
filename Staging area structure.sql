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
	CustomerName VARCHAR(MAX),
	ParentCompany VARCHAR(MAX),
	CustomerCategory VARCHAR(MAX)
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
	FullName VARCHAR(MAX),
	IsSalesPerson BIT,
)


CREATE TABLE [raw].dimLocation (
	LocationID INT,
	CityName VARCHAR(MAX),
	StateProvinceName VARCHAR(MAX),
	SalesTerritory VARCHAR(MAX),
	CountryName VARCHAR(MAX),
	Continent VARCHAR(MAX),
	Region VARCHAR(MAX),
	Subregion VARCHAR(MAX)
)


CREATE TABLE [raw].dimStockItem (
	StockItemID INT,
	StockItemName VARCHAR(MAX),
	ColorName VARCHAR(MAX),
	UnitPackage VARCHAR(MAX),
	OuterPackage VARCHAR(MAX),
	Size VARCHAR(MAX)
)


CREATE TABLE [raw].dimSuppliers (
	SupplierID INT,
	SupplierName VARCHAR(MAX),
	SupplierCategoryName VARCHAR(MAX),
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
	CustomerName VARCHAR(50),
	ParentCompany VARCHAR(30),
	CustomerCategory VARCHAR(20)
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
	FullName VARCHAR(24),
	IsSalesPerson BIT,
)


CREATE TABLE [clean].dimLocation (
	LocationID INT,
	CityName VARCHAR(40),
	StateProvinceName VARCHAR(30),
	SalesTerritory VARCHAR(15),
	CountryName VARCHAR(15),
	Continent VARCHAR(15),
	Region VARCHAR(10),
	Subregion VARCHAR(20)
)


CREATE TABLE [clean].dimStockItem (
	StockItemID INT,
	StockItemName VARCHAR(90),
	ColorName VARCHAR(15),
	UnitPackage VARCHAR(10),
	OuterPackage VARCHAR(10),
	Size VARCHAR(15)
)


CREATE TABLE [clean].dimSuppliers (
	SupplierID INT,
	SupplierName VARCHAR(30),
	SupplierCategoryName VARCHAR(30),
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
	TableName VARCHAR(50),
	LastExtract DATETIME
)


