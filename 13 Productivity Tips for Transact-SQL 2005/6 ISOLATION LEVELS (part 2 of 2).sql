--6: ISOLATION LEVELS (part 2 of 2)
--“You’ve reviewed the four isolation levels available in Tip #5 You’re looking for the ability to query against committed data, but you don’t want the query to implement any shared locks against the data.”

--In some situations, you may want to execute a series of queries in a stored procedure with the following guarantees:
--That you’re querying against committed data only.
--That you’ll return the same results each time.
--That another user can update the data, or insert related data, while your stored procedure is querying the same data, without the user	    experiencing a deadlock.
--That even when the user commits the update or insert transaction, your query will STILL continue to use the same version of the data that existed when your stored procedure queries begin.

--This scenario describes the SNAPSHOT isolation level in SQL Server 2005.

--The key word in the scenario above is “version” because SNAPSHOT isolation works by internally creating a snapshot version of data into the system tempdb database.

-- First, you must configure the database to support
-- SNAPSHOT isolation

ALTER database adventureWorks2008 set allow_snapshot_isolation on
GO

--User A
USE AdventureWorks2008
GO
begin tran
UPDATE Purchasing.Vendor
SET Name = 'Trey & Wilson Research, Inc.'
WHERE BusinessEntityID = 1584

--User B
use AdventureWorks2008
GO
set TRANSACTION ISOLATION LEVEL SNAPSHOT
begin tran
select * from Purchasing.Vendor where BusinessEntityID=1584
-- returns THE original Trey Research, because USER A hasn’t
-- COMMITTED the transaction


--User A
COMMIT tran


--User B
select * from Purchasing.Vendor where BusinessEntityID=1584
-- STILL continues to return the original Trey Research, because
-- USER B took a snapshot of the data

COMMIT tran

select * from Purchasing.Vendor where BusinessEntityID=1584
-- NOW returns the new value

--any option with this much power can come at a cost. You should only use this isolation level (or any isolation level) judiciously-abusing the SNAPSHOT level can become very resource intensive with the tempdb database.