--信息打印
--终端输出
print 'hello,sql'
--表格输出
select 'hello,sql'

--变量：（1）局部变量 （2）全局变量
--（1）局部变量：以@开头，先声明，再赋值
declare @str varchar(20)
set @str = 'i like sql'
--select @str = 'i like sql'
print @str
--set和select进行赋值的时候的区别
--set:赋值变量指定的值,一条
--select:一般用于表中查询出的数据赋值给变量,
--如果查询结果有多条,取最后一条赋值,多条
--exp:select @a = 字段名 from 表名
--当前表最后一个字段的值赋值给a






--（2）全局变量：（1）以@@作为前缀
--				 （2）由系统进行定义和维护,只读

--@@ERROR：返回执行的上一个语句的错误号
--@@IDENTITY：返回最后插入的标识值
--@@MAX_CONNECTIONS：返回允许同时进行的最大用户连接数
--@@ROWCOUNT：返回受上一语句影响的行数
--@@SERVERNAME：返回运行 SQL Server 的本地服务器的名称
--@@SERVICENAME：返回 SQL Server 正在其下运行的注册表项的名称
--@@TRANCOUNT：返回当前连接的活动事务数
--@@LOCK_TIMEOUT：返回当前会话的当前锁定超时设置（毫秒）


delete from AccountInfo where AccountId = 4
select * from AccountInfo
--示例
--(1)为赵云此人进行开户开卡操作,赵云身份证：420107199904054233
insert into AccountInfo(AccountCode,AccountPhone,RealName,OpenTime)
values('420107199904054233','15878547898','赵云',GETDATE())
--不知道具体自动编号，获取最后一次插入的编号值
declare @AccountId int
set @AccountId = @@IDENTITY
insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
values('6225123412357896',@AccountId,'123456',0,1)

--(2)需要求出张飞的银行卡卡号和余额，张飞身份证：420107199602034138
--方案1
select CardNo 银行卡号,CardMoney 余额 from BankCard
inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
where AccountCode = '420107199602034138'

--方案2
declare @AccountId int
--使用查询结果作为条件，用select
--select @AccountId = (select AccountId from AccountInfo where AccountCode = '420107199602034138')
select @AccountId =AccountId from AccountInfo where AccountCode = '420107199602034138'
select CardNo 银行卡号,CardMoney 余额 from BankCard where AccountId = @AccountId


--go语句
--(1)等待go语句之前代码执行完成之后才能执行后面的代码

use DBTEST2
drop database DBTEST3
create database DBTEST3
--等待数据库建立完成
go
--切换数据库
use DBTEST3
--账户信息表：存储个人信息
create table AccountInfo
(
	AccountId int primary key identity(1,1), --账户编号
	AccountCode varchar(20) not null, -- 身份证号码
	AccountPhone varchar(20) not null, -- 电话号码
	RealName varchar(20) not null, -- 真实姓名
	OpenTime smalldatetime not null, -- 开户时间
)

--银行卡表：存储银行卡信息
create table BankCard
(
	CardNo varchar(30) primary key, -- 银行卡卡号
	AccountId int not null, -- 账户编号（与账户信息表形成主外键关系）
	CardPwd varchar(30) not null, -- 银行卡密码
	CardMoney money not null, -- 银行卡余额
	CardState int not null, -- 1：正常，2：挂失，3：冻结，4：注销
	CardTime smalldatetime default(GETDATE()) -- 开卡时间
)

--(2)批处理结束的一个标志，作用域结束
declare @num int --@num作用范围：在此作用域全局
set @num = 100
set @num = 200

declare @num1 int --@num作用范围：在此作用域在go之前
set @num1 = 100
go
set @num1 = 200

go
declare @num1 int --@num作用范围：在此作用域在两个go之间
set @num1 = 100
go
set @num1 = 200
