-- Identify the top 3 cities with the highest number of customers to determine key markets for targeted marketing and logistic optimization.

select
location,
count(*) as number_of_customers
from
customer
group by location
order by number_of_customers desc
limit 3;

 /*
 Determine the distribution of customers by the number of orders placed. This insight will help in segmenting customers into one-time buyers, occasional shoppers, and regular customers for tailored marketing strategies.
 */
 
 with temp as (select 
customer_id,
count(*) as NumberOfOrders
from `order`
group by customer_id)
select
NumberOfOrders,
count(*) as CustomerCount
from
temp group by NumberOfOrders
order by NumberOfOrders;

/*
Identify products where the average purchase quantity per order is 2 but with a high total revenue, suggesting premium product trends.
*/

select
product_id as Product_Id,
avg(quantity) as AvgQuantity,
sum(quantity*price_per_unit) as TotalRevenue
from orderDetails
group by product_id
having  avg(quantity)=2
order by TotalRevenue desc;

/*
For each product category, calculate the unique number of customers purchasing from it. This will help understand which categories have wider appeal across the customer base.
*/

select p.category,
count(distinct o.customer_id) as unique_customers
from products p
join
orderdetails od
on p.product_id=od.product_id
join `order` o 
on o.order_id=od.order_id
group by p.category
order by unique_customers desc;

/*
Analyze the month-on-month percentage change in total sales to identify growth trends.
*/

with temp as (
select
date_format(order_date, '%Y-%m') as Month,
sum(total_amount) as TotalSales,
lag(sum(total_amount)) over(order by date_format(order_date, '%Y-%m')) as prev_total
from 
 `order`
group by Month
)

select Month,
TotalSales,
round(((TotalSales-prev_total)/prev_total)*100,2) as PercentChange
from 
temp;

/*
Examine how the average order value changes month-on-month. Insights can guide pricing and promotional strategies to enhance order value.
*/

with temp as (select
date_format(order_date,'%Y-%m') as  Month,
avg(total_amount)  as AvgOrderValue,
lag(avg(total_amount)) over(order by date_format(order_date,'%Y-%m')) as prev_avg
from
`order`
group by date_format(order_date,'%Y-%m'))
select 
Month,
AvgOrderValue,
round((AvgOrderValue-prev_avg),2) as ChangeInValue
from temp
order by ChangeInValue desc;

/*
Based on sales data, identify products with the fastest turnover rates, suggesting high demand and the need for frequent restocking.
*/

select
product_id,
count(order_id) as SalesFrequency
from
orderdetails
group by product_id
order by SalesFrequency desc
limit 5;

/*
List products purchased by less than 40% of the customer base, indicating potential mismatches between inventory and customer interest.
*/

with total_cust as (
    select count(distinct customer_id) as TotalCustomer from customer
),
allData as (
select 
od.product_id,
p.name,
count(distinct o.customer_id) as cust_count
from products p
join
orderdetails od  
on p.product_id=od.product_id
join 
`order` o
on o.order_id=od.order_id
join
customer c 
on o.customer_id=c.customer_id
group by od.product_id, p.name
)
select 
a.product_id as Product_id,
a.name as Name,
a.cust_count as  UniqueCustomerCount
from allData a 
cross join
total_cust t
where cust_count<0.4*TotalCustomer;

/*
Evaluate the month-on-month growth rate in the customer base to understand the effectiveness of marketing campaigns and market expansion efforts.
*/

with FP as ( select
    distinct customer_id,
    date_format(min(order_date), '%Y-%m') as FirstPurchaseMonth
    from `order`
    group by customer_id
)
select 
FirstPurchaseMonth,
count(distinct customer_id) as TotalNewCustomers
from FP
group by FirstPurchaseMonth
order by FirstPurchaseMonth;

/*
Identify the months with the highest sales volume, aiding in planning for stock levels, marketing efforts, and staffing in anticipation of peak demand periods.
*/

select 
date_format(order_date,'%Y-%m') as Month,
sum(total_amount) as TotalSales
from
`order`
group by 
date_format(order_date,'%Y-%m')
order by TotalSales desc
limit 3;
