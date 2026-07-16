-- Unit 07	- SQL Functions
-- Date:	- 13-07-2026
-- Topics:	- single row and multiple row

--Single row functions----------
--String functions----------

--for manipulation---------

--concat
--concatenate first name and country into one column

Select
FirstName , Country,
concat(FirstName ,'_', Country) as name_country
from Sales.Customers

--upper and lower
--transform customers first name to lowercase
Select
FirstName,
lower(FirstName) as lower_firstname
from Sales.Customers

Select
FirstName,
upper(FirstName) as upper_firstname
from Sales.Customers

--trim

select * from sales.Customers

Select
firstname,
trim(firstname) as trimmed_firstname
from  sales.Customers

--replace
--replace the special char in phoe number

Select
'949-412-5858' as phone,
replace('949-412-5858' , '-','/') as cleanphone

-- replace extension

Select
'file.csv' as filename,
replace('file.csv' , '.csv' , '.xlsx') as new_filename

-- for Calculations------------

--calculate len each customers firstname
Select 
	FirstName,
	len(firstname) as firstname_length
from Sales.Customers

--string extraction
-- using left and right

--retrieve first 2 characters for each first name

Select
firstname,
left(firstname , 2) as first2_firstname
from Sales.Customers

--retrieve last 2 characters for each first name

Select
firstname,
right(firstname , 2) as last2_firstname
from Sales.Customers

--retrieve the list of customers , first names  after removeing first character
-- manual way
Select
firstname,
right(firstname,(len(firstname)-1)) as nofirstchar_firstname
from Sales.Customers

-- using substring
Select
firstname,
substring(firstname,2,(len(firstname))) as nofirstchar_firstname
from Sales.Customers

--numeric functions-----------------
--round

select 3.516 as actual,

round(3.516,2) as round_2,
round(3.516,1) as round_1,
round(3.516,0) as round_0

--abs or absolte

select -10,
abs(-10),
abs(10)

--Date&time------------

Select
orderid,
creationtime,
'2025-01-01' as staticdate,
getdate() as today
from Sales.Orders

--day,month,year

Select
orderid,
creationtime,
year(creationtime) as year,
month(creationtime) as month,
day(creationtime) as day
from Sales.Orders

-- for quarters and week
-- using datepart

Select
orderid,
creationtime,
DATEPART(year,creationtime) as year_dp,
DATEPART(MONTH,creationtime) as month_dp,
DATEPART(DAY,creationtime) as day_dp,
DATEPART(HOUR,CREATIONTIME) AS HOUR_DP,
DATEPART(QUARTER,CREATIONTIME) AS QUARETER_DP,
DATEPART(WEEKDAY,CREATIONTIME) AS WEEKDAY_DP,
year(creationtime) as year,
month(creationtime) as month,
day(creationtime) as day
from Sales.Orders

--DATENAME

Select
orderid,
creationtime,
DATENAME(year,creationtime) as year_dn,
DATENAME(MONTH,creationtime) as month_dn,
DATENAME(DAY,creationtime) as day_dn,
DATENAME(HOUR,CREATIONTIME) AS HOUR_Dn,
DATENAME(QUARTER,CREATIONTIME) AS QUARETER_Dn,
DATENAME(WEEKDAY,CREATIONTIME) AS WEEKDAY_Dn
FROM SALES.Orders

--datetrunc
Select
orderid,
creationtime,
datetrunc(HOUR,creationtime) as creationtime_hour,
DATENAME(year,creationtime) as year_dn,
DATENAME(MONTH,creationtime) as month_dn,
DATENAME(DAY,creationtime) as day_dn,
DATENAME(HOUR,CREATIONTIME) AS HOUR_Dn,
DATENAME(QUARTER,CREATIONTIME) AS QUARETER_Dn,
DATENAME(WEEKDAY,CREATIONTIME) AS WEEKDAY_Dn
FROM SALES.Orders

--example for aggregations using datetrunc

select
creationtime,
count(*)
from sales.orders
group by CreationTime

--eomonth
Select
orderid,
creationtime,
eomonth(creationtime) as endofmonth
from sales.Orders

--how many orders were placed each year
Select
year(orderdate),
count(*) AS nroforders
FROM SALES.ORDERS
GROUP BY YEAR(ORDERDATE)

