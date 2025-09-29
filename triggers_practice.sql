use mydatabase;
select distinct table_name from information_schema.columns;
use salesdb;
select * from
(select productid,price,avg(price) over() avgprice from salesdb.products) as f where price>avgprice;


/*TRIGGERS*/

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
DELETE FROM employee WHERE id = 7;
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
)

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

