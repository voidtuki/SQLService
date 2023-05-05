--存储过程
use DBTEST2

--（1）没有输入参数，没有输出参数的存储过程
--定义存储过程实现查询出账户余额最低的银行卡账户信息，显示银行卡号，姓名，账户余额
--方案1，单个
drop proc proc_MinMoneyCard
create proc proc_MinMoneyCard
as
	select top 1 CardNo,RealName,CardMoney from BankCard
	inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
	order by CardMoney
go

--调用存储过程
exec proc_MinMoneyCard

--方案2：（余额最低，多个人并列，都可以查出来）
create proc proc_MinMoneyCard
as
	select CardNo,RealName,CardMoney from BankCard
	inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
	where CardMoney = 
	(select Min(CardMoney) from BankCard)
go

--调用存储过程
exec proc_MinMoneyCard

--（2）有输入参数，没有输出参数的存储过程
--模拟银行卡存钱操作，传入银行卡号，存钱金额，实现存钱操作
drop proc proc_Cunqian
create proc proc_Cunqian
@CardNo varchar(30),
@money money
as
	--存钱，更新银行卡表余额
	update BankCard set CardMoney = CardMoney + @money
	where CardNo = @CardNo

	--插入存钱数据到交易信息表
	insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
	values(@CardNo,@money,0,GETDATE())
go

--调用存储过程
select * from BankCard
select * from CardExchange
exec proc_Cunqian '6225125478544587',1000

--（3）有输入参数，没有输入参数，但是有返回值的存储过程（返回值必须整数）
--模拟银行卡取钱操作，传入银行卡号，取钱金额，实现取钱操作
--取钱成功，返回1，取钱失败返回-1
alter table BankCard add constraint CardMoney check(CardMoney >= 0)

drop proc proc_Quqian
create proc proc_Quqian
@CardNo varchar(30),
@money money
as
	--取钱更新银行卡表
	update BankCard set CardMoney = CardMoney - @money
	where CardNo = @CardNo

	--错误判断
	if @@ERROR <> 0
		return -1

	--添加取钱信息至交易信息表
	insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
	values(@CardNo,0,@money,GETDATE())

	return 1
go

--调用存储过程
select * from BankCard
select * from CardExchange

--创建一个变量接受结果
declare @returnValue int
exec @returnValue = proc_Quqian '6225123412357896',1000
select @returnValue

--（4）有输入参数，有输出参数的存储过程
--查询出某时间段的银行存取款信息以及存款总金额，取款总金额
--传入开始时间，结束时间，显示存取款交易信息的同时，返回存款总金额，取款总金额。
drop proc proc_selectExChange
create proc proc_selectExChange
@start varchar(30),
@end varchar(30),
--输出参数带上修饰符，output
@sumIn money output,
@sumOut money output
as
	--日期拼接字符串一定带上空格
	--存钱总金额
	select @sumIn = (select sum(MoneyInBank) from CardExchange
	where ExchangeTime between @start + ' 00:00:00' and @end + ' 23:59:59')
	--取钱总金额
	select @sumOut = (select sum(MoneyOutBank) from CardExchange
	where ExchangeTime between @start + ' 00:00:00' and @end + ' 23:59:59')

	--查看交易信息表，开始时间-结束时间
	select * from CardExchange where ExchangeTime between
	@start + ' 00:00:00' and @end + ' 23:59:59'
go

--调用存储过程
select * from BankCard
select * from CardExchange
--定义两个参数来接收输出参数，后面要带output修饰符
declare @sumIn money
declare @sumOut money
exec proc_selectExChange '2023-1-1','2023-12-31',@sumIn output,@sumOut output
select @sumIn
select @sumOut

--（5）具有同时输入输出参数的存储过程
--密码升级，传入卡号和密码，如果卡号密码正确，并且密码长度<8，自动升级成8位密码
drop proc proc_pwdUpgrade
create proc proc_pwdUpgrade
@cardNo varchar(30),
--同时具有输入输出参数的类型，取决于传入之前是否传值
@cardPwd varchar(30) output
as
	--判断是否存在此银行卡
	if not exists(select * from BankCard where CardNo = @cardNo and CardPwd = @cardPwd)
		set @cardPwd = ''
	else
	begin
		--存在判断密码长度，或者升级
		declare @len int = 8 - len(@cardPwd)
		declare @i int = 0
		--如果密码长度小于8，不安全，需要自动升级，后面两位变为随机数
		while @i < @len
		begin
			--如果长度不满足
			--floor将浮点数变为整数，rand随机浮点数，拼接字符串强转
			set @cardPwd = @cardPwd + convert(varchar(1),floor(rand()*10))
			set @i = @i + 1
		end

		--更新银行卡表
		update BankCard set CardPwd = @cardPwd where CardNo = @cardNo
	end
go

--调用存储过程
select * from BankCard

--如果输出参数有值，那么变为输入输出参数
declare @cardPwd  varchar(30) = '123456'
exec proc_pwdUpgrade '6225125478544587',@cardPwd output
--更改后的密码
select @cardPwd