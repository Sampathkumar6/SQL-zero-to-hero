-- Unit 02  - Data Definition Language
-- Date:	- 11-07-2026
-- Topics:	- CREATE,column data types, constraint, alter, add, drop

--create a new table with id, person_name, birth_date, and phone

Create table Persons(
	Id int not null,
	person_name varchar(50) not null,
	birth_date date,
	phone varchar(15) not null
	Constraint pk_persons primary key(Id)

)

--using alter and add, adding a new column.
Alter table Persons
Add email varchar(50) not null
select * from Persons

--using alter and drop, ignoring the column
Alter table Persons
drop column phone
select * from Persons

--using drop, remove table.
drop table Persons



