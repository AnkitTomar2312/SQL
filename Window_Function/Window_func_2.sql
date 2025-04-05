use coding_ninja;

alter table products
rename column `ï»¿ProductKey` to `ProductKey`;

-- Lag Concept
-- getting the data from the history

select * from sales_sample;

-- Example:
-- Get the values of sales for every row from the preceding date ordering 
-- by time and store it as prev_sales
-- for customers individually. Pull all the other column.

select *,
lag(SaleAmount,2) over(partition by  Salesperson order by SaleDate) prev_sales
from sales_sample;

-- [Get the data in year-month format order date] and 
-- [sum of [product of order quantity and product price]] over year_and_month 
-- as total_sale_amount. 
-- Also get the [previous month total_sale_amount in another column]. 
-- Also get the [change in the sale amount of current and prev month]

select * from sales_2016;
select * from products;

select date_format(str_to_date(s.OrderDate,'%Y-%m-%d'), '%Y-%m') year_and_month
from sales_2016 s; 

with sale as(
select date_format(str_to_date(s.OrderDate,'%Y-%m-%d'), '%Y-%m') year_and_month,
round(sum(s.OrderQuantity*p.ProductPrice),2) as total_sales_amount,
lag(round(sum(s.OrderQuantity*p.ProductPrice),2)) 
over(order by date_format(str_to_date(s.OrderDate,'%Y-%m-%d'), '%Y-%m')) as previous_month_sale_amount
from sales_2016 s
join products p
on s.ProductKey=p.ProductKey
group by date_format(str_to_date(s.OrderDate,'%Y-%m-%d'), '%Y-%m')
order by year_and_month)
select year_and_month, total_sales_amount, 
-- previous_month_sale_amount,
total_sales_amount - previous_month_sale_amount as change_in_sale_amount,
((total_sales_amount - previous_month_sale_amount)/previous_month_sale_amount*100)
as percentage_change_in_sales
from sale;

WITH sales_data AS (
    SELECT 
        date_format(str_to_date(s.OrderDate,'%Y-%m-%d'), '%Y-%m') AS yearmonth,
        SUM(s.OrderQuantity * p.ProductPrice) AS total_sale_amount
    FROM sales_2016 s
    JOIN products p ON s.ProductKey = p.ProductKey
    GROUP BY yearmonth
)
SELECT 
    yearmonth,
    total_sale_amount,
    LAG(total_sale_amount) OVER (ORDER BY yearmonth) AS prev_month_sale_amount,
    total_sale_amount - LAG(total_sale_amount) OVER (ORDER BY yearmonth) AS change_in_sale
FROM sales_data;

-- LEAD() concept 

select *,
lead(SaleAmount) over(partition by Salesperson order by SaleDate) next_sale
from sales_sample;

with sale as(
select date_format(str_to_date(s.OrderDate,'%Y-%m-%d'), '%Y-%m') year_and_month,
round(sum(s.OrderQuantity*p.ProductPrice),2) as total_sales_amount,
lead(round(sum(s.OrderQuantity*p.ProductPrice),2)) 
over(order by date_format(str_to_date(s.OrderDate,'%Y-%m-%d'), '%Y-%m')) as next_month_sale_amount
from sales_2016 s
join products p
on s.ProductKey=p.ProductKey
group by date_format(str_to_date(s.OrderDate,'%Y-%m-%d'), '%Y-%m')
order by year_and_month)
select year_and_month, total_sales_amount, next_month_sale_amount,
abs(total_sales_amount - next_month_sale_amount) as change_in_sale_amount,
round(abs((total_sales_amount - next_month_sale_amount)/next_month_sale_amount*100),2)
as percentage_change_in_sales
from sale; 

-- First value & Last values

-- Example
-- populate first customer's first and last names (order by orderDate) in 
-- seperate columns for all the the productkeys.
-- Pull productkey from sales_2016, firstname and lastname from Customers. Join on customerkey.
 select * from sales_2016;
 select * from customers;
 
select S.ProductKey, C.FirstName,C.LastName,
first_value(C.FirstName) over(partition by ProductKey order by Orderdate) as first_customer_firstname,
first_value(C.LastName) over(partition by ProductKey order by Orderdate) as first_customer_lastname
from customers C
join sales_2016 S
on C.customerKey=S.customerKey
order by S.productKey;

select S.ProductKey, C.FirstName,C.LastName,
last_value(C.FirstName) over(partition by S.ProductKey) as last_customer_firstname,
last_value(C.LastName) over(partition by S.ProductKey) as last_customer_lastname
from customers C
join sales_2016 S
on C.customerKey=S.customerKey
order by S.productKey;

select S.ProductKey, C.FirstName,C.LastName,
nth_value(C.FirstName,2) over(partition by ProductKey order by Orderdate) as first_customer_firstname,
nth_value(C.LastName,2) over(partition by ProductKey order by Orderdate) as first_customer_lastname
from customers C
join sales_2016 S
on C.customerKey=S.customerKey
order by S.productKey;

-- NTILE concept i.e. percentile categorise the values based on top values

-- Example- get top 20% high priced product from table product
-- Also pull columns productkey, productname, productprice

select ProductKey, ProductName, ProductPrice,
ntile(10) over(order by ProductPrice desc) as priceDecile
from products;

with decileTable as (
select ProductKey, ProductName, ProductPrice,
ntile(10) over(order by ProductPrice desc) as priceDecile
from products
)
select count(*)
from decileTable
where priceDecile<=2;

select count(*) from products;