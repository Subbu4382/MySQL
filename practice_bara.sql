

/* WINDOW FUNCTIONS*/

USE SALESDB;
SELECT ORDERID,ORDERDATE,productid,sales,
max(sales) over() highestsales,
SUM(SALES) OVER(PARTITION BY PRODUCTID order by SALES) totalsales
FROM ORDERS;



SELECT ORDERID,ORDERDATE,productid,sales,
max(sales) over(),
SUM(SALES) OVER(PARTITION BY PRODUCTID
      order by SALES rows between 2 preceding and current row) totalsales
FROM ORDERS;
  
  /*WINDOW RANK FUNCTIONS*/
  
SELECT ORDERID,PRODUCTID,SALES,
row_number() OVER(ORDER BY SALES DESC) SALESRANK_ROW,
RANK() OVER(order by SALES DESC) SALESRANK_RANK,
dense_rank() OVER(order by SALES DESC) SALESRANK_DENSE,
cume_dist() OVER(order by SALES DESC) SALESRANK_CUME,
percent_rank() OVER(order by SALES DESC) SALESRANK_PERCENT
FROM ORDERS;

/*WINDOW VALUE FUNCTIONS*/

SELECT ORDERID,PRODUCTID,SALES,
first_value(SALES) OVER(partition by PRODUCTID ORDER BY SALES) LOWESTSALES,
sales-first_value(SALES) OVER(partition by PRODUCTID ORDER BY SALES) salesdifference,
last_value(SALES) OVER(partition by PRODUCTID ORDER BY SALES ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HIGHESTSALES,
nth_value(SALES,2) OVER(partition by PRODUCTID ORDER BY SALES ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) nth_SALES
FROM ORDERS;



-- SUBQUERIES
SELECT ORDERID,PRODUCTID,QUANTITY,SALES FROM ORDERS WHERE PRODUCTID IN (
          SELECT PRODUCTID FROM PRODUCTS WHERE CATEGORY="Accessories");


SELECT * FROM (SELECT *,AVG(PRICE) OVER() AS AVGPRICE FROM PRODUCTS) T 
WHERE PRICE>AVGPRICE;


-- CTEs



with cte_orders as (
select customerid,sum(score) as avgScore
from customers
group by customerid)
-- Main Query
select *,rank() over(order by customerid) crank
from cte_orders
where avgScore>(select avg(score) from customers);

-- recursive ctes

with recursive numseries as (select 1 as mynumber
                  union all
                  select mynumber *2
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








