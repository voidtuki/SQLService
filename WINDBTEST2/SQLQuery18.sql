select * from BankCard
select * from CardExchange
--选择分支结构-------------------------------
--（1）某用户银行卡号为：622554785874125656
--该用户执行取钱操作，取钱5000元，余额充足则进行取钱操作，
--并提示“取钱成功”，否则提示“余额不足”
declare @balance int
select @balance =
(select CardMoney from BankCard where CardNo = '622554785874125656')
if @balance >= 5000
	begin
		--从银行卡取钱，更新银行卡表
		update BankCard set CardMoney = CardMoney - 5000
		where CardNo = '622554785874125656'

		--更新交易记录表
		update CardExchange set 
		MoneyInBank = MoneyInBank - 5000
		where CardNo = '622554785874125656'
		--插入记录
		insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
		values('622554785874125656',0,5000,GETDATE())

		print '取钱成功'

	end
else
	begin
		print '余额不足'
	end


select * from BankCard
--（2）查询银行卡信息，将银行卡状态1，2，3，4分别转换为汉字“正常，挂失，冻结，注销”，
--并且根据银行卡余额显示银行卡等级
--30万以下为“普通用户”，30万及以上为“VIP用户”，
--显示列分别为卡号，身份证，姓名，余额，用户等级，银行卡状态
--case-when-end 适合 在作为查询字段时候
select CardNo 卡号,AccountCode 身份证号,RealName 姓名,CardMoney 余额,
case
	when CardMoney >= 300000
	then 'VIP用户'
	else '普通用户'
end 用户等级,
case CardState
	when 1 then '正常'
	when 2 then '挂失'
	when 3 then '冻结'
	when 4 then '注销'
	else '异常'
end 银行卡状态
from BankCard
inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId

