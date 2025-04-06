-- MySQL CASE expression is a part of the control flow function that allows us to write an if-else or if-then-else logic to a query.
-- The CASE expression validates various conditions and returns the result when the first condition is true.
-- Evaluates a set of conditions or expressions, and based on the first condition that evaluates to true, it returns the corresponding result or value.

-- Generic Syntax
-- SELECT column1, column2,
--     	CASE
--         	WHEN condition1 THEN result1
--         	WHEN condition2 THEN result2
--        	ELSE resultN
--     	END AS alias_name
-- FROM table_name;

-- Example
-- SELECT customerkey, annualincome,
--     CASE
--         WHEN annualincome < 50000 THEN 'Low Income'
--         WHEN annualincome BETWEEN 50000 AND 100000 THEN 'Moderate Income' 
--         ELSE 'High Income'
--     END AS income_category
-- FROM customers;
use coding_ninja;

SET SQL_SAFE_UPDATES = 0;

update customers
set AnnualIncome=null
where AnnualIncome='';

alter table customers
change AnnualIncome AnnualIncome int;

select CustomerKey,AnnualIncome,
case when AnnualIncome<=50000 then 'Low Income'
	when  AnnualIncome between 50000 and 100000 then 'Mid Income'
    else 'High Income'
    end as income_category
from customers;


-- Handling of NULL Values using CASE statement
-- Generic Syntax
-- SELECT column1, column2,
--     	CASE 
--         	WHEN column_name IS NULL THEN 'Replacement Value'
--         	ELSE column_name
--     	END AS alias_name
-- FROM table_name;

-- Example
-- SELECT customerkey, annualincome,
--     CASE
--         WHEN annualincome < 50000 THEN 'Low Income'
--         WHEN annualincome BETWEEN 50000 AND 100000 THEN 'Moderate Income' 
--         WHEN annualincome IS NULL THEN 'Not Available'
--         ELSE 'High Income'
--     END AS income_category
-- FROM customers;

select CustomerKey,AnnualIncome,
case when AnnualIncome<=50000 then 'Low Income'
when AnnualIncome between 50000 and 100000 then 'Mid Income'
when AnnualIncome is null then 'Not Available'
else 'High Income'
end as income_category
from customers;



-- Updating of a table using CASE statement
-- Generic Syntax
-- UPDATE table_name
-- SET column1 = CASE
--                  WHEN condition1 THEN value1
--                  WHEN condition2 THEN value2
--                  ELSE default_value
--               END,
--      column2 = CASE
--                  WHEN condition1 THEN value3
--                  WHEN condition2 THEN value4
--                  ELSE default_value
--               END
-- WHERE condition;
create table customerdetails  select * from customers;

-- Example
ALTER TABLE customerdetails
ADD COLUMN IncomeCategory varchar(50)
AFTER annualincome;

select * from customerdetails;

UPDATE customerdetails
SET IncomeCategory = CASE
                 WHEN annualincome < 30000 THEN "low_income"
                 WHEN annualincome BETWEEN 30000 and 100000 THEN "moderate_income"
                 WHEN annualincome IS NULL or annualincome = '' THEN "Not Available"
                 ELSE "high_income"
              END;
              
SELECT * FROM customerdetails;

-- Conditional aggregation using CASE statement

-- Generic Syntax
-- SELECT column1, column2,
--     	CASE 
-- 			WHEN AGGREGATE_FUNCTION(col_name) condition1 THEN value1 
-- 			WHEN condition2 THEN value2
--      	ELSE default_value 
-- 		END AS alias_name,
-- FROM table_name
-- GROUP BY column1, column2

select customerkey, max(annualincome) 
from customers
group by customerkey;

show columns from territories;

alter table territories
rename column `ï»¿SalesTerritoryKey` to `SalesTerritoryKey`;
desc territories;
desc returns;

-- Example
SELECT t.region,
	ROUND(AVG(p.productcost), 2) AS AvgProductCost,
	CASE 
		WHEN AVG(p.productcost) > 200 THEN 'High Cost' 
		ELSE 'Low Cost'
	END AS CostCategory
FROM products p
JOIN product_subcategories psc ON p.productsubcategorykey = psc.﻿ProductSubcategoryKey
JOIN product_categories pc ON psc.productcategorykey = pc.﻿ProductCategoryKey
JOIN returns r ON p.﻿ProductKey = r.productkey
JOIN territories t ON r.territorykey = t.﻿SalesTerritoryKey
GROUP BY t.region
ORDER BY AvgProductCost DESC;

-- Example
SELECT TerritoryKey, orderQuantity,
	SUM(CASE
		WHEN orderQuantity > 2 THEN orderquantity
		ELSE 0
		END) AS High_Performance_Sales,
		SUM(CASE
		WHEN orderQuantity BETWEEN 1 AND 2 THEN orderquantity
		ELSE 0
		END) AS Medium_Performance_Sales,
		SUM(CASE
		WHEN orderQuantity < 1 THEN orderquantity
		ELSE 0
		END) AS Low_Performance_Sales
FROM Sales_2017
GROUP BY Territorykey,orderQuantity;

select count(*) -- TerritoryKey, orderQuantity
FROM Sales_2017
where TerritoryKey = 4 and orderQuantity = 3;

