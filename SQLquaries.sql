CREATE database SUBBU;
USE SUBBU;

DROP TABLE IF EXISTS STUDENT;
CREATE TABLE STUDENT (
    STUDENT_ID INT PRIMARY KEY,
    NAME VARCHAR(100),
    AGE INT,
    GENDER VARCHAR(10),
    DEPARTMENT VARCHAR(50),
    YEAR INT,
    SEMESTER INT,
    EMAIL VARCHAR(100),
    PHONE VARCHAR(15),
    MARKS INT,
    CITY VARCHAR(50),
    STATE VARCHAR(50),
    COUNTRY VARCHAR(50),
    SCHOLARSHIP_STATUS VARCHAR(10)
);
INSERT INTO STUDENT (STUDENT_ID, NAME, AGE, GENDER, DEPARTMENT, YEAR, SEMESTER, EMAIL, PHONE, MARKS, CITY, STATE, COUNTRY, SCHOLARSHIP_STATUS) VALUES
(201, 'Ravi Kumar', 20, 'Male', 'CSE', 2, 3, 'ravi.kumar@example.com', '9876543210', 85, 'Hyderabad', 'Telangana', 'India', 'Yes'),
(202, 'Anjali Sharma', 21, 'Female', 'ECE', 3, 5, 'anjali.sharma@example.com', '9876543211', 78, 'Delhi', 'Delhi', 'India', 'No'),
(203, 'Manoj Reddy', 19, 'Male', 'EEE', 1, 2, 'manoj.reddy@example.com', '9876543212', 92, 'Chennai', 'Tamil Nadu', 'India', 'Yes'),
(204, 'Priya Patel', 22, 'Female', 'IT', 4, 7, 'priya.patel@example.com', '9876543213', 88, 'Bangalore', 'Karnataka', 'India', 'Yes'),
(205, 'Amit Verma', 20, 'Male', 'Mechanical', 2, 4, 'amit.verma@example.com', '9876543214', 75, 'Mumbai', 'Maharashtra', 'India', 'No'),
(206, 'Sneha Joshi', 21, 'Female', 'CSE', 3, 6, 'sneha.joshi@example.com', '9876543215', 81, 'Pune', 'Maharashtra', 'India', 'No'),
(207, 'Rahul Nair', 20, 'Male', 'Civil', 2, 3, 'rahul.nair@example.com', '9876543216', 69, 'Kochi', 'Kerala', 'India', 'Yes'),
(208, 'Divya Rao', 19, 'Female', 'ECE', 1, 2, 'divya.rao@example.com', '9876543217', 74, 'Vizag', 'Andhra Pradesh', 'India', 'No'),
(209, 'Karthik Iyer', 22, 'Male', 'IT', 4, 7, 'karthik.iyer@example.com', '9876543218', 90, 'Chennai', 'Tamil Nadu', 'India', 'Yes'),
(210, 'Neha Gupta', 20, 'Female', 'CSE', 2, 4, 'neha.gupta@example.com', '9876543219', 83, 'Lucknow', 'Uttar Pradesh', 'India', 'No'),
(211, 'Suresh Das', 21, 'Male', 'Mechanical', 3, 5, 'suresh.das@example.com', '9876543220', 77, 'Bhubaneswar', 'Odisha', 'India', 'Yes'),
(212, 'Aarti Mehta', 19, 'Female', 'EEE', 1, 1, 'aarti.mehta@example.com', '9876543221', 88, 'Jaipur', 'Rajasthan', 'India', 'Yes'),
(213, 'Vikram Singh', 22, 'Male', 'Civil', 4, 8, 'vikram.singh@example.com', '9876543222', 72, 'Patna', 'Bihar', 'India', 'No'),
(214, 'Pooja Rani', 20, 'Female', 'CSE', 2, 3, 'pooja.rani@example.com', '9876543223', 79, 'Amritsar', 'Punjab', 'India', 'Yes'),
(215, 'Tarun Yadav', 21, 'Male', 'IT', 3, 5, 'tarun.yadav@example.com', '9876543224', 86, 'Gurgaon', 'Haryana', 'India', 'No');
SELECT * FROM STUDENT;
SELECT *FROM STUDENT WHERE AGE=20;
SELECT *FROM STUDENT WHERE SEMESTER=4;
SELECT *FROM STUDENT WHERE GENDER='MALE';
SELECT *FROM STUDENT ORDER BY AGE;
SELECT * FROM STUDENT WHERE SEMESTER =2;
DELETE FROM STUDENT WHERE STUDENT_ID BETWEEN 205 and 210;
SELECT * FROM STUDENT;
select student_id as id,age as A, student as stu from student;
SELECT s.student_id as id, s.age AS a FROM student AS s;

select *from student;
CREATE TABLE COURSE_ENROLLMENT (
    ENROLL_ID INT PRIMARY KEY,
    STUDENT_ID INT,
    COURSE_CODE VARCHAR(10),
    COURSE_NAME VARCHAR(100),
    INSTRUCTOR VARCHAR(100),
    CREDITS INT,
    FOREIGN KEY (STUDENT_ID) REFERENCES STUDENT(STUDENT_ID)
);
INSERT INTO COURSE_ENROLLMENT (ENROLL_ID, STUDENT_ID, COURSE_CODE, COURSE_NAME, INSTRUCTOR, CREDITS) VALUES
(1, 201, 'CSE101', 'Data Structures', 'Dr. Rao', 4),
(2, 202, 'ECE102', 'Digital Electronics', 'Dr. Mehta', 3),
(3, 203, 'EEE101', 'Circuits Analysis', 'Dr. Reddy', 4),
(4, 204, 'IT202', 'Web Development', 'Dr. Sharma', 3),
(5, 211, 'ME101', 'Thermodynamics', 'Dr. Gupta', 4),
(6, 212, 'EEE102', 'Electrical Machines', 'Dr. Reddy', 4),
(7, 213, 'CIV101', 'Structural Analysis', 'Dr. Verma', 3),
(8, 214, 'CSE102', 'Python Programming', 'Dr. Rao', 3),
(9, 215, 'IT203', 'Software Engineering', 'Dr. Sharma', 3),
(10, 201, 'CSE103', 'Operating Systems', 'Dr. Singh', 4);
select *from COURSE_ENROLLMENT;
SELECT 
    
    s.NAME, 
    c.COURSE_CODE, 
    c.COURSE_NAME, 
    c.INSTRUCTOR
FROM 
    STUDENT as  s
INNER JOIN 
    COURSE_ENROLLMENT as c ON s.STUDENT_ID = c.STUDENT_ID;
SELECT S.NAME,S.AGE,C.COURSE_NAME
FROM STUDENT AS S
LEFT JOIN COURSE_ENROLLMENT AS C 
ON S.STUDENT_ID = C.STUDENT_ID
ORDER BY AGE