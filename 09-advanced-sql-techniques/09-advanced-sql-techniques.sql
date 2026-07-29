-- Unit 09	- Advanced SQL techniques
-- Date:	- 21-07-2026
-- Topics:	- Subqueries , CTE , Views , CTAS Table and temp tables, Stored Procedure, Triggers

--sub query

--find the products that have the price higher than then avg price

Select *
from(
Select
productid,Price,
avg(price) over() as Price_avg
from sales.products)t where price > Price_avg

--rank customers based on their total amount of sales

Select
*,
rank() over(order by Customer_totalsales desc) customer_rank
from
(Select
customerid,
sum(sales) Customer_totalsales
from sales.orders group by CustomerID)t

--show the productid, productname, prices and total order count

Select * from sales.Products;
Select * from sales.orders

Select
productid,product,price,
(Select count(*) from sales.orders)totalorders
from sales.Products

--join---------

--show all customers details and find the total orders for each customer

Select c.*,o.ordercount from sales.Customers c left join (
Select customerid, count(*) ordercount from sales.orders group by CustomerID)o on c.CustomerID = o.CustomerID

--where-----
--find the products that have a price higher then avg price of all products

Select
productid,price
from sales.Products
where price > (select avg(price) from sales.Products)

--in operator--------
--show details of orders made by customers in germany or not in germany
Select
*
from sales.orders where customerid not in (select customerid from sales.Customers where Country = 'Germany')

--any / all -----------------
--find the femeale employees whose salary is greater than any male employee
--any
Select
employeeid,firstname,salary
from sales.Employees where gender = 'F' and salary > any(select salary from sales.Employees where gender = 'M')

--all
--find the femeale employees whose salary is greater than all male employee
Select
employeeid,firstname,salary
from sales.Employees where gender = 'F' and salary > all(select salary from sales.Employees where gender = 'M')

--show all customer details and find total orders of each cusstomers

Select
*,
(Select count(*) from sales.Orders o where o.CustomerID = c.customerid) customer_totalorders
from sales.Customers c

--exists----
--show the details of orders made by customers in germany

Select
*
from sales.orders o where exists (select 1 from sales.customers c where country = 'Germany' and o.CustomerID = c.CustomerID)

--STANDALONE CTE--------
--Find the total sales per customer

With CTE_total_sales as
(
Select
customerid,
sum(sales) as totalsales
from sales.orders group by CustomerID)

--Main query
Select
c.customerid,
c.FirstName,
c.LastName,
cte.totalsales
from sales.Customers c
left join CTE_total_sales cte
on cte.CustomerID = c.CustomerID
;
--multiple standalone CTE
--Find the total sales per customer
with cte_totalsales as(
Select
customerid,
sum(sales) as Totalsales
from sales.orders group by customerid),
--Find the last order date per customer
cte_lastorder as
(Select
customerid,
max(orderdate) as lastorder
from sales.orders group by customerid),

--rank customers based on total sales
cte_customer_rank as
(select
customerid,Totalsales,rank() over(order by Totalsales desc) as customer_rank
from cte_totalsales),

--segment customer based on their total sales
cte_customer_segment as
(
Select
customerid,
case
	when totalsales > 100 then 'High'
	when totalsales > 50 then 'Medium'
	else 'Low'
end customersegments
from cte_totalsales
)

select
c.Customerid,
c.FirstName,
c.LastName,
cto.Totalsales,
ctl.lastorder,
ccr.customer_rank,
ccs.customersegments
from sales.Customers c
left join cte_totalsales cto on cto.CustomerID = c.CustomerID
left join cte_lastorder ctl on ctl.CustomerID = c.CustomerID
left join cte_customer_rank ccr on ccr.CustomerID = c.CustomerID
left join cte_customer_segment ccs on ccs.CustomerID = c.CustomerID


--Recursive CTE
--Generate a sequence of numbers from 1 to 20

with series as (
--Anchor query
Select
1 as MyNumber
union all
--recursive query
select
MyNumber + 1
from series
where MyNumber <20)

--main query
Select * from series;

--show the hierarchy o displaying each employees level within the organization
with cte_employee_hierarchy as
(

--Anchor query
Select
EmployeeID,FirstName,ManagerID,1 as Levell
from sales.Employees where ManagerID is null
union all
--Recursive query
Select
e.EmployeeID,
e.FirstName,
e.ManagerID,
Levell + 1
from sales.Employees as e
inner join cte_employee_hierarchy ceh on e.ManagerID = ceh.EmployeeID
)
--main query
Select
*
from cte_employee_hierarchy;

