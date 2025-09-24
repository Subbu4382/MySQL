create database 42r;
use 42r;
CREATE TABLE students (
    name VARCHAR(50),
    Id VARCHAR(20),
    age INT,
    DOB DATE
);
insert into students values("Subbu","21B21A4382",21,"2003-11-29"),
                     ("Balaji","216Q1A4399",21,"2004-01-17"),
                     ("narasimha","216Q1A43A0",21,"2004-08-06");
CREATE TABLE stu_info (
    id VARCHAR(50),
    email VARCHAR(50),
    phno INT,
    course VARCHAR(40)
);
ALTER TABLE stu_info MODIFY phno VARCHAR(15);
insert into stu_info values("21B21A4382","subrahmanyamdunne@gmail.com","9912119533","Python FullStack"),
                 ("216Q1A4399","balajiamara24@gmail.com","6309830858","Mern fullstack"),
                 ("216Q1A43A0","narasimhanaidu45@gmail.com","9346516537","Java fullstack");
CREATE TABLE stu_skills (
    id VARCHAR(20),
    communication VARCHAR(50),
    technical VARCHAR(20),
    Sql_ VARCHAR(10),
    problemsolving VARCHAR(20)
);

insert into stu_skills values("21B21A4382","1/5","3/5","2/5","2/5"),
                          ("216Q1A4399","3/5","3/5","2/5","3/5"),
                          ("216Q1A43A0","3/5","4/5","4/5","4/5");

