--11: Use UPDATE Triggers to Implement Audit Trail Changes
--Requirement: You need to log changes to specific columns to an audit trail log. The log should contain the table modified, the primary key of the row modified, the name of the column modified, the values before and after the change (old value/new value), and the date/time of the update. 
USE SampleDB
GO

IF OBJECT_ID('dbo.Upd_Price') IS NOT NULL
BEGIN
  DROP TRIGGER dbo.Upd_Price
END
GO

CREATE TRIGGER Upd_Price
ON dbo.Price
FOR UPDATE
AS

  DECLARE @dLastUpdate datetime
  SET @dLastUpdate = GETDATE()

  -- Set the last Update for rows updated
  UPDATE Price
  SET LastUpdate = @dLastUpdate
  FROM Price P
  JOIN INSERTED I
    ON P.Id = I.Id

  -- Write out to the Audit Log, for rows where Price changed
  INSERT INTO AuditLog (TableName, PrimaryKey, LastUpdate, ColName, OldValue, NewValue)
    SELECT
      'PRICE' AS TableName,
      CONVERT(varchar(max), I.Id) AS PrimaryKey,
      @dLastUpdate AS LastUpdate,
      'Price' AS ColName,
      CONVERT(varchar(max), D.Price) AS OldValue,
      CONVERT(varchar(max), I.Price) AS NewValue
    FROM INSERTED I
    JOIN DELETED D
      ON I.Id = D.Id
    WHERE I.Price <> D.Price

  -- Now check for any changes to the description
  INSERT INTO AuditLog (TableName, PrimaryKey, LastUpdate, ColName, OldValue, NewValue)
    SELECT
      'PRICE' AS TableName,
      CONVERT(varchar(max), I.Id) AS PrimaryKey,
      @dLastUpdate AS LastUpdate,
      'Description' AS ColName,
      CONVERT(varchar(max), [D].[Description]) AS OldValue,
      CONVERT(varchar(max), [I].[Description]) AS NewValue
    FROM INSERTED I
    JOIN DELETED D
      ON I.Id = D.Id
    WHERE [I].[Description] <> [D].[Description]

GO

--Note This tip provides basic functionality for Audit Trail logging. If you want to build a completely automated audit trail solution, you should consider building a data-driven script to generate UPDATE triggers for those tables/columns where you require logging.

--Several companies make products that can help you build automated audit trail solutions. I can personally recommend SQLAudit from Red Matrix Technologies which provides these capabilities (and more). Considering the amount of development effort to build a comprehensive solution for audit trail, purchasing a third-party tool like SQLAudit may be a wise economic choice.