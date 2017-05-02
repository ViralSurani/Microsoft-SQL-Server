--12: Dynamic SQL
--The first example constructs a simple query where the table name is a variable. The second example demonstrates how to direct the results of a query that returns one row to an output variable.

USE SampleDB
GO

-- Must use Unicode data
DECLARE @cSQLSyntax nvarchar(2000)
DECLARE @cTableName varchar(20)

SET @cTableName = 'OrderHdr'
SET @cSQLSyntax = N'SELECT * FROM ' + @cTableName + ' WHERE Id=1'

EXEC sys.sp_executesql @cSQLSyntax

-- Return a column into an output variable
-- Query must only contain one row, else an error will occur
-- (query could also be a SUM that returns a scalar value)
declare @cValue nvarchar(30)
declare @columnName varchar(20)
set @columnName = 'Amount'

set @cSQLSyntax = N'SELECT @cValue='+@columnName+' FROM OrderHdr Where Id=1'

EXECUTE sys.sp_executesql @cSQLSyntax, N'@cValue nvarchar(30) OUTPUT', @cValue OUTPUT

select @cValue