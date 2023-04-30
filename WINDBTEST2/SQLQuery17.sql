--T-SQL中使用的运算符分为7种
--算术运算符：加（+）、减（-）、乘（*）、除（/）、模（%）
--逻辑运算符：AND、OR、LIKE、BETWEEN、IN、EXISTS、NOT、ALL、ANY
--赋值运算符：=
--字符串运算符：+
--比较运算符：=、>、<、>=、<=、<>
--位运算符：|、&、^
--复合运算符：+=、-=、/=、%=、*=

--（1）已知长方形的长和宽，求长方形的周长和面积
declare @length int = 10
declare @breadth int = 5
declare @perimeter int
set @perimeter = (@length+@breadth)*2
declare @area int
set @area = @length * @breadth

--SQL中+号拼接字符串，不能将int变为varchar类型
--方法1，使用Convert()函数转换类型，Convert(类型，值)
print '长方形周长为：'+Convert(varchar,@perimeter)
print '长方形面积为：'+Convert(varchar,@area)

--方法2，使用cast()函数，cast(值 as 类型)
print '长方形周长为：'+cast(@perimeter as varchar(10))
print '长方形面积为：'+cast(@area as varchar(10))

use DBTEST2

--（2）查询银行卡状态为冻结，并且余额超过1000000的银行卡信息
select * from BankCard
inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId

update BankCard set CardMoney = 1000000,CardState = 3
where AccountId = 1

select * from BankCard
where CardState = 3 and CardMoney >= 1000000

--（3）查询银行卡状态为冻结或者余额等于0的银行卡信息
select * from BankCard
where CardState = 3 or CardMoney = 0

--（4）查询出姓名中含有'刘'账户的信息以及银行卡信息
--方法1 通配符 %
select * from AccountInfo
inner join BankCard on AccountInfo.AccountId = BankCard.AccountId
where RealName like '刘%'
--方法2 通配符 _ 单个字符
select * from AccountInfo
inner join BankCard on AccountInfo.AccountId = BankCard.AccountId
where RealName like '刘_'

select * from AccountInfo
inner join BankCard on AccountInfo.AccountId = BankCard.AccountId
where AccountPhone like '13[0-9]%5'

--（5）查询余额在2000-5000之间的银行卡信息
--方法1 关系运算符 >
select * from BankCard
where CardMoney >= 2000 and CardMoney <= 5000

--方法2 逻辑运算符 between
select * from BankCard
where CardMoney between 2000 and 5000

--（6）查询出银行卡状态为冻结或者注销的银行卡信息
--方法1
select * from BankCard
where CardState = 3 or CardState = 4

--方法2
select * from BankCard
where CardState in (3,4)

--（7）关羽身份证：420107199507104133，关羽到银行来开户
--查询身份证在账户表是否存在，不存在则进行开户开卡，存在则不开户直接开卡
--限制一个账号只能开3张卡

select * from AccountInfo
select * from BankCard

delete from BankCard where CardNo = '62251254782323127'

declare @AccountId int -- 账户编号
declare @CardCount int -- 卡数量
if EXISTS(select * from AccountInfo where AccountCode = '420107199507104133')
begin
	--在表中存在不开户只开卡
	select @AccountId =
	(select AccountId from AccountInfo where AccountCode = '420107199507104133')


	--查询卡数量
	select @CardCount = 
	(select count(CardNo) from BankCard where BankCard.AccountId = @AccountId)
	--小于3张，还可以再开1张
	if @CardCount <=2
		begin
			insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState,CardTime)
			values('62251254782323122',@AccountId,'123456',0,1,GETDATE())
		end
	else
		begin
			print '您的开卡数量已达上限'
			print '开卡数量：'+Convert(varchar,@CardCount)
			select * from BankCard 
			inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
			where BankCard.AccountId = @AccountId
		end
end
else
begin
	--不存在表中开户开卡
	insert into AccountInfo(AccountCode,AccountPhone,RealName,OpenTime)
	values('420107199507104133',13454788854,'关羽',GETDATE())
	set @AccountId = @@IDENTITY --自动编号，从尾部开始
	insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState,CardTime)
	values('6225547858741263',@AccountId,'123456',0,1,GETDATE())
end

--（8）查询银行卡账户余额，是不是所有账户余额都超过了3000
-- 逻辑运算符 all
--格式 value 关系运算符 all()
if 3000 <= all(select CardMoney from BankCard)
	begin
		print '所有账户余额都超过了3000'
	end
else
	begin
		print '部分账户余额未超过了3000'
	end

--（9）查询银行卡账户余额，是否含有账户余额超过了300000000信息
if 300000000 <= any(select CardMoney from BankCard)
	begin
		print '有账户余额超过了300000000'
	end
else
	begin
		print '未有账户余额超过300000000'
	end
