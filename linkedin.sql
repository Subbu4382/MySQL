/*  DDL Commands
   - CREATE --> TO CREATE DATABASES,TABLES,VIEWS,INDEXES,TRIGGERS...
   - ALTER --> To modify structure of table
   - DROP --> To delete database or tables Permanently
   - TRUNCATE --> To delete all records in a table
   - RENAME --> To rename A table or a column
   */
   
-- Create a database
CREATE DATABASE StoreDB;
use storeDB;
-- Create a table
CREATE TABLE Electronics (product_id INT PRIMARY KEY,product_name VARCHAR(50),price DECIMAL(10 , 2 ));
-- Add new column
ALTER TABLE Electronics ADD stock INT;
-- Modify column datatype
ALTER TABLE Electronics MODIFY price FLOAT;
-- Drop a table
DROP TABLE Electronics;
-- Remove all data but keep table structure
TRUNCATE TABLE Electronics;
-- Rename table
RENAME TABLE Electronics TO Gadgets;

/* DML Commands(Data Manipulation Language)
Used to manipulate data inside tables.
     INSERT --> TO add new records
     UPDATE --> To modify existing data
     DELETE --> Remove records with WHERE
*/

INSERT INTO Electronics VALUES
(1, 'Laptop', 55000, 10),
(2, 'Mobile', 20000, 30),
(3, 'Headphones', 1500, 50);

-- Update product price
UPDATE Electronics SET price = 18000 WHERE product_id = 2;

-- Delete specific row
DELETE FROM Electronics WHERE product_id = 3;

-- Delete all rows (slower than TRUNCATE, can rollback)
DELETE FROM Electronics;

/* DCL Commands (Data Control Language)
     GRANT --> Give permissions to user
     REVOKE --> Take back permissions
*/
-- create new user
Create user "demo"@"localhost" identified by "demo@123";
-- Give specific permissions
GRANT SELECT, INSERT ON storedb.Electronics TO 'demo'@'localhost';
-- Give ALL privileges on a database
GRANT ALL PRIVILEGES ON storedb.* TO 'demo'@'localhost';
-- Give ALL privileges on ALL databases
GRANT ALL PRIVILEGES ON *.* TO 'demo'@'localhost' WITH GRANT OPTION;

-- Remove one privilege
REVOKE INSERT ON storedb.Electronics FROM 'demo'@'localhost';
-- Remove all privileges
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'demo'@'localhost';

-- See what privileges a user has
SHOW GRANTS FOR 'demo'@'localhost';
-- Show current user privileges
SHOW GRANTS FOR CURRENT_USER;


/*TCL Commands (Transaction Control Language)
Manages transactions (commit/rollback). Works with DML statements
    START TRANSACTION / BEGIN -->Start Transaction
    COMMIT -->Save Changes permanently
    ROLLBACK --> Undo Uncommitted changes
    SAVEPOINT --> Mark a point to rollback partially
    
*/
START TRANSACTION;
INSERT INTO Electronics VALUES (4, 'Smartwatch', 8000, 15);  -- Insert data and commit
COMMIT;

-- Insert then rollback (data won’t save)
INSERT INTO Electronics VALUES (5, 'Tablet', 25000, 8);
ROLLBACK;

START TRANSACTION;
INSERT INTO Electronics VALUES (6, 'Camera', 30000, 5);
SAVEPOINT sp1;

INSERT INTO Electronics VALUES (7, 'Speaker', 4000, 20);
ROLLBACK TO sp1;  -- Only removes Speaker insert

COMMIT;

/* DQL Command (Data Query Language)
       SELECT --> query to get Final result
       */
       
-- TO GET ALL THE COLUMNS FROM A TABLE
SELECT * FROM ELECTRONICS;

-- TO GET A SPECIFIC COLUMNS
SELECT PRODUCT_ID,PRICE FROM ELECTRONICS; 

select 50 AS NUMBER;

