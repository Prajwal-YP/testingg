USE Payroll;

-- LIKE Operator

-- 1. Employee whose name starts with 'A'
SELECT *
FROM tblEmployee
WHERE EmployeeName LIKE 'A%';

-- 2. Employee whose name Second character is vowel
SELECT *
FROM tblEmployee
WHERE EmployeeName LIKE '_[aeiouAEIOU]%';

-- 3. Employee whose name is ending with 't'
SELECT *
FROM tblEmployee
WHERE EmployeeName LIKE '%l';

-- 4. Employee whose name consists the character 'y'
SELECT *
FROM tblEmployee
WHERE EmployeeName LIKE '%y';

-- 5. Employee whose name consists of 7 characters
SELECT *
FROM tblEmployee
WHERE EmployeeName LIKE '_______';


-- 6. Employee whose names first character is '^' or '%' or '_'
SELECT *
FROM tblEmployee
WHERE EmployeeName LIKE '[%^_]%';

---------------------------------------------------------------------

-- Alias
--	is a alternate name given to a column_name or expression
--	If the alias has space i should be in following:
--		1. single quotes
--		2. squarer brackets

-- Example 1
SELECT Salary*12 AS 'Annual Salary', Salary*0.5 AS [Hiked Salay] 
FROM tblEmployee;

----------------------------------------------------------------------------------

-- Concatenation Operator
--	Used to combine mutiple strings using the operator '+'

-- Example1
SELECT EmployeeName+Designation
FROM tblEmployee;

---------------------------------------------------------------------------
-- Between operator
--	To filter records based on the ange of values in WHERE clause

SELECT *
FROM tblEmployee
WHERE Salary BETWEEN 20000 AND 30000 OR Salary BETWEEN 40000 AND 50000;

---------------------------------------------------------------------------
-- DELETE Clause
--	This clause is used to delete the records from the table specifified in the FROM Clause
--	Here WHERE Clause can be used(Selective dete possible)
--	Before deleting the data will be stored in the log-data-files(ldf), Hence it is slow
--	Triggers can be used here
DELETE 
FROM tblEmployee
WHERE EmployeeID IN (1);

---------------------------------------------------------------------------
-- Truncate Clause
--	This clause is used to delete the records from the table specifified in the FROM Clause
--	Here WHERE Clause can be used(Selective dete possible)
--	Before deleting the data will be stored in the log-data-files(ldf), Hence it is slow
--	Triggers can be used here
CREATE TABLE yp(
NAME VARCHAR(5));

EXEC sp_columns yp;
EXEC sp_help tblEmployee;


INSERT INTO yp VALUES
('AC');

SELECT *
FROM yp;

TRUNCATE yp;
---------------------------------------------------------------------------
-- Update Clause
--	To modify data in a relation(table)

update tblEmployee
SET EmployeeName='^Akash'
WHERE EmployeeID=1008;

----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- String Functions

--LEFT
--
SELECT LEFT('Excelsoft',5);
-- Output: Excel

----------------------------------------------------------------------------
-- RIGHT


-- CHARINDEX
--	used to search a specific string in a givin string
--		-> if the search-string is not present in the original stringm it retuen 0
--		-> else uf the search-string is present it return the starting index 
--		of search-sting in the original-string

SELECT CHARINDEX('SOFT','EXCELSOFT');
-- Output is 6

SELECT CHARINDEX('yp','EXCELSOFT');
-- Output is 0

----------------------------------------------------------------------------
-- LEN Function
--	Used to find the total number of characteers in a given strings

SELECT LEN('Prajwal Y P')
-- Output: 11
SELECT LEN('')
-- Output: 0

----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Date Function

-- 1. GETDATE

-- Ex.1	
SELECT GETDATE()
-- O/p: 2023-10-19 11:48:39.137

--DATEPART
-- 
-- Ex.1	
SELECT DATEPART(YEAR,GETDATE())
SELECT DATEPART(YYYY,GETDATE())
SELECT DATEPART(YY,GETDATE())

-- Ex.2
SELECT DATEPART(MONTH,GETDATE())
SELECT DATEPART(MM,GETDATE())
SELECT DATEPART(M,GETDATE())
-- O/p: 10

