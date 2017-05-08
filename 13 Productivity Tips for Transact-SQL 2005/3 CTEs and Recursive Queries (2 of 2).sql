--3: CTEs and Recursive Queries (1 of 2)
--“You need to take a table of vendor orders and produce a flat result set for a weekly report or chart for the first quarter of 2004. The result set must contain one row for each vendor and week-ending date, with the sum of orders for that week (even if zero).”

USE AdventureWorks2008
GO

IF OBJECT_ID('dbo.GetEndOfWeek') IS NOT NULL
BEGIN
  DROP FUNCTION dbo.GetEndOfWeek
END
GO

-- Converts date to the Saturday date for the week
-- So 6-12-07 becomes 6-16-07
CREATE FUNCTION dbo.GetEndOfWeek (@dDate datetime)
RETURNS datetime
AS
BEGIN
  DECLARE @dReturnDate datetime
  SET @dReturnDate = @dDate + (7 - DATEPART(WEEKDAY, @dDate))
  RETURN @dReturnDate
END
GO

--The report calls for a weekly result set by vendor for the first quarter of 2004. Since you may not know the first Saturday in 2004 (nor the last Saturday), you can simply declare two variables for ‘1-1-2004’ and ‘3-31-2004’, and use the UDF to convert them to the actual Saturday dates.

DECLARE @dStartDate datetime,
        @dEndDate datetime
-- First Saturday
SET @dStartDate = dbo.GetEndOfWeek('1-1-2004')
-- Last Saturday
SET @dEndDate = dbo.GetEndOfWeek('3-31-2004')

--next create two CTEs, one for a range of dates and a second for a list of vendors with at least one order.
--The first CTE, DateCTE, will contain a row for each Saturday date in the date range.
--build a simple CTE for each vendor with at least one order.
;WITH DateCTE
AS (SELECT
  @dStartDate AS WeekEnding
UNION ALL
SELECT
  (WeekEnding + 7) AS WeekEnding
FROM DateCTE
WHERE WeekEnding < @dEndDate),
VendorList
AS (SELECT
  VendorID
FROM Purchasing.PurchaseOrderHeader
GROUP BY VendorID)

SELECT
  Matrix.VendorID,
  Matrix.WeekEnding,
  SUM(COALESCE(Orders.TotalDue, 0)) AS WeeklySales
FROM (SELECT
  VendorID,
  WeekEnding
FROM VendorList,
     DateCTE) AS Matrix
LEFT JOIN Purchasing.PurchaseOrderHeader Orders
  ON Matrix.VendorID = Orders.VendorID
  AND Matrix.WeekEnding = dbo.GetEndOfWeek(Orders.OrderDate)
GROUP BY Matrix.VendorID,
         Matrix.WeekEnding
ORDER BY Matrix.VendorID, Matrix.WeekEnding