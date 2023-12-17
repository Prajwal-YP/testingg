USE Payroll;

--	Creating the table tblDepartment
DROP TABLE tblDepartment;
CREATE TABLE tblDepartment(
DepartmentId INT PRIMARY KEY,
DepartmentName VARCHAR(50) NOT NULL,
DepartmentLocation VARCHAR(50) NOT NULL);

--	Creating the table tblEmployee
DROP TABLE tblEmployee;
CREATE TABLE tblEmployee(
EmployeeId INT PRIMARY KEY,
EmployeeName VARCHAR(50) NOT NULL,
Designation VARCHAR(50) NOT NULL,
JoiningDate DATETIME NOT NULL,
EmailId VARCHAR(50) UNIQUE NOT NULL,
Salary INT NOT NULL,
DepartmentId INT FOREIGN KEY REFERENCES tblDepartment(DepartmentId));

-- Information on tblDepartment
EXEC sp_columns tblDepartment;
EXEC sp_help tblDepartment;

-- Information on tblEmployee
EXEC sp_columns tblEmployee;
EXEC sp_help tblEmployee;

-- Inserting records into tblDepartments
INSERT INTO tblDepartment VALUES
(10, 'Development', 'Mysore'),
(20, 'Finance', 'Delhi'),
(30, 'Marketing', 'Banglore'),
(40, 'Testing', 'Manglore'),
(50, 'Management', 'Udupi');


SELECT *
FROM tblDepartment;

-- Inserting records into tblEmployees
INSERT INTO tblEmployee VALUES
(1000, 'Prajwal_Y_P', 'Software Engineer', '2019-10-16','prajwal@excelindia.com', 50000,10),
(1001, 'Sagar', 'Trainee Software Engineer', '2022-01-12','Sagar@excelindia.com', 35000,10),
(1002, 'Nishanth', 'Business Analysts', '2021-04-12','Nishanth@excelindia.com', 48000,20),
(1003, 'Raghu', 'Business Analysts', '2022-02-01','Raghu@excelindia.com', 16000,20),
(1004, 'Sushil', 'Copywriter', '2022-01-12','Sushil@excelindia.com', 15000,30),
(1005, 'Pavithra', 'Copywriter', '2019-10-12','Pavithra@excelindia.com', 38000,30),
(1006, 'Vatsala', 'Teacher', '2020-08-14','Vatsala@excelindia.com', 13000,NULL),
(1007, 'Subramanya', 'Teacher', '2019-09-18','Subramanya@excelindia.com', 19000,NULL),
(1008, 'Akash', 'Software Tester', '2017-09-08','Akash@excelindia.com', 38000,40),
(1009, 'Raj Shekara', 'Software Tester', '2017-09-08','Rajshekara@excelindia.com', 21000,50);

SELECT *
FROM tblEmployee;

-- _____________________________________________________________________________________

CREATE TABLE Student(
StuId INT PRIMARY KEY,
StuName VARCHAR(50) NOT NULL,
StuGender Char(1) NOT NULL);

CREATE TABLE Subject(
SubID INT PRIMARY KEY,
SubName VARCHAR(50) NOT NULL);

----------------------------
INSERT INTO Student VALUES
(1, 'Mr. Prajwal Y P','M'),
(2, 'Mr. Ganesh', 'M'),
(3, 'Ms. Pavithra', 'F'),
(4, 'Ms. Vatsala', 'F');
SELECT * FROM Student;

INSERT INTO Subject VALUES
(100,'English'),
(101,'Kannada'),
(102,'Hindi'),
(103,'Tamil'),
(104,'Telugu');
SELECT * FROM Subject;
----------------------------
--stu				StuId(pk), StuName, StuGender
--sub				SubId(pk), SubName

--Desired3Sub		SlNo(PK), StuId(FK->Stu), SubId(FK->Sub) <<UNIQUE(StudId,SubId)>>
----------------------------


CREATE TABLE Desired3Subject(
SlNo INT PRIMARY KEY,
StuId INT FOREIGN KEY REFERENCES Student(StuId),
SubId INT FOREIGN KEY REFERENCES Subject(SubId)
CONSTRAINT UK_Subjects UNIQUE(StuId, SubId));

INSERT INTO Desired3Subject VALUES
(10,1,100), 
(11,1,101),
(12,1,102),
(13,2,100), 
(14,2,102),
(15,2,104),
(16,3,100), 
(17,3,102),
(18,3,103),
(19,4,101), 
(20,4,102),
(21,4,104);


SELECT * FROM Desired3Subject;

-- ____________________________________________
SELECT StuName,SubName
FROM Student AS Stu 
INNER JOIN Desired3Subject As D ON Stu.StuId=D.StuId
INNER JOIN Subject AS Sub ON D.SubId=Sub.SubID;
-- ____________________________________________

-- This is an example of Normalization