-- Trigger
-- sql statement reside in a system catalog

use coding_ninja;

CREATE TABLE employee(  

    name varchar(45) NOT NULL,    

    occupation varchar(35) NOT NULL,    

    working_date date,  

    working_hours varchar(10)  

);

INSERT INTO employee VALUES    

('Robin', 'Scientist', '2020-10-04', 12),  

('Warner', 'Engineer', '2020-10-04', 10),  

('Peter', 'Actor', '2020-10-04', 13),  

('Marco', 'Doctor', '2020-10-04', 14),  

('Brayden', 'Teacher', '2020-10-04', 12),  

('Antonio', 'Business', '2020-10-04', 11);