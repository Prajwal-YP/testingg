--Consider a website “FlyTrip.com” used by the customers to book the online flight tickets. 
--Customers can signup/register to book tickets for international and domestic travel. The 
--website helps check the availability of seats based on a source and destination city on a 
--given date.Here are some assumptions with respect to this scenario 
--	The website allows customers to book tickets multiple times 
--	Customers can choose the seats such as economy class, business class while booking the ticket 
--	The flight charges are based on the source and destination and include the charges for the travel class seat chosen at the time of booking. 


-- CREATING TABLE CUSTOMERS

CREATE DATABASE [Assesment];

USE [Assesment];

CREATE TABLE [tblCustomers](
	[CustomerId] VARCHAR(5) PRIMARY KEY,
	[CustomerName] VARCHAR(50) NOT NULL);

INSERT INTO [tblCustomers]
VALUES
	('C301','John'),
	('C302','Sam'),
	('C303','Robert'),
	('C304','Albert'),
	('C305','Jack'),
	('C306','Yp');


SELECT * FROM [tblCustomers];

CREATE TABLE [tblFlight](
	[FlightId] VARCHAR(5) PRIMARY KEY,
	[FlightName] VARCHAR(100) NOT NULL,
	[FlightType] VARCHAR(50) NOT NULL,
	[Source] VARCHAR(50) NOT NULL,
	[Destination] VARCHAR(50) NOT NULL,
	[FlightCharge] MONEY NOT NULL,
	[TicketsAvailable] INT NOT NULL,
	[TravelClass] VARCHAR(50) NOT NULL);


INSERT INTO [tblFlight]
VALUES
	('F101', 'Spice Jet Airlines', 'Domestic', 'Mumbai', 'Kolkata', 2000, 20, 'Business'),
	('F102', 'Indian Airlines', 'International', 'Delhi', 'Germany', 8000, 20, 'Business'),
	('F103', 'Deccan Airlines', 'Domestic', 'Chennai', 'Bengaluru', 3000, 34, 'Economy'),
	('F104', 'British Airlines', 'International', 'London', 'Italy', 1000, 3, 'Economy'),
	('F105', 'Swiss Airlines', 'International', 'Zurich', 'Spain', 3000, 10, 'Business');

SELECT * FROM [tblFlight]


CREATE TABLE [tblBooking](
	[BookingId] INT PRIMARY KEY,
	[FlightId] VARCHAR(5) FOREIGN KEY REFERENCES [tblFlight]([FlightId]) NOT NULL,
	[CustomerId] VARCHAR(5) FOREIGN KEY REFERENCES [tblCustomers]([CustomerId]) NOT NULL,
	[TravelClass] VARCHAR(50) NOT NULL,
	[NumberOfSeats] INT NOT NULL,
	[BookingDate] DATE NOT NULL,
	[TotalAmount] MONEY NOT NULL);

--f101 Business
--f102 Business
--f103 Economy
--f104 Economy
--f105 Business

INSERT INTO [tblBooking]
VALUES
(209, 'F102', 'C301', 'Business', 2, '2018-11-22', 16000),
(201, 'F101', 'C301', 'Business', 6, '2018-03-22', 12000),
(202, 'F105', 'C303', 'Business', 10, '2018-03-22', 30000),
(203, 'F103', 'C302', 'Economy', 1, '2018-03-22', 3000),
(204, 'F101', 'C302', 'Business', 5, '2018-03-22', 10000),
(205, 'F104', 'C303', 'Economy', 25, '2018-03-22', 25000),
(206, 'F105', 'C301', 'Business', 10, '2018-03-22', 30000),
(207, 'F104', 'C304', 'Economy', 22, '2018-03-22', 22000),
(208, 'F101', 'C304', 'Business', 6, '2018-03-22', 12000);

SELECT * FROM [tblBooking]

--_________________________________________________________________________________________


--Stored Procedure: usp_BookTheTicket 
--____________________________________
--Create a stored procedure named usp_BookTheTicket to insert values into the 
--tblBookingDetails. Implement appropriate exception handling. 
--Input Parameters: 
--	CustId 
--	FlightId 
--	NoOfTickets 
--Functionality: 
--	Check if CustId is present in tblCustomer 
--	Check if FlightId is present in tblFlight 
--	Check if NoOfTickets is a positive value and is less than or equal to TicketsAvailable value for that flight 
--	If all the validations are successful, insert the data by generating the BookingId and calculate the total amount based on the TicketCost 
--Return Values: 
--	 1, in case of successful insertion 
--	-1,if CustId is invalid 
--	-2,if FlightId is invalid 
--	-3,if NoOfTickets is less than zero 
--	-4,if NoOfTickets is greater than TicketsAvailable 
--	-99,in case of any exception

