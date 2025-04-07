-- Use cases of CTE
-- CTE is the short form for Common Table Expressions. CTE is one of the most powerful tools of SQL, 
-- and it also helps to clean the data. It is the concept of SQL used to simplify coding and help to get 
-- the result as quickly as possible. CTE is the temporary table used to reference the original table. 
-- If the original table contains too many columns and we require only a few of them, we can make CTE 
-- (a temporary table) containing the required columns only.

-- Functions of CTE
-- 1. Simplification of Complex Queries
-- 2. Improved Readability
-- 3. Reusability within Queries
-- 4. Support for Recursive Queries
-- 5. Temporary Scope

-- Generic Syntax
-- WITH CTE_NAME AS
-- (  
--   SELECT column_name1, column_name2,..., column_nameN
--   FROM table_name
--   WHERE condition
-- )
-- SELECT column_name1, column_name2,..., column_nameN 
-- FROM CTE_NAME;
use coding_ninja;
with nw_data as
(
select region, country, 
case when region = 'Northwest' then 1
else 0
end as nw_flag from territories
)
select region, sum(nw_flag) 
from nw_data
group by region;

select * from nw_data;

-- Example
WITH AverageCategoryPrice AS 
(
    SELECT psc.﻿productsubcategorykey,
           ROUND(AVG(p.productprice), 2) AS AvgPrice
    FROM products p
    JOIN product_subcategories psc ON p.productsubcategorykey = psc.﻿productsubcategorykey
    GROUP BY psc.productsubcategorykey
)
SELECT p.﻿ProductKey, p.Productname, p.productprice, acp.AvgPrice
FROM products p
JOIN AverageCategoryPrice acp ON p.productsubcategorykey = acp.﻿ProductSubcategoryKey
WHERE p.productprice > acp.AvgPrice
ORDER BY p.productprice DESC;

select * from AverageCategoryPrice;

-- Example Multiple CTEs:
WITH ReturnsByCategory AS (
    SELECT pc.categoryName, 
           SUM(r.returnQuantity) AS TotalReturns
    FROM returns r
    JOIN products p ON r.productkey = p.productkey
    JOIN product_subcategories psc ON p.﻿﻿﻿﻿ProductSubcategoryKey = psc.productsubcategorykey
    JOIN product_categories pc ON psc.productcategorykey = pc.﻿ProductCategoryKey
    GROUP BY pc.categoryName
),
RevenueByCategory AS (
    SELECT pc.categoryName, 
           SUM(p.productprice * s.orderquantity) AS TotalRevenue
    FROM sales_2015 s
    JOIN products p ON s.productkey = p.productkey
    JOIN product_subcategories psc ON p.﻿﻿﻿ProductSubcategoryKey = psc.productsubcategorykey
    JOIN product_categories pc ON psc.productcategorykey = pc.﻿ProductCategoryKey
    GROUP BY pc.categoryName
)
SELECT rbc.categoryName, rbc.TotalReturns, rvc.TotalRevenue
FROM ReturnsByCategory rbc
JOIN RevenueByCategory rvc ON rbc.categoryName = rvc.categoryName
ORDER BY rbc.TotalReturns DESC;

-- Example
WITH AvgCost AS (
    SELECT 
        pc.categoryName, 
        AVG(p.productcost) AS AvgProductCost
    FROM products p
    JOIN product_subcategories psc ON p.productsubcategorykey = psc.﻿ProductSubcategoryKey
    JOIN product_categories pc ON psc.productcategorykey = pc.﻿ProductCategoryKey
    GROUP BY pc.categoryName
),
RevenueByCategory AS (
    SELECT 
        pc.categoryName, 
        SUM(p.productprice * s_2017.orderquantity) AS TotalRevenue
    FROM sales_2017 s_2017
    JOIN products p ON s_2017.productkey = p.﻿ProductKey
    JOIN product_subcategories psc ON p.productsubcategorykey = psc.﻿ProductSubcategoryKey
    JOIN product_categories pc ON psc.productcategorykey = pc.﻿ProductCategoryKey
    GROUP BY pc.categoryName
)
SELECT ac.categoryName, ac.AvgProductCost, rbc.TotalRevenue
FROM AvgCost ac
JOIN RevenueByCategory rbc ON ac.categoryName = rbc.categoryName
ORDER BY rbc.TotalRevenue DESC;

-- Use of sub-queries in SQL
-- Subqueries and nested queries are terms that are often used interchangeably in SQL, 
-- but they refer to the same concept: a query embedded within another query.
-- A subquery is a SQL query that is nested inside another SQL query.

