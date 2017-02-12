--Author  :	Viral Surani
--Date		:	4 Sep 2016
--Source	:	http://www.codemag.com/Article/0503071
--Subject	:	Return Multiple Result Sets

CREATE PROCEDURE ReturnMultipleResultSet
AS
BEGIN

  SELECT * FROM Person.Address;
  SELECT* FROM Sales.CreditCard;

END

EXEC ReturnMultipleResultSet