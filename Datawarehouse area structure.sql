IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'DW_WWI')
	CREATE DATABASE DW_WWI
GO


USE DW_WWI
GO


CREATE SCHEMA [dw]
GO


CREATE TABLE [dw].dimCustomers (
	CustomerID INT IDENTITY(1,1),
	CustomerBK INT,
	CustomerName NVARCHAR(MAX),
	ParentCompany NVARCHAR(MAX),
	CustomerCategory NVARCHAR(MAX),
	IsDeleted BIT DEFAULT 0
)


CREATE TABLE [dw].factSale (
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


CREATE TABLE [dw].dimEmployee (
	PersonID INT IDENTITY(1,1),
	PersonBK INT,
	FullName NVARCHAR(MAX),
	IsSalesPerson BIT,
	IsDeleted BIT DEFAULT 0
)


CREATE TABLE [dw].dimLocation (
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


CREATE TABLE [dw].dimStockItem (
	StockItemID INT IDENTITY(1,1),
	StockItemBK INT,
	StockItemName NVARCHAR(MAX),
	ColorName NVARCHAR(MAX),
	UnitPackage NVARCHAR(MAX),
	OuterPackage NVARCHAR(MAX),
	Size NVARCHAR(MAX),
	IsDeleted BIT DEFAULT 0
)


CREATE TABLE [dw].dimSuppliers (
	SupplierID INT IDENTITY(1,1),
	SupplierBK INT,
	SupplierName NVARCHAR(MAX),
	SupplierCategoryName NVARCHAR(MAX),
	PaymentDays INT,
	IsDeleted BIT DEFAULT 0
)

CREATE TABLE [dw].factPurchase (
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