-- Need of sub-queries in SQL
-- 1. Data Retrieval from Multiple Tables
-- 2. Complex Calculations
-- 3. Filtering with Values from Other Tables
-- 4. Reusability and Modularity

-- Generic Syntax with SELECT statement
-- SELECT column1, column2, ...,
--        (subquery)
-- FROM table1
-- [WHERE condition];

-- Example
SELECT p.ProductSubcategoryKey, 
ROUND(AVG(p.ProductCost), 2)
FROM Products p, Product_Subcategories ps
WHERE p.ProductSubcategoryKey = ps.ProductSubcategoryKey
Group By p.ProductSubcategoryKey;

SELECT ps.SubcategoryName, (
    SELECT 
	ROUND(AVG(p.ProductCost), 2)
    FROM Products p
    WHERE p.ProductSubcategoryKey = ps.ProductSubcategoryKey
) AS AvgProductCost
FROM Product_Subcategories ps;

-- Generic Syntax with FROM statement
-- SELECT column1, column2, ...
-- FROM (
--   subquery
-- ) AS alias
-- [WHERE condition];

-- Example
SELECT p.ProductKey, p.Productname, sub.total_sales_quantity
FROM products p,
    (SELECT 
        s.productkey,
        ROUND(SUM(s.orderquantity * p.productPrice), 2) AS total_sales_quantity
    FROM sales_2017 s
    JOIN products p on p.ProductKey = s.productkey
    GROUP BY s.productkey) sub
WHERE p.ProductKey = sub.productkey
ORDER BY sub.total_sales_quantity DESC
LIMIT 10;

-- Generic Syntax with WHERE statement
-- SELECT column1, column2, ...
-- FROM table1
-- WHERE column_expression [NOT] operator (
--   subquery
-- );

-- Example
SELECT p.ProductKey,
SUM(r.ReturnQuantity)
FROM Returns r, Products p
WHERE r.ProductKey = p.ProductKey
group by p.ProductKey;

SELECT p.ProductKey, p.ProductName, p.ModelName
FROM Products p
WHERE (
    SELECT
	SUM(r.ReturnQuantity)
    FROM Returns r
    WHERE r.ProductKey = p.ProductKey
) > 50;
-- aggregate value is returned


-- Generic Syntax with HAVING statement
-- SELECT column1, column2
-- FROM table1
-- GROUP BY column1, column2
-- HAVING aggregate_condition [NOT] operator (
--   subquery
-- );

-- Example
SELECT 
    p.Productname,
    SUM(r.returnQuantity) AS total_return_quantity
FROM products p
JOIN returns r ON p.ProductKey = r.productkey
GROUP BY p.Productname
HAVING SUM(r.returnQuantity) > 
	(SELECT AVG(total_return_quantity) 
    FROM 
		(SELECT SUM(returnQuantity) AS total_return_quantity 
FROM returns GROUP BY productkey) subquery);

-- Generic Syntax of Subqueries in Joins
-- SELECT column1, column2, ...
-- FROM table1
-- [INNER | LEFT | RIGHT | FULL] JOIN table2
--   ON table1.column = (
--     subquery
--   )
-- [WHERE condition];

-- Example
SELECT t.region, sub.total_return_quantity
FROM territories t
JOIN (
    SELECT r.territorykey,
        SUM(r.returnQuantity) AS total_return_quantity
    FROM returns r
    GROUP BY r.territorykey
) sub ON t.salesterritorykey = sub.territorykey
ORDER BY sub.total_return_quantity DESC;

-- Generic Syntax of sub-query inside another sub-query
-- SELECT column1, column2, ...
-- FROM table1
-- WHERE column_expression operator (
--   SELECT column1, column2, ...
--   FROM table2
--   WHERE column_expression operator (
--     subquery
--   )
-- );

-- Example
SELECT t.region, sub.total_return_quantity
FROM territories t
JOIN (
    SELECT  r.territorykey,
			SUM(r.returnQuantity) AS total_return_quantity
    FROM returns r
    GROUP BY r.territorykey
) sub ON t.salesterritorykey = sub.territorykey
WHERE sub.total_return_quantity = (
    SELECT MAX(total_return_quantity)
    FROM (
        SELECT territorykey, SUM(r2.returnQuantity) AS total_return_quantity
        FROM returns r2
        GROUP BY r2.territorykey
    ) sub2
);










































