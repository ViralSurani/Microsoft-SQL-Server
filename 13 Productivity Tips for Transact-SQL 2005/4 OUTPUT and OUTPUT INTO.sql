--4: OUTPUT and OUTPUT INTO
--“You are inserting rows into a table and want to immediately retrieve the entire row, without the need for another SELECT statement, or a round trip to the server, and without using SCOPE_IDENTITY. Additionally, when you UPDATE rows in a table, you want to immediately know the contents of the row both before and after the UPDATE-again, without the need for another set of queries.”

--OUTPUT and OUTPUT INTO are nice capabilities to get immediate feedback on what has been added or changed. But don’t use them in place of audit trail triggers.

--SQL Server 2005 introduced a programming shortcut called OUTPUT that you can include in any INSERT/UPDATE/DELETE statement.

--For an INSERT, you just add the OUTPUT statement before the VALUES statement. If you are inserting into a table with an identity column, the OUTPUT result will include the new identity column value, as well as any default values or calculated columns from the table. This is much simpler than using SCOPE_IDENTITY to retrieve the full record after the insert.

--If you are inserting several records, you can use OUTPUT INTO to insert the results to a table variable, one insert at a time.

-- Using OUTPUT and OUTPUT INTO with INSERT
DECLARE @tInvoice TABLE (
  Id int IDENTITY,
  InvDate datetime,
  InvAmt decimal(14, 2)
)

INSERT INTO @tInvoice
OUTPUT INSERTED.*
  VALUES (GETDATE(), 1000)

DECLARE @tInsertedRows TABLE (
  Id int,
  InvDate datetime,
  InvAmt decimal(14, 2)
)

INSERT INTO @tInvoice
OUTPUT INSERTED.* INTO @tInsertedRows
  VALUES (GETDATE(), 2000)

INSERT INTO @tInvoice
OUTPUT INSERTED.* INTO @tInsertedRows
  VALUES (GETDATE(), 3000)

SELECT
  *
FROM @tInsertedRows

--Using OUTPUT and OUTPUT INTO with UPDATE
DECLARE @tTest TABLE (
  Col int,
  Amount decimal(14, 2)
)

INSERT INTO @tTest
  VALUES (1, 100)
INSERT INTO @tTest
  VALUES (2, 200)
INSERT INTO @tTest
  VALUES (3, 300)

UPDATE TOP (2) @tTest
SET Amount = Amount * 10
OUTPUT DELETED.*, INSERTED.*

-- This allows you to access the DELETED and INSERTED system tables
-- that were previously available only inside triggers

--Database triggers provide the best mechanism for logging database changes because they will fire regardless of how an INSERT/UPDATE occurs. So restrict the use of OUTPUT to instances where you want immediate feedback on changes.