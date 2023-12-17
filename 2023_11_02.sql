--  Transaction
---------------
--  	A transaction is a group of commands treated as one unit that change
--  the data stored in a database.

--  1.	BEGIN a transaction: Set the starting point.
--  2.	COMMIT a transaction: Make the transaction a permanent,
--		irreversible part of the database.
--  3.	ROLLBACK a transaction: Essentially saying that you want to forget
--		that it ever happened.
--  4.	SAVE a transaction: Establish a specific marker to allow us to do only a
--		partial rollback.
--_____________________________________________________________________________________
USE [TrainingDB];

CREATE TABLE [tblTransactionDemo](
[Id] INT PRIMARY KEY IDENTITY);

DELETE FROM [tblTransactionDemo]
SELECT * FROM [tblTransactionDemo]

BEGIN TRANSACTION [T1]
	SELECT 'BEGIN TRANSACTION T1'
	INSERT INTO [tblTransactionDemo] DEFAULT VALUES
	INSERT INTO [tblTransactionDemo] DEFAULT VALUES
	SELECT 'BEFORE ROLLBACK T1'
	SELECT * FROM [tblTransactionDemo]
ROLLBACK TRANSACTION [T1]

SELECT 'AFTER ROLLBACK T1'
SELECT * FROM [tblTransactionDemo]

BEGIN TRANSACTION [T2]
	SELECT 'BEGIN TRANSACTION T2'
	INSERT INTO [tblTransactionDemo] DEFAULT VALUES
	INSERT INTO [tblTransactionDemo] DEFAULT VALUES
	SAVE TRANSACTION [T3]
		SELECT 'SAVE TRANSACTION T3';
		INSERT INTO [tblTransactionDemo] DEFAULT VALUES
		INSERT INTO [tblTransactionDemo] DEFAULT VALUES
		SELECT 'BEFORE ROLLBACK T3'
		SELECT * FROM [tblTransactionDemo]
	ROLLBACK TRANSACTION [T3]
	SELECT 'AFTER ROLLBACK T3'
	SELECT * FROM [tblTransactionDemo]
COMMIT TRANSACTION [T2]

SELECT 'AFTER COMMIT T2'
SELECT * FROM [tblTransactionDemo]
