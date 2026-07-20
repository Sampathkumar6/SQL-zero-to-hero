-- Unit 04	-08-aggregation-analytical-functions
-- Date:	- 17-07-2026
-- Topics:	- aggregate functions, window basics, window aggregate funtions, window ranking funtion, window value funtion

--find the total number of orders

Select
count(*) as total_nr_of_orders
from sales.orders

--find the total sales of all orders
select
sum(sales) as totalsales
from sales.Orders

 --avg sales all porders
select
avg(sales) as avg_sales
from sales.Orders

-- max and min

select
max(sales) as max_sales,
min(sales) as min_sales
from sales.Orders

--combined
select
customerid,
count(*) as total_nr_of_orders,
sum(sales) as totalsales,
avg(sales) as avg_sales,
max(sales) as max_sales,
min(sales) as min_sales
from sales.Orders
group by customerid


--analyze the scores in customer table

Select
country,
count(*) as total_score,
sum(score) as totalsales,
avg(score) as avg_score,
max(score) as max_score,
min(score) as min_score
from Sales.customers
group by Country

--Window functions
--total sales across all orders

Select
sum(sales) 
from sales.Orders

--total sales for each product
select
productid,
sum(sales) as total_sales
from sales.Orders
group by productid

--find the total sales for each product , aditionally provide details such orderid,order date

Select
orderid,
OrderDate,
productid,
sum(sales) over(partition by productid)  total_sales_by_productid
from sales.orders

--find the total sales across orders 
--Aditionally provide details such as orderid, order status

Select
orderid,orderdate,
sum(sales) over() totalsales
from sales.orders

--find the total sales for each product aditionally provide details like orderid,orderdate

--partition clause--------------------

Select
orderid,orderdate,productid,
sum(sales) over(partition by productid) totalsales_productid
from sales.orders

--find total sales of all orders 
--find the total sales for each product aditionally provide details like orderid,orderdate

Select
orderid,orderdate,productid,sales,
sum(sales) over() totalsales,
sum(sales) over(partition by productid) totalsales_productid
from sales.orders

--find the total sales for each combination of product and order status
select
o1.orderid,o1.productid,o1.orderstatus,
sum(o1.sales) over(partition by o1.productid , o1.orderstatus) totalsales_combined_orderproduct
from sales.orders as o1

--order clause--------------------------------

--Rank each order based on their sales from highest to lowest,
--aditionallly provide details such as orderid, orderdate

Select
orderid,OrderDate,Sales,
rank() over(order by sales desc) as salesrank_desc
from sales.orders

--example for window function

Select
orderid,orderdate,orderstatus,sales,
sum(sales) over(partition by orderstatus order by orderdate rows between current row and 2 following) totalsales
from sales.Orders

--window funtion with where
-- find the total sales for each order status, only for two products 101 and 102
Select
orderid,orderdate,orderstatus,sales,
sum(sales) over(partition by orderstatus order by orderdate rows between current row and 2 following) totalsales
from sales.Orders
where productid in (101,102)


--rank the customer on total sales

select
customerid,
sum(sales) totalsales,
rank() over(order by sum(sales) desc) Rankcustomers
from sales.orders
group by CustomerID

--window aggregate funstions--
--count

--find total number of orders
--provide details such as orderid, orderdate

Select
orderid,orderdate,
count(*) over() total_orders 
from sales.Orders

--total orders by each customer
Select
customerid,
count(*) over(partition by customerid) total_orders
from sales.Orders

--find total number of customers, aditionallly provide all customer details
Select
*,
count(*) over() customerstotal
from sales.Customers

--find the total number of scores for the customers

Select
*,
count(score) over() totalscore
from sales.Customers

--handling duplicate rows
--check id table orders for any dupllicate rows

select
orderid,
count(*) over(partition by orderid) allorders,
(count(*) over(partition by orderid)) - 1 checkduplicae
from sales.Orders

--in case of dupllicates
Select
*
from (
	select
	orderid,
	count(*) over(partition by orderid) checkorders
	from sales.OrdersArchive
	)t
where checkorders > 1

--sum-------
/* Find total sales across all orders
and total sales foreach product .
Additionallly, provide details such as orderid, and orderdate*/

Select
orderid, orderdate, sales,
sum(sales) over() order_totalsales,
sum(sales) over(partition by productid) product_totalsales
from sales.Orders

--find the percentage contribution of each product's sales to the total sales

Select
*,
round(cast(sales as float)/ productsales_total * 100,2) as percent_contribution
from
(
Select
productid,sales,
sum(sales) over(partition by productid) productsales_total
from sales.Orders)t

--avg----------

/*find the avg sales across all orders
and find the average sales foreach product
additionally provide details such as orderid, orderdate*/

Select
orderid,orderdate,productid,sales,
avg(sales) over() as order_all_avgsales,
avg(sales) over(partition by productid) as product_avgsales
from sales.orders

--find the average svores ofcustomers and provide details like customerid, lastname

Select
customerid,LastName,score,
coalesce(score,0) customerscore,
AVG(score) over() customer_avgscore_null,
avg(coalesce(score,0)) over() customer_avgscore_nonull
from sales.Customers

--find all orders where sales are higher than the average sales across all orders
Select
*
from
(
Select
OrderID,sales,
avg(sales) over() avgsales
from sales.Orders
)t where sales > avgsales

/*find the highest and lowest sales for all orders
and the highest and lowest sales for each product
and provide details like orderid and orderdate*/

