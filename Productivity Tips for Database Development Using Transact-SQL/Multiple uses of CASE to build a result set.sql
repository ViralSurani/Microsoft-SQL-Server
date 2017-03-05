CREATE PROCEDURE GetAgingReport (@cAcctList varchar(8000), @dAgeDate datetime)
AS
SELECT

	SUM(CASE
		WHEN account.CreatedDate BETWEEN (@dAgeDate - 30) AND @dAgeDate THEN account.Balance
		ELSE 0
	END) AS Age30
	,SUM(CASE
		WHEN account.CreatedDate BETWEEN (@dAgeDate - 60) AND (@dAgeDate - 31) THEN account.Balance
		ELSE 0
	END) AS Age60
	,SUM(CASE
		WHEN account.CreatedDate BETWEEN (@dAgeDate - 90) AND (@dAgeDate - 61) THEN account.Balance
		ELSE 0
	END) AS Age90
	,SUM(CASE
		WHEN account.CreatedDate < (@dAgeDate - 90) THEN account.Balance
		ELSE 0
	END) AS AgeGT90
	,SUM(CASE
		WHEN account.CreatedDate > @dAgeDate THEN account.Balance
		ELSE 0
	END) AS NotAged
	,SUM(account.Balance) AS TotalBalance
	,category.CategoryId

FROM Account account
JOIN dbo.CsvToTable(@cAcctList) accountList
	ON account.AccountId = accountList.IntKey
JOIN CategoryMaster category
	ON category.CategoryId = account.CategoryId
GROUP BY category.CategoryId

ORDER BY TotalBalance

--References:
--BETWEEN
--https://msdn.microsoft.com/en-in/library/ms187922.aspx?f=255&MSPPError=-2147217396
--https://www.w3schools.com/SQl/sql_between.asp  --References:
--BETWEEN
--https://msdn.microsoft.com/en-in/library/ms187922.aspx?f=255&MSPPError=-2147217396
--https://www.w3schools.com/SQl/sql_between.asp