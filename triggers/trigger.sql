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

-- creating trigger
DELIMITER //  

Create Trigger before_insert_empworkinghours   

BEFORE INSERT ON employee 

FOR EACH ROW  

BEGIN  

IF NEW.working_hours < 0 THEN SET NEW.working_hours = 0;  

END IF;  

END //

DELIMITER 

INSERT INTO employee VALUES    

('Markus', 'Farmer', '2020-10-08', 14),

('Alex', 'Actor', '2020-10-10', -14);

select * from employee;

DELIMITER //

CREATE TRIGGER before_insert_empworkinghour

BEFORE INSERT ON employee

FOR EACH ROW

BEGIN

    IF NEW.working_hours > 24 THEN

        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Check the hours entered';

    ELSEIF NEW.working_hours < 0 THEN SET NEW.working_hours = 0;

    END IF;

END //

DELIMITER ;

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

DELIMITER //

CREATE TRIGGER before_delete_employee

BEFORE DELETE ON employee

FOR EACH ROW

BEGIN

    IF OLD.occupation = 'Actor' THEN

        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Actors data can not be deleted';

    END IF;

END //

DELIMITER ;

DELETE FROM employee WHERE occupation = 'Actor';

DELIMITER //

CREATE TRIGGER before_update_employee

BEFORE UPDATE ON employee

FOR EACH ROW

BEGIN

    IF OLD.name <> 'Peter' THEN

        SET NEW.working_hours = NEW.working_hours; 

    ELSEIF OLD.name = 'Peter' THEN

        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Update not allowed for Peter';

    END IF;

END //  

DELIMITER ;