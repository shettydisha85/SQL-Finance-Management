GO
CREATE Database FINANCE
GO
USE FINANCE
GO
create table Customers
(
RegNumber int primary key identity,
CustName varchar(30) not null,
PhoneNo bigint not null,
CustEmail varchar(30) not null,
CustUsername varchar(30) not null,
CustPassword varbinary(MAX) not null, --encrypted
CustAddress varchar(50) not null,
CardType varchar(10) not null,
BankName varchar(30) not null,
AccountNumber varbinary(MAX) not null,  --encrypted
IFSCCode varchar(11) not null,
ApprovalStatus varchar(10) not null
)
--Customers Table End
GO
--EMICard Table Start
create table EMICard
(
CardID int PRIMARY KEY identity,
CardNumber varbinary(MAX) not null, -- Encrypted
RegNumber int references Customers(RegNumber),
CardType varchar(10) not null,
CardLimit int not null,
ValidityPeriod Date not null,
AccountStatus varchar(20) not null
) 

--EMICard Table End
GO
--Admin Table Start
create table AdminCredentials
(
AdminUsername varchar(20) primary key,
AdminPassword varbinary(MAX) not null -- Encrypted
)


--Admin Table End
GO
--Products Table Start
create table Products
(
ProductID int Primary key identity,
ProductName varchar(30) not null,
ProductDesc varchar(100) not null,
ProductStock int not null,
ProductPrice int not null
)
--Products Table End
GO
--OrderDetails Tables Start
create table OrderDetails
(
TransactionID int Primary key identity,
RegNumber int references Customers(RegNumber),
CardID int references EMICard(CardID),
ProductID int references Products(ProductID),
Quantity int not null,
TotalAmount int not null,
EMIDuration int not null, 
EMIPaid int not null,
EMIBalance int not null,
CreatedDate datetime default getdate()
)


--OrderDetails Table End

GO
--Activity Log To store the values  of all the logs
create table ActivityLog
(
ActivityID int identity (1,1) PRIMARY KEY,
LogType varchar(20),
ActivityDesc varchar(200),
ActivityTimeStamp datetime default getdate()
)
GO
select * from Customers
select * from EMICard
select * from Products
select * from OrderDetails
select * from AdminCredentials
select * from ActivityLog
GO
--END OF TABLESS-----------------------

--TRIGGER AFTER INSERT CUSTOMER
create trigger InsertAuditCustomer 
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
		insert into ActivityLog values ('INSERTION','Inserted values into customer table ' + CAST(@RegNumber as varchar(40)) + ' ' + @CustName + ' ' + @CustUsername + ' ' + @CardType + ' ' + @AccountNumber + ' ' + @ApprovalStatus, DEFAULT)
END

GO

--EMI TRIGGER
create trigger InsertAuditEMI 
ON EMICard
FOR INSERT
AS
BEGIN

declare 
@CardID int,
@RegNumber int,
@CardType varchar(10),
@CardLimit int,
@ValidityPeriod Date,
@AccountStatus varchar(20)
		select @CardID = CardID from inserted
		select @RegNumber = RegNumber from inserted
		select @CardType = CardType from inserted
		select @CardLimit = CardLimit from inserted
		select @ValidityPeriod = ValidityPeriod from inserted
		select @AccountStatus = AccountStatus from inserted
		insert into ActivityLog values ('INSERTION','Inserted values into EMICard table ' + CAST(@RegNumber as varchar(40)) + ' ' + CAST(@CardID as varchar(40)) + ' ' + @CardType + ' ' + CAST(@CardLimit as varchar(40)) + ' ' +CAST(@ValidityPeriod as varchar(40)) + ' ' + @AccountStatus, DEFAULT)
END

GO

--STORED PROCEDURES


GO
create proc sp_GenerateCardID (@CardNum varbinary(MAX) out)
as
BEGIN
DECLARE @num1 varchar(4),
		@num2 varchar(4),
		@num3 varchar(4),
		@num4 varchar(4),
		@str1 varchar(8),
		@str2 varchar(8),
		@str varchar(MAX);
		set @num1 = CAST(FLOOR(RAND()*(999-100+1))+999 as varchar(4));
		set @num2 = CAST(FLOOR(RAND()*(999-100+1))+999 as varchar(4));
		set @num3 = CAST(FLOOR(RAND()*(999-100+1))+999 as varchar(4));
		set @num4 = CAST(FLOOR(RAND()*(999-100+1))+999 as varchar(4));
		set @str1 = CONCAT(@num1,@num2);
		print @str1
		set @str2 = CONCAT(@num3,@num4);
		print @str2
		set @str = CONCAT(@str1,@str2);
		declare @encryptedValue varbinary(MAX)
		SET @encryptedValue  = ENCRYPTBYPASSPHRASE('CardNumber',@str)
		set @CardNum = @encryptedValue
		
