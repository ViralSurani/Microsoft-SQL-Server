--2: CTEs and Recursive Queries (1 of 2)
--“You have a hierarchy of product items, groups, and brands, all in a single table. Each row has a parent key that points to the row’s parent. For any single row, you want to know all the row’s parent rows, or all the row’s child rows.”

--E-commerce applications in particular will often store a company’s product hierarchy in a single table, where each row contains a pointer key to the row’s parent.

--The key is to use a set of language constructs that allow you to first retrieve your main or “core” selection(s), and then a second set of queries or processes that takes the result of your core selections and repeatedly traverses (either up or down) a hierarchy to find subsequent matches.

DECLARE @tProduct TABLE (
  Id int,
  Name char(50),
  ParentId int
)

INSERT INTO @tProduct
  VALUES (1, 'A', NULL)
INSERT INTO @tProduct
  VALUES (2, 'B', NULL)
INSERT INTO @tProduct
  VALUES (3, 'C', NULL)

INSERT INTO @tProduct
  VALUES (6, 'A 1', 1)
INSERT INTO @tProduct
  VALUES (7, 'A 2', 1)
INSERT INTO @tProduct
  VALUES (8, 'A 3', 1)

INSERT INTO @tProduct
  VALUES (9, 'B 1', 2)
INSERT INTO @tProduct
  VALUES (10, 'B 2', 2)
INSERT INTO @tProduct
  VALUES (11, 'C 3', 3)

INSERT INTO @tProduct
  VALUES (12, 'A 1 a', 6)
INSERT INTO @tProduct
  VALUES (13, 'A 1 b', 6)
INSERT INTO @tProduct
  VALUES (14, 'A 2 c', 7)

--SELECT * from @tProduct

-- Find all child records for the search condition
DECLARE @cSearch char(50)
SET @cSearch = 'A'

;
WITH ProductCTE
AS (
--Anchor query
SELECT
  Id,
  Name,
  ParentId
FROM @tProduct
WHERE Name = @cSearch
UNION ALL

-- Recursive query
SELECT
  Prod.Id,
  Prod.Name,
  Prod.ParentId
FROM @tProduct Prod
JOIN ProductCTE
  ON Prod.ParentId = ProductCTE.Id)
SELECT
  *
FROM ProductCTE

-- Now, find all the PARENT rows for the search conditon
SET @cSearch = 'A 1 b'

;
WITH ProductCTE
AS (
-- Anchor query (same as before)
SELECT
  Id,
  Name,
  ParentId
FROM @tProduct
WHERE Name = @cSearch

UNION ALL
-- Recursive query…reverse the parentid and id columns
SELECT
  Prod.Id,
  Prod.Name,
  Prod.ParentId
FROM @tProduct Prod
JOIN ProductCTE
  ON Prod.Id = ProductCTE.ParentId)
SELECT
  *
FROM ProductCTE