USE WorldWideImporters
GO  
EXEC sys.sp_cdc_enable_db  
GO 


EXEC sys.sp_cdc_enable_table
	@source_schema = N'Sales',
	@source_name   = N'Customers',
	@role_name     = NULL,
	@supports_net_changes = 1
GO

EXEC sys.sp_cdc_enable_table
	@source_schema = N'Sales',
	@source_name   = N'Invoices',
	@role_name     = NULL,
	@supports_net_changes = 1 
GO

EXEC sys.sp_cdc_enable_table
	@source_schema = N'Application',
	@source_name   = N'People',
	@role_name     = NULL,
	@supports_net_changes = 1 
GO

EXEC sys.sp_cdc_enable_table
	@source_schema = N'Application',
	@source_name   = N'Cities',
	@role_name     = NULL,
	@supports_net_changes = 1 
GO

EXEC sys.sp_cdc_enable_table
	@source_schema = N'Warehouse',
	@source_name   = N'StockItems',
	@role_name     = NULL,
	@supports_net_changes = 1 
GO

EXEC sys.sp_cdc_enable_table
	@source_schema = N'Purchasing',
	@source_name   = N'Suppliers',
	@role_name     = NULL,
	@supports_net_changes = 1 
GO

EXEC sys.sp_cdc_enable_table
	@source_schema = N'Purchasing',
	@source_name   = N'SupplierTransactions',
	@role_name     = NULL,
	@supports_net_changes = 1 
GO

/*
SELECT sys.fn_cdc_map_lsn_to_time(__$start_lsn), * FROM cdc.Sales_Customers_CT
DECLARE @from_lsn binary(10), @to_lsn binary(10)
SET @from_lsn = sys.fn_cdc_get_min_lsn('Sales_Customers')
SET @to_lsn   = sys.fn_cdc_get_max_lsn()
SELECT * FROM cdc.fn_cdc_get_all_changes_Sales_Customers(@from_lsn, @to_lsn, N'all')
GO

