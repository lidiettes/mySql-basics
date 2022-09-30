--  Sample employee database 
--  See changelog table for details
--  Copyright (C) 2007,2008, MySQL AB
--  
--  Original data created by Fusheng Wang and Carlo Zaniolo
--  http://www.cs.aau.dk/TimeCenter/software.htm
--  http://www.cs.aau.dk/TimeCenter/Data/employeeTemporalDataSet.zip
-- 
--  Current schema by Giuseppe Maxia 
--  Data conversion from XML to relational by Patrick Crews
-- 
-- This work is licensed under the 
-- Creative Commons Attribution-Share Alike 3.0 Unported License. 
-- To view a copy of this license, visit 
-- http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to 
-- Creative Commons, 171 Second Street, Suite 300, San Francisco, 
-- California, 94105, USA.
-- 
--  DISCLAIMER
--  To the best of our knowledge, this data is fabricated, and
--  it does not correspond to real people. 
--  Any similarity to existing people is purely coincidental.
-- 

DROP DATABASE IF EXISTS employees;
CREATE DATABASE IF NOT EXISTS employees;
USE employees;

SELECT 'CREATING DATABASE STRUCTURE' as 'INFO';

DROP TABLE IF EXISTS dept_emp,
                     dept_manager,
                     titles,
                     salaries, 
                     employees, 
                     departments;

/*!50503 set default_storage_engine = InnoDB */;
/*!50503 select CONCAT('storage engine: ', @@default_storage_engine) as INFO */;

CREATE TABLE employees (
    emp_no      INT             NOT NULL,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      ENUM ('M','F')  NOT NULL,    
    hire_date   DATE            NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE departments (
    dept_no     CHAR(4)         NOT NULL,
    dept_name   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE  KEY (dept_name)
);

CREATE TABLE dept_manager (
   emp_no       INT             NOT NULL,
   dept_no      CHAR(4)         NOT NULL,
   from_date    DATE            NOT NULL,
   to_date      DATE            NOT NULL,
   FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)    ON DELETE CASCADE,
   FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
   PRIMARY KEY (emp_no,dept_no)
); 

CREATE TABLE dept_emp (
    emp_no      INT             NOT NULL,
    dept_no     CHAR(4)         NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no)  REFERENCES employees   (emp_no)  ON DELETE CASCADE,
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,dept_no)
);

CREATE TABLE titles (
    emp_no      INT             NOT NULL,
    title       VARCHAR(50)     NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,title, from_date)
) 
; 

CREATE TABLE salaries (
    emp_no      INT             NOT NULL,
    salary      INT             NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, from_date)
) 
; 

CREATE OR REPLACE VIEW dept_emp_latest_date AS
    SELECT emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM dept_emp
    GROUP BY emp_no;

# shows only the current department for each employee
CREATE OR REPLACE VIEW current_dept_emp AS
    SELECT l.emp_no, dept_no, l.from_date, l.to_date
    FROM dept_emp d
        INNER JOIN dept_emp_latest_date l
        ON d.emp_no=l.emp_no AND d.from_date=l.from_date AND l.to_date = d.to_date;
        
        
-- mi codigo

INSERT INTO employees (emp_no, birth_date, first_name, last_name, gender, hire_date) VALUES 
(1, '1987-11-12', 'pepe', 'morcillo','m', '2020-10-15'),
(2, '1988-11-12', 'pepe', 'lopez','m', '2020-10-16'),
(3, '1989-11-12', 'pepe', 'garcia','m', '2020-10-17'),
(4, '1990-11-12', 'luisa', 'real','f', '2020-10-18'),
(5, '1987-10-12', 'jose', 'pineda','m', '2020-11-15'),
(6, '1987-11-13', 'antonio', 'moreno','m', '2020-12-15'),
(7, '1987-11-12', 'Maria', 'garcia','f', '2021-10-15'),
(8, '1987-11-11', 'toni', 'solano','m', '2019-10-15'),
(9, '1987-11-15', 'juan', 'rosas','m', '2010-10-15'),
(10, '1987-11-12', 'pau', 'herrero','m', '2010-10-15'),
(11, '1987-11-16', 'jesus', 'holgado','m', '2021-10-15'),
(12, '1987-11-16', 'rosa', 'salas','f', '2020-11-15'),
(13, '1987-11-12', 'santi', 'pandilla','m', '2020-10-11'),
(14, '1987-11-12', 'mar', 'cordoba','m', '2020-10-10'),
(15, '1987-11-12', 'lola', 'miranda','f', '2020-10-11');

