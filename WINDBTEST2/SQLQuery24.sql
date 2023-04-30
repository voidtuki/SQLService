use DBTEST2

--视图
--功能单一，仅仅做为功能展示

--（1）显式卡号，身份证，姓名，余额
select CardNo 卡号,AccountCode 身份证,RealName 姓名,CardMoney 余额 from BankCard
inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId

--创建视图，重复使用模板
create view View_Account_Card
as
	select CardNo 卡号,AccountCode 身份证,RealName 姓名,CardMoney 余额 from BankCard
	inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
go

--删除视图
drop view View_Account_Card

--查看视图
select * from View_Account_Card

--修改数据不要在视图中修改

create view CardAndAccount as
select CardNo 卡号,AccountCode 身份证,RealName 姓名,CardMoney 余额 from BankCard 
left join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
go

select * from CardAndAccount
