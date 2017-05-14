--2: New GROUP BY Extensions

--SQL Server 2008 offers new GROUP BY extensions that allow you to specify multiple GROUP BY options in a single table-yes, in the same record set that contains the details.

--sp_dbcmptlevel: Sets certain database behaviors to be compatible with the specified version of SQL Server.
--https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-dbcmptlevel-transact-sql
--100 = SQL Server 2008
--sp_dbcmptlevel Adventureworks, 100

--you wanted to group all the Purchase Orders by Vendor Name, by Vendor Name and Year, and then a grand total for all vendors. 
USE AdventureWorks2012
GO

SELECT
  VE.Name AS Name,
  DATEPART(YEAR, PO.OrderDate) AS Yr,
  SUM(PO.TotalDue) AS TotalDue
FROM Purchasing.PurchaseOrderHeader PO
JOIN Purchasing.Vendor VE
  ON PO.VendorID = VE.BusinessEntityID
GROUP BY ROLLUP (VE.Name, DATEPART(YEAR, PO.OrderDate))

--note the NULL entries for the rows summarized by Name, and by Total
--The ROLLUP syntax is like a clean sweep: it will work progressively across the columns you specify.

--However, if you want to define your own GROUP BY statements, you can use the GROUP BY GROUPING SETS statement. This first example summarizes orders by Name, by Name and Year, and by Grand Total (and produces the exact same query as the one above that used ROLLUP).
SELECT
  VE.Name AS Name,
  DATEPART(YEAR, PO.OrderDate) AS Yr,
  SUM(PO.TotalDue) AS TotalDue
FROM Purchasing.PurchaseOrderHeader PO
JOIN Purchasing.Vendor VE
  ON PO.VendorID = VE.BusinessEntityID
GROUP BY GROUPING SETS ((VE.Name, DATEPART(YEAR, PO.OrderDate)))
ORDER BY Name, Yr

--Here are different examples if you want to specify multiple GROUP BY definitions that can’t be expressed by a ROLLUP.

-- 2 Groups, by name and by year
--GROUP BY grouping SETS((Name),(datepart(year,OrderDate)))

-- 2 Groups, by name/year, and by total
--GROUP BY grouping SETS((datepart(year,OrderDate)),())

-- 3 Groups, by name/year, by name, and by year
--GROUP BY grouping SETS((Name,(datepart(year,OrderDate)),(Name),(datepart(year,OrderDate)))

--Remember, you’ll need to account for the NULL entries when processing these result sets.