/*
SQL OPERATORS : 
     LIKE --> PATTER MATCHING
     BETWEEN --> CHECKS IF A VALUE LIES WITHIN RANGE
     IN --> MATCHES IN A LIST OF VALUES
     ANY -->COMPARES WITH ANY VALUE FROM A SUBQUERY
     ALL -->COMPARE ALL VALUES
     EXISTS --> RETURNS TRUE IF A SUBQUERY RETURNS ROWS*/
USE storedb;
SELECT * FROM electronics
WHERE product_name LIKE 'S%';

SELECT * FROM ELECTRONICS
WHERE PRICE BETWEEN 5000 AND 8000;

SELECT * FROM ELECTRONICS
WHERE PRODUCT_id IN (1, 2);

SELECT * FROM ELECTRONICS
WHERE PRICE > ANY (SELECT PRICE FROM ELECTRONICS WHERE PRODUCT_id = 3);

use practice;
-- Aggregate Function
/*   SUM() → Adds up values (e.g., total sales ).

     COUNT() → Counts rows (e.g., number of employees).

     AVG() → Calculates average (e.g., average salary ).

     MIN() → Finds the smallest value (e.g., lowest exam score ).

     MAX() → Finds the largest value (e.g., highest product price).*/
SELECT * FROM EMP;
-- Total Salary of Employees
SELECT SUM(salary) AS total_salary
FROM emp;
-- COUNT – Number of Employees
SELECT COUNT(*) AS total_employees
FROM emp;
-- AVG – Average Salary
SELECT AVG(salary) AS average_salary
FROM emp;
-- MIN – Youngest Employee Age
SELECT MIN(salary) AS youngest_age
FROM emp;
-- MAX – Highest Salary
SELECT MAX(salary) AS highest_salary
FROM emp;
-- Find total salary of IT department employees
SELECT SUM(salary) AS it_total_salary
FROM emp
WHERE job = 'clerk';
-- Find average age of employees in HR department
SELECT AVG(age) AS hr_avg_age
FROM emp
WHERE department = 'manager';

USE PRACTICE;
SELECT * FROM EMP;
/*
	# GROUP BY CLAUSE --> used to arrange identical data into groups
*/
-- Count employees per department
SELECT JOB, COUNT(*) AS total_employees
FROM emp
GROUP BY JOB;

-- Average salary per department
SELECT depT_NO, AVG(salary) AS avg_salary
FROM emp
GROUP BY depT_NO;

-- Highest salary per department
SELECT DEPT_NO, MAX(salary) AS highest_salary
FROM emp
GROUP BY depT_NO;

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product VARCHAR(50),
    city VARCHAR(50),
    amount INT
);

INSERT INTO sales (sale_id, product, city, amount) VALUES
(1, 'Laptop', 'Hyderabad', 50000),
(2, 'Laptop', 'Delhi', 45000),
(3, 'Phone', 'Hyderabad', 20000),
(4, 'Phone', 'Delhi', 22000),
(5, 'Tablet', 'Hyderabad', 30000),
(6, 'Tablet', 'Delhi', 28000);


-- Total sales per product
SELECT product, SUM(amount) AS total_sales
FROM sales
GROUP BY product;

-- Total sales per city
SELECT city, SUM(amount) AS city_sales
FROM sales
GROUP BY city;

-- Sales per product per city
SELECT product, city, SUM(amount) AS sales
FROM sales
GROUP BY product, city;

USE PRACTICE;
SELECT * FROM EMP;
SELECT * FROM DEPT;

/* INNER JOIN
	SYNTAX-->SELECT COLUMN_NAME
			FROM TABLE 1
            INNER JOIN TABLE 2
            ON CONDITION
*/
-- Returns only matching rows from both tables.
SELECT e.EMP_NO, e.ename, e.salary, d.dname
FROM emp e
INNER JOIN dept d
  ON e.dept_NO = d.dept_NO;




/* LEFT JOIN
	SYNTAX-->SELECT COLUMN_NAME
			FROM TABLE 1
			LEFT JOIN TABLE 2
            ON CONDITION
*/
-- Returns all employees, even if they don’t belong to any department.
SELECT E.*,D.*
FROM emp e
LEFT JOIN dept d
  ON e.dept_NO = d.dept_NO;




