-- Creating a table in SQL
-- Syntax
-- CREATE TABLE table_name (
--     column1 datatype1 [constraint],
--     column2 datatype2 [constraint],
--     column3 datatype3 [constraint],
--     ...
--     [table_constraints]
-- );

-- Create a table employees in SQL with following columns and datatypes
-- EmployeeID which is an INT and PRIMARY KEY
-- FirstName which is VARCHAR of 50 length and NOT NULL constraint
-- Email which is VARCHAR of 100 length, has UNIQUE values and NOT NULL constraint
-- Salary which is DECIMAL of precision (10, 2)
-- BirthDate which is DATE and NOT NULL constraint
create table employees(
employeeid int primary key,
firstname varchar(50) not null,
email varchar(100) unique not null,
salary decimal(10,2),
birthdate date not null );

select * from employees;

create table misc(
employeeid int primary key,
birthdate date not null,
aadhar text(12) unique);
 

-- Creating a table in SQL from the existing table
-- Syntax
-- CREATE TABLE new_table_name AS
-- SELECT * FROM existing_table_name;

-- Create a separate table containing all the records similar to the Customers table. 
-- Rename the new table to CustomerDetails.

-- Read from SQL Table
-- Query to find the colors of the products from performing well financially in the market.
-- (ProductPrice> 1000 AND ProductCost<1000)


-- Update SQL Table
-- Syntax
-- UPDATE table_name
-- SET column1 = value1, column2 = value2, ...
-- WHERE condition;

-- Query to update multiple rows in customerdetails at a time
-- SET emailaddress ='huang@learnsector.com'
-- WHERE lastname='huang'.


-- Delete from SQL
-- Syntax
-- DELETE FROM table_name
-- WHERE some_condition;

-- Query to delete the rows from customerdetails WHERE lastname='huang'.

-- Query to delete all rows from customerdetails (No need for where condition).

-- Null and Empty Values
-- Syntax:
-- SELECT column_names
-- FROM table_name
-- WHERE column_name IS NULL;

-- Query to get null records from customers from Prefix using prefix is null condition

-- Query to get null records from customers from Prefix using Prefix = ''

-- Convert (Update) EMPTY values to NULL values using SET Prefix= NULL WHERE Prefix = ''

-- Drop Table
-- Syntax
-- DROP TABLE table_name;

-- Query to drop table customerdetails 

 
 
 
   