USE [master]
GO
/****** Object:  Database [FINANCE]    Script Date: 19-04-2021 11:25:38 ******/
CREATE DATABASE [FINANCE]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'FINANCE', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\FINANCE.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'FINANCE_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\FINANCE_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [FINANCE] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [FINANCE].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [FINANCE] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [FINANCE] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [FINANCE] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [FINANCE] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [FINANCE] SET ARITHABORT OFF 
GO
ALTER DATABASE [FINANCE] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [FINANCE] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [FINANCE] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [FINANCE] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [FINANCE] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [FINANCE] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [FINANCE] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [FINANCE] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [FINANCE] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [FINANCE] SET  ENABLE_BROKER 
GO
ALTER DATABASE [FINANCE] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [FINANCE] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [FINANCE] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [FINANCE] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [FINANCE] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [FINANCE] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [FINANCE] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [FINANCE] SET RECOVERY FULL 
GO
ALTER DATABASE [FINANCE] SET  MULTI_USER 
GO
ALTER DATABASE [FINANCE] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [FINANCE] SET DB_CHAINING OFF 
GO
ALTER DATABASE [FINANCE] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [FINANCE] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [FINANCE] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [FINANCE] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'FINANCE', N'ON'
GO
ALTER DATABASE [FINANCE] SET QUERY_STORE = OFF
GO
USE [FINANCE]
GO
/****** Object:  Table [dbo].[ActivityLog]    Script Date: 19-04-2021 11:25:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActivityLog](
	[ActivityID] [int] IDENTITY(1,1) NOT NULL,
	[LogType] [varchar](20) NULL,
	[ActivityDesc] [varchar](200) NULL,
	[ActivityTimeStamp] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ActivityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AdminCredentials]    Script Date: 19-04-2021 11:25:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AdminCredentials](
	[AdminUsername] [varchar](20) NOT NULL,
	[AdminPassword] [varbinary](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AdminUsername] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 19-04-2021 11:25:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[RegNumber] [int] IDENTITY(1,1) NOT NULL,
	[CustName] [varchar](30) NOT NULL,
	[PhoneNo] [bigint] NOT NULL,
	[CustEmail] [varchar](30) NOT NULL,
	[CustUsername] [varchar](30) NOT NULL,
	[CustPassword] [varbinary](max) NOT NULL,
	[CustAddress] [varchar](50) NOT NULL,
	[CardType] [varchar](10) NOT NULL,
	[BankName] [varchar](30) NOT NULL,
	[AccountNumber] [varbinary](max) NOT NULL,
	[IFSCCode] [varchar](11) NOT NULL,
	[ApprovalStatus] [varchar](10) NOT NULL,
	[OtpExpiry] [datetime] NULL,
	[EmailVerfication] [bit] NULL,
	[ActivationCode] [uniqueidentifier] NULL,
	[Otp] [nvarchar](4) NULL,
PRIMARY KEY CLUSTERED 
(
	[RegNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[CustUsername] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[CustEmail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[PhoneNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EMICard]    Script Date: 19-04-2021 11:25:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMICard](
	[CardID] [int] IDENTITY(1,1) NOT NULL,
	[CardNumber] [varbinary](max) NOT NULL,
	[RegNumber] [int] NULL,
	[CardType] [varchar](10) NOT NULL,
	[CardLimit] [int] NOT NULL,
	[ValidityPeriod] [date] NOT NULL,
	[AccountStatus] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CardID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetails]    Script Date: 19-04-2021 11:25:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetails](
	[TransactionID] [int] IDENTITY(1,1) NOT NULL,
	[RegNumber] [int] NULL,
	[CardID] [int] NULL,
	[ProductID] [int] NULL,
	[Quantity] [int] NOT NULL,
	[TotalAmount] [int] NOT NULL,
	[EMIDuration] [int] NOT NULL,
	[EMIPaid] [int] NOT NULL,
	[EMIBalance] [int] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[Iteration] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 19-04-2021 11:25:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [varchar](30) NOT NULL,
	[ProductDesc] [varchar](100) NOT NULL,
	[ProductStock] [int] NOT NULL,
	[ProductPrice] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ActivityLog] ADD  DEFAULT (getdate()) FOR [ActivityTimeStamp]
GO
ALTER TABLE [dbo].[Customers] ADD  DEFAULT (getdate()) FOR [OtpExpiry]
GO
ALTER TABLE [dbo].[OrderDetails] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[EMICard]  WITH CHECK ADD FOREIGN KEY([RegNumber])
REFERENCES [dbo].[Customers] ([RegNumber])
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD FOREIGN KEY([CardID])
REFERENCES [dbo].[EMICard] ([CardID])
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD FOREIGN KEY([ProductID])
REFERENCES [dbo].[Products] ([ProductID])
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD FOREIGN KEY([RegNumber])
REFERENCES [dbo].[Customers] ([RegNumber])
GO
/****** Object:  StoredProcedure [dbo].[sp_ApproveUser]    Script Date: 19-04-2021 11:25:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[sp_ApproveUser] (@RegNumber int)
as
begin
	update Customers
	set ApprovalStatus = 'Approved'
	where RegNumber = @RegNumber
	insert into ActivityLog values ('UPDATE','Approved Customer ' + cast(@RegNumber as varchar(30)),DEFAULT)
end
GO
/****** Object:  StoredProcedure [dbo].[sp_BUYNOW]    Script Date: 19-04-2021 11:25:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[sp_BUYNOW] (@RegNumber int, @ProductID int, @Quantity int,@EMIDuration int)
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


GO
/****** Object:  StoredProcedure [dbo].[sp_CreditDetails]    Script Date: 19-04-2021 11:25:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create    proc [dbo].[sp_CreditDetails](@RegNumber int)
as
begin
    declare @TotalCredit int,
            @CreditUsed int,
            @RemainingCredit int
 
    if ((select CardType from EMICard where RegNumber = @RegNumber) = 'Gold')
        set @TotalCredit= 50000
    else
        set @TotalCredit = 80000
 
    set @CreditUsed = (select SUM(EMIBalance) from OrderDetails where RegNumber = @RegNumber)
    set @RemainingCredit = @TotalCredit - @CreditUsed
    select @TotalCredit TotalCredit,@CreditUsed CreditUsed,@RemainingCredit RemainingCredit
end
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteUser]    Script Date: 19-04-2021 11:25:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[sp_DeleteUser] (@RegNumber int)
as
begin
	BEGIN TRANSACTION
		delete from OrderDetails where RegNumber = @RegNumber
		delete from EMICard where RegNumber = @RegNumber
		delete from Customers where RegNumber = @RegNumber
		insert into ActivityLog values ('DELETE','DELTED USER : ' + CAST(@RegNumber as varchar(40)),default)
	COMMIT TRANSACTION
end
GO
/****** Object:  StoredProcedure [dbo].[sp_GenerateCardID]    Script Date: 19-04-2021 11:25:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_GenerateCardID] (@CardNum varbinary(MAX) out)
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
/****** Object:  StoredProcedure [dbo].[sp_getEMICardDetails]    Script Date: 19-04-2021 11:25:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   proc [dbo].[sp_getEMICardDetails](@username varchar(50))
as
begin

select e.RegNumber, c.CustName,e.CardID,CAST(DECRYPTBYPASSPHRASE('CardNumber',e.CardNumber) as varchar(MAX)) 'CardNumber',e.CardType,e.ValidityPeriod,e.CardLimit,e.AccountStatus from Customers c inner join EMICard e on e.RegNumber =c.RegNumber where c.CustUsername=@username
end
GO
/****** Object:  StoredProcedure [dbo].[sp_getOrderDetails]    Script Date: 19-04-2021 11:25:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[sp_getOrderDetails](@username varchar(50))
as
begin
select o.TransactionID,c.RegNumber,e.CardID,p.ProductID,o.Quantity,o.TotalAmount,o.EMIDuration,
o.EMIPaid,o.EMIBalance,o.CreatedDate from OrderDetails o,Customers c,EMICard e,Products p
where c.RegNumber=o.RegNumber and e.CardID=o.CardID and c.RegNumber=e.RegNumber and p.ProductID=o.ProductID and c.CustUsername=@username
end

GO
/****** Object:  StoredProcedure [dbo].[sp_GetPurchasedProduct]    Script Date: 19-04-2021 11:25:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---For Dashboard (Get Purchased Product)
create   proc [dbo].[sp_GetPurchasedProduct] (@RegNumber int)
as
begin
select p.ProductID,p.ProductName,o.Quantity,o.TotalAmount from Products p, OrderDetails o
where p.ProductID = o.ProductID and o.RegNumber = @RegNumber
end
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertCustomer]    Script Date: 19-04-2021 11:25:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------Stored Procedure for InsertCustomer
CREATE proc [dbo].[sp_InsertCustomer]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertOTP]    Script Date: 19-04-2021 11:25:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   proc [dbo].[sp_InsertOTP] (@CustEmail varchar(30), @Otp varchar(4))
as
begin
update Customers
set Otp = @Otp, OtpExpiry = default
where CustEmail = @CustEmail
end


GO
/****** Object:  StoredProcedure [dbo].[sp_LoginAdmin]    Script Date: 19-04-2021 11:25:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[sp_LoginAdmin] (@AdminUsername varchar(30), @AdmPassword nvarchar(MAX))
as
begin
select * from AdminCredentials where AdminUsername = @AdminUsername and @AdmPassword = DECRYPTBYPASSPHRASE('FINANCE',AdminPassword)
end

GO
/****** Object:  StoredProcedure [dbo].[sp_LoginUser]    Script Date: 19-04-2021 11:25:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--LOGIN USER
create proc [dbo].[sp_LoginUser] (@CustUsername varchar(30), @CustPassword nvarchar(MAX))
as
begin
select * from Customers where CustUsername = @CustUsername and @CustPassword = CAST(DECRYPTBYPASSPHRASE('FINANCELTI'+ @CustUsername,CustPassword) as nvarchar(MAX)) COLLATE SQL_Latin1_General_CP1_CS_AS

if @@ROWCOUNT = 0
	insert into ActivityLog values ('LOGIN', 'User : ' + @CustUsername + ' failed to Log in.',DEFAULT)
else
	insert into ActivityLog values ('LOGIN', 'User : ' + @CustUsername + ' Logged IN.',DEFAULT)
end

GO
/****** Object:  StoredProcedure [dbo].[sp_RefreshEMI]    Script Date: 19-04-2021 11:25:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[sp_RefreshEMI]
as
begin
BEGIN TRANSACTION
update OrderDetails
set EMIPaid = EMIPaid + CEILING(TotalAmount/EMIDuration),
Iteration = Iteration + 1
where Iteration < EMIDuration -- to filter out paid ones

update OrderDetails
set EMIBalance = CEILING(TotalAmount-EMIPaid)
where Iteration < EMIDuration -- to filter out paid ones

update OrderDetails
set EMIBalance = 0, EMIPaid=TotalAmount
where Iteration = EMIDuration

if (@@ROWCOUNT > 0)
insert into ActivityLog values ('EMI_UPD','EMI updated for every user, check your order details for more info',DEFAULT)
else
insert into ActivityLog values ('EMI_UPD',null,DEFAULT)
COMMIT TRANSACTION

end
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateApproval]    Script Date: 19-04-2021 11:25:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[sp_UpdateApproval](@RegNumber int)
as
begin
update Customers
set ApprovalStatus = 'Approved'
update EMICard
set AccountStatus='Approved'
where RegNumber = @RegNumber
end

GO
/****** Object:  StoredProcedure [dbo].[sp_UpdatePassword]    Script Date: 19-04-2021 11:25:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   proc [dbo].[sp_UpdatePassword](@otp varchar(20),@CustEmail varchar(40),@CustPassword nvarchar(400))
as
begin 
DECLARE @EncryptedPassword varbinary(MAX),
@CustUsername varchar(40)
if (getdate() > DATEADD(MINUTE,1,CAST((select OtpExpiry from Customers where CustEmail = @CustEmail) as datetime)))
BEGIN
print 'OTP EXPIRED'
return --hehe expired
END
BEGIN TRANSACTION
set @CustUsername = (select CustUsername from Customers where CustEmail = @CustEmail)
set @EncryptedPassword = ENCRYPTBYPASSPHRASE('FINANCELTI'+ @CustUsername,@CustPassword)update Customers set CustPassword = @EncryptedPassword
where Otp=@otp and CustEmail = @CustEmail update Customers set Otp=NUll
where Otp=@otp and CustEmail = @CustEmail
COMMIT TRANSACTION
end
GO
/****** Object:  StoredProcedure [dbo].[sp_ValidateUser]    Script Date: 19-04-2021 11:25:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   proc [dbo].[sp_ValidateUser] (
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

GO
USE [master]
GO
ALTER DATABASE [FINANCE] SET  READ_WRITE 
GO
