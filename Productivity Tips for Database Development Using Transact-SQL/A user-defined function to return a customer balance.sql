ALTER FUNCTION dbo.GetCustomerBalance (@iAccKey int, @dCompDate datetime)
RETURNS decimal
AS
BEGIN

  DECLARE @nCreditAmount decimal
  DECLARE @nDebitAmount decimal

  SET @nCreditAmount = (SELECT
    SUM(Amount)
  FROM Credits
  WHERE AcctKey = @iAccKey
  AND ([dbo].[GetDate]([Status], DrDate, WIPDate, CompDate)) <= @dCompDate)

  SET @nDebitAmount = (SELECT
    SUM(Amount)
  FROM Debits
  WHERE AcctKey = @iAccKey
  AND ([dbo].[GetDate]([Status], DrDate, WIPDate, CompDate)) <= @dCompDate)

  RETURN (ISNULL(@nCreditAmount, 0) - ISNULL(@nDebitAmount, 0))

END

--SELECT dbo.GetCustomerBalance(1,GETDATE())