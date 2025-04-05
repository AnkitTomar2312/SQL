-- Cross Join
-- Syntax
-- SELECT *
-- FROM table1
-- CROSS JOIN table2;

use coding_ninja;


rename table `product-subcategories` to `product_subcategories`;

-- Cross Join product_categories and product_subcategories
select count(*) from product_categories;
select count(*) from product_subcategories;

select count(*)
from product_categories
cross join product_subcategories;

-- SELF JOIN
-- Syntax
-- SELECT columns
-- FROM table1 alias1
-- JOIN table1 alias2 ON alias1.column_name = alias2.column_name;
 
-- Create table employees
Drop table if exists employees;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    employee_designation VARCHAR(100),
    manager_id INT
);

-- Insert values in employees
INSERT INTO employees (employee_id, employee_name, employee_designation, manager_id) VALUES
(1, 'Alice', 'CEO', NULL),       -- Alice is the CEO (no manager)
(2, 'Bob', 'VP of Sales', 1),    -- Bob reports to Alice
(3, 'Charlie', 'VP of Engineering', 1),  -- Charlie reports to Alice
(4, 'David', 'Sales Manager', 2),  -- David reports to Bob
(5, 'Eve', 'Sales Manager', 2),  -- Eve reports to Bob
(6, 'Frank', 'Engineering Manager', 3),  -- Frank reports to Charlie
(7, 'Grace', 'Engineering Manager', 3),  -- Grace reports to Charlie
(8, 'Hank', 'Sales Executive', 4),  -- Hank reports to David
(9, 'Ivy', 'Sales Executive', 5),  -- Ivy reports to Eve
(10, 'Jack', 'Software Engineer', 6);  -- Jack reports to Frank

select * from employees;

-- Query employees to get the employee name and desgnation and manager name and designation in front of 
-- individual employees joining on e.manager_id = m.employee_id
select e.employee_name, e.employee_designation, 
	   m.employee_name as manager_name, m.employee_designation as manager_designation
from employees as e
join employees as m
on m.employee_id = e.manager_id;

-- IFNULL
-- Syntax
-- SELECT IFNULL(expression, value_if_null) AS alias
-- FROM table_name;

-- COALESCE
-- Syntax
-- SELECT COALESCE(column_name, value_if_null)
-- FROM table_name;

-- Create a table customer_dummy
drop table if exists customer_dummy;
CREATE TABLE customer_dummy (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(255)
);

INSERT INTO customer_dummy (customer_id, customer_name, email, phone, address) VALUES
(1, 'Alice', NULL, '1234567890', '123 Street, NY'),
(2, 'Bob', 'bob@example.com', NULL, '456 Avenue, LA'),
(3, 'Charlie', NULL, NULL, '789 Boulevard, TX'),
(4, 'David', 'david@example.com', '9876543210', NULL),
(5, 'Eve', NULL, NULL, NULL);

select * from customer_dummy;

-- Query customer_dummy to get customer id, name and the following
-- 1. email_status such that if email is null, it should return 'No email provided' using ifnull
-- 2. contact_info such that if email is null, it takes phone and if that is null, it takes address and if that is null too
-- it returns 'No Contact Provided' using coalesce
select customer_id,customer_name,
ifnull(email,'No Email Provided') as email_info,
coalesce(email,phone,address,'No Contact Detail Provided') as contact_detail
from customer_dummy;

-- Fun Time

-- Total Return Quantity by Product Subcategory and Category
-- Approach: 
-- Pull categoryname, subcategoryName and sum of returnQuantity
-- joining products and returns on productkey
-- joining product_subcategories and products on productsubcategorykey
-- joining product_subcategories and product_categories on productcategorykey
alter table returns
rename column `ï»¿ReturnDate` to `ReturnDate`;

select pc.categoryname, ps.subcategoryname, sum(r.returnquantity) as total_return_quantity
from product_categories as pc
inner join product_subcategories as ps on pc.﻿ProductCategoryKey = ps.ProductCategoryKey
inner join products as p on ps.﻿ProductSubcategoryKey = p.ProductSubcategoryKey
inner join returns as r on r.ProductKey = p.﻿ProductKey
group by pc.categoryname, ps.subcategoryname
order by total_return_quantity;

-- Territories with a Total Return Quantity Greater Than 200
-- Approach
-- Pull region, country, sum of returnQuantity
-- joining returns and territories on territorykey
-- HAVING total_return_quantity > 200


-- Top 5 Product Subcategories by Total Return Quantity
-- Approach: 
-- Pull subcategoryName and sum of returnQuantity
-- joining products and returns on productkey
-- joining product_subcategories and products on productsubcategorykey
-- joining product_subcategories and product_categories on productcategorykey
-- ORDER BY total_return_quantity DESC  


-- Top 5 Customers by Total Sales Quantity
-- Approach
-- Pull firstname, lastname, sum of orderquantity
-- joining sales_2017 and customers on customerkey
-- ORDER BY total_sales_quantity DESC


