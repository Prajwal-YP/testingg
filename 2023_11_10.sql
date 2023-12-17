--INSTEAD OF triggers, specifically INSTEAD OF INSERT trigger. 
--We know that, AFTER triggers are fired after the triggering event(INSERT, UPDATE or DELETE events), 
--where as, INSTEAD OF triggers are fired instead of the triggering event(INSERT, UPDATE or DELETE events). 
--In general, INSTEAD OF triggers are usually used to correctly update views that are based on multiple tables. 


--If not created please use the script to create tables
CREATE TABLE tblEmployee
(
 Id int Primary Key,
 Name nvarchar(30),
 Gender nvarchar(10),
 DepartmentId int
)

CREATE TABLE tblDepartment
(
DeptId int Primary Key,
DeptName nvarchar(20)
)

--Insert data into tblDepartment table
Insert into tblDepartment values (1,'IT')
Insert into tblDepartment values (2,'Payroll')
Insert into tblDepartment values (3,'HR')
Insert into tblDepartment values (4,'Admin')

--Insert data into tblEmployee table
Insert into tblEmployee values (1,'John', 'Male', 3)
Insert into tblEmployee values (2,'Mike', 'Male', 2)
Insert into tblEmployee values (3,'Pam', 'Female', 1)
Insert into tblEmployee values (4,'Todd', 'Male', 4)
Insert into tblEmployee values (5,'Sara', 'Female', 1)
Insert into tblEmployee values (6,'Ben', 'Male', 3)


--Since, we now have the required tables, let's create a view based on these tables. 
--The view should return Employee Id, Name, Gender and DepartmentName columns. 
--So, the view is obviously based on multiple tables.


--Script to create the view:
Create view vWEmployeeDetails
as
Select Id, Name, Gender, DeptName
from tblEmployee 
join tblDepartment
on tblEmployee.DepartmentId = tblDepartment.DeptId


--When you execute, Select * from vWEmployeeDetails, the data from the view, is seen.


--Now, let's try to insert a row into the view, vWEmployeeDetails, by executing the following query. 
--At this point, an error will be raised stating 'View or function vWEmployeeDetails is not updatable 
--because the modification affects multiple base tables.'
Insert into vWEmployeeDetails values(7, 'Valarie', 'Female', 'IT')


--So, inserting a row into a view that is based on multipe tables, raises an error by default. 
--Now, let's understand, how INSTEAD OF TRIGGERS can help us in this situation. 
--Since, we are getting an error, when we are trying to insert a row into the view, 
--let's create an INSTEAD OF INSERT trigger on the view vWEmployeeDetails.


--Script to create INSTEAD OF INSERT trigger:
Create trigger tr_vWEmployeeDetails_InsteadOfInsert
on vWEmployeeDetails
Instead Of Insert
as
Begin
	Declare @DeptId int

	--Check if there is a valid DepartmentId
	--for the given DepartmentName
	Select @DeptId = DeptId 
	from tblDepartment 
	join inserted
	on inserted.DeptName = tblDepartment.DeptName

	--If DepartmentId is null throw an error
	--and stop processing
	if(@DeptId is null)
	Begin
		Raiserror('Invalid Department Name. Statement terminated', 16, 1)
		return
	End

	--Finally insert into tblEmployee table
	Insert into tblEmployee(Id, Name, Gender, DepartmentId)

	Select Id, Name, Gender, @DeptId
	from inserted
End
--Now, let's execute the insert query:
Insert into vWEmployeeDetails values(7, 'Valarie', 'Female', 'IT')


--The instead of trigger correctly inserts, the record into tblEmployee table. 
--Since, we are inserting a row, the inserted table, contains the newly added row, 
--where as the deleted table will be empty.


--In the trigger, we used Raiserror() function, to raise a custom error, when 
--the DepartmentName provided in the insert query, doesnot exist. 

--We are passing 3 parameters to the Raiserror() method. 
--	The first parameter is the error message, 
--	the second parameter is the severity level. 
--Severity level 16, indicates general errors that can be corrected by the user.




--==============================================================


--INSTEAD OF UPDATE trigger. 
------------------------------
--An INSTEAD OF UPDATE triggers gets fired instead of an update event, on a table or a view. 
--For example, let's say we have, an INSTEAD OF UPDATE trigger on a view or a table, and then 
--when you try to update a row with in that view or table, instead of the UPDATE, the trigger 
--gets fired automatically. INSTEAD OF UPDATE TRIGGERS, are of immense help, 
--to correctly update a view, that is based on multiple tables.


DROP TABLE tblEmployee
CREATE TABLE tblEmployee
(
 Id int Primary Key,
 Name nvarchar(30),
 Gender nvarchar(10),
 DepartmentId int
)

DROP TABLE tblDepartment
--SQL Script to create tblDepartment table 
CREATE TABLE tblDepartment
(
DeptId int Primary Key,
DeptName nvarchar(20)
)

--Insert data into tblDepartment table
Insert into tblDepartment values (1,'IT')
Insert into tblDepartment values (2,'Payroll')
Insert into tblDepartment values (3,'HR')
Insert into tblDepartment values (4,'Admin')

