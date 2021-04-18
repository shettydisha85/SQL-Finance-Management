--Addding Unique Constrain

alter table Customers add unique (PhoneNo)         --unique constraint
alter table Customers add unique (CustEmail)
alter table Customers add unique (CustUsername)

--------------used in sp_insertotp
alter table Customers
add OtpExpiry datetime DEFAULT getdate() null

select * from Customers

--------------------------------------------------Insert Audit Customer------------------------------------------
create or alter trigger InsertAuditCustomer 
ON Customers
FOR INSERT
AS
BEGIN

declare 
@RegNumber int,
@CustName varchar(30),
@PhoneNo bigint,
@CustEmail varchar(30),
@CustUsername varchar(30),
@CustPassword nvarchar(MAX), --encrypted
@CustAddress varchar(50),
@CardType varchar(10),
@BankName varchar(30),
@AccountNumber nvarchar(MAX),  --encrypted
@IFSCCode varchar(11),
@ApprovalStatus varchar(10)
		select @RegNumber = RegNumber from inserted
		select @CustName = CustName from inserted
		select @CustUsername = CustUserName from inserted
		select @CardType = CardType from inserted
		select @AccountNumber = AccountNumber from inserted
		select @ApprovalStatus = ApprovalStatus from inserted
		insert into ActivityLog values ('INSERTION','Inserted values into customer table ' + CAST(@RegNumber as varchar(40)) + ' ' + @CustName +
		' ' + @CustUsername + ' ' + @CardType + ' ' + @AccountNumber + ' ' + @ApprovalStatus, DEFAULT)
END

--------------------------------------------------------Stored Procedure for InsertCustomer
alter proc sp_InsertCustomer
(@CustName varchar(30),
@PhoneNo bigint,
@CustEmail varchar(30),
@CustUsername varchar(30),
@CustPassword nvarchar(MAX), --encrypted
@CustAddress varchar(50),
@CardType varchar(10),
@BankName varchar(30),
@AccountNumber nvarchar(MAX),  --encrypted
@IFSCCode varchar(11),
@ApprovalStatus varchar(10))

AS 
BEGIN
DECLARE @EncryptedPassword varbinary(MAX),
		@EncryptedAccountNumber varbinary(MAX);
SET @EncryptedPassword  = ENCRYPTBYPASSPHRASE('FINANCELTI'+ @CustUsername,@CustPassword)
SET	@EncryptedAccountNumber =  ENCRYPTBYPASSPHRASE('FINANCELTI',@AccountNumber)
insert into Customers (CustName,PhoneNo,CustEmail,CustUsername,CustPassword,CustAddress,CardType,BankName,AccountNumber,IFSCCode,ApprovalStatus,OtpExpiry)
values (@CustName,@PhoneNo,@CustEmail,@CustUsername,@EncryptedPassword,
@CustAddress,@CardType,@BankName,@EncryptedAccountNumber,@IFSCCode,@ApprovalStatus,null)
END


------------------------------------------------sp_validate user---------------------------------

