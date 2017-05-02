--9: Data Conversions with CAST and CONVERT
--Requirement: You need to produce an English-like message that describes the results of an accounting process. The string should read something like "100 Employee Checks were generated on 11/15/2004 at 5:07:02 PM, for a total dollar value of $134,123.11".

DECLARE @nRowCount integer
DECLARE @dReportDate datetime
DECLARE @nDollors decimal(14, 2)

SET @nRowCount = 156
SET @dReportDate = GETDATE()
SET @nDollors = 156134.11

DECLARE @cDateString varchar(20)
DECLARE @cRowCount varchar(20)
DECLARE @cMessage varchar(8000)

--There is no need of below two lines
--SET @cRowCount = LTRIM(RTRIM(CONVERT(int,@nRowCount,20)))
--SET @cDateString = LTRIM(RTRIM(CONVERT(datetime,@dReportDate,20)))

SET @cRowCount = @nRowCount
SET @cDateString = @dReportDate

SET @cMessage = 'Generated ' + @cRowCount + ' Employee checks on ' + @cDateString + ' for total amount of $' + CAST(@nDollors AS varchar(20))
SELECT
  @cMessage