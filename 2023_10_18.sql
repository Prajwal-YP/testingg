
-- Displaying all the databases
SELECT name,filename 
FROM sys.sysaltfiles;

-- Creating the database
CREATE DATABASE Payroll;

-- Selecting or using the database
USE Payroll;

-- Creating the table for the database
CREATE TABLE tblEmployeeDt1(
EmployeeId INT,
EmployeeName VARCHAR(50),
Designation VARCHAR(50),
JoinedDate DATE,
EmailId VARCHAR(50),
Salary MONEY,
EmployeeLocation VARCHAR(50),
DepartmentID INT );


-- Inserting a tuple in a table
INSERT INTO tblEmployeeDt1 VALUES
(1000, 'Prajwal Y P', 'Database Administrator', '2023-10-11', 'prajwal.yp@excelindia.com', 55000, 'Mysuru', 10),
(1001, 'Sagar', 'Database Developer', '2023-10-13', 'Sagar.1@excelindia.com', 45000, 'Bangaluru', 10),
(1002, 'Nishanth', 'Trainee Software Developer', '2023-11-12', 'Nishanth.2@excelindia.com', 45000, 'Manglore', 11),
(103, 'Preetham', 'Database Developer', '2023-01-11', 'Preetham.3@excelindia.com', 46000, 'Mysuru', 11),
(104, 'Raghu', 'Trainee Database Developer', '2023-10-11', 'Raghu.4@excelindia.com', 43000, 'Bangaluru', 12),
(105, 'Sushil', 'Trainee Software Developer', '2023-08-10', 'Sushil.5@excelindia.com', 31000, 'Manglore', 12),
(1006, 'Pavithra', 'Finance', '2022-10-06', 'Pavithra.6@excelindia.com', 51000, 'Mysuru', 13),
(1007, 'Vatsala', 'Finance', '2022-09-11', 'Vatsala.7@excelindia.com', 52000, 'Bangaluru', 13),
(108, 'Neelima', 'HR', '2023-10-09', 'Neelima.8@excelindia.com', 53000, 'Manglore', 14),
(109, 'Subramanya', 'Trainer', '2023-10-11', 'Subramanya.9@excelindia.com', 52500, 'Bangaluru', 14);
								
-- Display all trcords of a table
SELECT *
FROM tblEmployeeDt1;

-- Deleting a table in a database
DROP TABLE tblEmployeeDt1;

-- Only selecting the data is possible
SELECT 'Prajwal Y P' AS MyName;

-- ANY and DISTINCT clauses. ANY is Default
SELECT *, Designation
FROM tblEmployeeDt1;
