/*####  STAGING AREA STRUCTURE  ####*/

CREATE TABLE dimCustomers (
	CustomerID INT,
	CustomerName VARCHAR(MAX),
	ParentCompany VARCHAR(MAX),
	CustomerCategory VARCHAR(MAX)
)


CREATE TABLE factSale (
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


CREATE TABLE dimEmployee (
	PersonID INT,
	FullName VARCHAR(MAX),
	IsSalesPerson BIT,
)


CREATE TABLE dimLocation (
	LocationID INT,
	CityName VARCHAR(MAX),
	StateProvinceName VARCHAR(MAX),
	SalesTerritory VARCHAR(MAX),
	CountryName VARCHAR(MAX),
	Continent VARCHAR(MAX),
	Region VARCHAR(MAX),
	Subregion VARCHAR(MAX)
)


CREATE TABLE dimStockItem (
	StockItemID INT,
	StockItemName VARCHAR(MAX),
	ColorName VARCHAR(MAX),
	UnitPackage VARCHAR(MAX),
	OuterPackage VARCHAR(MAX),
	Size VARCHAR(MAX)
)


CREATE TABLE dimSuppliers (
	SupplierID INT,
	SupplierName VARCHAR(MAX),
	SupplierCategoryName VARCHAR(MAX),
	PaymentDays INT
)

CREATE TABLE factPurchase (
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