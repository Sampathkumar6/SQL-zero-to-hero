
-- UNIT 1- INTRODUCTION AND BASICS OF SQL
-- 09-07-2026
-- Topics like select, where, orderby, group by and other fundamentals

-- using select and where
select * from customers where score > 500

-- filter data with customers score other than zero.
select * from customers where score !=0

-- filter specific columns from customers with country filter.
select first_name,country from customers where country = 'Germany'

-- using order by
select * from customers order by country ASC, score DESC
-- after order by the sorting happens in the order of conditions which are mentioned

-- using group by
select country, SUM(score) as total_score, COUNT(country) as total_count from customers group by country

--using having to filter after groupby
select country, SUM(score) as total_score, COUNT(country) as total_count from customers where score >400 group by country having sum(score) > 800

-- find the avg score for each country considering customers with score not equal to zero and retun only countries with avg score greater than 430

select id , country , avg(score) as avgcountry from customers where score !=0 group by country having AVG(score) > 430

-- using distinct
select distinct(country) from customers

--using top
select top 3 * from customers

-- using top condition - select top3 with highest score
select top 3 * from customers order by score DESC

--another example - to get the 2 most recent orders
select top 2 * from orders order by order_date desc

-- multiple queries
select * from customers
select * from orders

--implementing create new column data or custom data
select 123 as static_number
select 'sam' as static_name

--implementing existing column data with custom data (Static values)
select id, first_name, 'new' as customer_type from customers
