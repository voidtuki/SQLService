--����
--�����һ�δ��뷢���������������д��붼��ִ�У������߼�����

--��Ա��Ϣ���£����ڶ��������֤�ţ������������п����ţ�

select * from BankCard

--���� 420107198905064135 6225125478544587
--���� 420107199507104133 6225123412357896
--�ŷ� 420107199602034138 622554785874125656

--��1���������ȡ��6000�������checkԼ���������˻�������>=0����
--Ҫ��ʹ������ʵ�֣��޸��������ȡ���¼��������ʹ������

--���Լ��
alter table BankCard add  constraint ck_money check(CardMoney >= 0)

--����
begin transaction
declare @myError int = 0

--�޸����п����
update BankCard set CardMoney = CardMoney - 6000
where CardNo = '6225123412357896'

--���д�����ͳ�ƴ���
set @myError = @myError + @@Error

--���ױ������Ϣ
insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
values ('6225123412357896',0,6000,GETDATE())

--���д�����ͳ�ƴ���
set @myError = @myError + @@Error

--�ж��Ƿ��г���������ع��������ύ
if @myError = 0
	begin
		commit transaction
		print 'ȡ��ɹ�'
	end
else
	begin
		rollback transaction
		print 'ȡ��ʧ��'
	end

--�鿴�Ƿ����ɴ�����Ϣ
select * from BankCard
select * from CardExchange

--��2�������������ŷ�ת��1000Ԫ�������checkԼ���������˻�������>=0��;
--����������������1���ŷ����1000Ԫ����2�������۳�1000Ԫ����3������ת�˼�¼��
--ʹ��������������

--����
begin transaction
declare @myError1 int =  0

--���ת�����
--ת��������
update BankCard set CardMoney = CardMoney - 1000
where CardNo = '6225125478544587'
--ת�룬�ŷ�
update BankCard set CardMoney = CardMoney + 1000
where CardNo = '622554785874125656'

--ͳ�ƴ������
set @myError1 = @myError1 + @@ERROR

--���ת����Ϣ��ת�˱�
insert into CardTransfer(CardNoOut,CardNoIn,TransferMoney,TransferTime)
values('6225125478544587','622554785874125656',1000,GETDATE())

--ͳ�ƴ������
set @myError1 = @myError1 + @@ERROR

--�ж��Ƿ��г���������ع��������ύ
if @myError1 = 0
	begin
		commit transaction
		print 'ת�˳ɹ�'
	end
else
	begin
		rollback transaction
		print 'ת��ʧ��'
	end

--�鿴�Ƿ����ɴ�����Ϣ
select * from BankCard
select * from CardTransfer