-- HOW MANY ORDERS WERE PLACED EACH MOPNTH

SELECT
DATENAME(MONTH,ORDERDATE) MONTHNUMBER,
COUNT(*) AS NOOFORDERS
FROM SALES.ORDERS
GROUP BY DATENAME(MONTH,ORDERDATE)

--SHOW ALL ORDERS PLACED AT MONTH OF FEBRUARY

SELECT
*
FROM SALES.ORDERS
WHERE MONTH(ORDERDATE) = 2

--FORMAT AND CASTING----------

Select
orderid,
creationtime,
format(creationtime,'MM-dd-yyyy') us_date,
format(creationtime,'dd-MM-yyyy') standard_date,
format(creationtime,'dd') dd,
format(creationtime,'ddd') ddd,
format(creationtime,'dddd') dddd,
format(creationtime,'MM') MM,
format(creationtime,'MMM') MMM,
format(creationtime,'MMMM') MMMM
from Sales.Orders

--example - creation time in below format
--Day wed jan Q1 2025 12:34:56 PM

Select
Orderid,
CreationTime,
'Day ' + format(creationtime, 'ddd MMM') + ' Q' + datename(quarter,creationtime) + ' ' + format(creationtime, 'yyyy hh:mm:ss tt') as customformat
from sales.Orders

--use case using aggregations

select
format(orderdate, 'MMM yy') as orderdate,
count(*) as ordercount
from sales.Orders
group by format(orderdate, 'MMM yy')

--Data standardization using format
--data from different sources scenario

SELECT 'N' AS FormatType, FORMAT(1234.56, 'N') AS FormattedValue
UNION ALL
SELECT 'P' AS FormatType, FORMAT(1234.56, 'P') AS FormattedValue
UNION ALL
SELECT 'C' AS FormatType, FORMAT(1234.56, 'C') AS FormattedValue
UNION ALL
SELECT 'E' AS FormatType, FORMAT(1234.56, 'E') AS FormattedValue
UNION ALL
SELECT 'F' AS FormatType, FORMAT(1234.56, 'F') AS FormattedValue
UNION ALL
SELECT 'N0' AS FormatType, FORMAT(1234.56, 'N0') AS FormattedValue
UNION ALL
SELECT 'N1' AS FormatType, FORMAT(1234.56, 'N1') AS FormattedValue
UNION ALL
SELECT 'N2' AS FormatType, FORMAT(1234.56, 'N2') AS FormattedValue
UNION ALL
SELECT 'N_de-DE' AS FormatType, FORMAT(1234.56, 'N', 'de-DE') AS FormattedValue
UNION ALL
SELECT 'N_en-US' AS FormatType, FORMAT(1234.56, 'N', 'en-US') AS FormattedValue;

--convert
--usually used to the data type of a value or a column
Select
convert(Int , '123') as [String to int CONVERT],
convert(date , '2025-09-07') as [String to Date CONVERT]

--using 3rd paramenter in convert

Select
creationtime,
convert(date , creationtime) as [datetime to date],
convert(varchar, creationtime , 32) as [USA Std. Style32]
from sales.Orders

Select
creationtime,
convert(date , creationtime) as [datetime to date],
convert(varchar, creationtime , 34) as [EUR Std. Style34]
from sales.Orders

--cast funtion

select
cast(123 as int) as [string to int],
cast(123 as varchar) as [int to string],
cast('2025-09-08' as date) as [string to date],
cast('2025-09-08' as datetime) as [string to datetime],
creationtime from sales.orders

--date calculations
--date add

select
orderid,
orderdate,
dateadd(year , 2, orderdate) as twoyearsadded,
dateadd(MONTH , 3, orderdate) as threemonthsadded,
--10 days subtracted
dateadd(DAY , -10, orderdate) as days_subtract
from sales.Orders

--difference between days
--datediff()

--calculate the age of the employees


select
employeeid,
birthdate,
datediff(year , BirthDate , getdate()) as age
from sales.Employees

--find the average shipping duration in days for each month
Select * from sales.orders
Select
month(orderdate) as orderdatemonth,
avg(datediff(day , OrderDate, ShipDate)) as daystoship
from sales.orders
group by month(OrderDate)