Select
orderid,OrderDate,productid,Sales,
max(sales) over() as max_ordersale,
min(sales) over() as min_ordersale,
max(sales) over(partition by productid) as max_productsale,
min(sales) over(partition by productid) as min_productsale
from sales.Orders

--show the employees who have the highest salaries
Select
* from (
Select
*,
max(Salary) over() emp_highsalary
from sales.Employees)t where Salary = emp_highsalary

--find the deviation from each sales from min and max sale amounts

Select
*,
sales - max_ordersale as deviation_for_maxsale,
sales - min_ordersale as deviation_for_minsale
from
(Select
orderid,sales,
max(sales) over() as max_ordersale,
min(sales) over() as min_ordersale
from sales.Orders)t

--Using running or rolling concept for advanced aggregations
--Calculate moving average of sales for each product over time

Select
orderid,orderdate,productid,sales,
avg(sales) over(partition by productid order by orderdate) product_MA_sales
from sales.Orders

--Calculate moving average of sales for each product over time, including only the next order

Select
orderid,orderdate,productid,sales,
avg(sales) over(partition by productid order by orderdate rows between current row and 1 following) product_MA_sales
from sales.Orders

--Window ranking functions1

--row_number() ususally used to rank the rows to provide distinct rank without comparing repeating values

--rank the orders based on their sales from highest to lowest

Select
orderid,sales,
row_number() over(order by sales desc) as rankedsales
from sales.Orders

--rank() usually used to rank the rows to provide rank with comparing repeating values.
--multiple entries with same value may have same repetetive rank
--there will be gaps in rank, example- 1,2,2,4 rank with be 1,2,2,4 (asc rank)

Select
orderid,sales,
rank() over(order by sales desc) as ranked_sales
from sales.Orders

--dense_rank()
--same as rank function only difference it wont leave gaps in ranking

Select
orderid,sales,
rank() over(order by sales desc) as ranked_sales,
dense_rank() over(order by sales desc) as ranked_sales
from sales.Orders

--Find the top highest sales for each product

select
*
from
(
Select
orderid,productid,sales,
row_number() over(partition by productid order by sales desc) row_sales_desc
from sales.Orders)t where row_sales_desc = 1

--find the lowest 2 customers based on their total sales

Select
*
from
(select
customerid,
sum(sales) total_sales,
row_number() over(order by sum(sales) ASC) row_totalsales
from sales.Orders  group by CustomerID)t where row_totalsales<=2

--Assign unique id's to rows of the 'orders archive' table

Select
row_number() over (order by orderid , orderdate ASC) Uniqueid,
*
from sales.OrdersArchive

--identify duplicates in orders.archive and provide clean table without them

Select
*
from(
Select
*,
row_number() over(partition by orderid order by creationtime desc) ranked_creationtime
from sales.OrdersArchive)t where ranked_creationtime =1

--ntile
--usually used to seperate data into equal parts
--if there are odd count and one part ends up with high count that one is ordered first then rest

Select
orderid,sales,
ntile(2) over(order by sales desc) sales_ntile2_desc,
ntile(3) over(order by sales desc) sales_ntile3_desc
from sales.orders

--Segment all orders into 3 categories: high , medium and low sales
--assuming < 25 as low, < 60 is medium, rest high

Select *,
case
	when sales_ntile3 = 1 then 'High'
	when sales_ntile3 = 2 then 'Medium'
	when sales_ntile3 = 3 then 'Low'
end as Category
from(
Select
orderid,sales,
max(sales) over() sales_max,
min(sales) over() sales_min,
avg(sales) over() sales_avg,
NTILE(3) over(order by sales DESC) sales_ntile3
from sales.Orders)t

--Use case for equalizing load
-- In order to export the date, divide the orders into two groups

Select
ntile(2) over(order by orderid ASC) as Groups,
*
from
sales.orders

--Percentage based ranking----------
--find the products that falls within the highest 40% of sales

Select *,
concat(sales_dist * 100 , '%') as sales_dist_percent,
concat(sales_percentRanked * 100 , '%') as sales_dist_percent
from(
Select
	productid , price ,
	CUME_DIST() over(order by price DESC) sales_dist,
	percent_rank() over(order by price DESC) sales_percentRanked
from sales.Products)t where sales_dist <= 0.4

--Windows Value Funtions--------
--Usually lag and lead funtion used to access previous and next row respectively in operations, also first_value and last_value

--Analyze the month-over-month (MoM) performance by finding the percentage change in sales between the current and the previous month

Select *,
case
	when (sales_month - precedeing_monthsales) is not null then (sales_month - precedeing_monthsales)
	else 0
end as changeinsales_month,
round(cast((sales_month - precedeing_monthsales) as float) / precedeing_monthsales *100,1) as mom_change_percent
from(
Select
month(orderdate) as month_num,
sum(sales) as sales_month,
lag(sum(sales)) over(order by month(orderdate)) precedeing_monthsales
from Sales.orders group by month(orderdate))t

--In order to analuze customer loyalty, rank customers based on	average days between their orders


select
customerid,
avg(daysuntilnextorder) avgadays,
rank() over(order by avg(daysuntilnextorder)) rankavg
from(
Select
orderid,
customerid,orderdate as currentorder,
lead(orderdate) over(partition by customerid order by orderdate) nextorder,
datediff(day,orderdate,lead(orderdate) over(partition by customerid order by orderdate)) daysuntilnextorder
from sales.orders)t group by customerid

--Find the lowest and highest sales for each product

Select
productid,sales,
min(sales) over(partition by productid) as product_minsales,
max(sales) over(partition by productid) as product_maxsales
from
sales.orders

-----------------------------END-----------------------------