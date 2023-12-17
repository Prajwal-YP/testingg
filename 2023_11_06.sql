--	Dependent T-SQL
--	Handling Error Exceptions

--	DECLARE @var1 INT =100, @var2 INT =0, @quotient INT =0;
--
--	BEGIN TRY
--		SET @quotient =	@var1/@var2;
--		PRINT @quotient;
--	END TRY
--	BEGIN CATCH
--		PRINT 'In this ('+CAST(@var1 AS VARCHAR)+'/'+CAST(@var2 AS VARCHAR)+'), The divisor is 0!! Change it';
--		PRINT ''
--		PRINT 'ERROR: ' + ERROR_MESSAGE()
--	END CATCH
--
--	PRINT ''
--	PRINT 'Thank you for visiting . . . !!'
--
--	SELECT *
--	FROM [sys].[messages]
--	WHERE [message_id] IN (1105);

--____________________________________________________________________________________________

USE [Payroll];

 --SELECT * FROM [Toys]
 --SELECT * FROM [Category]
 --SELECT * FROM [Transactions]
 --SELECT * FROM [Customers]

--____________________________________________________________________________________________
--CusId		->	104
--TId		->	T1005
--Quantity	->	2
--WRITE T-SQL block to update the following transaction in toy center appplication

DECLARE 
	@CustomerId INT =104, 
	@ToyId VARCHAR(5) = 'T1005', 
	@Quantity INT =2;

-- Check whether the customer is valid 
	DECLARE 
		@IsCustomer SMALLINT;

	SELECT
		@IsCustomer=[CusId]
	FROM 
		[Customers]
	WHERE 
		[CusId]=@CustomerId;

	IF ISNULL(@IsCustomer,0)=0
	BEGIN
		PRINT 'Customer ID is invalid !!'
		GOTO EOP
	END

-- Check whether the toy is valid 
	DECLARE 
		@IsToy VARCHAR(5) = '';

	SELECT 
		@IsToy=[TId]
	FROM 
		[Toys]
	WHERE 
		[TId]=@ToyId;

	IF @IsToy=''
	BEGIN
		PRINT 'Toy ID is invalid !!'
		GOTO EOP
	END

-- Check whether the quantity is valid
	DECLARE @StockAvailable INT = NULL;

	SELECT
		@StockAvailable=[Stock]
	FROM
		[Toys]
	WHERE
		[TId] IN (@ToyId);

	IF @StockAvailable < @Quantity
	BEGIN
		PRINT 'Can not order this toy, as we have only ' + CAST(@StockAvailable AS VARCHAR)+ ' stocks available'
		GOTO EOP
	END

BEGIN TRANSACTION [Updaterecords]
	BEGIN TRY
	--Update the stock of the toy
		UPDATE [Toys]
		SET [Stock] = [Stock]- @Quantity
		WHERE [TId] IN (@ToyId);

	-- Insert a transaction record
		DECLARE @ToyPrice INT = NULL, @NewId INT =NULL;

		-- Get price
		SELECT
			@ToyPrice=[Price]
		FROM
			[Toys]
		WHERE
			[TId] IN (@ToyId);

		-- Get latest transaction ID
		SELECT
			@NewId = [TxnId]
		FROM
			[Transactions]
		ORDER BY 
			[TxnId] ASC;

		INSERT INTO [Transactions]([TxnId],[CusId],[TId],[Quantity],[Txncost])
		VALUES
		(@NewId+1,@CustomerId,@ToyId,@Quantity,@ToyPrice*@Quantity);
	END TRY
	BEGIN CATCH
		PRINT 'can not place the order !!(Can not update the records)'
		PRINT 'ERROR: '+ ERROR_MESSAGE()
		ROLLBACK TRANSACTION [Updaterecords]
		GOTO EOP
	END CATCH
COMMIT TRANSACTION [UpdateRecords]

EOP:
	PRINT 'Thank you for visiting'

--____________________________________________________________________________________________

--	STORED PROCEDURES
--USE [TrainingDB]