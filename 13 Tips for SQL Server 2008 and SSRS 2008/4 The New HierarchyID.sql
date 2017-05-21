--4: The New HierarchyID

--SQL Server 2005 gave developers new language capabilities to perform recursive queries against data stored hierarchically. SQL Server 2008 now allows you to store hierarchical data better than before, and also provides new functions to query data without needing to use common table expressions.

--SQL Server 2008 introduces a new data type called the HierarchyID data type.

USE Test
GO

IF (OBJECT_ID('dbo.InsertProductTree') IS NOT NULL)
  DROP PROCEDURE InsertProductTree
IF (OBJECT_ID('dbo.ProductTree') IS NOT NULL)
  DROP TABLE ProductTree
IF (OBJECT_ID('dbo.ProductLevels') IS NOT NULL)
  DROP TABLE ProductLevels
GO

CREATE TABLE ProductTree (
  ProductTreePK int IDENTITY,
  [Description] varchar(1000),
  ProductLevelPK int,
  HireID hierarchyid
)
CREATE TABLE ProductLevels (
  ProductLevelPK int IDENTITY,
  [Description] varchar(50)
)
GO

INSERT INTO ProductLevels
  VALUES ('All Products')
INSERT INTO ProductLevels
  VALUES ('Family')
INSERT INTO ProductLevels
  VALUES ('Brand')
INSERT INTO ProductLevels
  VALUES ('Category')
INSERT INTO ProductLevels
  VALUES ('SubCategory')
INSERT INTO ProductLevels
  VALUES ('SKU')
GO

--Code to insert data into a table with a Hierarchical ID
CREATE PROCEDURE [dbo].[InsertProductTree] (@ProductParentPK int, @Description varchar(50), @ProductLevelPK int)
AS
BEGIN

  DECLARE @hierProductParentID hierarchyid,
          @LastChild hierarchyid,
          @NewHierID hierarchyid,
          @varLastChild varchar(50)

  -- Take the product's specified parent
  -- and find the HierarchyID
  SELECT
    @hierProductParentID = HireID
  FROM ProductTree
  WHERE ProductTreePK = @ProductParentPK

  -- Take the HierarchyID for the parent and covert to string
  -- now stored as something like '/1/'
  SET @varLastChild = @hierProductParentID.ToString()

  -- Determine the current Last Child
  SELECT
    @LastChild = MAX(HireID)
  FROM ProductTree
  WHERE HireID.ToString() LIKE @varLastChild + '[1-9]/' --WHERE HierID.ToString() LIKE @varLastChild +'[0-9]/'

  -- Use GetDescendant to get the HierarchyID for the parent
  -- of the last child
  SET @NewHierID = @hierProductParentID.GetDescendant(@LastChild, NULL)

  -- If you're trying to save a root level row, get the root ID
  IF @NewHierID IS NULL
  BEGIN
    SET @NewHierID = hierarchyid ::GetRoot()
  END

  INSERT INTO ProductTree ([Description], ProductLevelPK, HireID)
    VALUES (@Description, @ProductLevelPK, @NewHierID)

END
GO

EXEC [dbo].[InsertProductTree] NULL,
                               'All Products',
                               1
EXEC [dbo].[InsertProductTree] 1,
                               'Family A',
                               2
EXEC [dbo].[InsertProductTree] 1,
                               'Family B',
                               2
EXEC [dbo].[InsertProductTree] 1,
                               'Family C',
                               2

SELECT
  PT.*,
  PT.HireID.ToString() AS [Level],
  (SELECT
    ProductTreePK
  FROM ProductTree
  WHERE HireID = PT.HireID.GetAncestor(1))
  AS ParentID
FROM ProductTree PT