INSERT INTO salaries (emp_no, salary, from_date, to_date) VALUES 
(1, 5000, '2014-11-12', '2022-10-20'),
(2, 15000, '2013-11-12', '2022-10-20'),
(3, 25000, '2010-11-12', '2022-10-20'),
(4, 5000, '2016-11-12', '2022-10-20'),
(5, 5000, '2014-11-12', '2022-10-20'),
(6, 15000, '2015-11-12', '2022-10-20'),
(7, 5000, '2014-11-12', '2022-10-20'),
(8, 15000, '2014-11-12', '2022-10-20'),
(9, 5000, '2014-11-12', '2022-10-20'),
(10, 5000, '2014-11-12', '2022-10-20'),
(11, 15000, '2014-11-12', '2022-10-20'),
(12, 5000, '2014-11-12', '2022-10-20'),
(13, 5000, '2014-11-12', '2022-10-20'),
(14, 5000, '2014-11-12', '2022-10-20'),
(15, 5000, '2014-11-12', '2022-10-20');

INSERT INTO titles (emp_no, title, from_date, to_date) VALUES 
(1, 'lawyer', '2014-11-15', '2020-10-20'),
(2, 'teacher', '2013-11-15', '2020-10-20'),
(3, 'lawyer', '2010-11-15', '2020-10-20'),
(4, 'teacher', '2016-11-15', '2020-10-20'),
(5, 'lawyer','2014-11-15', '2020-10-20'),
(6, 'teacher', '2015-11-12', '2017-10-18'),
(7, 'lawyer', '2014-11-12', '2017-10-18'),
(8, 'teacher', '2014-11-12', '2016-10-18'),
(9, 'lawyer', '2014-11-12', '2016-10-19'),
(10, 'teacher', '2014-11-12', '2015-10-20'),
(11, 'lawyer', '2014-11-12', '2015-10-20'),
(12, 'teacher', '2014-11-12', '2010-10-20'),
(13, 'teacher', '2014-11-12', '2010-10-20'),
(14, 'lawyer', '2014-11-12', '2010-10-20'),
(15, 'lawyer', '2014-11-12', '2010-10-20');

INSERT INTO departments (dept_no, dept_name) VALUES 
('MK', 'marketing'),
('SA', 'sales assistants'),
('HR', 'human resources'),
('AA', 'accounting'),
('QQ', 'quality');

INSERT INTO dept_manager (dept_no, emp_no, from_date, to_date) VALUES
('MK', 11, '2014-11-14', '2015-10-20'),
('SA', 12, '2014-11-15', '2010-10-20'),
('HR', 13, '2014-11-16', '2010-11-20'),
('AA', 14, '2014-11-17', '2010-12-20'),
('QQ', 15, '2014-11-18', '2010-10-15');

