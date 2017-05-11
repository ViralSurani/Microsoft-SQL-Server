--5 ISOLATION LEVELS (part 1 of 2)
--“You’ve just started using SQL Server and want to understand how SQL Server locks rows during queries and updates. This is a two-part tip: the first will cover the four options that developers had prior to SQL Server 2000, and the next tip will cover an option that is specific to SQL Server 2005.”

--SQL Server 2000 contains four isolation levels, each progressively more restrictive. They are as follows:
--    READ UNCOMMITTED (dirty read)
--    READ COMMITTED (the default level)
--    REPEATABLE READ
--    SERIALIZABLE READ

--The first level, READ UNCOMMITTED, offers the least amount of isolation against other actions on the same row. If USER A begins to update a record, and USER B queries the record before USER A commits the transaction, USER B will still pick up the change.

-- USER A
USE AdventureWorks2008
GO

BEGIN TRAN

  -- change from Trey Research to 'Trey & Wilson Research, Inc.'
  SELECT
    *
  FROM Purchasing.Vendor
  WHERE Name LIKE '%Trey Research%'

  UPDATE Purchasing.Vendor
  SET Name = 'Trey & Wilson Research, Inc.'
  WHERE BusinessEntityID = 1584


  -- USER B (in other window)
  USE AdventureWorks2008
  GO

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

  SELECT
    *
  FROM Purchasing.Vendor
  WHERE BusinessEntityID = 1584


  -- will return 'Trey & Wilson Research, Inc'
  -- even before USER A does a ‘COMMIT TRANSACTION’
  -- because we are doing a dirty read (reading uncommitted)



  --The second level, READ COMMITTED is the default SQL Server isolation level. As the name implies, you can only query against committed data. So if another user is in the middle of a transaction that updates data, your query against the same record will be locked out until the original transaction completes. So in the example above, if USER A updates the record and then USER B tries to query before USER A’s transaction is done, USER B’s query will be in deadlock until USER A is done.

  --User A
  USE AdventureWorks2008
  GO

  BEGIN TRAN
    UPDATE Purchasing.Vendor
    SET Name = 'Trey & Wilson Research, Inc.'
    WHERE BusinessEntityID = 1584

    --User B
    USE AdventureWorks2008
    GO

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED

    SELECT
      *
    FROM Purchasing.Vendor
    WHERE BusinessEntityID = 1584

    -- This query will remain in DEADLOCK, because USER A
    -- has an exclusive lock on the ROW
    -- The query will finish when USER A does a COMMIT or a ROLLBACK

    --The third level is REPEATABLE READ. In some stored procedures, a developer may need to query the same row or set of rows more than once. It’s possible that another user may do something to update a row in between, which means that the original query might report a different value for the row. The process querying the data wants to ensure that the data remains the same between the two queries, even if someone tries to change the data during the process-in other words, the query wants to REPEAT the same read. So the user trying to update the record will be deadlocked out until the stored procedure finished. 

    --User B
    USE AdventureWorks2008
    GO

    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ

    BEGIN TRAN
      SELECT
        *
      FROM Purchasing.Vendor
      WHERE BusinessEntityID = 1584
      -- returns ‘Trey Research’

      --User A
      USE AdventureWorks2008
      GO

      BEGIN TRAN

        -- change from Trey Research to 'Trey & Wilson Research, Inc.'
        UPDATE Purchasing.Vendor
        SET Name = 'Trey & Wilson Research, Inc.'
        WHERE BusinessEntityID = 1584

        -- Deadlock, because USER B still has the row, and will continue
        -- to have the row, until USER B is finished

        --User B
        SELECT
          *
        FROM Purchasing.Vendor
        WHERE BusinessEntityID = 1584
      -- USER B will still have the same value as the first time…
      -- you are doing a ‘repeatable read’ and will get the same value
      -- until you commit….this is helpful if you have a stored proc
      -- that may read the same data multiple times, and need for it
      -- to be the same

      --User A
      -- still in deadlock!!!

      --User B
      COMMIT TRAN

    --User A
    -- lock is released from USER B’ stored procs
    COMMIT TRAN

    --The REPEATABLE READ level would seem to protect a long stored procedure that queries and re-queries data from any other processes that change the same data.
    --Suppose you have a long stored procedure that queries a set of data based on a condition, and then re-executes the same or similar query later in the procedure. Suppose someone INSERTS a new row in between, where the row meets the condition of the stored procedure? 

    --This newly inserted record is known as a “phantom” record and you may not wish to see it until your stored procedure finishes. In this case the REPEATABLE READ doesn’t protect you-the stored procedure would return a different result the second time. 

    --However, the forth transaction level (SERIALIZABLE) protects this, by using “key-range locks” to lock out any insertions that would otherwise affect the conditions of queries performed inside a SERIALIZABLE transaction. SERIALIZABLE offers you the greatest level of isolation from other processes-and as you also can see-runs greater risk of other processes being locked out until you finish.

    -- Isolation level SERIALIZABLE
    --User B
    USE AdventureWorks2008
    GO

    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
    BEGIN TRAN
      SELECT
        COUNT(*)
      FROM Purchasing.Vendor
      WHERE CreditRating = 2
      -- returns a count of 9

      --User A
      USE AdventureWorks2008
      GO

      BEGIN TRAN
        INSERT INTO Purchasing.Vendor (BusinessEntityID, AccountNumber, Name, CreditRating, PreferredVendorStatus, ActiveFlag, ModifiedDate)
          VALUES (555555, '000000A', 'My Test Vendor', 2, 1, 1, GETDATE())
      -- DEADLOCK, BECAUSE THIS INSERT WOULD AFFECT THE ROW COUNT
      -- result for the serializable transaction for USER B

      --User B
      COMMIT TRAN

    --User A
    -- INSERT finally goes through, can commit
    COMMIT TRAN


    --User B
    SELECT
      COUNT(*)
    FROM Purchasing.Vendor
    WHERE CreditRating = 2
    -- NOW returns a count of 10