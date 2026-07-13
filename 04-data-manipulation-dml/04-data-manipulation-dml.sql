-- Unit 04 - Data Manipulation language (DML)
-- Date: 11-07-2026
-- Topics: Insert, 

--Insert data manually
Insert into customers(id,first_name,country, score)
values
	(6,'sam','australia',null),
	(7,'padma',null,80)
select * from customers

-- only custom columns
Insert into customers(id,first_name)
values
	(10,'kaki')
select * from Persons

--Insert data using select , usually inserting data from one table to another
--from customers to persons
Insert into Persons (id , person_name , birth_date , phone)
select
id,
first_name,
Null,
'Unknown'
from customers

-- using update - change data in exiting table columns
-- example - change the score of customer with id 6 to 0

Select * from customers
update customers
	set score = 0 , country = 'India' where id = 6

-- update all customer null score to 0
Select * from customers
update customers
	set score = 0 where score is Null

--using delete
delete from customers where id > 5
select * from customers

--delete all data from table persons
delete from Persons
select * from Persons