/* RIGHT JOIN
	SYNTAX-->SELECT COLUMN_NAME
			FROM TABLE 1
			RIGHT JOIN TABLE 2
            ON CONDITION           
                --> (WE CAN USE RIGHT JOIN IN LEFT JOIN ITSELF BY INTERCHANGING TABLES)
*/
-- Returns all departments, even if no employees are assigned.
SELECT E.ENAME,E.JOB,E.SALARY,D.DNAME,D.LOCATION
FROM emp e
RIGHT JOIN dept d
  ON e.dept_NO = d.dept_NO;


/* FULL JOIN
	SYNTAX-->SELECT COLUMN_NAME FROM TABLE 1
			LEFT JOIN TABLE 2 ON CONDITION
                    UNION
			SELECT COLUMN_NAME FROM TABLE 1
			LEFT JOIN TABLE 2 ON CONDITION
(IN MYSQL THERE IS NO FULL JOIN KEY WORD TO ACHIEVE FULL JOIN WE USE UNION ON LEFT AND RIGHT JOINS)
*/
-- Returns all rows from both tables (employees and departments), showing NULLs where there’s no match.
SELECT * FROM emp e LEFT JOIN dept d ON e.dept_NO = d.dept_NO
UNION
SELECT * FROM emp e RIGHT JOIN dept d ON e.dept_NO = d.dept_NO;






/* CROSS JOIN
	SYNTAX-->SELECT COLUMN_NAME
			FROM TABLE 1
			CROSS JOIN TABLE 2 
(IN CROSS JOIN THERE IS NO ON CONDITION
        IF WE PERFORM ON CONDITION IN CROSS JOIN IT ACTS LIKE INNER JOIN)
*/
-- Returns Cartesian product(NO.OF RECORDS IN TABLE 1 * NO.OF RECORDS IN TABLE 2)
         -- (every employee combined with every department).
SELECT E.ENAME,E.JOB,E.SALARY,D.DNAME,D.LOCATION
FROM emp e
CROSS JOIN dept d;




/* SELF JOIN
	SYNTAX-->SELECT COLUMN_NAME
			FROM TABLE 1 AS T1
			JOIN TABLE 1 AS T2
            ON CONDITION
*/
-- Joining a table with itself (example: find employees and their managers from the same emp table).
-- Assume emp has a manager_id column referencing another employee.
SELECT e.ename AS Employee, m.ename AS Manager
FROM emp e
LEFT JOIN emp m
  ON e.MGR = m.emp_NO;




/* SET OPERATORS : 
            -->UNION ----REMOVES DUPLICATES
            -->UNION ALL ----KEEP DUPLICATES
            -->INTERSECT ----COMMON RECORDS
            -->EXCEPT  ----DIFFERENCE*/
-- Get all unique department IDs from both Employees and Departments.
SELECT dept_NO FROM Emp
UNION
SELECT dept_NO FROM DepT;
-- Same as above but shows duplicates.
SELECT dept_NO FROM Emp
UNION ALL
SELECT dept_NO FROM DepT;
-- Find department IDs that exist in both Employees and Departments.
SELECT dept_NO FROM Emp
INTERSECT
SELECT dept_NO FROM DepT;
-- Find department IDs present in Employees but not in Departments.
SELECT dept_NO FROM DEPT
EXCEPT
SELECT dept_NO FROM  Emp;


use practice;