END

GO


create trigger EMICardGeneration 
ON Customers
FOR INSERT
AS
BEGIN

declare @CardNumber varbinary(MAX),
		@RegNumber int,
		@CardType varchar(10),
		@CardLimit int,
		@ValidityPeriod Date,
		@Encrypted varbinary(MAX),
		@AccountStatus varchar(20);
		exec sp_GenerateCardID @Encrypted out
		select @CardNumber = @Encrypted
		select @RegNumber = RegNumber from inserted
		select @CardType = CardType from inserted
		IF (@CardType = 'Gold')
			select @CardLimit = 50000
		ELSE
			select @CardLimit = 80000
		select @ValidityPeriod =  DATEADD(year,5,CAST(getdate() as date))
		select @AccountStatus = ApprovalStatus from inserted
		insert into EMICard values (@CardNumber,@RegNumber,@CardType,@CardLimit,@ValidityPeriod,@AccountStatus)
		END

GO

GO -- CUSTOMER REGISTRATION
create proc sp_InsertCustomer(@CustName varchar(30),
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
insert into Customers values (@CustName,@PhoneNo,@CustEmail,@CustUsername,@EncryptedPassword,@CustAddress,@CardType,@BankName,@EncryptedAccountNumber,@IFSCCode,@ApprovalStatus)

END
GO

GO
--LOGIN USER
create proc sp_LoginUser (@CustUsername varchar(30), @CustPassword nvarchar(MAX))
as
begin
select * from Customers where CustUsername = @CustUsername and @CustPassword = CAST(DECRYPTBYPASSPHRASE('FINANCELTI'+ @CustUsername,CustPassword) as nvarchar(MAX)) COLLATE SQL_Latin1_General_CP1_CS_AS

if @@ROWCOUNT = 0
	insert into ActivityLog values ('LOGIN', 'User : ' + @CustUsername + ' failed to Log in.',DEFAULT)
else
	insert into ActivityLog values ('LOGIN', 'User : ' + @CustUsername + ' Logged IN.',DEFAULT)
end

GO


-- FOR ADMIN
GO
begin
declare @encryptedValue varbinary(MAX)
SET @encryptedValue  = ENCRYPTBYPASSPHRASE('FINANCELTI',N'Admin@123')
insert into AdminCredentials values ('akshans',@encryptedValue)
end


GO


GO

create proc sp_LoginAdmin (@AdminUsername varchar(30), @AdmPassword nvarchar(MAX))
as
begin
select * from AdminCredentials where AdminUsername = @AdminUsername and @AdmPassword = DECRYPTBYPASSPHRASE('FINANCE',AdminPassword)
end

GO




--SP For Dashboard (Get Emi Card Details)
create or alter proc sp_getEMICardDetails(@username varchar(50))
as
begin

select c.CustName,e.CardID,CAST(DECRYPTBYPASSPHRASE('CardNumber',e.CardNumber) as varchar(MAX)) 'CardNumber',e.CardType,e.ValidityPeriod,e.CardLimit,e.AccountStatus from Customers c inner join EMICard e on e.RegNumber =c.RegNumber where c.CustUsername=@username
end

exec sp_getEMICardDetails 'Akshans'

select * from OrderDetails 
select * from EMICard
select * from Customers
select * from Products

select o.TransactionID,c.RegNumber,e.CardID,p.ProductID,o.Quantity,o.TotalAmount,o.EMIDuration,
o.EMIPaid,o.EMIBalance,o.CreatedDate from OrderDetails o,Customers c,EMICard e,Products p
where c.RegNumber=o.RegNumber and e.CardID=o.CardID and c.RegNumber=e.RegNumber 
and p.ProductID=o.ProductID and c.CustUsername='Akshans'

--SP For Dashboard (Get Order Details)
create or alter proc sp_getOrderDetails(@username varchar(50))
as
begin
select o.TransactionID,c.RegNumber,e.CardID,p.ProductID,o.Quantity,o.TotalAmount,o.EMIDuration,
o.EMIPaid,o.EMIBalance,o.CreatedDate from OrderDetails o,Customers c,EMICard e,Products p
where c.RegNumber=o.RegNumber and e.CardID=o.CardID and c.RegNumber=e.RegNumber and p.ProductID=o.ProductID and c.CustUsername=@username
end

exec sp_getOrderDetails 'rinky27'

--Insert value into Admin Table
begin
declare @encryptedValue varbinary(MAX)
SET @encryptedValue  = ENCRYPTBYPASSPHRASE('FINANCE',N'Admin@123')
insert into AdminCredentials values ('Disha',@encryptedValue)
end

