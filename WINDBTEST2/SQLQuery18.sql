select * from BankCard
select * from CardExchange
--ѡ���֧�ṹ-------------------------------
--��1��ĳ�û����п���Ϊ��622554785874125656
--���û�ִ��ȡǮ������ȡǮ5000Ԫ�������������ȡǮ������
--����ʾ��ȡǮ�ɹ�����������ʾ�����㡱
declare @balance int
select @balance =
(select CardMoney from BankCard where CardNo = '622554785874125656')
if @balance >= 5000
	begin
		--�����п�ȡǮ���������п���
		update BankCard set CardMoney = CardMoney - 5000
		where CardNo = '622554785874125656'

		--���½��׼�¼��
		update CardExchange set 
		MoneyInBank = MoneyInBank - 5000
		where CardNo = '622554785874125656'
		--�����¼
		insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
		values('622554785874125656',0,5000,GETDATE())

		print 'ȡǮ�ɹ�'

	end
else
	begin
		print '����'
	end


select * from BankCard
--��2����ѯ���п���Ϣ�������п�״̬1��2��3��4�ֱ�ת��Ϊ���֡���������ʧ�����ᣬע������
--���Ҹ������п������ʾ���п��ȼ�
--30������Ϊ����ͨ�û�����30������Ϊ��VIP�û�����
--��ʾ�зֱ�Ϊ���ţ����֤�����������û��ȼ������п�״̬
--case-when-end �ʺ� ����Ϊ��ѯ�ֶ�ʱ��
select CardNo ����,AccountCode ���֤��,RealName ����,CardMoney ���,
case
	when CardMoney >= 300000
	then 'VIP�û�'
	else '��ͨ�û�'
end �û��ȼ�,
case CardState
	when 1 then '����'
	when 2 then '��ʧ'
	when 3 then '����'
	when 4 then 'ע��'
	else '�쳣'
end ���п�״̬
from BankCard
inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId

