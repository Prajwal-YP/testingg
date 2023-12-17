--	1. What are types of Variables and mention the difference between them
--	There are 2 types of variables. There are as follows:
--		1. Local Variables
--		2. Global variables
--	 -----------------------------------------------------------------------------------------------------------------
--	|LOCAL VARIABLES											| GLOBAL VARABLES										  |
--	|---------------------------------------------------------------------------------------------------------------------|
--	|Denoted using @											| Denoted using @@										  |
--	|---------------------------------------------------------------------------------------------------------------------|
--	|Scope of this variable is available to all the session		| Scope of this variable is available to only one session |
--	 -----------------------------------------------------------------------------------------------------------------
--_____________________________________________________________________________________________________________________________
--2. Declare a variable with name [SQLData] which can store a string datatype 
--	and assign a value to using SELECT option and specify an alias name for the same

--Declaring the variable [SQLData] of string datatype
	DECLARE @SQLData VARCHAR(50);
--Assigning a value to the variable [SQLData] 
SELECT @SQLData='Prajwal'  
--Specifying the alias name as "SQL String Data"
SELECT @SQLData AS [SQL String Data]

--_____________________________________________________________________________________________________________________________
--3. What is used to define a SQL variable to put a value in a variable?
--	a. SET @id = 6;
--	b. SET id = 6;
--	c. Id = 6;
--	d. SET #id = 6;
--Select the correct option
--								a.

--_____________________________________________________________________________________________________________________________
--4. Compare Local and Global Temporary tables with an Example

