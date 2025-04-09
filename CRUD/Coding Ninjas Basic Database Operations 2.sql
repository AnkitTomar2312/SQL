-- Where Clause
-- Syntax
-- SELECT column1, column2, ...
-- FROM table_name
-- WHERE condition;

-- Query to find the customers who have more than 2 children. (TotalChildren > 2)
select firstname, lastname, totalchildren
from customers
where totalchildren >= 2;

-- Query to find the customers with the total number of children not equal to 5. (TotalChildren <> 5)
select firstname, lastname, totalchildren
from customers
where totalchildren <> 5;

select firstname, lastname, totalchildren
from customers
where totalchildren != 5;
 
-- Syntax 1: (AND operator)
-- SELECT column1, column2, ...
-- FROM tableName
-- WHERE condition1 AND condition2;

-- Query to find the customers whose education level is Bachelors and Occupation is Professional.
-- (EducationLevel="Bachelors" AND Occupation="Professional")
select firstname, lastname, educationlevel, occupation
from customers
where educationlevel = "Bachelors" and occupation = "Professional";

-- Syntax 2: (OR)
-- SELECT column1, column2, ...
-- FROM tableName
-- WHERE condition1 OR condition2;

-- Query to find the customers with 0 children or are homeowners. (TotalChildren="0" OR HomeOwner="Y")
select prefix, firstname, lastname, totalchildren, homeowner
from customers
where totalchildren = 0 or homeowner = 'Y' or prefix = 'MRS.';

-- Syntax 3: (NOT)
-- SELECT column1, column2, ...
-- FROM tableName
-- WHERE NOT condition;

-- Query to find customers who do not own a home (NOT HomeOwner="Y")
select firstname, lastname, homeowner
from customers
where homeowner != 'Y';

select firstname, lastname, homeowner
from customers
where not homeowner = 'Y';

-- Syntax 4: 
-- SELECT column1, column2, ...
-- FROM tableName
-- WHERE columnname LIKE pattern;

-- Query to find the customers whose name starts with ‘S’ and ends with ‘S’. (LastName Like "S%S")
select firstname, lastname
from customers
where lastname like 'S%S';

-- Query to find the customers whose last name starts with 0 or multiple characters, 
-- have an ‘A’ in between followed by a single character, and end with ‘G’. (LastName Like "%A_G")
select firstname, lastname
from customers
where lastname like '%A_G';

-- Query to find customers whose names start and end with a vowel. (FirstName LIKE '[aeiou]%[aeiou]')
select firstname, lastname
from customers
where firstname like '[AEIOU]%[AEIOU]';

-- Syntax:
-- SELECT column1, column2, ...
-- FROM tableName
-- WHERE column IN (value1, value2, ...);

-- Query to find the customers with MRS and MS prefixes. (prefix IN ('MRS.', 'MS.'))
select prefix, firstname, lastname 
from customers
where prefix in ('MRS.','MS.');

-- Syntax:
-- SELECT column1, column2, ...
-- FROM tableName
-- WHERE column BETWEEN value1 AND value2;

-- Query to find the customers with a total number of children between  0-2. 
-- (CAST(TotalChildren as INT) between 0 and 2)
select firstname, lastname, totalchildren
from customers
where totalchildren between 0 and 3;

-- Syntax:
-- SELECT DISTINCT column1, column2, ...
-- FROM tableName
-- WHERE condition;

-- Query to find the unique Income of the customers. (AnnualIncome)
select annualincome
from customers;

select distinct annualincome
from customers;

-- Query to find the unique EducationLevel, Occupation of the customers.
select distinct educationlevel, occupation
from customers;

-- Basic syntax:
-- SELECT column1, column2, ...
-- FROM table_name
-- ORDER BY column1 [ASC|DESC], column2 [ASC|DESC], ...;

-- Query products to get ProductSKU, Productname, productcost, productprice 
-- ordering by Descending productcost
select productsku, productname, productcost, productprice
from products
order by productcost desc;

select distinct annualincome 
from customers
order by cast(annualincome as unsigned) desc;
 
-- Basic Syntax:
-- SELECT column1, column2, ...
-- FROM table_name
-- LIMIT number;

-- Query products to get ProductSKU, Productname, productcost, productprice for 10 products
-- ordering by Descending productcost
select productsku, productname, productcost, productprice
from products
order by productcost desc
limit 10;

-- Basic Syntax:
-- SELECT column1, column2, ...
-- FROM table_name
-- LIMIT number OFFSET offset;

-- Query products to get ProductSKU, Productname, productcost, productprice for 10 products offset 20
-- ordering by Descending productcost
select productsku, productname, productcost, productprice
from products
order by productcost desc
limit 10 offset 20;

-- Single Line Comment.

SELECT * FROM Customers; -- This is a comment after the code

-- Multi-line Comment

/* This is a multi-line comment
   and it can span multiple lines. */
   
SELECT * FROM Customers;


