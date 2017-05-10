
1: PIVOT<br>
“You want to query a table of vendor orders and group the order amounts by quarter for each vendor.”<br>

2: CTEs and Recursive Queries (1 of 2)<br>
“You have a hierarchy of product items, groups, and brands, all in a single table. Each row has a parent key that points to the row’s parent. For any single row, you want to know all the row’s parent rows, or all the row’s child rows.”<br>

3: CTEs and Recursive Queries (2 of 2)<br>
“You need to take a table of vendor orders and produce a flat result set for a weekly report or chart for the first quarter of 2004. The result set must contain one row for each vendor and week-ending date, with the sum of orders for that week (even if zero).”<br>

4: OUTPUT and OUTPUT INTO<br>
“You are inserting rows into a table and want to immediately retrieve the entire row, without the need for another SELECT statement, or a round trip to the server, and without using SCOPE_IDENTITY. Additionally, when you UPDATE rows in a table, you want to immediately know the contents of the row both before and after the UPDATE-again, without the need for another set of queries.”<br>