-- -----------------------------------------------------------------
--|	Table variables (DECLARE @t TABLE) 								|
--|		are visible only to the connection that creates it, 		|
--|		and are deleted when the batch or stored procedure ends.	|
--|																	|
--|	Local temporary tables (CREATE TABLE #t) 						|
--|		are visible only to the connection that creates it, 		|
--|		and are deleted when the connection is closed.				|
--|																	|
--|	Global temporary tables (CREATE TABLE ##t) 						|
--|		are visible to everyone, and are deleted when 				|
--|		all connections that have referenced them have closed.		|
--|																	|
--|	Tempdb permanent tables (USE tempdb CREATE TABLE t) 			|
--|		are visible to everyone, and are deleted 					|
--|		when the server is restarted.								|
-- -----------------------------------------------------------------

--In SSMS, for each query page we have made a connection to our database engine.
--This connection have unique id for that session 
--Example:		filename- srevername.master(sa(52))

-- We create Local Temporary Table named #HAHA, in Session sa(52)
	CREATE TABLE #HAHA(
	ID INT,
	NAME VARCHAR(50));
-- We can successfully access this table only in query page with connnection ID sa(52)
-- We can not access this table in query page with connnection ID other than sa(52), say sa(53)
SELECT * FROM [#HAHA]

-- We create Global Temporary Table named ##HAHA, in Session sa(52)
CREATE TABLE ##HAHA1(
ID INT,
NAME VARCHAR(50));

-- We can successfully access this table in any query page with or without connnection ID sa(52)
SELECT * FROM [##HAHA1]

--These temporary table will be droped automatically as soon as the connection that created it gets closed

--_____________________________________________________________________________________________________________________________
--5. Create a table with an IDENTITY column whose Seed value is 2 and Increment value of 100
--CREATE TABLE [tester](
--ID INT IDENTITY(2,100),
--NAME VARCHAR(50) DEFAULT 'NA',
--LOCATION VARCHAR(50));

--INSERT INTO [tester] VALUES ('Prajwal','Loc-1');
--INSERT INTO [tester](Location) VALUES ('Loc-2');
--INSERT INTO [tester](Location) VALUES ('Loc-3');

--OUTPUT:

--ID		NAME		LOCATION
--2			Prajwal		Loc-1
--102		NA			Loc-2
--202		NA			Loc-3

--_____________________________________________________________________________________________________________________________
--6. What is the difference between SCOPE_IDENTITY() and @@IDENTITY. Explain with an Example.

SELECT SCOPE_IDENTITY()
SELECT @@IDENTITY 

--_____________________________________________________________________________________________________________________________
--7.	
----Assignment Questions
CREATE DATABASE [TrainingDB]
USE [TrainingDB];

CREATE TABLE tblProject
(
   ProjectId BIGINT PRIMARY KEY,
   Name VARCHAR(100) NOT NULL,
   Code NVARCHAR(50) NOT NULL,
   ExamYear SMALLINT NOT NULL
);


CREATE TABLE tblExamCentre 
(
  ExamCentreId BIGINT PRIMARY KEY,
  Code VARCHAR(100) NULL,
  Name VARCHAR(100)  NULL
);

CREATE TABLE tblProjectExamCentre
(
   ProjectExamCentreId BIGINT PRIMARY KEY,
   ExamCentreId BIGINT NOT NULL FOREIGN KEY REFERENCES tblExamCentre(ExamCentreId),
   ProjectId BIGINT FOREIGN KEY REFERENCES tblProject(ProjectId)
);

INSERT INTO tblProject(ProjectId,Name,Code,ExamYear) VALUES
(1,	'8808-01-CW-YE-GCEA-2022',	'PJ0001',	2022),
(2,	'6128-02-CW-YE-GCENT-2022',	'PJ0002',	2022),
(3, '7055-02-CW-YE-GCENA-2022','PJ0003',	2022),
(4,	'8882-01-CW-YE-GCEA-2022','	PJ0004',	2022),
(5,'7062-02-CW-YE-GCENT-2022',	'PJ0005',	2022),
(8,	'6128-02-CW-YE-GCENT-1000',	'PJ0008',	1000),
(9,	'7062-02-CW-YE-GCENT-5000',	'PJ0009',	5000),
(10,'8808-01-CW-YE-GCEA-2023',	'PJ0010',	2023),
(11,'8808-01-CW-YE-GCEA-2196',	'PJ0011',	2196),
(15,'6073-02-CW-YE-GCENA-2022',	'PJ0015',	2022),
(16,'8808-01-CW-YE-GCE0-2022',	'PJ0016',	2022);


INSERT INTO tblExamCentre(ExamCentreId,Name,Code) VALUES
(112,'VICTORIA SCHOOL-GCENA-S','2711'),
(185,'NORTHBROOKS SECONDARY SCHOOL-GCENA-S','2746'),
(227,'YIO CHU KANG SECONDARY SCHOOL-GCENA-S','2721'),
(302,'CATHOLIC JUNIOR COLLEGE','9066'),
(303,'ANGLO-CHINESE JUNIOR COLLEGE','9067'),
(304,'ST. ANDREW''S JUNIOR COLLEGE','9068'),
(305,'NANYANG JUNIOR COLLEGE','9069'),
(306,'HWA CHONG INSTITUTION','9070'),
(1,NULL,'2011'),
(2,'NORTHBROOKS SECONDARY SCHOOL-GCENA-S',NULL);


INSERT INTO tblProjectExamCentre(ProjectExamCentreId,ProjectId,ExamCentreId) VALUES
(44,1,112),
(45,1,227),
(46,1,185),
(47,2,112),
(48,2,227),
(49,2,185),
(50,3,112),
(51,3,227),
(52,3,185),
(69,4,112);

select * from tblProject
select * from tblExamCentre
select * from tblProjectExamCentre



--1.Write a procedure to fetch the ProjectId, ProjectName, ProjectCode, ExamCentreName and ExamCentreCode 
--	from the tables tblProject and tblExamCentre based on the 
--	ProjectId and ExamCentreId passed as input parameters.

CREATE PROCEDURE [usp_fetch_projects](
	@ProjectId BIGINT,
	@ExamcenterId BIGINT)
AS
BEGIN
	SELECT
		[P].[ProjectId], 
		[P].[Name] AS [Project Name],
		[P].[Code] AS [Project Code]
	FROM
		[tblProject] [P]
	WHERE
		[P].[ProjectId] IN (@ProjectId)
	
	SELECT
		[E].[Name] AS [Exam Centre Name],
		[E].[Code] AS [Exam Centre Code]
	FROM
		[tblExamCentre] [E]
	WHERE
		[E].[ExamCentreId] IN (@ExamcenterId)
END

EXECUTE [usp_fetch_projects] @ProjectID=1, @ExamCenterId=112
	--SELECT
	--	[P].[ProjectId], 
	--	[P].[Name] AS [Project Name], 
	--	[P].[Code] AS [Project Code],
	--	[E].[Name] AS [Exam Centre Name], 
	--	[E].[Code] AS [Exam Centre Code]
	--FROM 
	--	[tblProject] [P]
	--	INNER JOIN [tblProjectExamCentre] [PE]
	--		ON [P].[ProjectId]=[PE].[ProjectId]
	--	INNER JOIN [tblExamCentre] [E]
	--		ON [PE].[ExamCentreId]=[E].[ExamCentreId]

--____________________________________________________________________________________________________________________
--2.Write a procedure to insert values into the table tblProject when the data for the ProjectId 
--which is being inserted does not exist in the table.
CREATE PROCEDURE [usp_add_project](
	@ProjectId BIGINT,
	@Name VARCHAR(100),
	@Code NVARCHAR(50),
	@ExamYear SMALLINT)
AS
BEGIN
	DECLARE @IsPresent BIT = 0;
	
	SELECT 
		@IsPresent=1
	FROM 
		[tblProject] 
	WHERE
		[ProjectId] IN (@ProjectId);

	IF @IsPresent=0
	BEGIN
		INSERT INTO [tblProject] ([ProjectId],[Name],[Code],[ExamYear])
		VALUES
		(@ProjectId,@Name,@Code,@ExamYear);
	END
END

--____________________________________________________________________________________________________________________
--3.Write a procedure to update the columns-Code and Name in tblExamCentre when 
--either of the Code or the Name column is NULL and also delete the records 
--from the table tblProjectExamCentre when ProjectId IS 4.
CREATE PROCEDURE [usp_update_exam_projectExam]
AS
BEGIN
	UPDATE
		[tblExamCentre]
	SET
		[Name]='Mysore University College',
		[Code]='2100'
	WHERE
		[Name] IS NULL
		OR
		[Code] IS NULL;

	DELETE FROM
		[tblProjectExamCentre]
	WHERE
		[ProjectId] IN (12);
END

EXECUTE [usp_update_exam_projectExam]

--____________________________________________________________________________________________________________________
--4.Write a procedure to fetch the total count of records present in 
--the table tblProject based on the ProjectId AS OUTPUT parameter and 
--also sort the records in ascending order based on the ProjectName.
CREATE PROCEDURE [usp_project_count](
	@count INT OUTPUT)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		@count= COUNT([ProjectId])
	FROM
		[tblProject]

	SELECT 
		*
	FROM
		[tblProject]
	ORDER BY 
		[Name];
END

DECLARE @Num INT;
EXECUTE [usp_project_count] @COUNT=@Num OUTPUT
PRINT 'Total number os rows in tblProject: '+ CAST(@NUM AS VARCHAR)
--____________________________________________________________________________________________________________________
--5.Write a procedure to create a Temp table named Students with columns- 
--StudentId,StudentName and Marks where the column StudentId is generated 
--automatically and insert data into the table and also retrieve the data.
CREATE PROCEDURE [usp_temp_table_test]
AS
BEGIN
	CREATE TABLE [#tblStudent](
		[StudentId] INT PRIMARY KEY IDENTITY(101,1),
		[StudentName] VARCHAR(50) NOT NULL,
		[Marks] INT NOT NULL);

	INSERT INTO [#tblStudent]([StudentName], [Marks])
	VALUES
	('Ram',90),
	('Raj',69),
	('Rajamma',38),
	('Ramamani',98);

	SELECT 
		* 
	FROM 
		[#tblStudent]
END

EXECUTE [usp_temp_table_test]

--____________________________________________________________________________________________________________________
--6.Write a procedure to perform the following DML operations on the column - 
--	ProjectName in tblProject table by using a varibale. 
--Declare a local variable and initialize it to value 0, 
--1. When the value of the variable is equal to 2, then insert another record into the table tblProject.
--2. When the value of the variable is equal to 10, then change the ProjectName to 'Project_New' for input @ProjectId

--In the next part of the stored procedure, return all the fields of the table tblProject(ProjectId,ProjectName,Code and Examyear)
--based on the ProjectId and for the column ExamYear display it as given using CASE statement.
--1.If the ExamYear is greater than or equal to 2022 then display 'New'
--2.If the ExamYear is lesser than or equal to 2022 then display 'Old'
CREATE PROCEDURE [usp_projects_ExamDate](
	@Var INT,
	@ProjectID BIGINT,
	@Name VARCHAR(100)='NA',
	@CODE NVARCHAR(50)='NA',
	@ExamYear SMALLINT=-1,
	@OpProjectID BIGINT OUTPUT,
	@OpName VARCHAR(100) OUTPUT,
	@OpCODE NVARCHAR(50) OUTPUT,
	@OpExamYear VARCHAR(5) OUTPUT)
AS
BEGIN
	IF @Var=2
	BEGIN
		INSERT INTO [tblProject]([ProjectId], [Name], [Code], [ExamYear])
		VALUES
		(@ProjectID, @Name, @CODE, @ExamYear);
	END

	IF @Var=10
	BEGIN
		UPDATE 
			[tblProject]
		SET
			[Name] = @Name
		WHERE
			[ProjectId] IN (@ProjectID);
	END

	SELECT 
		@OpProjectID = [ProjectId],
		@OpName = [Name],
		@OpCODE = [Code],
		@OpExamYear = (
			CASE
				WHEN [ExamYear]>=2022
					THEN 'NEW'
				ELSE
					'OLD'
			END)
	FROM
		[tblProject]
	WHERE
		[ProjectId] IN (@ProjectID);
END


DECLARE @OpProjectID BIGINT, @OpName VARCHAR(100), @OpCODE NVARCHAR(50), @OpExamYear VARCHAR(5);


EXECUTE [usp_projects_ExamDate] @Var=10,@ProjectId=8,@Name='6128-02-CW-YE-GCENT-1000',@OpProjectID=@OpProjectID OUTPUT, @OpName=@OpName OUTPUT, @OpCODE = @OpCODE OUTPUT, @OpExamYear=@OpExamYear OUTPUT

PRINT @OpProjectID
PRINT @OpName
PRINT @OpCODE
PRINT @OpExamYear
PRINT 'Completed'

--____________________________________________________________________________________________________________________