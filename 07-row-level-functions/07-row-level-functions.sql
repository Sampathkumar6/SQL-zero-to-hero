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

