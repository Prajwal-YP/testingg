--Triggers

--In general, a trigger is a special kind of stored procedure 
--that automatically executes when an event occurs in the database server.


--3 Types of Events

--1.	DML Triggers
--2.	DDL Triggers
--3.	Logon triggers

--____________________________________________________________________________________________________________________________________
--1.	DML Triggers -- INSERT,UPDATE,DELETE

--DML stands for Data Manipulation Language. INSERT, UPDATE, and DELETE statements are DML statements. 
--DML triggers are fired, when ever data is modified using INSERT, UPDATE, and DELETE events.

--DML triggers can be again classified into 2 types.
--1. After triggers (Sometimes called as FOR triggers)
--2. Instead of triggers

--____________________________________________________________________________________________________________________________________
--	After triggers, as the name says, fires after the triggering action. 
--	The INSERT, UPDATE, and DELETE statements, causes an after trigger to fire after the respective statements complete execution.

--	On other hand, as the name says, INSTEAD of triggers, fires instead of the triggering action. 
--	The INSERT, UPDATE, and DELETE statements, can cause an INSTEAD OF trigger to fire INSTEAD OF the respective statement execution.

--____________________________________________________________________________________________________________________________________
--We will use Employee and tblEmployeeAudit tables for our examples

--Emp table
-----------
--Id	Name	Salary 	Gender	DepartmentId
--1		Ramesh	5000	Male	3
--2		Suresh	3400	Male	2
--3		Sathish	6000	Female	1
--4		Doolu	4800	Male	4
--5		Boolu	3200	Female	1
--6		Rakesh	4800	Male	3

 
--SQL Script to create tblEmployeeAudit table:
CREATE TABLE tblEmployeeAudit
(
 Id int identity(1,1) primary key,
 AuditData nvarchar(1000)
)

--____________________________________________________________________________________________________________________________________
--	When ever, a new Employee is added, we want to capture the ID and the date and time, the new employee is added in tblEmployeeAudit table. 
--	The easiest way to achieve this, is by having an AFTER TRIGGER for INSERT event.



-- Example for AFTER TRIGGER for INSERT event on tblEmployee table:
CREATE TRIGGER tr_tblEMployee_ForInsert
ON tblEmployee
FOR INSERT
AS
BEGIN
	Declare @Id int
	Select @Id = Id from inserted

	insert into tblEmployeeAudit 
	values('New employee with Id  = ' + Cast(@Id as nvarchar(5)) + ' is added at 	' + cast(Getdate() as nvarchar(20)))
END

--____________________________________________________________________________________________________________________________________
--	In the trigger, we are getting the id from inserted table. So, what is this inserted table? 

--	INSERTED table, is a special table used by DML triggers. When you add a new row into tblEmployee table, 
--	a copy of the row will also be made into inserted table, which only a trigger can access. 

--	You cannot access this table outside the context of the trigger. 

--	The structure of the inserted table will be identical to the structure of tblEmployee table.


--	So, now if we execute the following INSERT statement on tblEmployee. 
--	Immediately, after inserting the row into tblEmployee table, the trigger 
--	gets fired (executed automatically), and a row into tblEmployeeAudit, is also inserted.


Insert into Emp values (7,'Tan', 2300, 'Female', 3)
--____________________________________________________________________________________________________________________________________
--Along, the same lines, let us now capture audit information, when a row is deleted from the table, tblEmployee.



--Example for AFTER TRIGGER for DELETE event on tblEmployee table:
CREATE TRIGGER tr_tblEMployee_ForDelete
ON tblEmployee
FOR DELETE
AS
BEGIN
Declare @Id int
Select @Id = Id from deleted

insert into tblEmployeeAudit 
values('An existing employee with Id  = ' + Cast(@Id as nvarchar(5)) + ' is deleted at ' + Cast(Getdate() as nvarchar(20)))
END



--The only difference here is that, we are specifying, the triggering event as DELETE and retrieving the deleted row ID from DELETED table. 
--DELETED table, is a special table used by DML triggers. 

--When you delete a row from tblEmployee table, a copy of the deleted row will be made available in DELETED table, 
--which only a trigger can access. Just like INSERTED table, DELETED table cannot be accessed, outside the context of the trigger and, 
--the structure of the DELETED table will be identical to the structure of tblEmployee table.

--==============================================================
--UPDATE Triggers
-------------------------

--Triggers make use of 2 special tables, INSERTED and DELETED. 
--The inserted table contains the updated data and the deleted table contains the old data. 
--The After trigger for UPDATE event, makes use of both inserted and deleted tables. 


