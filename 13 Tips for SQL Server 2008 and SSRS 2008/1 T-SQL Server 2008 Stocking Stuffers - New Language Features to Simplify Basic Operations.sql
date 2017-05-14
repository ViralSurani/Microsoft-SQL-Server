--1: T-SQL Server 2008 “Stocking Stuffers”-New Language Features to Simplify Basic Operations

--You can now DECLARE a variable and initialize it in one line of code.
--You can use new Row Constructor syntax to insert multiple rows in a single statement. You simply separate the row definitions with parenthesis and a comma.
--You can use basic assignment operators to simplify incrementing.

-- Variable initialization
DECLARE @iCounter int = 5
SELECT
  @iCounter

-- Insert Row Constructors
DECLARE @tSales TABLE (
  EmpId int,
  Yr int,
  Sales money,
  MyCounter int
)
INSERT @tSales
  VALUES (1, 2005, 12000, @iCounter),
  (1, 2006, 18000, @iCounter + 1),
  (1, 2007, 25000, @iCounter + 2),
  (3, 2006, 20000, @iCounter + 3),
  (3, 2007, 24000, @iCounter + 4);
SELECT
  *
FROM @tSales

-- Assignment operators
UPDATE @tSales
SET MyCounter += 1
SELECT
  *
FROM @tSales