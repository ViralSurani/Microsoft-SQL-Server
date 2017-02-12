

ALTER function GetCustomerBalance(@iAccKey int, @dCompDate datetime)
returns decimal as
begin

declare @Credits table(AcctKey int, Amount decimal, CompDate datetime)
declare @Debits table(AcctKey int, Amount decimal, CompDate datetime)

INSERT INTO @Credits VALUES(1,1000,CAST('21-01-2017' AS DATETIME))
INSERT INTO @Credits VALUES(1,2000,CAST('20-01-2017' AS DATETIME))
INSERT INTO @Credits VALUES(1,3000,CAST('19-01-2017' AS DATETIME))

return 0
end

SELECT dbo.GetCustomerBalance(1,CAST('21-01-2017' AS DATETIME))