/*
Transaction- work performed againt database in sql
commit- permanently save all the transaction 
*/
use coding_ninja;
select @@autocommit;
set autocommit=0;
drop table if exists employee1;
CREATE TABLE employee1(  

    name varchar(45) NOT NULL,    

    occupation varchar(35) NOT NULL,    

    working_date date,  

    working_hours varchar(10)  

);

INSERT INTO employee1 VALUES    

('Robin', 'Scientist', '2020-10-04', 12),  

('Warner', 'Engineer', '2020-10-04', 10),  

('Peter', 'Actor', '2020-10-04', 13),  

('Marco', 'Doctor', '2020-10-04', 14),  

('Brayden', 'Teacher', '2020-10-04', 12),  

('Antonio', 'Business', '2020-10-04', 11);

select * from employee1;

rollback;

select * from employee1;

-- savepoint concept begin
-- we divide database into parts and we can save the parts of different transaction using save point

START TRANSACTION;

 

UPDATE employee1

SET occupation = 'Teacher'

where name = 'Warner';

 

select * from employee1;

 

SAVEPOINT second_update;

 

INSERT INTO employee1 VALUES    

('Victor', 'Player', '2020-10-18', 15);

 

select * from employee1;

 

SAVEPOINT second_insert;

 

select * from employee1;

 

ROLLBACK TO SAVEPOINT second_update;

 

select * from employee1;

 

COMMIT;

 

ROLLBACK;

  

-- Update working hours

UPDATE employee1

SET working_hours = working_hours * 1.10;

 

select * from employee1;

 

-- Insert a new customer

INSERT INTO employee1 VALUES    

('Markus', 'Farmer', '2020-10-08', 14);

 

select * from employee1;

 

COMMIT;

 

select * from employee1;

 

Rollback;

 

select * from employee1;

START TRANSACTION;

 

UPDATE employee1

SET occupation = 'Data Scientist'

where name = 'Robin';

 

select * from employee1;

 

SAVEPOINT first_update;

 

INSERT INTO employee1 VALUES    

('Alex', 'Actor', '2020-10-10', 13);

 

SAVEPOINT first_insert;

 

COMMIT;

 

select * from employee1;

select * from employee1;

-- DCL command begin
/*
1. Grant Command:- to give the access

grant priviledge_name
on object_name
to {user|public|role_name}
[with grant option]

2. Revoke Command:- to take back the access
*/

-- Generic Syntax

-- GRANT privilege_name

-- ON object_name

-- TO {user_name |PUBLIC |role_name}

-- [WITH GRANT OPTION];

 

-- Example

 

-- GRANT SELECT (Productname, productprice), 

-- INSERT (productSKU, Productname) 

-- ON mydatabase.products 

-- TO 'user4'@'localhost';

-- REVOKE Command - Used to revoke certain access.

 

-- REVOKE SELECT ON student FROM 'user4'@'localhost';

