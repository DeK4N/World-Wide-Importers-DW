/*#######################################################################
							HELPER SQL
#######################################################################*/


/*#####
	Check if any data exists in ETL LOG
####*/

IF EXISTS (
	SELECT ID
	FROM EtlLog
)
	SELECT 1
ELSE 
	SELECT 0

/*####
	Procedure for truncating all staging area tables - parameter SchemaName (raw, clear)
####*/
USE STAG_WWI
GO

CREATE OR ALTER PROCEDURE TruncateTables 
	@SchemaName NVARCHAR(50)
AS
BEGIN
	IF @SchemaName IN ('raw', 'clear')
	BEGIN
		DECLARE @SQL VARCHAR(MAX) = ''
		SELECT @SQL = @SQL + 'TRUNCATE TABLE ' + S.name + '.' + T.name + ';'
		FROM sys.tables T
		JOIN sys.schemas S
			ON T.schema_id = S.schema_id
		WHERE S.name = @SchemaName

		EXEC(@SQL)
	END
	ELSE
		PRINT('Invalid parameter - correct parameters: raw, clear')
END

EXEC TruncateTables @SchemaName = 'raw'



