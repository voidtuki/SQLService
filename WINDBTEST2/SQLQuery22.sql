--事务
--如果有一段代码发生错误，则下面所有代码都不执行，以免逻辑错乱

--人员信息如下：（第二列是身份证号，第三列是银行卡卡号）

select * from BankCard

--刘备 420107198905064135 6225125478544587
--关羽 420107199507104133 6225123412357896
--张飞 420107199602034138 622554785874125656

--（1）假设关羽取款6000，（添加check约束，设置账户余额必须>=0），
--要求：使用事务实现，修改余额和添加取款记录两部操作使用事务

--添加约束
alter table BankCard add  constraint ck_money check(CardMoney >= 0)

--事务
begin transaction
declare @myError int = 0

--修改银行卡余额
update BankCard set CardMoney = CardMoney - 6000
where CardNo = '6225123412357896'

--如有错误则统计次数
set @myError = @myError + @@Error

--向交易表添加信息
insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
values ('6225123412357896',0,6000,GETDATE())

--如有错误则统计次数
set @myError = @myError + @@Error

--判断是否有出错，如有则回滚；无则提交
if @myError = 0
	begin
		commit transaction
		print '取款成功'
	end
else
	begin
		rollback transaction
		print '取款失败'
	end

--查看是否生成错误信息
select * from BankCard
select * from CardExchange

--（2）假设刘备向张飞转账1000元，（添加check约束，设置账户余额必须>=0）;
--分析步骤有三步（1）张飞添加1000元，（2）刘备扣除1000元，（3）生成转账记录；
--使用事务解决此问题

--事务
begin transaction
declare @myError1 int =  0

--添加转账余额
--转出，刘备
update BankCard set CardMoney = CardMoney - 1000
where CardNo = '6225125478544587'
--转入，张飞
update BankCard set CardMoney = CardMoney + 1000
where CardNo = '622554785874125656'

--统计错误次数
set @myError1 = @myError1 + @@ERROR

--添加转账信息到转账表
insert into CardTransfer(CardNoOut,CardNoIn,TransferMoney,TransferTime)
values('6225125478544587','622554785874125656',1000,GETDATE())

--统计错误次数
set @myError1 = @myError1 + @@ERROR

--判断是否有出错，如有则回滚；无则提交
if @myError1 = 0
	begin
		commit transaction
		print '转账成功'
	end
else
	begin
		rollback transaction
		print '转账失败'
	end

--查看是否生成错误信息
select * from BankCard
select * from CardTransfer
