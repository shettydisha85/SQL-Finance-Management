create or alter proc sp_ApproveUser (@RegNumber int)
as
begin
	update Customers
	set ApprovalStatus = 'Approved'
	where RegNumber = @RegNumber
	insert into ActivityLog values ('UPDATE','Approved Customer ' + cast(@RegNumber as varchar(30)),DEFAULT)
end

create or alter proc sp_DeleteUser (@RegNumber int)
as
begin
	BEGIN TRANSACTION
		delete from OrderDetails where RegNumber = @RegNumber
		delete from EMICard where RegNumber = @RegNumber
		delete from Customers where RegNumber = @RegNumber
		insert into ActivityLog values ('DELETE','DELTED USER : ' + CAST(@RegNumber as varchar(40)),default)
	COMMIT TRANSACTION
end

Update Customers
set ApprovalStatus='Pending'

select * from Customers

exec sp_RefreshEMI

select * from ActivityLog

select * from OrderDetails

update orderdetails
set iteration=0

truncate table orderdetails

exec sp_buynow 

sp_helptext sp_RefreshEMI

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

drop table OrderDetails


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
CreatedDate datetime default getdate(),
Iteration int not null
)

select * from OrderDetails


--
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


select * from OrderDetails
select * from EMICard

exec sp_RefreshEMI

---SP For Dashboard ()

create  or alter proc sp_CreditDetails(@RegNumber int)
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

exec sp_CreditDetails 1
drop proc sp_CreditDetails

---For Dashboard (Get Purchased Product)
create or alter proc sp_GetPurchasedProduct (@RegNumber int)
as
begin
select p.ProductID,p.ProductName,o.Quantity,o.TotalAmount from Products p, OrderDetails o
where p.ProductID = o.ProductID and o.RegNumber = @RegNumber
end