-- Conditional logic in JOINs
-- Generic Syntax
-- SELECT [columns]
--        [CASE expression]
-- FROM table1
-- [JOIN type] table2 ON table1.column = table2.column
--         	[AND (CASE
--                       WHEN condition1 THEN true_value
--                       WHEN condition2 THEN true_value
--                       ELSE false_value
--                   END)]
-- [JOIN type] table3 ON table2.column = table3.column
--             [AND (CASE
--                       WHEN condition1 THEN true_value
--                       WHEN condition2 THEN true_value
--                       ELSE false_value
--                   END)]
-- WHERE condition
-- GROUP BY columns
-- ORDER BY columns;

-- Example

SELECT 
    p.ProductName, 
    pc.CategoryName, 
    psc.SubcategoryName,
    SUM(IFNULL(r.ReturnQuantity, 0)) AS TotalReturns,
    CASE
        WHEN SUM(IFNULL(r.ReturnQuantity, 0)) > 50 THEN 'High Returns'
        WHEN SUM(IFNULL(r.ReturnQuantity, 0)) > 25 THEN 'Moderate Returns'
        ELSE 'Low Returns'
    END AS ReturnLevel
FROM Products p
JOIN Product_Subcategories psc 
    ON p.ProductSubcategoryKey = psc.﻿ProductSubcategoryKey
JOIN Product_Categories pc 
    ON psc.ProductCategoryKey = pc.﻿ProductCategoryKey
LEFT JOIN Returns r 
    ON p.﻿ProductKey = r.ProductKey
    AND (
        (pc.CategoryName = 'Bikes' AND r.ReturnQuantity > 20) OR
        (pc.CategoryName = 'Components' AND r.ReturnQuantity > 5) OR
        (pc.CategoryName NOT IN ('Bikes', 'Components'))
    )
JOIN Territories t 
    ON r.TerritoryKey = t.﻿SalesTerritoryKey
    AND (
        (t.Region = 'North America' AND r.ReturnQuantity > 20) OR
        (t.Region = 'Europe' AND r.ReturnQuantity > 15) OR
        (t.Region NOT IN ('North America', 'Europe'))
    )
GROUP BY p.ProductName, pc.CategoryName, psc.SubcategoryName
-- HAVING TotalReturns > 10
ORDER BY TotalReturns DESC;

-- Some Examples:

-- 1. Customer Return Behaviour
SELECT c.customerkey, c.FirstName, c.lastname,
    SUM(COALESCE(r.returnQuantity, 0)) AS total_return_quantity,
    CASE
         WHEN SUM(COALESCE(r.returnQuantity, 0)) > 5 THEN 'Frequent Returner'
         WHEN SUM(COALESCE(r.returnQuantity, 0)) between 1 and 5 THEN 'Occasional Returner'
         ELSE 'Non-Returner'
     END AS return_behavior
FROM customers c
LEFT JOIN sales_2015 s5 ON c.customerkey = s5.customerkey
LEFT JOIN returns r ON s5.ProductKey = r.ProductKey
GROUP BY c.customerkey, c.FirstName, c.lastname
ORDER BY total_return_quantity DESC;

-- 2. Total Return Quantity by Product Subcategory and Category with Segmentation
SELECT pc.categoryname, ps.subcategoryname,
    	SUM(r.returnQuantity) AS total_return_quantity,
    	CASE WHEN SUM(r.returnQuantity) > 100 THEN 'High Return'
        	 WHEN SUM(r.returnQuantity) > 50 THEN 'Medium Return'
        	 ELSE 'Low Return'
    	END AS return_segment
FROM products p
JOIN product_subcategories ps ON p.productsubcategorykey = ps.productsubcategorykey
JOIN product_categories pc ON ps.productcategorykey = pc.productcategorykey
JOIN returns r ON p.productkey = r.productkey
GROUP BY pc.categoryname, ps.subcategoryname;

-- 3. Total product cost and total product price for each product category
SELECT pc.categoryName,
    CASE
        WHEN SUM(COALESCE(p.productCost, 0)) < 10000 THEN 'Low Cost Category'
        WHEN SUM(COALESCE(p.productCost, 0)) >= 10000 AND SUM(COALESCE(p.productCost, 0)) < 50000 THEN 'Moderate Cost Category'
        ELSE 'High Cost Category'
    END AS CategoryCostLabel,
    ROUND(SUM(COALESCE(p.productCost, 0)), 2) AS TotalProductCost,
    ROUND(SUM(COALESCE(p.productPrice, 0)), 2) AS TotalProductPrice
FROM
    Products p
    JOIN Product_Subcategories ps ON p.productSubcategoryKey = ps.productSubcategoryKey
    JOIN Product_Categories pc ON ps.productCategoryKey = pc.productCategoryKey
GROUP BY pc.categoryName
ORDER BY TotalProductCost DESC;

-- 4. Total return quantity and average product price for each product subcategory and region
SELECT ps.subcategoryName, t.region,
    SUM(r.returnQuantity) AS TotalReturnQuantity,
    ROUND(AVG(p.productPrice), 2) AS AvgProductPrice,
    CASE
        WHEN AVG(p.productPrice) < 100 THEN 'Below $100'
        ELSE 'Above $100'
    END AS PriceLabel
FROM Returns r
JOIN Products p ON r.productKey = p.productKey
JOIN Product_Subcategories ps ON p.productSubcategoryKey = ps.productSubcategoryKey
JOIN Territories t ON r.territoryKey = t.salesterritoryKey
GROUP BY ps.subcategoryName, t.region
ORDER BY TotalReturnQuantity DESC;








