--3: The New MERGE Statement to Combine INSERT/UPDATE/DELETE

--Suppose you are writing a maintenance routine that compares a target table to a source table. You need to do three things:
--If data exists in the source table but not the target table (based on a lookup on an ID column), insert the data from the source to the target
--If data exists in both tables (again, based on a matching ID), update the data from the target table into the source table (some columns might have changed)
--Finally, if any ID values are in the target, but don’t appear in the source, delete those ID values in the source.

--SQL Server 2008 contains a new MERGE statement that allows developers to handle all three of these situations in one line of code!

IF OBJECT_ID('dbo.tSource') IS NULL
BEGIN
  CREATE TABLE tSource (
    ID int,
    Name char(50),
    Age int
  )
END
ELSE
BEGIN
  TRUNCATE TABLE tSource
END

IF OBJECT_ID('dbo.tTarget') IS NULL
BEGIN
  CREATE TABLE tTarget (
    ID int,
    Name char(50),
    Age int
  )
END
ELSE
BEGIN
  TRUNCATE TABLE tTarget
END

INSERT INTO tTarget
  VALUES (1, 'Kevin', 42),
  (2, 'Steve', 40),
  (3, 'Mike', 30);

INSERT INTO tSource
  VALUES (1, 'Kevin goff', 43),
  (2, 'steve', 41),
  (4, 'john', 50);

SELECT
  *
FROM tSource
SELECT
  *
FROM tTarget

MERGE tTarget t
USING tSource s ON t.ID = s.ID
-- If we have an ID match, update tTarget
WHEN MATCHED THEN UPDATE SET t.Name = s.Name, t.Age = s.Age
-- If ID in source but not target,
-- insert ID into Target
WHEN NOT MATCHED THEN INSERT VALUES (ID, Name, Age)
-- If ID is in target but not source,
-- delete the ID row in the target
WHEN NOT MATCHED BY SOURCE THEN DELETE;

SELECT
  *
FROM tSource
SELECT
  *
FROM tTarget