CREATE OR ALTER PROCEDURE [USP_BookTheTicket]
	@CustomerId VARCHAR(5),
	@FlightId VARCHAR(5),
	@NumberOfTickets INT
AS
BEGIN
	-- CutomerId Validation
	IF 
		@CustomerId IS NULL
		OR
		NOT EXISTS(SELECT [CustomerId] FROM [tblCustomers] WHERE [CustomerId] IN (@CustomerId))
	BEGIN
		PRINT 'INVALID CUSTOMER !!!';
		RETURN -1;
	END

	-- FlightId Validation
	IF
		@FlightId IS NULL
		OR
		NOT EXISTS(SELECT [FlightId] FROM [tblFlight] WHERE [FlightId] IN (@FlightId))
	BEGIN
		PRINT 'INVALID FLIGHT';
		RETURN -2;
	END

	-- Negetive Tickets Validation
	IF @NumberOfTickets<=0
	BEGIN
		PRINT 'You should book atleast 1 ticket !!';
		RETURN -3;
	END

	-- Declaring the needed variables
	DECLARE
		@NewId INT,
		@TravelClass VARCHAR(50),
		@AvailableTickets INT,
		@Price MONEY;

	SELECT
		@TravelClass=[TravelClass],
		@Price=[FlightCharge],
		@AvailableTickets=[TicketsAvailable]
	FROM
		[tblFlight]
	WHERE 
		[FlightId] IN (@FlightId);

	SELECT 
		@NewId=MAX([BookingId])+1
	FROM
		[tblBooking];

	-- Tickets stock availability Validation
	IF @NumberOfTickets>@AvailableTickets
	BEGIN
		PRINT 'Tickets OUT OF STOCK !!';
		RETURN -4;
	END

	-- Now begining the transaction to perform task
	BEGIN TRY 
		BEGIN TRANSACTION
			-- Updating the tickets availability
			UPDATE 
				[tblFlight]
			SET
				[TicketsAvailable] -= @NumberOfTickets
			WHERE 
				[FlightId] IN (@FlightId);

			-- Recording a new booking transaction 
			INSERT INTO [tblBooking]
				([BookingId], [FlightId], [CustomerId], [TravelClass], [NumberOfSeats], [BookingDate], [TotalAmount])
			VALUES
				(@NewId, @FlightId, @CustomerId,@TravelClass, @NumberOfTickets, CAST(GETDATE() AS DATE), @Price*@NumberOfTickets);
		COMMIT
		RETURN 1;
	END TRY
	BEGIN CATCH 
		PRINT 'UNEXPECTED ERROR !!'
		PRINT ERROR_MESSAGE()
		ROLLBACK
		RETURN -99
	END CATCH

END

--	Function: ufn_BookedDetails 
--Create a function ufn_BookedDetails to get the booking details based on the BookingId 
--Input Parameter: 
--	BookingId 
--Functionality: 
--	Fetch the details of the ticket purchased based on the BookingId 
--Return Value: 
--A table containing following fields: 
--	BookingId 
--	CustName 
--	FlightName 
--	Source 
--	Destination 
--	BookingDate 
--	NoOfTickets 
--	TotalAmt 

CREATE OR ALTER FUNCTION [UFN_BookedDetails](@BookingId INT)
RETURNS TABLE
AS
RETURN
	SELECT
		[B].[BookingId] AS [Booking Id],
		[C].[CustomerName] AS [Customer Name],
		[F].[FlightName] AS [Flight Name],
		[F].[Source],
		[F].[Destination],
		[B].[BookingDate] AS [Booking Date],
		[B].[NumberOfSeats] AS [Number Of Tickets],
		[B].[TotalAmount] AS [Total Amount]
	FROM
		[tblBooking] [B]
		INNER JOIN [tblFlight] [F] ON [B].[FlightId]=[F].[FlightId]
		INNER JOIN [tblCustomers] [C] ON [C].[CustomerId]=[B].[CustomerId]
	WHERE
		[B].[BookingId] IN (@BookingId)
--___________________________________________________________________________________________

SELECT * FROM [tblCustomers];
SELECT * FROM [tblFlight];
SELECT * FROM [tblBooking];

--Stored Procedure output
DECLARE @Status INT;
	EXECUTE @Status = [USP_BookTheTicket] @CustomerId='C305', @FlightId='F103', @NumberOfTickets=4;
PRINT @Status;

--Function output
SELECT 
	*
FROM
	[UFN_BookedDetails](209)

--_____________________________________________________________________________________

--9.Identify the customer(s) who have paid highest flightcharge for the travel class economy. 
--Write a SQL query to display id, flightname and name of the identified customers. 


SELECT 
	[B].[BookingId],
	[F].[FlightName],
	[C].[CustomerName]
