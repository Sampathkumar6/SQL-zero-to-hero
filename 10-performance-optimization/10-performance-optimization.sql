-- Unit 10	-Performance optimization
-- Date:	- 09-08-2026
-- Topics:	- tips

--Selecting only what we need

Select * from sales.orders

Select orderid,productid,quantity,Sales from sales.orders


--For just exploration or getting to know the table, use limited rows

--time taking or resourse wastage in case of large data

Select
	orderid,
	sales
from sales.orders

--good practice

Select top 10
	orderid,
	sales
from sales.orders

-----------------
select ProductID,OrderDate,sales from sales.orders where CustomerID = 1 or CustomerID = 3 or customerid = 4


--good practice is to use in rather than or

select ProductID,OrderDate,sales from sales.orders where CustomerID in (1,3,4)

---------------

---joins
sElect * from sales.customers
sElect * from sales.orders

--Best performance
select c.firstname, o.orderid from sales.customers c inner join sales.orders o on c.customerid = o.customerid
--second best

select c.firstname, o.orderid from sales.customers c left join sales.orders o on c.customerid = o.customerid
select c.firstname, o.orderid from sales.customers c right join sales.orders o on c.customerid = o.customerid

--least performance
select c.firstname, o.orderid from sales.customers c outer join sales.orders o on c.customerid = o.customerid


--explicit join vs implicit join

select o.orderid, c.firstname
from sales.customers c,sales.orders o
where c.customerid = o.customerid
