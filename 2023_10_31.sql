

---
--What are View?
--	A VIEW in SQL Server is like a virtual table that contains data from one or multiple tables.
--	It does not hold any data and does not exist physically in the database.


--> Similar to a SQL table, the view name should be unique in a database.
--> It contains a set of predefined SQL queries to fetch data from the database.
--> It can contain database tables from single or multiple databases as well.

--________________________________________________________________________________________________
--Syntax
--------

--	CREATE VIEW [View_Name] 
--	AS  
--	SELECT [column1], [Column2]...[Column N]
--	From [tables]  
--	Where [conditions];


--Types
-------
--1.	System Views
--2.	User defined Views


--Example 1: SQL VIEW to fetch all records of a table
--Example 2: SQL VIEW to fetch a few columns of a table
--Example 3: SQL VIEW to fetch a few columns of a table and filter results using WHERE clause
--Example 4: SQL VIEW to fetch records from multiple tables
--Example 5: SQL VIEW to fetch specific column
--Example 6: Use Sp_helptext to retrieve VIEW definition
--Example 7: sp_refreshview to update the Metadata of a SQL VIEW
--Example 8: Schema Binding a SQL VIEW

--_______________________________________________________________________________________________
--1.
CREATE VIEW [view_Emp_Details]
WITH SCHEMABINDING
AS(
	SELECT *
	FROM [dbo].[Emp]);

--Gives an error
--	Msg 1054, Level 15, State 6, Procedure view_Emp_Details, Line 4 [Batch Start Line 72]
--	Syntax '*' is not allowed in schema-bound objects.
--NOTE
--	We cannot call all columns (Select *) in a VIEW with SCHEMABINDING option. Let’s specify the columns in the following query and execute it again.

--_______________________________________________________________________________________________
--2.
--CREATE VIEW DemoView
--WITH SCHEMABINDING
--AS
--     SELECT TableID, ForeignID ,Value, CodeOne
--     FROM [AdventureWorks2017].[dbo].[MyTable];

CREATE VIEW [view_Emp_Details]
WITH SCHEMABINDING
AS
	(SELECT [Id],[Name],[Gender]
	FROM [TrainingDB].[dbo].[Emp]);

--We again get the following error message.
--	Msg 4512, Level 16, State 3, Procedure view_Emp_Details, Line 4 [Batch Start Line 93]
--	Cannot schema bind view 'view_Emp_Details' because name 'TrainingDB.dbo.Emp' is invalid 
--	for schema binding. Names must be in two-part format and an object cannot reference itself.


--In my query, I used a three-part object name in the format [DBName.Schema.Object]. We cannot use this format with SCHEMABINDING option in a VIEW. We can use the two-part name as per the following query.

--_______________________________________________________________________________________________
CREATE VIEW [view_Emp_Details]
WITH SCHEMABINDING
AS
	(SELECT [Id],[Name],[Gender]
	FROM [dbo].[Emp]);

--Once you have created a VIEW with SCHEMABINDING option, 
--try to add a modify a column data type using Alter table command.

ALTER TABLE [dbo].[Emp]
ALTER COLUMN [Id] BIGINT;

--Error mssg
--	Msg 5074, Level 16, State 1, Line 118
--	The object 'view_Emp_Details' is dependent on column 'Id'.
--	Msg 4922, Level 16, State 9, Line 118
--	ALTER TABLE ALTER COLUMN Id failed because one or more objects access this column.
--NOTE
--	We need to drop the VIEW definition itself along with other dependencies on that table before making a change to the existing table schema.

--_______________________________________________________________________________________________
--SQL VIEW ENCRYPTION
---------------------

--We can encrypt the VIEW using the WITH ENCRYPTION clause. 
--Previously, we checked users can see the view definition using the sp_helptext command. 
--If we do not want users to view the definition, we can encrypt it.

CREATE VIEW [view_Emp_Details]
WITH ENCRYPTION
AS
	(SELECT [Id],[Name],[Gender]
	FROM [dbo].[Emp]);


--Now if you run the sp_helptext command to view the definition, you get the following error message.

EXEC sp_helptext [view_Emp_Details]

--The text for the object ‘view_Emp_Details’ is encrypted.

--_______________________________________________________________________________________________
--SQL VIEW for DML (Update, Delete and Insert) queries
------------------------------------------------------
--We can use SQL VIEW to insert, update and delete data in a single SQL table. 
--We need to note the following things regarding this.
	-->	We can use DML operation on a single table only
	-->	VIEW should not contain Group By, Having, Distinct clauses
	-->	We cannot use a subquery in a VIEW in SQL Server
	-->	We cannot use Set operators in a SQL VIEW
--Insert into DemoView values(4,'CC','KK','RR')
--Delete from DemoView where TableID=7
--Update DemoView set value='Raj' where TableID=5

