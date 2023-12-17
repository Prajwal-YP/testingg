--u1

BEGIN TRAN
SELECT * FROM [tblEmployee]
WHERE [EmployeeId] BETWEEN 1000 AND 1005
SELECT * FROM [tblEmployee]

UPDATE [tblEmployee]
SET [Salary]=26000
WHERE [EmployeeId] IN (1003);
ROLLBACK

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

DBCC useroptions 
------------------------------------------------------------------------------------------------
--u2

UPDATE [tblEmployee]
SET [Salary]=16000
WHERE [EmployeeId] IN (1003);

SELECT * FROM [tblEmployee]
WHERE [EmployeeId] BETWEEN 1000 AND 1005

INSERT INTO [tblEmployee]
VALUES
(1013,	'Ragho',	'Business Analysts'	,'2022-02-01 00:00:00.000',	'Ragu@excelindia.com',	16000,	20);

DELETE [tblEmployee]
WHERE [EmployeeId] IN (1013)
------------------------------------------------------------------------------------------------
EXEC sp_helpindex [a]
EXEC sp_spaceused [tblEmployee]

CREATE TABLE [a](
id int UNIQUE,
name nvarchar(50));

INSERT INTO [a]
VALUES
(2,'yp2'),(1,'yp1');

SELECT * FROM [a];
CREATE NONCLUSTERED INDEX
	[Ixone]
ON
	[a]([id]);
------------------------------------------------------------------------------------------------
SELECT * FROM [tblEmployee]

------------------------------------------------------------------------------------------------
SELECT 
	* 
FROM 
	[tblEmployee]
ORDER BY
	[EmployeeId]
OFFSET 
	0 ROWS
FETCH FIRST 
	5 ROWS ONLY
------------------------------------------------------------------------------------------------
DECLARE cr_a CURSOR FOR (SELECT * FROM [tblEmployee])
OPEN cr_a

DECLARE 
	@EmployeeId INT, 
	@EmployeeName VARCHAR(50), 
	@Designation VARCHAR(50), 
	@JoiningDate DATETIME, 
	@EmailId VARCHAR(50), 
	@Salary MONEY, 
	@DepartmentId INT;

FETCH NEXT FROM cr_a INTO @EmployeeId, @EmployeeName, @Designation, @JoiningDate, @EmailId, @Salary, @DepartmentId

PRINT @EmployeeId
PRINT @EmployeeName
PRINT @Designation
PRINT @JoiningDate
PRINT @EmailId
PRINT @Salary
PRINT @DepartmentId


CLOSE cr_a
DEALLOCATE cr_a