--Insert data into tblEmployee table
Insert into tblEmployee values (1,'John', 'Male', 3)
Insert into tblEmployee values (2,'Mike', 'Male', 2)
Insert into tblEmployee values (3,'Pam', 'Female', 1)
Insert into tblEmployee values (4,'Todd', 'Male', 4)
Insert into tblEmployee values (5,'Sara', 'Female', 1)
Insert into tblEmployee values (6,'Ben', 'Male', 3)


--Since, we now have the required tables, let's create a view based on these tables. 
--The view should return Employee Id, Name, Gender and DepartmentName columns. 
--So, the view is obviously based on multiple tables.

DROP view vWEmployeeDetails
--Script to create the view:
CREATE view vWEmployeeDetails
as
Select Id, Name, Gender, DeptName
from tblEmployee 
join tblDepartment
on tblEmployee.DepartmentId = tblDepartment.DeptId


When you execute, Select * from vWEmployeeDetails

--Now, let's try to update the view, in such a way that, it affects, both the underlying tables, 
--and see, if we get the same error. The following UPDATE statement changes Name column from tblEmployee 
and DeptName column from tblDepartment. So, when we execute this query, we get the same error.

Update vWEmployeeDetails set Name = 'Johny', DeptName = 'IT' where Id = 1


--Now, let's try to change, just the department of John from HR to IT. 
--The following UPDATE query, affects only one table, tblDepartment. 
--So, the query should succeed. But, before executing the query, please note 
--that, employees JOHN and BEN are in HR department.

Update vWEmployeeDetails set DeptName = 'IT' where Id = 1


--After executing the query, select the data from the view, and notice that BEN's 
--DeptName is also changed to IT. We intended to just change JOHN's DeptName. So, 
--the UPDATE didn't work as expected. This is because, the UPDATE query, updated the 
--DeptName from HR to IT, in tblDepartment table. For the UPDATE to work correctly, 
--we should change the DeptId of JOHN from 3 to 1.


--Updated incorrectly

--So, the conclusion is that, if a view is based on multiple tables, and if you update the view, 
--the UPDATE may not always work as expected. To correctly update the underlying base tables, 
--thru a view, INSTEAD OF UPDATE TRIGGER can be used.

--Before, we create the trigger, let's update the DeptName to HR for record with Id = 3.

Update tblDepartment set DeptName = 'HR' where DeptId = 3
--Script to create INSTEAD OF UPDATE trigger:
Create Trigger tr_vWEmployeeDetails_InsteadOfUpdate
on vWEmployeeDetails
instead of update
as
Begin
	-- if EmployeeId is updated
	if(Update(Id))
	Begin
		Raiserror('Id cannot be changed', 16, 1)
		Return
	End

	-- If DeptName is updated
	if(Update(DeptName)) 
	Begin
		Declare @DeptId int

		Select @DeptId = DeptId
		from tblDepartment
		join inserted
		on inserted.DeptName = tblDepartment.DeptName

		if(@DeptId is NULL )
		Begin
			Raiserror('Invalid Department Name', 16, 1)
			Return
		End

		Update tblEmployee set DepartmentId = @DeptId
		from inserted
		join tblEmployee
		on tblEmployee.Id = inserted.id
	End

	-- If gender is updated
	if(Update(Gender))
	Begin
		Update tblEmployee set Gender = inserted.Gender
		from inserted
		join tblEmployee
		on tblEmployee.Id = inserted.id
	End

	-- If Name is updated
	if(Update(Name))
	Begin
		Update tblEmployee set Name = inserted.Name
		from inserted
		join tblEmployee
		on tblEmployee.Id = inserted.id
	End
End


--Now, let's try to update JOHN's Department to IT. 
Update vWEmployeeDetails 
set DeptName = 'IT'
where Id = 1

--The UPDATE query works as expected. The INSTEAD OF UPDATE trigger, correctly updates, JOHN's DepartmentId to 1, in tblEmployee table.


--Now, let's try to update Name, Gender and DeptName. 
--The UPDATE query, works as expected, without raising the error - 'View or function vWEmployeeDetails 
--is not updatable because the modification affects multiple base tables.'


Update vWEmployeeDetails 
set Name = 'Johny', Gender = 'Female', DeptName = 'IT' 
where Id = 1


--Update() function used in the trigger, returns true, even if you update with the same value. 
--For this reason, I recommend to compare values between inserted and deleted tables, rather than 
--relying on Update() function. The Update() function does not operate on a per row basis, but across all rows.



--==============================================================


--INSTEAD OF DELETE trigger. 
-----------------------------
--An INSTEAD OF DELETE trigger gets fired instead of the DELETE event, on a table or a view. 
--For example, let's say we have, an INSTEAD OF DELETE trigger on a view or a table, and 
--then when you try to update a row from that view or table, instead of the actual DELETE event, 
--the trigger gets fired automatically. INSTEAD OF DELETE TRIGGERS, are used, to delete records 
--from a view, that is based on multiple tables.


DROP TABLE tblEmployee
CREATE TABLE tblEmployee
(
 Id int Primary Key,
 Name nvarchar(30),
 Gender nvarchar(10),
 DepartmentId int
)

