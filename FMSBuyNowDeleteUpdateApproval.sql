GO
alter table OrderDetails
add Iteration int;
GO

--DONT EXECUTE THE ABOVE QUERY IF YOU ARE RUNNING THIS QUERY SECOND TIME

--START FROM HERE IF ITS NOT YOUR FIRST TIME
GO
create or alter proc sp_BUYNOW (@RegNumber int, @ProductID int, @Quantity int,@EMIDuration int)
as
BEGIN
	DECLARE @CardID int,
			@CardLimit int,
			@res varchar(50),
			@TotalAmount int,
			@EMIPaid int,
			@EMIBalance int,
			@Iteration int
	 -- SET THE CARD ID From registration number
	set @CardID = ( select CardID from EMICard,Customers where Customers.RegNumber = EMICard.RegNumber and Customers.RegNumber = @RegNumber)
	print @CardID
	
	--CHECK IF THE STOCK is valid
	if (@Quantity > (select ProductStock from Products where ProductID = @ProductID))
		BEGIN
		set @res = 'Stock is less'
		print @res
		return -1;
		END
	--Calculating the total ammount	
	set @TotalAmount = (select ProductPrice*@Quantity from Products where ProductID = @ProductID)
	
	--Catching the card details	
	set @CardLimit = (select CardLimit from EMICard where CardID = @CardID)

	--check for card limit
	if (@CardLimit < @TotalAmount)
		BEGIN
		set @res = 'Limit is less'
		print @res
		return -2
		END
	-- if the account status is not approved
	if ((select AccountStatus from EMICard where CardID = @CardID) != 'Approved')
		BEGIN
		set @res = 'Card is not approved'
		print @res
		return -3
		END
	set @EMIPaid = 0
	set @Iteration = 0 -- as buy now is the first iteration 
	set @EMIBalance = CEILING(@TotalAmount-@EMIPaid)

	BEGIN TRANSACTION
		update Products set ProductStock = (ProductStock - @Quantity) where ProductID = @ProductID
		insert into OrderDetails values (@RegNumber,@CardID,@ProductID,@Quantity,@TotalAmount,@EMIDuration,@EMIPaid,@EMIBalance,DEFAULT,@Iteration)		
		update EMICard set CardLimit = (CardLimit - @EMIBalance) where CardID = @CardID
		insert into ActivityLog values ('EMI_INIT','EMI start for Customer : ' + cast(@RegNumber as varchar(MAX)) + ' Card ID : ' + cast (@CardID as varchar(MAX)) + ' Product ID : ' + cast (@ProductID as varchar(MAX))+ ' Quantity : ' + cast(@Quantity as varchar(MAX)) + ' EMI DURATION : ' + cast(@EMIDuration as varchar(MAX)) +' EMI BALANCE' + cast(@EMIBalance as varchar(MAX)),DEFAULT)
	COMMIT TRANSACTION

END

create or alter proc sp_getEMICardDetails(@username varchar(50))
as
begin

select e.RegNumber, c.CustName,e.CardID,CAST(DECRYPTBYPASSPHRASE('CardNumber',e.CardNumber) as varchar(MAX)) 'CardNumber',e.CardType,e.ValidityPeriod,e.CardLimit,e.AccountStatus from Customers c inner join EMICard e on e.RegNumber =c.RegNumber where c.CustUsername=@username
end


GO
--exec sp_BUYNOW @RegNumber = 2, @ProductID = 2,@EMIDuration = 5,@Quantity = 5 --example to execute query

GO
create or alter proc sp_RefreshEMI
as
begin
	BEGIN TRANSACTION
		update OrderDetails
		set EMIPaid = EMIPaid + CEILING(TotalAmount/EMIDuration),
			Iteration = Iteration + 1
		where Iteration < EMIDuration -- to filter out paid ones

		update OrderDetails
		set	EMIBalance = CEILING(TotalAmount-EMIPaid)
		where Iteration < EMIDuration -- to filter out paid ones

		update OrderDetails
		set EMIBalance = 0
		where Iteration = EMIDuration

		if (@@ROWCOUNT > 0)
		insert into ActivityLog values ('EMI_UPD','EMI updated for every user, check your order details for more info',DEFAULT)
		else
		insert into ActivityLog values ('EMI_UPD',null,DEFAULT)
	COMMIT TRANSACTION

end


GO

create or alter trigger UpdateLimit
on OrderDetails
for UPDATE
as
begin
	declare @RegNumber int,
			@EMIBalance int
	select @RegNumber = RegNumber from INSERTED
	print @RegNumber
	select @EMIBalance = cast((select SUM(EMIBalance) from OrderDetails where RegNumber = @RegNumber) as int)
	print @EMIBalance
	BEGIN TRANSACTION
	if ((select CardType from EMICard where CardID = @RegNumber) = 'Gold')
		BEGIN
			update EMICard
			set CardLimit = 50000 - @EMIBalance
			where CardID = @RegNumber
		END
	else
		BEGIN
			update EMICard
			set CardLimit = 80000 - @EMIBalance
			where CardID = @RegNumber
		END
	insert into ActivityLog values ('LIMIT_UPD','Limit updated for custumer ' + cast(@RegNumber as varchar(4)) + ' by ' + cast(@EMIBalance as varchar(10)),DEFAULT)
	COMMIT TRANSACTION
end






-- W A R N I N G 
-- RUN THIS WHEN YOU WANT TO IMPLEMENT EMI FUNCTIONALITY AUTOMATICALLY
WHILE (1=1)
BEGIN  
    WAITFOR DELAY '00:01';  
    EXEC sp_RefreshEMI;  
END;  
GO  


--Update Approval
create or alter proc sp_UpdateApproval(@RegNumber int)
as
begin
update Customers
set ApprovalStatus = 'Approved'
update EMICard
set AccountStatus='Approved'
where RegNumber = @RegNumber
end

--Delete Cust
create proc sp_DeleteUser(@RegNumber int)
as
begin
BEGIN TRANSACTION
delete from OrderDetails where RegNumber = @RegNumber
delete from EMICard where RegNumber = @RegNumber
delete from Customers where RegNumber = @RegNumber
COMMIT TRANSACTION
end

--ValidateUser
create proc sp_ValidateUser (
@CustUsername varchar(30),
@PhoneNo bigint,
@CustEmail varchar(30),
@AccountNumber nvarchar(MAX))
as
begin
declare @res varchar(50);
set @res = ''
select @res from Customers where CustUsername = @CustUsername
if (@@ROWCOUNT = 1)
set @res = 'UserName '+ @CustUsername + ' Exists'
else
BEGIN
select @res from Customers where PhoneNo = @PhoneNo
if (@@ROWCOUNT = 1)
set @res = 'Phone number already registered'
else
BEGIN
select @res from Customers where CustEmail = @CustEmail
if(@@ROWCOUNT = 1)
set @res = 'Email ID already exists'
else
BEGIN
select @res from Customers where @AccountNumber = CAST(DECRYPTBYPASSPHRASE('FINANCELTI',AccountNumber) as nvarchar(MAX))
if (@@ROWCOUNT = 1)
set @res = 'Account Number Already Exists'
END
END
END
if @@ROWCOUNT = 0
set @res=''
select @res
end

select * from AdminCredentials

insert into AdminCredentials values('Disha')

select CAST(DECRYPTBYPASSPHRASE('FINANCELTI'+CustUsername,CustPassword) as nvarchar(400)) from Customers

select * from OrderDetails
select * from Customers
select * from EMICard

update EMICard
set AccountStatus='Approved'
where RegNumber=1003