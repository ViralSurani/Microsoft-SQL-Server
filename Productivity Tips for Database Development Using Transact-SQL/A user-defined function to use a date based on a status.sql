CREATE FUNCTION [dbo].[GetDate] (@iStatus int, @dDrDate datetime, @dWIPDate datetime, @dCompDate datetime)
RETURNS datetime
AS
BEGIN

  DECLARE @dReturnDate datetime

  SET @dReturnDate = (SELECT
    CASE
      WHEN @iStatus = 1 THEN @dDrDate
      WHEN @iStatus = 2 THEN @dWIPDate
      WHEN @iStatus = 3 THEN @dCompDate
      ELSE @dDrDate
    END)

  RETURN (ISNULL(@dReturnDate, CAST('01-01-1901' AS datetime)))

END