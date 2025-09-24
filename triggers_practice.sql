use mydatabase;
select distinct table_name from information_schema.columns;
use salesdb;
select * from
(select productid,price,avg(price) over() avgprice from salesdb.products) as f where price>avgprice;


drop table messages;
create table message(message varchar(225));
 
 drop trigger trigger_emp_msg;
 drop trigger employee_insert_trigger;
 
 
 
 /*Triggers */
 -- Creating a Trigger on employee on delete action
 delimiter ##
 create trigger employee_delete_trigger
 after delete on employee for each row
 begin
 insert into message values(concat("employee ",old.emp_name,"  is deleted"));
 end ##
 delimiter ;
 
DELETE FROM employee WHERE id = 8;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM employee WHERE emp_name="srinu";
SET SQL_SAFE_UPDATES = 1;





use practice;
create table products(products varchar(30),quantity int);
create table orders(ord_product varchar(30),ord_quantity int);
insert into products values("mobiles",20),("watches",10),("laptops",5);

/* creating trigger on orders and products tables*/
drop trigger sell_products;
delimiter //
CREATE TRIGGER SELL_PRODUCTS
BEFORE INSERT ON ORDERS FOR each row
BEGIN
SET @available=0;
select quantity into @available from products where products=new.ord_product;
if @available>new.ord_quantity then
update products set quantity=quantity-new.ord_quantity where products=new.ord_product;
elseif @available=new.ord_quantity then
update products set quantity=0 where products=new.ord_product;

else
signal sqlstate "45000"
set message_text="available quantity is less than ordered quantity!!";
end if;
end //
delimiter ;
SET SQL_SAFE_UPDATES = 0;
insert into orders values("laptops",5);
SET SQL_SAFE_UPDATES = 1;
show triggers;
/* 
CREATED TRIGGER ON EMP SALARY UPDATES

*/
use practice;
DROP TABLE SALARY_LOGS;
CREATE TABLE EMP_SALARY_LOGS(EMP_ID INT,MESSAGE VARCHAR(30));
delimiter //
CREATE TRIGGER after_sal_update
AFTER UPDATE ON EMP FOR EACH ROW
BEGIN
IF NEW.SALARY>OLD.SALARY THEN
   INSERT INTO EMP_SALARY_LOGS(EMP_ID,MESSAGE)
   VALUES (NEW.EMP_NO,CONCAT(NEW.ENAME,'GOT A SALARY HIKE!'));
elseif NEW.SALARY<OLD.SALARY THEN
   INSERT INTO SALARY_LOGS(EMP_ID,MESSAGE)
   VALUES(NEW.EMP_NO,concat(NEW.ENAME,'GOT A SALARY CUT !'));
else
  INSERT INTO SALARY_LOGS(EMP_ID,MESSAGE)
  VALUES (NEW.EMP_NO,CONCAT(NEW.ENAME,'SALARY UNCHANGED !'));
END IF;
END //
DELIMITER ;

UPDATE EMP SET SALARY =2000 WHERE EMP_NO=7934;
  


/* ============================================
   TRIGGER 1: Log Employee Deletions
   Why? → To keep a record when any employee 
   is deleted from the table.
   ============================================ */
DELIMITER ##
CREATE TRIGGER employee_delete_trigger
AFTER DELETE ON employee
FOR EACH ROW
BEGIN
    INSERT INTO message 
    VALUES (CONCAT("Employee ", OLD.emp_name, " is deleted"));
END ##
DELIMITER ;

/* Test the Trigger */
SET SQL_SAFE_UPDATES = 0;
DELETE FROM employee WHERE id = 8;
DELETE FROM employee WHERE emp_name = "srinu";
SET SQL_SAFE_UPDATES = 1;


/* ============================================
   TRIGGER 2: Manage Product Stock on Orders
   Why? → To automatically update product stock 
   when a new order is placed.
   ============================================ */
USE practice;

/* Sample Tables */
CREATE TABLE products (
    product_name VARCHAR(30), 
    quantity INT
);

CREATE TABLE orders (
    ord_product VARCHAR(30), 
    ord_quantity INT
);

INSERT INTO products 
VALUES ("mobiles", 20), ("watches", 10), ("laptops", 5);

-- Drop if trigger already exists
DROP TRIGGER IF EXISTS sell_products;

DELIMITER //
CREATE TRIGGER sell_products
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE available INT DEFAULT 0;
    
    -- Get available stock for the ordered product
    SELECT quantity INTO available 
    FROM products 
    WHERE product_name = NEW.ord_product;
    
    -- Case 1: Sufficient stock
    IF available > NEW.ord_quantity THEN
        UPDATE products 
        SET quantity = quantity - NEW.ord_quantity
        WHERE product_name = NEW.ord_product;
    
    -- Case 2: Exact stock match
    ELSEIF available = NEW.ord_quantity THEN
        UPDATE products 
        SET quantity = 0
        WHERE product_name = NEW.ord_product;
    
    -- Case 3: Not enough stock
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Available quantity is less than ordered quantity!!";
    END IF;
END //
DELIMITER ;

/* Test the Trigger */
SET SQL_SAFE_UPDATES = 0;
INSERT INTO orders VALUES ("laptops", 5);
SET SQL_SAFE_UPDATES = 1;

SHOW TRIGGERS;



/* ============================================
   TRIGGER 3: Log Employee Salary Updates
   Why? → To track salary changes (hike, cut, or no change).
   ============================================ */
USE practice;

-- Drop old log table if exists
DROP TABLE IF EXISTS emp_salary_logs;

-- Create a fresh log table
CREATE TABLE emp_salary_logs (
    emp_id INT,
    message VARCHAR(100)
);

DELIMITER //
CREATE TRIGGER after_sal_update
AFTER UPDATE ON emp
FOR EACH ROW
BEGIN
    -- Case 1: Salary Hike
    IF NEW.salary > OLD.salary THEN
        INSERT INTO emp_salary_logs (emp_id, message)
        VALUES (NEW.emp_no, CONCAT(NEW.ename, ' GOT A SALARY HIKE!'));
    
    -- Case 2: Salary Cut
    ELSEIF NEW.salary < OLD.salary THEN
        INSERT INTO emp_salary_logs (emp_id, message)
        VALUES (NEW.emp_no, CONCAT(NEW.ename, ' GOT A SALARY CUT!'));
    
    -- Case 3: No Change
    ELSE
        INSERT INTO emp_salary_logs (emp_id, message)
        VALUES (NEW.emp_no, CONCAT(NEW.ename, ' SALARY UNCHANGED!'));
    END IF;
END //
DELIMITER ;

/* Test the Trigger */
UPDATE emp SET salary = 2000 WHERE emp_no = 7934;

