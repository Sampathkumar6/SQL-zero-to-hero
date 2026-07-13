-- Unit 06	- cobmining data
-- Date:	- 12-07-2026
-- Topics:	- joins and set operators

--joining data
--Basic joins-----------------------------

--No data
Select * from customers;
Select * from orders;

-- get all data customers along with their order, but only for customers who have placed and order
-- it is always good practice to use table.column formatting
select
	customers.id,
	customers.first_name,
	orders.order_id,
	orders.sales
from customers
inner join orders
on customers.id = orders.customer_id

-- same problem with shorthand allias

select
	c.id,
	c.first_name,
	o.order_id,
	o.sales
from customers as c
inner join orders as o
on c.id = o.customer_id

--Left join
-- get all customers along their orders , including thosse without orders

Select * from customers;
Select * from orders;

Select
	c.id,
	c.first_name,
	o.customer_id,
	o.sales
from customers as c
left join orders as o
on c.id = o.customer_id

-- get all customers with orders, including orders without customers

Select
	o.customer_id,
	o.sales,
	c.first_name,
	c.score
from customers as c
right join orders as o
on o.customer_id = c.id

-- full join
select * from customers full join orders on id=customer_id

--Advanced joins-------------------------------

--left anti join
select * from customers as c left join orders as o on c.id = o.customer_id where o.customer_id is null

Select * from customers;
Select * from orders;

--right anti join (using left join)
select * from orders as o left join customers as c on c.id = o.customer_id where c.id is null

--full anti join - both tables un common data
select * from customers as c full join orders as o on c.id = o.customer_id where o.customer_id is null or c.id is null

--get all customers along with their orders , but only for customers who have placed oreders
-- without using inner
select * from customers as c left join orders as o on c.id = o.customer_id where o.customer_id is not null

--cross join
-- want everything from a and everything from b, meaning not common key, just everythig.

select * from customers;select * from orders

select * from customers cross join orders

--multi table join
/* using salesdb , retrieve a list of all orders , along with the releated customer , product, and employee details

for each order display,

	orderid , customers name , product name , sales amount , product price , salespersons name

*/
--check all tables first

select * from Sales.Orders;select * from Sales.Customers;select * from Sales.Products;select * from Sales.Employees

--starting here DB is changed so watch out for warning, above all statements are MyDatabase
select
o.OrderID,c.FirstName as customers_name,p.Product as product_name,(o.Sales * o.Quantity) as salesamount,p.Price as product_price,e.FirstName as salespersons_name
from Sales.Orders as o
left join Sales.Customers as c on o.CustomerID = c.CustomerID
left join Sales.Products as p on o.ProductID = p.ProductID
left join Sales.Employees as e on o.SalesPersonID = e.EmployeeID
--where sc.CustomerID is not null or sp.ProductID is not null or so.SalesPersonID is not null

--set operators-------------------
--for rows, union, union all
Select * from sales.Customers ; select * from sales.Employees

/*rules
1. columns from both table must follow same count
2. same data type
3. first statement before set operator is the key column and controls alliases.
4. order by can only be used once that too at the end
*/

Select FirstName , LastName from Sales.Customers
UNION
Select FirstName , LastName from Sales.Employees

-- combine information from customers and employees into one table

Select 
	FirstName,
	LastName
from Sales.Customers 

Union

Select
	FirstName,
	LastName
from Sales .Employees

-- Combine data from customers and employees rables including duplicates
-- union all

Select 
	FirstName,
	LastName
from Sales.Customers 

Union all

Select
	FirstName,
	LastName
from Sales .Employees

-- Except
-- find the employees who are not customers at the same time

Select
	FirstName,
	LastName
from Sales .Employees

except

Select 
	FirstName,
	LastName
from Sales.Customers

--Intersect - used for only common rows
-- find employees who are also customers

Select
	FirstName,
	LastName
from Sales .Employees

intersect

Select 
	FirstName,
	LastName
from Sales.Customers

-- example of set operator usage
-- orders are stored in seperate tables (orders and orders archives)
-- combine all orders data into one report without duplicates

Select * from Sales.Orders ; Select * from Sales.OrdersArchive

Select
[OrderID]
,[CustomerID]
,[SalesPersonID]
,[ProductID]
,[OrderDate]
,[ShipDate]
,[OrderStatus]
,[ShipAddress]
,[BillAddress]
,[Quantity]
,[Sales]
,[CreationTime]
from Sales.Orders
union
Select
[OrderID]
,[ProductID]
,[CustomerID]
,[SalesPersonID]
,[OrderDate]
,[ShipDate]
,[OrderStatus]
,[ShipAddress]
,[BillAddress]
,[Quantity]
,[Sales]
,[CreationTime]
from Sales.OrdersArchive
order by orderid
--except
-- Delta detection
-- Identifying the differences or changes (delta) between two batches of data
-- used for checking data quality or data correctness