use DBTEST2

--��ͼ
--���ܵ�һ��������Ϊ����չʾ

--��1����ʽ���ţ����֤�����������
select CardNo ����,AccountCode ���֤,RealName ����,CardMoney ��� from BankCard
inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId

--������ͼ���ظ�ʹ��ģ��
create view View_Account_Card
as
	select CardNo ����,AccountCode ���֤,RealName ����,CardMoney ��� from BankCard
	inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
go

--ɾ����ͼ
drop view View_Account_Card

--�鿴��ͼ
select * from View_Account_Card

--�޸����ݲ�Ҫ����ͼ���޸�

create view CardAndAccount as
select CardNo ����,AccountCode ���֤,RealName ����,CardMoney ��� from BankCard 
left join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
go

select * from CardAndAccount
