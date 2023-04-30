--T-SQL��ʹ�õ��������Ϊ7��
--������������ӣ�+��������-�����ˣ�*��������/����ģ��%��
--�߼��������AND��OR��LIKE��BETWEEN��IN��EXISTS��NOT��ALL��ANY
--��ֵ�������=
--�ַ����������+
--�Ƚ��������=��>��<��>=��<=��<>
--λ�������|��&��^
--�����������+=��-=��/=��%=��*=

--��1����֪�����εĳ��Ϳ��󳤷��ε��ܳ������
declare @length int = 10
declare @breadth int = 5
declare @perimeter int
set @perimeter = (@length+@breadth)*2
declare @area int
set @area = @length * @breadth

--SQL��+��ƴ���ַ��������ܽ�int��Ϊvarchar����
--����1��ʹ��Convert()����ת�����ͣ�Convert(���ͣ�ֵ)
print '�������ܳ�Ϊ��'+Convert(varchar,@perimeter)
print '���������Ϊ��'+Convert(varchar,@area)

--����2��ʹ��cast()������cast(ֵ as ����)
print '�������ܳ�Ϊ��'+cast(@perimeter as varchar(10))
print '���������Ϊ��'+cast(@area as varchar(10))

use DBTEST2

--��2����ѯ���п�״̬Ϊ���ᣬ��������1000000�����п���Ϣ
select * from BankCard
inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId

update BankCard set CardMoney = 1000000,CardState = 3
where AccountId = 1

select * from BankCard
where CardState = 3 and CardMoney >= 1000000

--��3����ѯ���п�״̬Ϊ�������������0�����п���Ϣ
select * from BankCard
where CardState = 3 or CardMoney = 0

--��4����ѯ�������к���'��'�˻�����Ϣ�Լ����п���Ϣ
--����1 ͨ��� %
select * from AccountInfo
inner join BankCard on AccountInfo.AccountId = BankCard.AccountId
where RealName like '��%'
--����2 ͨ��� _ �����ַ�
select * from AccountInfo
inner join BankCard on AccountInfo.AccountId = BankCard.AccountId
where RealName like '��_'

select * from AccountInfo
inner join BankCard on AccountInfo.AccountId = BankCard.AccountId
where AccountPhone like '13[0-9]%5'

--��5����ѯ�����2000-5000֮������п���Ϣ
--����1 ��ϵ����� >
select * from BankCard
where CardMoney >= 2000 and CardMoney <= 5000

--����2 �߼������ between
select * from BankCard
where CardMoney between 2000 and 5000

--��6����ѯ�����п�״̬Ϊ�������ע�������п���Ϣ
--����1
select * from BankCard
where CardState = 3 or CardState = 4

--����2
select * from BankCard
where CardState in (3,4)

--��7���������֤��420107199507104133����������������
--��ѯ���֤���˻����Ƿ���ڣ�����������п��������������򲻿���ֱ�ӿ���
--����һ���˺�ֻ�ܿ�3�ſ�

select * from AccountInfo
select * from BankCard

delete from BankCard where CardNo = '62251254782323127'

declare @AccountId int -- �˻����
declare @CardCount int -- ������
if EXISTS(select * from AccountInfo where AccountCode = '420107199507104133')
begin
	--�ڱ��д��ڲ�����ֻ����
	select @AccountId =
	(select AccountId from AccountInfo where AccountCode = '420107199507104133')


	--��ѯ������
	select @CardCount = 
	(select count(CardNo) from BankCard where BankCard.AccountId = @AccountId)
	--С��3�ţ��������ٿ�1��
	if @CardCount <=2
		begin
			insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState,CardTime)
			values('62251254782323122',@AccountId,'123456',0,1,GETDATE())
		end
	else
		begin
			print '���Ŀ��������Ѵ�����'
			print '����������'+Convert(varchar,@CardCount)
			select * from BankCard 
			inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
			where BankCard.AccountId = @AccountId
		end
end
else
begin
	--�����ڱ��п�������
	insert into AccountInfo(AccountCode,AccountPhone,RealName,OpenTime)
	values('420107199507104133',13454788854,'����',GETDATE())
	set @AccountId = @@IDENTITY --�Զ���ţ���β����ʼ
	insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState,CardTime)
	values('6225547858741263',@AccountId,'123456',0,1,GETDATE())
end

--��8����ѯ���п��˻����ǲ��������˻���������3000
-- �߼������ all
--��ʽ value ��ϵ����� all()
if 3000 <= all(select CardMoney from BankCard)
	begin
		print '�����˻���������3000'
	end
else
	begin
		print '�����˻����δ������3000'
	end

--��9����ѯ���п��˻����Ƿ����˻�������300000000��Ϣ
if 300000000 <= any(select CardMoney from BankCard)
	begin
		print '���˻�������300000000'
	end
else
	begin
		print 'δ���˻�����300000000'
	end