create or alter proc sp_ValidateUser (
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


-----STEP 1
	alter table Customers add 
	[EmailVerfication] [bit] null,
	[ActivationCode] [uniqueidentifier],
	[Otp] [nvarchar] (4) null
-------------------------------------------------SP_UPDATEPASSWORD------------------------

create proc sp_UpdatePassword(@otp varchar(20),@Password varchar(50))
	as
	begin 
	update Customers set CustPassword=CAST (@Password as varbinary(MAX))  where Otp=@otp
	update Customers set Otp=NUll where Otp=@otp
	end


	---------------alter
alter proc sp_UpdatePassword(@otp varchar(20),@CustUsername varchar(40),@CustPassword nvarchar(400))
as
begin
BEGIN TRANSACTION
DECLARE @EncryptedPassword varbinary(MAX)
set @EncryptedPassword = ENCRYPTBYPASSPHRASE('FINANCELTI'+ @CustUsername,@CustPassword)
update Customers set CustPassword = @EncryptedPassword
where Otp=@otp and CustUsername = @CustUsername
update Customers set Otp=NUll
where Otp=@otp and CustUsername = @CustUsername
COMMIT
end

---------------alter again
alter proc sp_UpdatePassword(@otp varchar(20),@CustEmail varchar(40),@CustPassword nvarchar(400))
as
begin



BEGIN TRANSACTION
DECLARE @EncryptedPassword varbinary(MAX),
@CustUsername varchar(40)



set @CustUsername = (select CustUsername from Customers where CustEmail = @CustEmail)
set @EncryptedPassword = ENCRYPTBYPASSPHRASE('FINANCELTI'+ @CustUsername,@CustPassword)



update Customers set CustPassword = @EncryptedPassword
where Otp=@otp and CustEmail = @CustEmail



update Customers set Otp=NUll
where Otp=@otp and CustEmail = @CustEmail
COMMIT TRANSACTION
end

---------------------------Sp_InsertOTP
create proc sp_InsertOTP (@CustEmail varchar(30), @Otp varchar(4))
as
begin
    update Customers
    set Otp = @Otp
    where CustEmail = @CustEmail
end
--------alter 

----------for this add column in customers table
 alter proc sp_InsertOTP (@CustEmail varchar(30), @Otp varchar(4))
as
begin
update Customers
set Otp = @Otp, OtpExpiry = default
where CustEmail = @CustEmail
end

select * from Customers
update Customers set CustEmail = 'sai.neerharika@gmail.com' where RegNumber=3

select * from Customers

select * from Customers where CustUsername = BiswaR and @CustPassword = CAST(DECRYPTBYPASSPHRASE('FINANCELTI'+ @CustUsername,CustPassword) as nvarchar(MAX)) COLLATE SQL_Latin1_General_CP1_CS_AS

select CAST(DECRYPTBYPASSPHRASE('FINANCELTI',CustPassword) as varchar(MAX)) from Customers

select * from Customers

select * from Products

DBCC checkident ('Products', reseed, 3)
delete from Products where ProductID>1000
delete from OrderDetails where ProductID>1000

INSERT INTO Products VALUES('OnePlus 8T 5G','Colour:Aquamarine Green
Style name:8GB RAM, 128GB Storage',50,42999)
INSERT INTO PRODUCTS VALUES('Apple iPhone 12 (128GB)','Colour:Blue
Style name:128GB
Pattern name:iPhone 12',60,78999)
INSERT INTO PRODUCTS VALUES('Oppo A31','Colour:Mystery Black
Size name:6GB
Style name:With Offer',70,13999)
INSERT INTO PRODUCTS VALUES('Redmi 9','Style name:4GB RAM 64GB Storage
Colour:Sky Blue',50,17999)
INSERT INTO PRODUCTS VALUES('Redmi Note 9','Colour:Pebble Grey
Size name:4GB RAM 64GB Storage',60,15000)
INSERT INTO PRODUCTS VALUES('Apple iPhone 12 Pro Max','Colour:Graphite
Style name:256GB',80,69999)
INSERT INTO PRODUCTS VALUES('OnePlus 8 Pro','Style name:8GB RAM + 128GB Storage
Colour:Onyx Black',70,54999)
INSERT INTO PRODUCTS VALUES('OnePlus Nord 5G','Style name:12GB RAM + 256GB Storage
Colour:Gray Onyx',100,29999)
INSERT INTO PRODUCTS VALUES('Lava BeU Rose Pink','Colour:Rose Pink
Pattern name:Lava BeU',60,5999)

UPDATE Products
SET ProductName='MI 10T 5G',ProductDesc='Size name:6GB RAM
Colour:Cosmic Black', ProductStock=50,ProductPrice=39999
WHERE ProductID=1;

UPDATE Products
SET ProductName='OPPO F19 Pro',ProductDesc='Colour:Fluid Black', 
ProductStock=70,ProductPrice=25999
WHERE ProductID=2;

UPDATE Products
SET ProductName='Vivo Y12s',ProductDesc='Colour:Glacier Blue 
Style name: 3GB RAM, 32GB Storage', 
ProductStock=90,ProductPrice=15999
WHERE ProductID=3;

select * from Products
select * from Customers
select * from EMICard
select * from OrderDetails
delete from Customers where RegNumber>1000

DBCC checkident ('Customers', reseed, 3)