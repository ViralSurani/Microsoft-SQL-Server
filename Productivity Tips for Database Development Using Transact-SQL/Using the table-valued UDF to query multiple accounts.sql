CREATE FUNCTION GetCreditEntriesByAccNo (@cList varchar(8000))
RETURNS TABLE
AS
  RETURN
  (
  SELECT
    credit.*
  FROM credits credit
  JOIN dbo.CsvToTable(@cList) intKeyRow
    ON credit.AcctKey = intKeyRow.intKey
  )

--SELECT * FROM dbo.GetCreditEntriesByAccNo('1,2')