DROP TABLE tblDepartment
--SQL Script to create tblDepartment table 
CREATE TABLE tblDepartment
(
DeptId int Primary Key,
DeptName nvarchar(20)
)

--Insert data into tblDepartment table
Insert into tblDepartment values (1,'IT')
Insert into tblDepartment values (2,'Payroll')
Insert into tblDepartment values (3,'HR')
Insert into tblDepartment values (4,'Admin')

--Insert data into tblEmployee table
Insert into tblEmployee values (1,'John', 'Male', 3)
Insert into tblEmployee values (2,'Mike', 'Male', 2)
Insert into tblEmployee values (3,'Pam', 'Female', 1)
Insert into tblEmployee values (4,'Todd', 'Male', 4)
Insert into tblEmployee values (5,'Sara', 'Female', 1)
Insert into tblEmployee values (6,'Ben', 'Male', 3)

--Since, we now have the required tables, let's create a view based on these tables. 
--The view should return Employee Id, Name, Gender and DepartmentName columns. 
--So, the view is obviously based on multiple tables.

DROP view vWEmployeeDetails
--Script to create the view:
Create view vWEmployeeDetails
as
Select Id, Name, Gender, DeptName
from tblEmployee 
join tblDepartment
on tblEmployee.DepartmentId = tblDepartment.DeptId

Select * from vWEmployeeDetails


--we tried to insert a row into the view, and we got an error stating - 'View or function vWEmployeeDetails is not updatable because the modification affects multiple base tables'.
--Along, the same lines, in Previous example, when we tried to update a view that is based on multiple tables, we got the same error. To get the error, the UPDATE should affect both the base tables. If the update affects only one base table, we don't get the error, but the UPDATE does not work correctly, if the DeptName column is updated.


--Now, let's try to delete a row from the view, and we get the same error.
Delete from vWEmployeeDetails where Id = 1


--Script to create INSTEAD OF DELETE trigger:
Create Trigger tr_vWEmployeeDetails_InsteadOfDelete
on vWEmployeeDetails
instead of delete
as
Begin
	Delete tblEmployee 
	from tblEmployee
	join deleted
	on tblEmployee.Id = deleted.Id

	--Subquery
	--Delete from tblEmployee 
	--where Id in (Select Id from deleted)
End

--Notice that, the trigger tr_vWEmployeeDetails_InsteadOfDelete, makes use of DELETED table. DELETED table contains all the rows, that we tried to DELETE from the view. So, we are joining the DELETED table with tblEmployee, to delete the rows. You can also use sub-queries to do the same. In most cases JOINs are faster than SUB-QUERIEs. However, in cases, where you only need a subset of records from a table that you are joining with, sub-queries can be faster.

--Upon executing the following DELETE statement, the row gets DELETED as expected from tblEmployee table
Delete from vWEmployeeDetails where Id = 1


--Trigger	INSERTED or DELETED?
--Instead of Insert	DELETED table is always empty and the INSERTED table contains the newly inserted data.
--Instead of Delete	INSERTED table is always empty and the DELETED table contains the rows deleted
--Instead of Update	DELETED table contains OLD data (before update), and inserted table contains NEW data(Updated data)


--==============================================================


Enabling and disabling DML triggers on a table
DISABLE TRIGGER TR_UPD_Locations2 on Locations

--Enabling specific trigger on the table using T-SQL.
ENABLE TRIGGER TR_UPD_Locations2 on Locations

--To disable all triggers on a table, use below syntax. This statement is not supported if the table is part of merge replication.
DISABLE TRIGGER ALL ON Locations


Dropping a trigger on a table.
DROP TRIGGER TRL_UPD_Locations2




--==============================================================









--DDL Triggers
--DDL triggers in SQL Server are fired on DDL events. i.e. against create, alter and drop statements, etc. These triggers are created at the database level or server level based on the type of DDL event.
--These triggers are useful in the below cases.
--⦁	Prevent changes to the database schema
--⦁	Audit database schema changes
--⦁	To respond to a change in the database schema

--Creating a DDL trigger
--Below is the sample syntax for creating a DDL trigger for ALTER TABLE event on a database which records all the alter statements against the table. You can write your custom code to track or audit the schema changes using EVENTDATA().

--CREATE TABLE TableSchemaChanges (ChangeEvent xml, DateModified datetime)
 
--CREATE TRIGGER TR_ALTERTABLE ON DATABASE
FOR ALTER_TABLE
AS
BEGIN
 
INSERT INTO TableSchemaChanges
SELECT EVENTDATA(),GETDATE()
 
END

--___________________________________________________________________________________________________________________________________

CREATE TABLE [A](
[id] INT);

ALTER TRIGGER [tr_a_ins]
	ON [A]
	INSTEAD OF DELETE, INSERT
AS
BEGIN
	PRINT 'Operation done'
	INSERT INTO [A]
	SELECT * FROM INSERTED
END

INSERT INTO [A]
VALUES
(1);

TRUNCATE TABLE [a]

SELECT * FROM [A]
UPDATE [A]
SET [id]=2;