-- Ex.3 day
SELECT DATEPART(DAY,GETDATE())
SELECT DATEPART(dd,GETDATE())

-- Ex.4 // Day of the year
SELECT DATEPART(DY,GETDATE())
SELECT DATEPART(Y,GETDATE())
-- O/p: 10

-- DATEADD
-- 
SELECT DATEADD(dw,2, GETDATE())

-- DATEDIFF
SELECT DATEDIFF(DD,'2023-10-18','2023-10-19')
-- O/P: 1

------------------------------------------------------------------------------
------------------------------------------------------------------------------

-- CONSTRAINTS
--	It is a set of rules specified on columns/attributes for the validation of data.
--	There are 5 types of constraints. They are as follows:
--		1. UNIQUE
--		2. NOT NULL
--		3. CHECK
--		4. PRIMARY KEY
--		5. FOREIGN KEY

------------------------------------------------------------------------------
-- 1. UNIQUE
--	This constraint is used to avoid the duplicate/redundant values in a column
--	Example
	DROP TABLE emp;
--
	CREATE TABLE emp(
	Id INT UNIQUE,
	LastName VARCHAR(50),
	FirstName VARCHAR(50),
	Age INT);
--
	INSERT INTO emp VALUES
	(NULL,'L1','F1',25),
	(NULL,'L2','F2',25);
--	Error: "Violation of UNIQUE KEY constraint 'UQ__emp__3214EC061C1DF331'. Cannot insert duplicate key in object 'dbo.emp'."
--	Every column which has unique constraint has a constraint name known as Key
--	Here in our example Key is 'UQ__emp__3214EC061C1DF331'.
--	We can also give our own name to a contraint.

--	Example to give key name for unique key constraint
	DROP TABLE emp;

	CREATE TABLE emp(
	Id INT,
	LastName VARCHAR(50) UNIQUE,
	FirstName VARCHAR(50),
	Age INT
	CONSTRAINT UC_Id UNIQUE(Id));
--
	INSERT INTO emp VALUES
	(1,'L1','F1',25),
	(2,'L1','F2',25);
--	Error: Violation of UNIQUE KEY constraint 'UQ__emp__7449F3999A8ACFAC'. Cannot insert duplicate key in object 'dbo.emp'
--	combination of unique keys
	DROP TABLE emp;

	CREATE TABLE emp(
	Id INT,
	LastName VARCHAR(50),
	FirstName VARCHAR(50),
	Age INT
	CONSTRAINT UC_Id UNIQUE(Id,LastName));
--
	INSERT INTO emp VALUES
	(1,'L1','F1',25),
	(1,'L1','F2',25);
--	Error: Violation of UNIQUE KEY constraint 'UC_Id'. Cannot insert duplicate key in object 'dbo.emp'.
	
------------------------------------------------------------------------------
--	2. NOT NULL
--	This constraint is used to avoid NULL values in a column.
--	It is assiged to a column where the data is mandatory.
--	By default the column data has NULL as                                        
--	Example
	DROP TABLE emp;

	CREATE TABLE emp(
	Id INT NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	FirstName VARCHAR(50),
	Age INT);
--
	INSERT INTO emp VALUES
	(1,NULL,'F1',25);
--	Error: Cannot insert the value NULL into column 'LastName', table 'Payroll.dbo.emp'; column does not allow nulls. INSERT fails.

------------------------------------------------------------------------------
--	3. CHECK
--	Extra validation assigned to columns with some conditions
--	If check-condition is true, data will get inserted to the table else will get an error
--	Example:
--	
	DROP TABLE emp;

	CREATE TABLE emp(
	Id INT,
	LastName VARCHAR(50),
	FirstName VARCHAR(50),
	Age INT,
	Loc	VARCHAR(50),
	CHECK(Age>=2),
	CONSTRAINT CK_Age CHECK(Age>=18 AND Loc IN ('Mysore')));
--
	INSERT INTO emp VALUES
	(1,'L1','F1',25,'Banglore');
--	Error: The INSERT statement conflicted with the CHECK constraint "CK_Age". The conflict occurred in database "Payroll", table "dbo.emp".

------------------------------------------------------------------------------
------------------------------------------------------------------------------

-- Primary Key
--	
SELECT *
FROM tblEmployee
ORDER BY EmployeeName
;