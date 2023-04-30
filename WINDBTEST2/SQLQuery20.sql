use DBTEST2

--（1）关羽银行卡号为“6225547858741263”，
--查询出余额比关羽多的银行卡信息，显示卡号，身份证、姓名、余额
--方法1 子查询
select CardNo 卡号,AccountCode 身份证,RealName 姓名,CardMoney 余额 from BankCard
inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
where CardMoney > 
(select CardMoney from BankCard where CardNo = '6225547858741263' ) 

--方法2 使用变量
declare @balance int;
select @balance = (select CardMoney from BankCard where CardNo = '6225547858741263')
select CardNo 卡号,AccountCode 身份证,RealName 姓名,CardMoney 余额 from BankCard
inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
where CardMoney > @balance

--（2）从所有账户信息中查询出余额最高的交易明细（存钱取钱信息）
--方法2，如果有多个人余额一样，并且都是最高，下面查询只能查出一个
--方法1 子查询
--如果有多个人余额一样，并且都是最高，需要都查出来
--逻辑运算符in，可存在多个值，关系运算符=，只能接收一个值
select * from BankCard
select * from CardExchange where CardNo in
(select CardNo from BankCard where CardMoney =
(select MAX(CardMoney) from BankCard ))

--方法2 先排序top1，子查询
select * from BankCard
select * from CardExchange
where CardNo = 
(select top 1 CardNo from BankCard 
order by CardMoney desc)

--（3）查询有取款记录的银行卡及账户信息，显示卡号，身份证，姓名，余额
--方法1 取款记录不为null的银行卡号
--以下代码，关系运算符=只能获取一个值，多个值报错
select * from CardExchange
select CardNo 卡号,AccountCode 身份证,RealName 姓名,CardMoney 余额 from BankCard
inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
where
CardNo = (select CardNo from CardExchange where MoneyOutBank <> 0)

--方法2 关系运算符<>
--使用in来判断，获取多个值，<>不等于空
select * from CardExchange
select CardNo 卡号,AccountCode 身份证,RealName 姓名,CardMoney 余额 from BankCard
inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
where
CardNo in (select CardNo from CardExchange where MoneyOutBank <> 0)


--查找多条取钱记录的账户信息
--先取钱
select * from BankCard
select * from CardExchange
--更新银行卡表
update BankCard set CardMoney = CardMoney - 2000
where CardNo = '6225125478544587'
--插入数据至交易信息表
insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
values('6225125478544587',0,2000,GETDATE())

--（4）查询出没有存款记录的银行卡及账户信息，显示卡号，身份证，姓名，余额
select * from BankCard
inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
inner join CardExchange on CardExchange.CardNo = BankCard.CardNo

select * from CardExchange
select CardNo 卡号,AccountCode 身份证,RealName 姓名,CardMoney 余额 from BankCard
inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
where
--是没有存款记录，而不是存款金额为0
CardNo not in (select CardNo from CardExchange where MoneyinBank <> 0)

--（5）关羽的银行卡号为“6225547858741263”，查询当天是否有收到转账
if exists(select * from CardTransfer
					where CardNoIn = '6225547858741263'
					--注意时间转换为字符串时，需要给长度
					and CONVERT(varchar(10),TransferTime) = CONVERT(varchar(10),GETDATE()))
	print '有转账'
else 
	print '无转账'

--刘备转账给关羽1000块
select RealName 姓名,CardNo 卡号,CardMoney 余额 from BankCard
inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
--转账金额
declare @TransferMoney int = 1000
--更新银行卡信息
update BankCard set CardMoney = CardMoney + @TransferMoney
where CardNo = '6225547858741263'--关羽
update BankCard set CardMoney = CardMoney - @TransferMoney
where CardNo = '6225125478544587'--刘备
--插入数据到转账信息表
insert into CardTransfer(CardNoOut,CardNoIn,TransferMoney,TransferTime)
values('6225125478544587','6225547858741263',@TransferMoney,GETDATE())

--（6）查询出交易次数（存储取款操作）最多的银行卡账户信息，显示
--卡号，身份证，姓名，余额，交易次数
--方法1 只能查询一个值
select * from CardExchange
select * from BankCard
inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
--使用分组查询和聚合函数count（统计此字段出现次数）
--使用分组统计后的临时表作为内连接的字段，来查询
inner join (select CardNo,Count(*) exchangeCount from CardExchange group by CardNo)
CardExchangeTemp on BankCard.CardNo = CardExchangeTemp.CardNo
--以次数降序排列
order by exchangeCount desc

--方法2
--可以查询多个值
--(如果有多个人交易次数相同，都是交易次数最多，则使用以下方案)
select  BankCard.CardNo 卡号,AccountCode 身份证,RealName 姓名,CardMoney 余额,交易次数 
from AccountInfo
inner join BankCard on AccountInfo.AccountId = BankCard.AccountId
inner join
(select CardNo,COUNT(*) 交易次数 from CardExchange group by CardNo) Temp 
on BankCard.CardNo = Temp.CardNo
--如果有相同的最多交易次数，使用以下条件
where 交易次数 = (select max(交易次数) from
(select CardNo,COUNT(*) 交易次数 from CardExchange group by CardNo) Temp )

--（7）查询出没有转账交易记录的银行卡信息，显示卡号，身份证，姓名，余额
select CardNo 卡号,AccountCode 身份证,RealName 姓名,CardMoney 余额 from BankCard
inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
where CardNo not in
--查出有没有转账记录卡号即可
(select CardNoIn from CardTransfer)
and
CardNo not in
(select CardNoOut from CardTransfer)