/*String Functions */
SELECT EMP_NO, ENAME, JOB,
    -- 1. CONCAT → Full employee description
    CONCAT(ENAME, ' works as ', JOB, ' in Dept ', DEPT_NO) AS EmployeeInfo,
    -- 2. LENGTH → Name length
    LENGTH(ENAME) AS NameLength,
    -- 3. UPPER & LOWER → Job title formatting
    UPPER(JOB) AS UpperJob, LOWER(JOB) AS LowerJob,
    -- 4. SUBSTRING → First 3 letters of job
    SUBSTRING(JOB, 1, 3) AS JobCode,
    -- 5. INSTR → Position of 'A' in ENAME
    INSTR(ENAME, 'A') AS PositionOfA,
    -- 6. REPLACE → Replace MANAGER with BOSS
    REPLACE(JOB, 'MANAGER', 'BOSS') AS UpdatedJob,
    -- 7. TRIM → Remove spaces from a sample string
    TRIM('   SQL Functions   ') AS TrimmedText,
    -- 8. REVERSE → Reverse the employee name
    REVERSE(ENAME) AS ReversedName
FROM EMP;




use practice;


/* DATE AND TIME FUNCTIONS */
SELECT ENAME,HIREDATE,
    -- Extract Parts
    YEAR(HIREDATE) AS hire_year,
    MONTHNAME(HIREDATE) AS hire_month,
    DAYNAME(HIREDATE) AS hire_day,
    -- Date Arithmetic
    DATE_ADD(HIREDATE, INTERVAL 1 YEAR) AS next_anniversary,
    DATE_SUB(HIREDATE, INTERVAL 6 MONTH) AS six_months_before,
    -- Difference
    DATEDIFF(CURDATE(), HIREDATE) AS days_in_company,
    TIMESTAMPDIFF(YEAR, HIREDATE, CURDATE()) AS years_in_company,
    -- Formatting
    DATE_FORMAT(HIREDATE, '%d-%M-%Y') AS formatted_date,
    DATE_FORMAT(HIREDATE, '%W, %M %d %Y') AS detailed_date
FROM EMP;



SELECT ENAME, HIREDATE,
    
    -- Time Functions
    NOW() AS current_datetime,
    ADDTIME(NOW(), '02:00:00') AS after_2_hours,
    SUBTIME(NOW(), '01:00:00') AS before_1_hour,
    SEC_TO_TIME(3661) AS seconds_to_time,
    TIME_TO_SEC('01:01:01') AS time_to_seconds,
    
    -- String + Date Combined
    CONCAT(ENAME, ' joined on ', DATE_FORMAT(HIREDATE, '%W, %M %d %Y')) AS join_message
    
FROM EMP;

USE PRACTICE;


/* SUBQUERIES */
-- Subquery in WHERE (Single Row Subquery)
-- Find employees earning more than Allen.

SELECT ENAME, SALARY
FROM EMP
WHERE SALARY > (
    SELECT SALARY 
    FROM EMP 
    WHERE ENAME = 'ALLEN'
);




-- Subquery in WHERE (Multi-Row with IN)
-- Find employees who work in the same department as SCOTT.

SELECT ENAME, DEPT_NO
FROM EMP
WHERE DEPT_NO IN (
    SELECT DEPT_NO 
    FROM EMP 
    WHERE ENAME = 'SCOTT'
);



-- Subquery in FROM (Inline View)
-- Find employees with salary above department average.

SELECT e.ENAME, e.DEPT_NO, e.SALARY FROM EMP e
JOIN (
    SELECT DEPT_NO, AVG(SALARY) AS AVG_SAL
    FROM EMP
    GROUP BY DEPT_NO
) d ON e.DEPT_NO = d.DEPT_NO
WHERE e.SALARY > d.AVG_SAL;

-- Subquery in SELECT
-- Display employee name with their department name (using subquery instead of join).
SELECT ENAME,
       (SELECT DNAME 
        FROM DEPT 
        WHERE DEPT.DEPT_NO = EMP.DEPT_NO) AS DEPARTMENT
FROM EMP;



-- Correlated Subquery
-- Find employees who earn the maximum salary in their department.

SELECT ENAME, DEPT_NO, SALARY
FROM EMP e
WHERE SALARY = (
    SELECT MAX(SALARY)
    FROM EMP
    WHERE DEPT_NO = e.DEPT_NO
);

-- Subquery with EXISTS
-- Find departments that have at least one employee.

SELECT DEPT_NO, DNAME
FROM DEPT d
WHERE EXISTS (
    SELECT 1 
    FROM EMP e 
    WHERE e.DEPT_NO = d.DEPT_NO
);

