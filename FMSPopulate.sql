GO -- add dummy credentials to check
exec sp_InsertCustomer 
@CustName = 'Akshans Rautela',
@PhoneNo = 8108917503,
@CustEmail = 'akshans.rautela@lntinfotech.com',
@CustUsername ='Akshans',
@CustPassword = 'Hello@123', 
@CustAddress = 'Mumbai, Mahrastra, India',
@CardType = 'Platinium',
@BankName = 'SBI',
@AccountNumber = '1122334455',
@IFSCCode = 'SBI001@123',
@ApprovalStatus = 'Approved'

GO

exec sp_InsertCustomer 
@CustName = 'zero one',
@PhoneNo = 12345677,
@CustEmail = 'zeroone@gmail.com',
@CustUsername ='zero',
@CustPassword = 'Hello@123', 
@CustAddress = 'Mumbai, Mahrastra, India',
@CardType = 'Platinium',
@BankName = 'SBI',
@AccountNumber = '1122334455',
@IFSCCode = 'SBI001@123',
@ApprovalStatus = 'Approved'

GO
exec sp_InsertCustomer 
@CustName = 'four',
@PhoneNo = 123456377,
@CustEmail = 'four@gmail.com',
@CustUsername ='four',
@CustPassword = 'Hello@123', 
@CustAddress = 'Mumbai, Mahrastra, India',
@CardType = 'Gold',
@BankName = 'SBI',
@AccountNumber = '1122334455',
@IFSCCode = 'SBI001@123',
@ApprovalStatus = 'Approved'
GO

insert into Products values ('Harpic','Hema, Rekha, Jaya aur Sushma... Sabki pasand nirmaaa, N I R M A',100,500)
insert into Products values ('iPhone','The new Innovation in technology is here, buy the new Iphone',50,50000)
insert into Products values ('Clock','Time is a relative function, it is relative to gravity probably',10,2000)

GO

insert into OrderDetails values (1,1,1,1,500,3,100,200,DEFAULT)
insert into OrderDetails values (1,2,1,1,500,3,100,200,DEFAULT)
insert into OrderDetails values (1,1,1,1,500,3,100,200,DEFAULT)

select * from EMICard
select * from Customers
select c.CustName,e.CardID,e.CardNumber,e.CardType,e.ValidityPeriod,e.CardLimit from Customers c inner join EMICard e on e.RegNumber =c.RegNumber where e.RegNumber=1
select * from OrderDetails


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
where c.RegNumber=o.RegNumber and e.CardID=o.CardID and c.RegNumber=e.RegNumber and p.ProductID=o.ProductID and c.CustUsername='Akshans'
end

--Insert value into Admin Table
begin
declare @encryptedValue varbinary(MAX)
SET @encryptedValue  = ENCRYPTBYPASSPHRASE('FINANCE',N'Admin@123')
insert into AdminCredentials values ('Disha',@encryptedValue)
end

select * from AdminCredentials