--_______________________________________________________________________________________________
--Example 10: Alter a SQL VIEW

--_______________________________________________________________________________________________
--Example 11: Drop SQL VIEW
--DROP VIEW demoview;
DROP VIEW [dbo].[view_Emp_Details];

--_______________________________________________________________________________________________
--Dept Table
------------
--	DeptId		DeptName
--	1			CS
--	2			Mech
--	3			EC
--	4			IS

--Emp table
-----------
--Id	Name	Salary 	Gender	DepartmentId
--1		Ramesh	5000	Male	3
--2		Suresh	3400	Male	2
--3		Sathish	6000	Female	1
--4		Doolu	4800	Male	4
--5		Boolu	3200	Female	1
--6		Rakesh	4800	Male	3

USE [TrainingDB];

SELECT * FROM [Emp]

CREATE VIEW [view_Emp_Details]
AS
	(SELECT *
	FROM [dbo].[Emp]);

DROP VIEW [view_Emp_Details];

CREATE VIEW [view_Dept_Details]
AS
	(SELECT *
	FROM [Dept]);

DROP VIEW [view_Dept_Details];

SELECT * FROM [view_Emp_Details]
SELECT * FROM [view_Dept_Details]


CREATE VIEW [view_Emp_Dept_Details]
AS
	(SELECT
		*
	FROM
		[view_Emp_Details] [E]
		INNER JOIN [view_Dept_Details] [D]
			ON [E].[DepartmentId]=[D].[DeptId]);

SELECT * FROM [view_Emp_Dept_Details];

DROP VIEW [view_Emp_Dept_Details];

--Resulting Table
-----------------
--Id	Name	Salary 	Gender	DeptName
--1		Ramesh	5000	Male	EC
--2		Suresh	3400	Male	Mech
--3		Sathish	6000	Female	CS
--4		Doolu	4800	Male	IS
--5		Boolu	3200	Female	CS
--6		Rakesh	4800	Male	EC

--_______________________________________________________________________________________________
--Advantages of View
--------------------
--1.	Views are used to reduce the Complexity of the database schema
--2.	Views can be used has a mechanism to Implement row and column level security
--3.	Views can be used to present Aggregated data and detailed data.

--_______________________________________________________________________________________________
--What is the Difference between Physical table and Virtual table I.e Views?

--1.	In physical tables we can see the data which is related to that prescribed table only.
--		In Views we can join more than one table to form the virtual table.

--2.	A VIEW does not require any storage in a database because it does not exist physically.
--		Physical tables Occupy space because they exists physically.

--3.	We can allow users to get the data from the VIEW
--		The user does not require permission for each table or column to fetch data
--_______________________________________________________________________________________________

--sp_refreshview
--	Used to update any alteration of base table in a view
EXEC sp_refreshview [view_Emp_Details]
EXEC sp_refreshview [view_Dept_Details]
EXEC sp_refreshview [view_Emp_Dept_Details]
--_______________________________________________________________________________________________
--sp_helptext 
--	Used to get the script of query of a particular view
EXEC sp_helptext [view_Emp_Details]
EXEC sp_helptext [view_Dept_Details]
EXEC sp_helptext [view_Emp_Dept_Details]
--_______________________________________________________________________________________________

CREATE DATABASE [StudentMarks];

USE [StudentMarks];

CREATE TABLE [StuDtl](
[StuId] INT,
[StuName] VARCHAR(50));

CREATE TABLE [SubDtl](
[SubId] INT,
[SubName] VARCHAR(50));

CREATE TABLE [MarkDtl](
[StuId] INT,
[SubId] INT,
[Marks] INT);

CREATE TABLE [GradeDtl](
[Lbound] INT,
[Ubound] INT,
[Grade] CHAR(1));

INSERT INTO [StuDtl]
VALUES
(1,'Prajwal'),
(2,'Pavithra'),
(3,'Manu'),
(4,'Vatsala');

INSERT INTO [SubDtl]
VALUES
(10,'MSSQL'),
(20,'POSTGRE_SQL');

INSERT INTO [MarkDtl]
VALUES
(1,10,80),
(2,10,60),
(3,20,70),
(4,20,40);

INSERT INTO [GradeDtl]
VALUES
(90,100,'A'),
(80,89,'B'),
(70,79,'C'),
(60,69,'D'),
(0,59,'F');

SELECT
	[StuName], [SubName], [Marks], [Grade]
FROM
	[StuDtl] [S]
	INNER JOIN [MarkDtl] [M]
		ON [S].[StuId]=[M].[StuId]
	INNER JOIN [SubDtl] [Sub]
		ON [Sub].[SubId]=[M].[SubId]
	INNER JOIN [GradeDtl] [G]
		ON [Marks] BETWEEN [Lbound] AND [Ubound];