USE PRACTICE;




/* CTEs (COMMON TABLE EXPRESSIONS)*/
-- Find employees earning above their department average.
WITH dept_avg AS (
  SELECT DEPT_NO, AVG(SALARY) AS avg_sal
  FROM EMP
  GROUP BY DEPT_NO
)
SELECT e.EMP_NO, e.ENAME, e.DEPT_NO, e.SALARY, d.avg_sal
FROM EMP e
JOIN dept_avg d ON e.DEPT_NO = d.DEPT_NO
WHERE e.SALARY > d.avg_sal
ORDER BY e.SALARY DESC;




with cte_orders as (
select customerid,sum(score) as avgScore
from customers
group by customerid)
-- Main Query
select *,rank() over(order by customerid) crank
from cte_orders
where avgScore>(select avg(score) from customers);




-- recursive ctes
-- GET 1 TO 20 NUMBERS USING CTEs
with recursive numseries as (select 1 as mynumber
                  union all
                  select mynumber +1
                  from numseries
                  where mynumber<20)
   select * from numseries;




-- emp Hierarchy using recursion ctes
WITH recursive CTE_EMP_HIERARCHY AS(
    SELECT EMPLOYEEID,FIRSTNAME,MANAGERID,1 AS LEVEL
    FROM EMPLOYEES
    WHERE MANAGERID IS NULL
    
    UNION ALL
     
     SELECT E.EMPLOYEEID,E.FIRSTNAME,E.MANAGERID,LEVEL+1
     FROM EMPLOYEES AS E 
     INNER JOIN CTE_EMP_HIERARCHY CEH
     ON E.MANAGERID=CEH.EMPLOYEEID)
     SELECT * FROM CTE_EMP_HIERARCHY;



use practice;
select * from dept;



/*STORED PROCEDURES*/
-- Create a Simple Stored Procedure → Get All Employees

DELIMITER //
CREATE PROCEDURE GetAllEmployees()
BEGIN
    SELECT * FROM EMP;
END //
DELIMITER ;

-- Call the procedure
CALL GetAllEmployees();



-- Stored Procedure with Parameters → Get Employees by Department

DELIMITER //
CREATE PROCEDURE GetEmployeesByDept(IN dept INT)
BEGIN
    SELECT ENAME, JOB, SALARY
    FROM EMP
    WHERE DEPT_NO = dept;
END //
DELIMITER ;
-- Call the procedure
CALL GetEmployeesByDept(30);


-- Stored Procedure with Output Parameter → Count Employees in a Department
DELIMITER //
CREATE PROCEDURE CountEmployeesByDept(IN dept INT, OUT emp_count INT)
BEGIN
    SELECT COUNT(*) INTO emp_count
    FROM EMP
    WHERE DEPT_NO = dept;
END //
DELIMITER ;
-- Call the procedure
CALL CountEmployeesByDept(20, @emp_count);
SELECT @emp_count AS TotalEmployees;




-- Stored Procedure → Increase Salary of All Clerks

DELIMITER //
CREATE PROCEDURE IncreaseClerkSalary(IN hike_amt INT)
BEGIN
    UPDATE EMP
    SET SALARY = SALARY + hike_amt
    WHERE JOB = 'CLERK';
    SELECT ENAME,SALARY FROM EMP;
END //
DELIMITER ;
-- Call the procedure
CALL IncreaseClerkSalary(200);
DROP procedure IncreaseClerkSalary;




-- Examples of CTAS

--  Copy full table

CREATE TABLE emp_copy AS
SELECT * FROM EMP;


-- Copy only structure (no data)

CREATE TABLE emp_structure AS
SELECT * FROM EMP WHERE 1=0; -- To copy only Structure of a table we use Where 1=0


-- Create a summary table

CREATE TABLE dept_salary_summary AS
SELECT DEPT_NO, AVG(SALARY) AS avg_sal
FROM EMP
GROUP BY DEPT_NO;






