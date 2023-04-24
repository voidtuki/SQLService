--数据库设计案例

create database DBTEST2

--业务需求说明
--模拟银行业务，设计简易版的银行数据库表结构，要求可以完成以下基本功能需求：
--1、银行开户（注册个人信息）及开卡（办理银行卡）（一个人可以办理多张银行卡，但是最多只能办理3张），要区分是新客户还是老客户
--2、存钱
--3、查询余额
--4、取钱
--5、转账
--6、查看交易记录
--7、账户挂失
--8、账户注销

--表设计
-- 1、账户信息表：存储个人信息
-- 2、银行卡表：存储银行卡信息
-- 3、交易信息表（存储存钱和取钱的记录）
-- 4、转账信息表（存储转账信息记录）
-- 5、状态信息变化表（存储银行卡状态变化的记录，状态有：1、正常，2、挂失，3、冻结，4、注销）

--表结构设计
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

--交易信息表（存储存钱和取钱的记录）
create table CardExchange
(
	ExchangeId int primary key identity(1,1), -- 交易自动编号
	CardNo varchar(30) not null, -- 银行卡号（与银行卡表形成主外键关系）
	MoneyInBank money not null, -- 存钱金额
	MoneyOutBank money not null, -- 取钱金额
	ExchangeTime smalldatetime not null -- 交易时间
)

--转账信息表（存储转账信息记录）
create table CardTransfer
(
	TransferId int primary key identity(1,1), -- 转账自动编号
	CardNoOut varchar(30) not null, -- 转出银行卡号（与银行卡表形成主外键关系）
	CardNoIn varchar(30) not null, -- 转入银行卡号（与银行卡表形成主外键关系）
	TransferMoney money not null, -- 交易金额
	TransferTime smalldatetime not null, -- 交易时间
)

--状态信息变化表（存储银行卡状态变化的记录，状态有1：正常，2：挂失，3：冻结，4：注销）
create table CardStateChange
(
	StateId int primary key identity(1,1), -- 状态信息自动编号
	CardNo varchar(30) not null, -- 银行卡号（与银行卡表形成主外键关系）
	OldState int not null, -- 银行卡原始状态
	NewState int not null, -- 银行卡新状态
	StateWhy varchar(200) not null, -- 状态变换原因
	StateTime smalldatetime not null, -- 记录产生时间
)

--添加测试数据
--为刘备、关羽、张飞三个人进行开户开卡的操作
--刘备身份证：420107198905064135
--关羽身份证：420107199507104133
--张飞身份证：420107199602034138


insert into AccountInfo(AccountCode,AccountPhone,RealName,Opentime)
values('420107198905064135','13554785425','刘备',GETDATE())
insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
values('6225125478544587',1,'123456',0,1)

insert into AccountInfo(AccountCode,AccountPhone,RealName,Opentime)
values('420107199507104133','13454788854','关羽',GETDATE())
insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
values('6225547858741263',2,'123456',0,1)

insert into AccountInfo(AccountCode,AccountPhone,RealName,Opentime)
values('420107199602034138','13456896321','张飞',GETDATE())
insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
values('622554785874125656',3,'123456',0,1)

drop table BankCard
drop table AccountInfo

select * from AccountInfo
select * from BankCard


--进行存钱操作，刘备存钱2000元，关羽存钱8000元，张飞存钱50000元
select * from CardExchange
select * from BankCard
update BankCard set CardMoney = CardMoney + 2000 where CardNo = '6225125478544587'
insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
values('6225125478544587',2000,0,GETDATE())

update BankCard set CardMoney = CardMoney + 8000 where CardNo = '6225547858741263'
insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
values('6225547858741263',8000,0,GETDATE())

update BankCard set CardMoney = CardMoney + 50000 where CardNo = '622554785874125656'
insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
values('622554785874125656',50000,0,GETDATE())

--转账：刘备给张飞转账1000元
select * from AccountInfo
INNER JOIN BankCard on AccountInfo.AccountId = BankCard.AccountId
INNER JOIN CardExchange on CardExchange.CardNo = BankCard.CardNo

select * from CardTransfer

update BankCard set CardMoney = CardMoney - 1000 where CardNo = '6225125478544587'
update BankCard set CardMoney = CardMoney + 1000 where CardNo = '622554785874125656'
insert into CardTransfer(CardNoOut,CardNoIn,TransferMoney,TransferTime)
values('6225125478544587','622554785874125656',1000,GETDATE())
