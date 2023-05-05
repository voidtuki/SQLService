--函数
--1、系统函数
--2、自定义函数：（1）标量值函数（返回单个值），
--				 （2）表值函数（返回查询结果）

--（1）编写一个函数求改银行的金额总和（没有参数，返回标量值）
use DBTEST2

drop function GetSumMoney
create function GetSumMoney() returns money --无参函数
as
begin
	declare @sum money
	select @sum = (select sum(CardMoney) from BankCard)
	return @sum
end

--函数名调用 dbo.函数名(),select表展示,print控制台展示
select dbo.GetSumMoney()

--（2）传入账户编号，返回账户真实姓名（有参数，返回标量值）
create function GetRealNameById(@accid int) returns varchar(30)
begin
	declare @name varchar(30)
	select @name =  (select RealName from AccountInfo where AccountId = @accid)
	return @name
end


select * from AccountInfo
select dbo.GetRealNameById(3)

--（3）传递开始时间和结束时间，返回交易记录（存钱取钱），
--交易记录中包含 真实姓名，卡号，存钱金额，取钱金额，交易时间
--（有参数，返回表值）

--方案1
drop function GetRecordByTime
create function GetRecordByTime(@start varchar(30),@end varchar(30))
returns @result table  --返回表值的数据结构
(
	RealName varchar(20),
	CardNo varchar(30),
	MoneyInBank money,
	MoneyOutBank money,
	ExchangeTime smalldatetime
)
--函数体
as
begin 
	--向表里添加查询的结果
	insert into @result
	select RealName 真实姓名,BankCard.CardNo 卡号,MoneyInBank 存钱金额,
	MoneyOutBank 取钱金额,ExchangeTime 交易时间 from CardExchange
	inner join BankCard on BankCard.CardNo = CardExchange.CardNo
	inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
	--因为smalldatetime有时分秒，所以得自己加上才能比较，记得空格+时:分:秒
	where ExchangeTime between @start+' 00:00:00' and @end + ' 23:59:59'
	--将表作为返回值返回
	return
end

select * from GetRecordByTime('2023-4-22','2023-4-23')

--方案2，简化版本
create function GetRecordByTime(@start varchar(30),@end varchar(30))
returns table  --返回表值的数据结构
--函数体
as
	--向表里添加查询的结果
	return
	select RealName 真实姓名,BankCard.CardNo 卡号,MoneyInBank 存钱金额,
	MoneyOutBank 取钱金额,ExchangeTime 交易时间 from CardExchange
	inner join BankCard on BankCard.CardNo = CardExchange.CardNo
	inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
	--因为smalldatetime有时分秒，所以得自己加上才能比较，记得空格+时:分:秒
	where ExchangeTime between @start+' 00:00:00' and @end + ' 23:59:59'
	--将表作为返回值返回
go