FROM
	[tblBooking] [B]
	INNER JOIN [tblCustomers] [C]
		ON [B].[CustomerId]=[C].[CustomerId]
	INNER JOIN [tblFlight] [F]
		ON [B].[FlightId]=[F].[FlightId]
WHERE
	[B].[TravelClass] IN ('Economy')
ORDER BY 
	[B].[TotalAmount] DESC;

--10.Identify the International flight(s) which are booked for the maximum number of times.
--Write a SQL query to display id and name of the identified flights. 

SELECT TOP 1 WITH TIES
	[F].[FlightId],
	[F].[FlightName]
FROM
	[tblFlight] [F]
	INNER JOIN [tblBooking] [B]
		ON 
			[F].[FlightId]=[B].[FlightId]
			AND
			[F].[FlightType]='International'
GROUP BY
	[F].[FlightId],
	[F].[FlightName]
ORDER BY
	COUNT([B].[BookingId])
	

--11.Identify the customer(s) who have bookings during the months of March 2018 to January 2019 and paid 
--overall total flightcharge less than the average flightcharge of all bookings belonging to travel class ‘Business’. 
--Write a SQL query to display id and name of the identified customers. 

SELECT
	[C].[CustomerId],
	[C].[CustomerName]
FROM
	[tblCustomers] [C]
	INNER JOIN [tblBooking] [B]
		ON 
			[C].[CustomerId]=[B].[CustomerId]
			AND
			[B].[BookingDate] BETWEEN '2018-03-1' AND '2019-01-31'
GROUP BY
	[C].[CustomerId],
	[C].[CustomerName]
HAVING
	SUM([B].[TotalAmount])<(
		SELECT
			AVG([B1].[TotalAmount])
		FROM
			[tblBooking] [B1]
		WHERE
			[B1].[TravelClass] IN ('Business'))
--12.Identify the bookings with travel class ‘Business’ for the International flights.
--Write a SQL query to display booking id, flight id and customer id of those customer(s) 
--not having letter ‘e’ anywhere in their name and have booked the identified flight(s). 

SELECT
	[B].[BookingId],
	[F].[FlightId],
	[C].[CustomerId]
FROM
	[tblBooking] [B]
	INNER JOIN [tblFlight] [F]
		ON 
			[B].[FlightId]=[F].[FlightId]
			AND
			[F].[FlightType] IN ('International')
			AND
			[B].[TravelClass] IN ('Business')
	INNER JOIN [tblCustomers] [C]
		ON 
			[C].[CustomerId]=[B].[CustomerId]
			AND
			[C].[CustomerName] NOT LIKE '%e%'

--13.Identify the booking(s) which have flight charges paid is less than the average flight charge for 
--all flight ticket bookings belonging to same flight type. Write a SQL query to display 
--booking id, source city, destination city and booking date of the identified bookings. 

SELECT 
	[B].[BookingId],
	[F].[Source] AS [Source City],
	[F].[Destination] AS [Destination City],
	[B].[BookingDate]
FROM 
	[tblBooking] [B]
	INNER JOIN [tblFlight] [F]
		ON [B].[FlightId]=[F].[FlightId]
WHERE 
	[B].[TotalAmount]<(
		SELECT
			AVG([TotalAmount]) 
		FROM
			[tblBooking] [B1]
			INNER JOIN [tblFlight] [F1]
				ON 
					[B1].[FlightId]=[F1].[FlightId]
					AND
					[F1].[FlightType]=[F].[FlightType])

--14.Write a SQL query to display customer’s id and name of those customers who have paid the flight charge 
--which is more than the average flightcharge for all international flights. 

SELECT
	[C].[CustomerId],
	[C].[CustomerName]
FROM
	[tblCustomers] [C]
	INNER JOIN [tblBooking] [B]
		ON [C].[CustomerId]=[B].[CustomerId]
	INNER JOIN [tblFlight] [F]
		ON [F].[FlightId]=[B].[FlightId]
WHERE
	[F].[FlightCharge] > (
		SELECT	
			AVG([F1].[FlightCharge])	
		FROM 
			[tblFlight] [F1]
		WHERE
			[F1].[FlightType] IN ('International'))


--15.Identify the customer(s) who have booked tickets for all types of flights. Write a SQL query to display name of the identified customers. 
--Note: The types of flight are not only the ones defined in the sample data. 
SELECT * FROM [tblCustomers]
SELECT * FROM [tblFlight]
SELECT * FROM [tblBooking]



--16.Display flight id of the booked flight tickets, which fulfills EITHER of these requirements: 
--Flight’s id of the booked flight tickets that are booked for maximum number of times for the travel class ‘Business’ 
--Total flight charge of a flight id of booked flight tickets is more than the average flight charge of all bookings done for the same flight for travel clas

