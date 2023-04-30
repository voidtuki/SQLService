use DBTEST2

--��1���������п���Ϊ��6225547858741263����
--��ѯ�����ȹ��������п���Ϣ����ʾ���ţ����֤�����������
--����1 �Ӳ�ѯ
select CardNo ����,AccountCode ���֤,RealName ����,CardMoney ��� from BankCard
inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
where CardMoney > 
(select CardMoney from BankCard where CardNo = '6225547858741263' ) 

--����2 ʹ�ñ���
declare @balance int;
select @balance = (select CardMoney from BankCard where CardNo = '6225547858741263')
select CardNo ����,AccountCode ���֤,RealName ����,CardMoney ��� from BankCard
inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
where CardMoney > @balance

--��2���������˻���Ϣ�в�ѯ�������ߵĽ�����ϸ����ǮȡǮ��Ϣ��
--����2������ж�������һ�������Ҷ�����ߣ������ѯֻ�ܲ��һ��
--����1 �Ӳ�ѯ
--����ж�������һ�������Ҷ�����ߣ���Ҫ�������
--�߼������in���ɴ��ڶ��ֵ����ϵ�����=��ֻ�ܽ���һ��ֵ
select * from BankCard
select * from CardExchange where CardNo in
(select CardNo from BankCard where CardMoney =
(select MAX(CardMoney) from BankCard ))

--����2 ������top1���Ӳ�ѯ
select * from BankCard
select * from CardExchange
where CardNo = 
(select top 1 CardNo from BankCard 
order by CardMoney desc)

--��3����ѯ��ȡ���¼�����п����˻���Ϣ����ʾ���ţ����֤�����������
--����1 ȡ���¼��Ϊnull�����п���
--���´��룬��ϵ�����=ֻ�ܻ�ȡһ��ֵ�����ֵ����
select * from CardExchange
select CardNo ����,AccountCode ���֤,RealName ����,CardMoney ��� from BankCard
inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
where
CardNo = (select CardNo from CardExchange where MoneyOutBank <> 0)

--����2 ��ϵ�����<>
--ʹ��in���жϣ���ȡ���ֵ��<>�����ڿ�
select * from CardExchange
select CardNo ����,AccountCode ���֤,RealName ����,CardMoney ��� from BankCard
inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
where
CardNo in (select CardNo from CardExchange where MoneyOutBank <> 0)


--���Ҷ���ȡǮ��¼���˻���Ϣ
--��ȡǮ
select * from BankCard
select * from CardExchange
--�������п���
update BankCard set CardMoney = CardMoney - 2000
where CardNo = '6225125478544587'
--����������������Ϣ��
insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
values('6225125478544587',0,2000,GETDATE())

--��4����ѯ��û�д���¼�����п����˻���Ϣ����ʾ���ţ����֤�����������
select * from BankCard
inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
inner join CardExchange on CardExchange.CardNo = BankCard.CardNo

select * from CardExchange
select CardNo ����,AccountCode ���֤,RealName ����,CardMoney ��� from BankCard
inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
where
--��û�д���¼�������Ǵ����Ϊ0
CardNo not in (select CardNo from CardExchange where MoneyinBank <> 0)

--��5����������п���Ϊ��6225547858741263������ѯ�����Ƿ����յ�ת��
if exists(select * from CardTransfer
					where CardNoIn = '6225547858741263'
					--ע��ʱ��ת��Ϊ�ַ���ʱ����Ҫ������
					and CONVERT(varchar(10),TransferTime) = CONVERT(varchar(10),GETDATE()))
	print '��ת��'
else 
	print '��ת��'

--����ת�˸�����1000��
select RealName ����,CardNo ����,CardMoney ��� from BankCard
inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
--ת�˽��
declare @TransferMoney int = 1000
--�������п���Ϣ
update BankCard set CardMoney = CardMoney + @TransferMoney
where CardNo = '6225547858741263'--����
update BankCard set CardMoney = CardMoney - @TransferMoney
where CardNo = '6225125478544587'--����
--�������ݵ�ת����Ϣ��
insert into CardTransfer(CardNoOut,CardNoIn,TransferMoney,TransferTime)
values('6225125478544587','6225547858741263',@TransferMoney,GETDATE())

--��6����ѯ�����״������洢ȡ��������������п��˻���Ϣ����ʾ
--���ţ����֤�������������״���
--����1 ֻ�ܲ�ѯһ��ֵ
select * from CardExchange
select * from BankCard
inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
--ʹ�÷����ѯ�;ۺϺ���count��ͳ�ƴ��ֶγ��ִ�����
--ʹ�÷���ͳ�ƺ����ʱ����Ϊ�����ӵ��ֶΣ�����ѯ
inner join (select CardNo,Count(*) exchangeCount from CardExchange group by CardNo)
CardExchangeTemp on BankCard.CardNo = CardExchangeTemp.CardNo
--�Դ�����������
order by exchangeCount desc

--����2
--���Բ�ѯ���ֵ
--(����ж���˽��״�����ͬ�����ǽ��״�����࣬��ʹ�����·���)
select  BankCard.CardNo ����,AccountCode ���֤,RealName ����,CardMoney ���,���״��� 
from AccountInfo
inner join BankCard on AccountInfo.AccountId = BankCard.AccountId
inner join
(select CardNo,COUNT(*) ���״��� from CardExchange group by CardNo) Temp 
on BankCard.CardNo = Temp.CardNo
--�������ͬ����ཻ�״�����ʹ����������
where ���״��� = (select max(���״���) from
(select CardNo,COUNT(*) ���״��� from CardExchange group by CardNo) Temp )

--��7����ѯ��û��ת�˽��׼�¼�����п���Ϣ����ʾ���ţ����֤�����������
select CardNo ����,AccountCode ���֤,RealName ����,CardMoney ��� from BankCard
inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
where CardNo not in
--�����û��ת�˼�¼���ż���
(select CardNoIn from CardTransfer)
and
CardNo not in
(select CardNoOut from CardTransfer)