--find the number of days between each order and previous order
--for referring to previous row we use lag()

Select
orderid,
orderdate,
lag(orderdate) over (order by orderdate) previousorderdate,
datediff(day , lag(orderdate) over (order by orderdate), OrderDate) as daysdiff
from sales.orders

--isdate
--check if value is date or not

select
isdate(123) datecheck1,
isdate('2025-08-20') as datacheck2,
isdate('20-08-2025') as datacheck3,
isdate('2025') as datacheck4,
isdate('08') as datacheck5

--date conversion from varchar

select
orderdate,
isdate(orderdate) as datecheck,
case when isdate(orderdate) = 1 then cast(orderdate as date) end Neworderdate
from
(
Select '2025-08-20' as orderdate union
Select '2025-08-21' union
Select '2025-08-22' union
Select '2025-08'
)t

--null function
/*
isnull		- to replace null with any value
coalesce	- to replace null with any value
nullif		- to replace any value with null
isnull		- check for null
is not null	- check for not null
*/

--find the average score of customers

Select
CustomerID,
score,
isnull(Score,0) origscore,
avg(score) over() Avgscore_wthnull,
avg(coalesce(score,0)) over() Avgscore_withzero
from sales.Customers

--usecase 1

--display full name of customers in single field
--by merging  their first and last name
--and add 10 bonus points to each customers score

select
customerid,
firstname,
lastname,
CONCAT(firstname,' ',coalesce(LastName,'')) as fullname,
score,
isnull(score,0) +10 as newscore
from sales.Customers

--usecase 2
--sort the customers from lowest to highest scores
--with nulls appearing laast

Select
CustomerID,
Score,
coalesce(Score,0) as scorenonull
from sales.Customers
order by coalesce(Score,0)

--nullif
--find the sales price for each order by dividing the sales by the quantity

select * from sales.Orders

Select
OrderID,
Quantity,
Sales,
Sales / nullif(Quantity,0) as salesprice 
from sales.Orders

--is null
--is not null

--identify the customers who have no scores

Select
*
from sales.Customers
where score is null

--show a list of customers who have scores

Select
*
from sales.Customers
where score is not null

--is null with leftjoin
--left anti join

--show the list of all customers who have not placed any orders

Select
c.*,
o.OrderID
from sales.Customers c
left join sales.orders o
on c.CustomerID = o.CustomerID
where o.CustomerID is null 

--empty
--to perform operations on empty cells

--case statement
--usually used for data transformations
-- Generate a report showing the total sales for each category:
	--High if the sales > 50
	--Medium if sales are between 20 and 50
	--low if sales < 20
--Sort the result from lowest to highest

Select
category,
sum(sales) as totalsales
from
(
Select
OrderID,
Sales,
case
	when sales > 50 then 'High'
	when sales > 20 then 'Medium'
	else 'low'
end category
from sales.orders
)t
group by category
order by totalsales ASC

--Retrieve employee details with gender displayed as full text

Select
EmployeeID,
FirstName,
LastName,
Gender,
CASE
	WHEN Gender = 'M' then 'Male'
	When Gender = 'F' then 'Female'
	else ''
end gendername
FROM SALES.Employees

--retrieve customer details with abbrevated countrycode

Select
customerid,
firstname,
lastname,
Country,
case /* this is for table*/
	when country = 'Germany' then 'DE'
	when country = 'USA' then 'US'
end abbrevated_country,
case country /* this is only for one column*/
	when 'Germany' then 'DE'
	when 'USA' then 'US'
end abbrevated_country2
from sales.Customers

-- find the average score of customers and trat nulls 0
-- and aadditionally provide details like customerid, lastname

Select
CustomerID,
firstname,
lastname,
Score,
case when score is null then 0 else score end scoreclean,
avg(case when score is null then 0 else score end) over() avgcustomerclean,
avg(score) over() avgcustomer
from sales.Customers

-- conditional aggregation
--count how many times each customer has made an order with sales greater than 30

Select
customerid,
--case when sales > 30 then count(customerid) end ordercount30
sum(case when sales > 30 then 1 else 0 end) totalorders
from sales.orders
group by CustomerID
-------------------------------------------------------------------
