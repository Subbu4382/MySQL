use practice;
show tables;
select*from emp;
select*from dept;
-- Find employees earning more than the average salary.
select * from emp where salary > (select avg(salary) from emp);
-- List employees working in the same department as SCOTT.
select * from emp where dept_no in (select dept_no from emp where ename="scott") and ename<>'scott';
select dept_no from emp where ename="scott" limit 1;
-- Find the employee with the highest salary.
select * FROM EMP WHERE SALARY =(SELECT MAX(SALARY) FROM EMP );
-- Find the employee with the SECOND HIGHEST salary.
select * FROM EMP WHERE SALARY <(SELECT MAX(SALARY) FROM EMP ) order by SALARY DESC LIMIT 1;
SELECT * FROM EMP order by SALARY DESC LIMIT 1 offset 1;
-- Find employees whose salary is higher than ALL employees in department 30.
SELECT * FROM EMP WHERE SALARY > ALL(SELECT SALARY FROM EMP WHERE DEPT_NO=30);
SELECT SALARY FROM EMP WHERE DEPT_NO=30;
-- Find employees whose salary is higher than ANY employee in department 20.
SELECT * FROM EMP WHERE SALARY > ANY(SELECT SALARY FROM EMP WHERE DEPT_NO=20);
SELECT SALARY FROM EMP WHERE DEPT_NO=20;
-- Find employees with the minimum salary in each department.
SELECT E.* FROM EMP E WHERE SALARY =(SELECT MIN(SALARY) FROM EMP WHERE DEPT_NO=E.DEPT_NO);

create view  emp_details_view as select emp_no,ename,job from emp;
select * from emp_details_view;

-- use 42r;
-- show tables;
-- select * from stu_info as si join stu_skills as ss on si.id=ss.id join students as s on ss.id=s.id;
-- select si.email,si.course,ss.technical,s.name,s.dob from stu_info as si join stu_skills as ss on si.id=ss.id join students as s on ss.id=s.id;


























