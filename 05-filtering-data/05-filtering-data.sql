-- Unit 04	- Filtering data
-- Date:	- 12-07-2026
-- Topics:	- where (comparision operators, logical operators, range operators, membership operator, search operator)

-------Comparision operator---------------
-- < > = != <= >=

--select all data from customers only germany

select * from customers
	where country = 'Germany'

--select all data from customers except germany

select * from customers
	where country <> 'Germany'

-- all customers with score > 0

--select all data from customers only germany

-- using other operators

select * from customers
	where score > 500

select * from customers
	where score >= 500

select * from customers
	where score < 500

select * from customers
	where score <= 500

---------Logical operators-------------------
--AND

Select * from customers
	where score > 400 and score < 850

-- retrieve all customers from USA with score greater than 500
Select * from customers
	where country = 'USA' and score > 500

--OR
-- customers in usa or either with score > 500

Select * from customers
	where country = 'USA' or score > 500

-- NOT

select * from customers
where not score < 500

-- Range operator--------------------------

-- AND , OR , NOT, BETWEEN

select * from customers
	where score between 100 and 500
-- same output without using between
select * from customers
	where score >=100 and score <=500

--Membership operator--------------

select * from customers
	where country = 'Germany' or country = 'USA'

-- using a list  in condition statement with in

select * from customers
	where country in ('Germany','USA')

--search operator-------------
--like--

--find all the customers whose first name starts with M

select * from customers
	where first_name like 'M%'

--find alll customers with first name ends with n

select * from customers
	where first_name like '%n'

--find alll customers with first name has r

select * from customers
	where first_name like '%r%'

--find alll customers with first name has r in third position

select * from customers
	where first_name like '__r%'