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

