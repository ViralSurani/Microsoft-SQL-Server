--10: Update Triggers
--Requirement: You need to make sure that any UPDATES performed against a table automatically update a timestamp column.

--An UPDATE trigger is a specific type of stored procedure that fires every time an UPDATE statement executes against the table. You can use triggers to enforce specific rules, and/or to ensure that specific columns are updated.

--UPDATE triggers provide access to two critical system tables that contain the state of the row before it was updated (DELETED) and after it was updated (INSERTED).

--In constructing an UPDATE trigger, you need to remember that the trigger fires once, regardless of the number of rows affected by an UPDATE statement.

Use SampleDB
GO

IF OBJECT_ID('dbo.Upd_OrderHdr') IS NOT NULL
BEGIN
	DROP TRIGGER dbo.Upd_OrderHdr
END
GO

CREATE TRIGGER dbo.Upd_OrderHdr
ON dbo.OrderHdr
FOR UPDATE
AS
  UPDATE OrderHdr
  SET LastUpdate = GETDATE()
  FROM OrderHdr O
  JOIN INSERTED I
    ON O.Id = I.Id
GO