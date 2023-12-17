-- ALTER Commands
-- 1. ADD
-- 2. DROP
-- 3. ALTER
-- 4. EXEC sp_rename

USE [Payroll];

CREATE TABLE [experiment](
[SlNo] INT,
[Name] VARCHAR(50) NOT NULL);

INSERT INTO [experiment] VALUES (NULL, 'yp');

SELECT * FROM [experiment];

ALTER TABLE [experiment]
ADD CONSTRAINT [pk_experiment] PRIMARY KEY([SlNo]);
-- Error

DELETE FROM [experiment];

ALTER TABLE [experiment]
ADD CONSTRAINT [pk_experiment] PRIMARY KEY([SlNo]);
-- Error: 
-- If the ciolumn is NULL it can not be a PRIMARY KEY. 
-- So first Make that column (Alter the column) as NOT NULL.

ALTER TABLE [experiment]
ALTER COLUMN [SlNo] INT NOT NULL;

ALTER TABLE [experiment]
ADD CONSTRAINT [uk_experiment] UNIQUE([SlNo]);

ALTER TABLE [experiment]
ADD CONSTRAINT [pk_experiment] PRIMARY KEY([SlNo]);
-- SUCCESS

ALTER TABLE [experiment]
ADD CONSTRAINT [def_experiment] DEFAULT 'Name Not Specifies' FOR [Name];

ALTER TABLE [experiment]
ADD CONSTRAINT [def_experiment] DEFAULT 'Name Not Specifies' FOR [Name];

ALTER TABLE [experiment]
ADD CONSTRAINT [fk_experiment] 
FOREIGN KEY([SlNo]) REFERENCES [Student]([StuId])
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE [experiment]
DROP CONSTRAINT [fk_experiment];

EXEC sp_help [experiment];

DROP TABLE [experiment];

-- _____________________________________________________________
-- Disaasociate emplye in dep 10 to dept 50
UPDATE tblDepartment
SET DepartmentId=50
WHERE [DepartmentId] IN (10);
-- _____________________________________________________________

SELECT * FROM [Student];
SELECT * FROM [experiment];

INSERT INTO [Student] VALUES (5,'Mr unknown', 'M')

INSERT INTO [experiment] VALUES (5,'unknon')

DELETE FROM [Student] WHERE [StuId] IN (5);


--_______________________________________________________________

SELECT *
FROM [tblEmployeeDtlC];

SELECT DISTINCT  TOP 4 [Salary]
FROM [tblEmployeeDtlC]
ORDER BY [Salary];

SELECT *
FROM [tblEmployeeDtlC]
ORDER BY [Salary] DESC;

SELECT TOP 4 *
FROM [tblEmployeeDtlC]
ORDER BY [Salary] DESC;

SELECT TOP 4 WITH TIES *
FROM [tblEmployeeDtlC];
--Error: The TOP N WITH TIES clause is not allowed without a corresponding ORDER BY clause.

SELECT TOP 4 WITH TIES *
FROM [tblEmployeeDtlC]
ORDER BY [Salary] DESC;

SELECT TOP 40 PERCENT *
FROM [tblEmployeeDtlC]
ORDER BY [Salary] DESC;

SELECT *
FROM [tblEmployeeDtlC]
ORDER BY [EmployeeID], [Salary] DESC;


--_______________________________________________________________

-- AGGREGATE FUNCTION
-- • SUM() : computes the total of a column
-- • AVG() : computes the average value in a column
-- • MIN() : finds the smallest value in a column
-- • MAX() : finds the largest value in a column
-- __________________________________________________________________________________
-- • COUNT() : counts the number of non-NULL values in a column
SELECT *
FROM [tblEmployeeDtlC]

SELECT COUNT(EmployeeId)
FROM [tblEmployeeDtlC]
-- __________________________________________________________________________________
-- • COUNT (*): 
--		counts rows of query results and does not depend on the presence or absence of NULL values in a column. 
--		If there are no rows, it returns a value of zero.
SELECT *
FROM [tblEmployeeDtlC]

SELECT COUNT(*)
FROM [tblEmployeeDtlC]
-- __________________________________________________________________________________

-- GROUP BY
--	Collect data across multiple records and group the results by one or more columns
-- SYNTAX
--		SELECT column1,AGGREGATE
--		FROM list-of-tables
--		GROUP BY column-list;
SELECT *
FROM tblEmployeeDtlC


SELECT [Designation], COUNT(*) AS [Total Employees]
FROM [tblEmployeeDtlC]
GROUP BY [Designation]
ORDER BY [Total Employees];

-- "Columns in GROUP BY Clause" should be present in "SELECT Clause" too
-- "Columns in ORDER BY Clause" Should be present in "SELECT Clause too"
-- ORDER BY Clause can have Aggregate function on any column 

-- DEFAULT Constraint will not allow us to create a column with default values other than NULL Values
-- HAVING and GROUP BY Clauses can take expressions too
-- __________________________________________________________________________________

-- JOINS
--	Used to combine data from multiple tables

SELECT * FROM [Employees];
SELECT * FROM [tblDepartmentC];

-- Types of Joins

-- 	 1. CROSS JOIN
SELECT * 
FROM [Employees] AS E CROSS JOIN [tblDepartmentC] AS D;

--__________________________________________________________________________________
-- 	 2. INNER JOIN

-- 	 	 EQUI JOIN

--ORACLE
SELECT * 
FROM [Employees] AS E ,[tblDepartmentC] AS D
WHERE E.DepartmentId=D.DepartmentID;

--MS SQL SERVER SYNTAX
SELECT * 
FROM [Employees] AS E INNER JOIN [tblDepartmentC] AS D
ON E.DepartmentId=D.DepartmentID;

--__________________________________________________________________________________
-- 	 	 NON-EQUI JOIN
SELECT * 
FROM [Employees] AS E INNER JOIN [tblDepartmentC] AS D
ON E.DepartmentId=D.DepartmentID;

--__________________________________________________________________________________
-- 	 3. OUTER JOIN
-- 	 	 LEFT
--			Display all tuples of left table and matching tuples of right table
SELECT * 
FROM [Employees] AS E LEFT JOIN [tblDepartmentC] AS D
ON E.DepartmentId=D.DepartmentID;

--__________________________________________________________________________________
-- 	 	 RIGHT
--			Display all tuples of right table and matching tuples of left table
SELECT * 
FROM [Employees] AS E RIGHT JOIN [tblDepartmentC] AS D
ON E.DepartmentId=D.DepartmentID;

--__________________________________________________________________________________
-- 	 	 FULL
SELECT * 
FROM [Employees] AS E FULL OUTER JOIN [tblDepartmentC] AS D
ON E.DepartmentId=D.DepartmentID;