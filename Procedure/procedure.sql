use coding_ninja;

CREATE TABLE student_info (

    stud_id INT PRIMARY KEY,

    stud_code INT,

    stud_name VARCHAR(50),

    subject VARCHAR(50),

    marks INT,

    phone VARCHAR(15)

);

-- Insert data

INSERT INTO student_info (stud_id, stud_code, stud_name, subject, marks, phone) VALUES 

(1, 101, 'Mark', 'English', 68, '3454569357'),

(2, 102, 'Joseph', 'Physics', 70, '9876543659'),

(3, 103, 'John', 'Maths', 70, '9765326975'),

(4, 104, 'Barack', 'Maths', 92, '87069873256'),

(5, 105, 'Rinky', 'Maths', 85, '6753159757'),

(6, 106, 'Adam', 'Science', 82, '79642256864'),

(7, 107, 'Andrew', 'Science', 83, '5674243579'),

(8, 108, 'Brayan', 'Science', 83, '7524316576'),

(9, 109, 'Alexandar', 'Biology', 67, '2347346438');

select * from student_info;

-- procedure without any parameter

DELIMITER %%  

CREATE PROCEDURE get_merit_student ()  

BEGIN  

    SELECT * FROM student_info WHERE marks > 70;

END %% 

DELIMITER ;

call get_merit_student();

-- Dynamic Procedure
DELIMITER &&  

CREATE PROCEDURE get_student_count (IN var1 INT)  

BEGIN  

    SELECT count(*) FROM student_info

    where marks > var1;      

END &&  

DELIMITER ;

CALL get_student_count(50);
CALL get_student_count(80);

-- in procedure 
DELIMITER &&  

CREATE PROCEDURE get_student_count1 (IN var1 INT)  

BEGIN  

    SELECT count(*) FROM student_info

    where marks > var1;      

END &&  

DELIMITER ;

-- out

DELIMITER &&  

CREATE PROCEDURE get_student_count_out2 (OUT count_var INT)  

BEGIN  

    SELECT count(*) INTO count_var FROM student_info

    where marks > 80;      

END &&  

DELIMITER 

CALL get_student_count_out2 (@student_count_out);
select @student_count_out;

-- Session Variable

set @x=10;

select @x+5 as addition;

-- combinatio of INOUT wih=th session varaible
DELIMITER && 

CREATE PROCEDURE display_marks (INOUT var2 INT)  

BEGIN  

    SELECT marks INTO var2 FROM student_info WHERE stud_id = var2;   

END &&

DELIMITER ;