--Views----------------------
--central logic definition------

--find the running total of sales for each month
with cte_monthly_summary as
(
Select
datetrunc(month , orderdate) ordermonth,
sum(sales) Totalsales
from sales.orders
group by datetrunc(month , orderdate))
select
ordermonth,
totalsales,
sum(Totalsales) over(order by ordermonth) as runningtotal
from cte_monthly_summary;

--provide a view that combines details from orders, products, customers, and employees
Create View sales.V_Order_details as(
Select
o.orderid,
o.orderdate,
p.Product,
p.Category,
coalesce(c.FirstName,'') +' '+ coalesce(c.LastName,'') Customername,
c.Country customercountry,
coalesce(e.FirstName,'') +' '+ coalesce(e.LastName,'') Salesname,
e.Department,
o.sales,
o.quantity
from sales.orders o
left join sales.Products p
on p.ProductID = o.ProductID
left join sales.Customers c
on c.CustomerID = o.CustomerID
left join sales.Employees e
on e.EmployeeID = o.SalesPersonID
)

Select * from sales.V_Order_details;


--Provide a view for EU sales team that combines details from all tables and excludes data related to the USA
Create view order_details_EU as(
Select
	o.orderid,
	o.orderdate,
	p.Product,
	p.Category,
	coalesce(c.FirstName,'') +' '+ coalesce(c.LastName,'') Customername,
	c.Country customercountry,
	coalesce(e.FirstName,'') +' '+ coalesce(e.LastName,'') Salesname,
	e.Department,
	o.sales,
	o.quantity
	from sales.orders o
	left join sales.Products p
	on p.ProductID = o.ProductID
	left join sales.Customers c
	on c.CustomerID = o.CustomerID
	left join sales.Employees e
	on e.EmployeeID = o.SalesPersonID
	where c.Country != 'USA')
Select * from order_details_EU;

--CTAS and Temp

Select
DATENAME(Month,orderdate) as OrderMonth,
count(orderid) as totalorders
into sales.monthlyorders
from sales.orders
group by DATENAME(Month,orderdate)

select * from sales.monthlyorders
drop table sales.monthlyorders

--transact sql (checking for the user created then dropping)

if OBJECT_ID('sales.monthlyorders' , 'U') is not null
drop table sales.monthlyorders;
go
Select
DATENAME(Month,orderdate) as OrderMonth,
count(orderid) as totalorders
into sales.monthlyorders
from sales.orders
group by DATENAME(Month,orderdate)

--Temporary tables
Select
*
into Sales.orderstest
from #Orders
delete from #orders where orderstatus = 'Delivered'
select * from Sales.orderstest

--Stored procedure
--Query for-----

--For US customers find the total number of customers and average score



--procedure for the query

create procedure getcustomersummary as
begin
Select
Count (*) totalcustomers,
avg(Score) avgscore
from sales.customers where country = 'USA'
end

exec getcustomersummary

-- same procedure with parameter
drop procedure getcustomersummary

create procedure getcustomersummary @country NVARCHAR (50)
as
begin
Select
Count (*) totalcustomers,
avg(Score) avgscore
from sales.customers where country = @country
end

exec getcustomersummary @country = 'USA';

--same procedure with parameter and variable

alter procedure getcustomersummary @country NVARCHAR(50)
as
begin

declare @totalcustomers int, @avgscore float;

select
	@totalcustomers = count(*),
	@avgscore = avg(score)
from sales.customers
where country = @country

select
	count(orderid) totalorders,
	sum(sales) totalsales
from sales.orders o
join sales.customers c
on c.customerid = o.custommerid
where c.country = @country;

end;

--exec getcustomersummary @country ='Germany'

print 'total customers from' + ':' + @country + ':' + cast(@totalcustomers as nvarchar);
print 'Average score from' + ':' + @country + ':' + cast(@avgscore as nvarchar);

--Trigger
--any manipulation to particualr table can be tracked on tables

Create table sales.employeelogs (

	logID Int Identity (1,1) primary key,
	Employeeid Int,
	LogMessage varchar(255),
	LogDate Date
)

create trigger trig_Afterinsertemployee on sales.employees
after insert
as
begin
	insert into sales.employeelogs (EmployeeId,logMessage, LogDate)
	Select
		Employeeid,
		'New employee added' + cast(employeeid as varchar),
		GETDATE()
	from inserted
end

Select * from sales.employeelogs

insert into sales.Employees
values
(7,'Maria', 'Doe','HR','1988-01-12','F',80000,3)