INSERT INTO dept_emp (dept_no, emp_no, from_date, to_date) VALUES
('MK', 1, '2014-11-15', '2020-10-20'),
('SA', 1, '2012-11-15', '2014-11-15'),
('SA', 2, '2013-11-15', '2020-10-20'),
('HR', 2, '2010-11-15', '2013-10-20'),
('HR', 3 ,'2010-11-15', '2020-10-20'),
('MK', 3, '2005-11-15', '2010-10-20'),
('SA', 4, '2014-11-15', '2020-10-20'),
('MK', 4, '2012-11-15', '2014-10-20'),
('HR', 5, '2014-11-15', '2020-10-20'),
('QQ', 5, '2012-11-15', '2014-10-20'),
('SA', 6, '2015-11-12', '2017-10-18'),
('MK', 6, '2011-11-12', '2015-10-18'),
('AA', 7, '2014-11-12', '2017-10-18'),
('SA', 7, '2012-11-12', '2014-10-18'),
('MK', 8, '2014-11-12', '2016-10-18'),
('HR', 8, '2012-11-12', '2014-10-18'),
('SA', 9, '2014-11-12', '2016-10-19'),
('AA', 9, '2010-11-12', '2014-10-19'),
('SA', 10, '2014-11-12', '2015-10-20'),
('QQ', 10, '2009-11-12', '2014-10-20'),
('MK', 11, '2014-11-14', '2015-10-20'),
('SA', 12, '2014-11-15', '2010-10-20'),
('HR', 13, '2014-11-16', '2010-11-20'),
('AA', 14, '2014-11-17', '2010-12-20'),
('QQ', 15, '2014-11-18', '2010-10-15');

SHOW CREATE TABLE employees;
SELECT * from employees WHERE emp_no = 1;
SELECT * from employees WHERE emp_no = 8;
UPDATE employees SET first_name = 'antonio' where emp_no = 8;
SELECT * from employees;

SET SQL_SAFE_UPDATES = 0;
UPDATE departments SET dept_name = 'finanzas' where dept_no = 'MK';
SET SQL_SAFE_UPDATES = 1;


UPDATE departments SET dept_name = 'compras' where dept_no = "SA";
UPDATE departments SET dept_name = 'recursos humanos' where dept_no = "HR";
UPDATE departments SET dept_name = 'cuentas' where dept_no = "AA";
UPDATE departments SET dept_name = 'calidad' where dept_no = "QQ";

-- Select all employees with a salary greater than 20,000, you must list all employees data and the salary.

SELECT e.first_name, e.last_name, s.salary
FROM salaries AS s
	LEFT JOIN employees AS e
    ON e.emp_no = s.emp_no
WHERE salary > 20000; 

-- Select all employees with a salary below 10,000, you must list all employees data and the salary.

SELECT e.first_name, e.last_name, s.salary
FROM salaries AS s
	LEFT JOIN employees AS e
    ON e.emp_no = s.emp_no
WHERE salary < 10000; 

-- Select all employees who have a salary between 14,000 and 50,000, you must list all employees data and the salary.

SELECT e.first_name, e.last_name, s.salary
FROM salaries AS s
	LEFT JOIN employees AS e
    ON e.emp_no = s.emp_no
WHERE salary < 50000 and salary > 14000;

-- Select the total number of employees

SELECT COUNT(emp_no)
FROM employees;

-- Select the total number of employees who have worked in more than one department

SELECT COUNT(r.emp_no) AS emp_2more_depts
FROM (
    SELECT emp_no 
    FROM dept_emp 
    GROUP BY emp_no
    HAVING COUNT(emp_no) > 1
)AS r ; 

-- Select the titles of the year 2020

SELECT * from titles WHERE to_date BETWEEN '2019-12-31' AND '2022-09-29';

-- Select the name of all employees with capital letters

SELECT UPPER(first_name) 
FROM employees;

-- Select the name, surname and name of the current department of each employee. ( FALTA CURRENT )

SELECT first_name, last_name, z.dept_name
FROM (
    SELECT e.first_name, e.last_name, d.emp_no, d.dept_no
    FROM dept_emp AS d
	LEFT JOIN employees AS e
    ON d.emp_no = e.emp_no
) AS y
    LEFT JOIN departments AS z
    ON y.dept_no = z.dept_no;
    
    
-- Select the name, surname and number of times the employee has worked as a manager   

SELECT e.first_name, e.last_name, COUNT(m.dept_no) 
	FROM employees as e 
	JOIN dept_manager as m 
	on m.emp_no = e.emp_no
	GROUP BY dept_no;


-- Select the name of employees without any being repeated

SELECT DISTINCT first_name from employees;


-- Delete all employees with a salary greater than 20,000

DELETE from salaries WHERE salary > 20000;

-- Remove the department that has more employees

