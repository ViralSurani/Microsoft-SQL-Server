1: T-SQL Server 2008 “Stocking Stuffers”-New Language Features to Simplify Basic Operations
You can now DECLARE a variable and initialize it in one line of code.
You can use new Row Constructor syntax to insert multiple rows in a single statement. You simply separate the row definitions with parenthesis and a comma.
You can use basic assignment operators to simplify incrementing.

2: New GROUP BY Extensions
SQL Server 2008 offers new GROUP BY extensions that allow you to specify multiple GROUP BY options in a single table-yes, in the same record set that contains the details.

3: The New MERGE Statement to Combine INSERT/UPDATE/DELETE
UPSERT
If data exists in the source table but not the target table (based on a lookup on an ID column), insert the data from the source to the target
If data exists in both tables (again, based on a matching ID), update the data from the target table into the source table (some columns might have changed)
Finally, if any ID values are in the target, but don’t appear in the source, delete those ID values in the source.