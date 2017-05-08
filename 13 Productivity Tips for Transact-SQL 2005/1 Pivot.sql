--1: PIVOT
--“You want to query a table of vendor orders and group the order amounts by quarter for each vendor.”
--Application developers often need to convert raw data into some type of analytical view, such as sales by month or quarter or the brackets of an aging report.
--PIVOT allows you to (as the name implies) turn rows of raw data into columns.
--a query against the Purchase Order tables in AdventureWorks that summarizes order amounts by quarter. 

USE AdventureWorks2008
GO

WITH OrdCTE
AS (SELECT
  POH.VendorID,
  (POD.OrderQty * POD.UnitPrice) AS OrderTot,
  DATEPART(q, POH.OrderDate) AS OrderQtr
FROM Purchasing.PurchaseOrderHeader POH
JOIN Purchasing.PurchaseOrderDetail POD
  ON POH.PurchaseOrderID = POD.PurchaseOrderID)

SELECT
  VendorID,
  [1] AS Q1,
  [2] AS Q2,
  [3] AS Q3,
  [4] AS Q4
FROM OrdCTE
PIVOT (SUM(OrderTot) FOR OrderQtr IN ([1], [2], [3], [4])) AS X

-- You can use MAX instead, if you want the top order for each Qtr

--A few additional notes on PIVOT:
--The list of values in the IN clause must be static. Microsoft’s implementation of PIVOT does not directly support dynamic queries. If you need to determine these values dynamically at runtime, you MUST construct the entire SQL statement as a string and then use Dynamic SQL. If you frequently need to generate PIVOT tables dynamically, you may want to look at GeckoWare’s SQL CrossTab Builder product (http://www.geckoware.com.au/Content.aspx?Doc_id=1002).
--You must specify the column you are PIVOTING on (Ordertot) as a scalar expression (e.g. MAX(), SUM(), etc.).