--Date Functions
--Requirement: You need to retrieve daily order information and summarize it by week for a weekly report or weekly graph.

--The first snippet presents a UDF that converts any date during the week to a Saturday date for that week.
IF OBJECT_ID('dbo.GetEndOfWeek') IS NOT NULL
BEGIN
  DROP FUNCTION dbo.GetEndOfWeek
END
GO

CREATE FUNCTION dbo.GetEndOfWeek (@dDate datetime)
RETURNS datetime
AS
BEGIN
  DECLARE @dReturnDate datetime
  SET @dReturnDate = @dDate + (7 - (DATEPART(WEEKDAY, @dDate)))
  RETURN @dReturnDate
END
GO

--The second snippet demonstrates the UDF as part of a query against orders, which summarizes the data by the week-ending Saturday date. You can use this result set for a weekly report or graph.
SELECT
  dbo.GetEndOfWeek(OrderDate) AS WeekEnding,
  SUM(Amount) AS WeekAmount
FROM orderhdr
GROUP BY dbo.GetEndOfWeek(OrderDate)

--you could use the quarter datepart to summarize data by quarter.
--The Weekday datepart is scoped to SQL Server's setting for the first day of the week. The default is Sunday. To set the first day of the week to a different day (e.g., summarize sales from Monday to Sunday instead of Sunday to Saturday), use the SET DATEFIRST command:

-- Change first day of week from default of
-- Sunday (7) to Monday (1)
IF NULL IS NOT NULL
BEGIN
	SET DATEFIRST 1
END

--For example, a row with a date of "05-26-2003 22:10:00" will not be retrieved if the query calls for all rows where Date <= CAST('05-26-2003') AS DATETIME. This is because SQL compares 5-26-2003 at 22:10:00 to 5-26-2003 at 00:00:00 (12 AM), and finds that the former is not <= the latter. If you want all data through 5-26, including any transactions that hit right up to 11:59 PM that day, you could add one day to the comparison date, and change the logic to less than (Date < CAST('05-26-2003') + 1 ).