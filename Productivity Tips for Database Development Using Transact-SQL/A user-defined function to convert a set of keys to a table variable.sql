--SET versus SELECT when assigning variables?
--http://stackoverflow.com/questions/3945361/set-versus-select-when-assigning-variables

CREATE FUNCTION dbo.CsvToTable (@cList varchar(8000))
-- Converts a comma-delimited list of integer keys to a TABLE
-- Used to take a variable list of selections
-- (accounts, products, etc.) and put them into a TABLE that can
-- be used in a subsequent JOIN
RETURNS @IntKeyTable TABLE (
  IntKey int
)
AS
BEGIN

  DECLARE @nPosition int
  DECLARE @cTempValue varchar(8000)
  DECLARE @nIntKey int

  SET @cList = RTRIM(@cLIst) + ','
  -- So right now we might have '1111,2222,'
  -- (Careful if the CSV already ended with a comma,
  -- you'll wind up with an extra 0 in the key table)

  -- see if comma exists in list
  -- (use PATINDEX to return pattern position within a string
  WHILE PATINDEX('%,%', @cList) <> 0
  BEGIN

    -- get the position of the comma
    SET @nPosition = PATINDEX('%,%', @cList)

    -- get the key, from beginning of string to the comma
    SET @cTempValue = LEFT(@cList, @nPosition - 1)
    SET @nIntKey = CAST(@cTempValue AS int)

    -- Write out to the Keys table (convert to integer)
    INSERT INTO @IntKeyTable
      VALUES (@nIntKey)

    -- wipe out the value we just inserted
    SET @cList = STUFF(@cList, 1, @nPosition, '')

  END

  RETURN

END

--SELECT * from dbo.CsvToTable('111,222')