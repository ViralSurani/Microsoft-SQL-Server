--13: Get a List of Tables and Columns for a Database

-- Return a list of table names
SELECT DISTINCT
  TABLE_NAME
FROM SampleDB.INFORMATION_SCHEMA.COLUMNS
ORDER BY TABLE_NAME

-- Return a list of columns
-- (perform a SELECT * to see a full list)
SELECT
  TABLE_NAME,
  COLUMN_NAME,
  DATA_TYPE,
  CHARACTER_MAXIMUM_LENGTH
FROM SampleDB.INFORMATION_SCHEMA.COLUMNS
ORDER BY TABLE_NAME

-- You could combine the capability of LIKE
-- to find columns with a particular search
-- pattern