Create AFTER UPDATE trigger script:
Create trigger tr_tblEmployee_ForUpdate
on tblEmployee
for Update
as
Begin
Select * from deleted
Select * from inserted 
End


--Now, execute this query:
Update tblEmployee set Name = 'Tods', Salary = 2000, 
Gender = 'Female' where Id = 4


--	Immediately after the UPDATE statement execution, the AFTER UPDATE trigger gets fired, 
--	and you should see the contenets of INSERTED and DELETED tables.


--The following AFTER UPDATE trigger, audits employee information upon UPDATE, and stores the audit data in tblEmployeeAudit table.
Alter trigger tr_tblEmployee_ForUpdate
on tblEmployee
for Update
as
Begin
      -- Declare variables to hold old and updated data
      Declare @Id int
      Declare @OldName nvarchar(20), @NewName nvarchar(20)
      Declare @OldSalary int, @NewSalary int
      Declare @OldGender nvarchar(20), @NewGender nvarchar(20)
      Declare @OldDeptId int, @NewDeptId int
     
      -- Variable to build the audit string
      Declare @AuditString nvarchar(1000)
      
      -- Load the updated records into temporary table
      Select *
      into #TempTable
      from inserted
     
      -- Loop thru the records in temp table
      While(Exists(Select Id from #TempTable))
      Begin
            --Initialize the audit string to empty string
            Set @AuditString = ''
           
            -- Select first row data from temp table
            Select Top 1 @Id = Id, @NewName = Name, 
            @NewGender = Gender, @NewSalary = Salary,
            @NewDeptId = DepartmentId
            from #TempTable
           
            -- Select the corresponding row from deleted table
            Select @OldName = Name, @OldGender = Gender, 
            @OldSalary = Salary, @OldDeptId = DepartmentId
            from deleted where Id = @Id

    -- Build the audit string dynamically           
            Set @AuditString = 'Employee with Id = ' + Cast(@Id as nvarchar(4)) + ' changed'
            if(@OldName <> @NewName)
                  Set @AuditString = @AuditString + ' NAME from ' + @OldName + ' to ' + @NewName
                 
            if(@OldGender <> @NewGender)
                  Set @AuditString = @AuditString + ' GENDER from ' + @OldGender + ' to ' + @NewGender
                 
            if(@OldSalary <> @NewSalary)
                  Set @AuditString = @AuditString + ' SALARY from ' + Cast(@OldSalary as nvarchar(10))+ ' to ' + Cast(@NewSalary as nvarchar(10))
                  
    if(@OldDeptId <> @NewDeptId)
                  Set @AuditString = @AuditString + ' DepartmentId from ' + Cast(@OldDeptId as nvarchar(10))+ ' to ' + Cast(@NewDeptId as nvarchar(10))
           
            insert into tblEmployeeAudit values(@AuditString)
            
            -- Delete the row from temp table, so we can move to the next row
            Delete from #TempTable where Id = @Id
      End
End
--__________________________________________________________________________________________________________________________________________________________________

USE [Payroll];

CREATE TABLE [tblEmployeeDt1_Log](
[EmployeeId] INT IDENTITY,
[Message] NVARCHAR(1000));

ALTER TRIGGER [tr_tblEmployeeDtl_ins_del_upd]
	ON [tblEmployeeDt1]
	FOR INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE 
		@IsInserted BIT	= 0,
		@IsDeleted BIT	= 0,
		@String NVARCHAR(1000),
		@Id INT, 
		@Name VARCHAR(50),
		@Designation VARCHAR(50),
		@JoinDate DATE,
		@Email VARCHAR(50),
		@Salary MONEY,
		@EmpLoc VARCHAR(50),
		@DeptId INT,
		@NewName VARCHAR(50),
		@NewDesignation VARCHAR(50),
		@NewJoinDate DATE,
		@NewEmail VARCHAR(50),
		@NewSalary MONEY,
		@NewEmpLoc VARCHAR(50),
		@NewDeptId INT;


	SELECT * INTO [#INSERTED]
	FROM [INSERTED];
	
	SELECT * INTO [#DELETED]
	FROM [DELETED];

	SELECT @IsInserted=1 WHERE EXISTS(SELECT * FROM [#INSERTED]);
	SELECT @IsDeleted=1 WHERE EXISTS(SELECT * FROM [#DELETED]);
	
	-- For INSERT
	IF @IsInserted=1 AND @IsDeleted=0
	BEGIN 
		WHILE(EXISTS(SELECT * FROM [#INSERTED]))
		BEGIN

			SELECT @Id=[EmployeeId], @Name=[EmployeeName]
			FROM [#INSERTED]

			SET @String = 'An New employee '''+@Name+''' with ID = '+CAST(@Id AS VARCHAR)+' was added at '+CAST(GETDATE() AS VARCHAR);

			DELETE FROM [#INSERTED]
			WHERE [EmployeeId] IN (@Id);

			INSERT INTO [tblEmployeeDt1_Log]([Message])
			VALUES
			(@string);
		END
	END
	
	-- For DELETE
	IF @IsInserted=0 AND @IsDeleted=1
	BEGIN 
		WHILE(EXISTS(SELECT * FROM [#DELETED]))
		BEGIN

			SELECT TOP 1 @Id=[EmployeeId], @Name=[EmployeeName]
			FROM [#DELETED]

			SET @String = 'An Existing employee '''+@Name+''' with ID = '+CAST(@Id AS VARCHAR)+' was removed at '+CAST(GETDATE() AS VARCHAR);

			DELETE FROM [#DELETED]
			WHERE [EmployeeId] IN (@Id);

			INSERT INTO [tblEmployeeDt1_Log]([Message])
			VALUES
			(@string);
		END
	END

	-- For UPDATE
	IF @IsInserted=1 AND @IsDeleted=1
	BEGIN
		WHILE(EXISTS(SELECT * FROM [#DELETED]))
		BEGIN

			SELECT TOP 1 
				@Id=[EmployeeId], 
				@Name=[EmployeeName],
				@Designation = [Designation],
				@JoinDate =[JoinedDate],
				@Email =[EmailId],
				@Salary =[Salary],
				@EmpLoc =[EmployeeLocation],
				@DeptId =[DepartmentId]
			FROM [#DELETED]
			ORDER BY [EmployeeId];

			SELECT TOP 1 
				@NewName=[EmployeeName],
				@NewDesignation = [Designation],
				@NewJoinDate =[JoinedDate],
				@NewEmail =[EmailId],
				@NewSalary =[Salary],
				@NewEmpLoc =[EmployeeLocation],
				@NewDeptId =[DepartmentId]
			FROM [#INSERTED]
			ORDER BY [EmployeeId];

			SET @String = 'An Existing employee '''+@Name+''' with ID = '+CAST(@Id AS VARCHAR)+' has changed, ';

			IF @Name <> @NewName
				SET @String += ', Name ('+@Name+' to '+@NewName+')';

			IF @Designation <> @NewDesignation
				SET @String += ', Designation ('+@Designation+' to '+@NewDesignation+')';

			IF @JoinDate <> @NewJoinDate
				SET @String += ', JoinDate ('+CAST(@JoinDate AS VARCHAR)+' to '+CAST(@NewJoinDate AS VARCHAR)+')';

			IF @Email <> @NewEmail
				SET @String += ', Email ('+@Email+' to '+@NewEmail+')';

			IF @Salary <> @NewSalary
				SET @String += ', Salary ('+CAST(@Salary AS VARCHAR)+' to '+CAST(@NewSalary AS VARCHAR)+')';

			IF @EmpLoc <> @NewEmpLoc
				SET @String += ', Location ('+@EmpLoc+' to '+@NewEmpLoc+')';

			IF @DeptId <> @NewDeptId
				SET @String += ', Dept. Id ('+CAST(@DeptId AS VARCHAR)+' to '+CAST(@NewDeptId AS VARCHAR)+')';

			DELETE FROM [#DELETED]
			WHERE [EmployeeId] IN (@Id);

			DELETE FROM [#INSERTED]
			WHERE [EmployeeId] IN (@Id);

			INSERT INTO [tblEmployeeDt1_Log]([Message])
			VALUES
			(@string);
		END
	END
END

DELETE [tblEmployeeDt1]
WHERE [EmployeeId] IN (110)

INSERT INTO [tblEmployeeDt1]
VALUES
(110, 'Preetham', 'Database Developer', '2023-01-11','Preetham.4@excelindia.com',46000.0000,'Mysuru',20)


UPDATE
	[tblEmployeeDt1]
SET
	[EmployeeName]='Krishna',
	[Designation]='Database Co Engineer',
	[Salary]=55000
WHERE
	[EmployeeId] IN (1001);
SELECT * FROM [tblEmployeeDt1]
SELECT * FROM [tblEmployeeDt1_Log]