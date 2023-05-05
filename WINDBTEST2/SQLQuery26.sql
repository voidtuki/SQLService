--����
--1��ϵͳ����
--2���Զ��庯������1������ֵ���������ص���ֵ����
--				 ��2����ֵ���������ز�ѯ�����

--��1����дһ������������еĽ���ܺͣ�û�в��������ر���ֵ��
use DBTEST2

drop function GetSumMoney
create function GetSumMoney() returns money --�޲κ���
as
begin
	declare @sum money
	select @sum = (select sum(CardMoney) from BankCard)
	return @sum
end

--���������� dbo.������(),select��չʾ,print����̨չʾ
select dbo.GetSumMoney()

--��2�������˻���ţ������˻���ʵ�������в��������ر���ֵ��
create function GetRealNameById(@accid int) returns varchar(30)
begin
	declare @name varchar(30)
	select @name =  (select RealName from AccountInfo where AccountId = @accid)
	return @name
end


select * from AccountInfo
select dbo.GetRealNameById(3)

--��3�����ݿ�ʼʱ��ͽ���ʱ�䣬���ؽ��׼�¼����ǮȡǮ����
--���׼�¼�а��� ��ʵ���������ţ���Ǯ��ȡǮ������ʱ��
--���в��������ر�ֵ��

--����1
drop function GetRecordByTime
create function GetRecordByTime(@start varchar(30),@end varchar(30))
returns @result table  --���ر�ֵ�����ݽṹ
(
	RealName varchar(20),
	CardNo varchar(30),
	MoneyInBank money,
	MoneyOutBank money,
	ExchangeTime smalldatetime
)
--������
as
begin 
	--�������Ӳ�ѯ�Ľ��
	insert into @result
	select RealName ��ʵ����,BankCard.CardNo ����,MoneyInBank ��Ǯ���,
	MoneyOutBank ȡǮ���,ExchangeTime ����ʱ�� from CardExchange
	inner join BankCard on BankCard.CardNo = CardExchange.CardNo
	inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
	--��Ϊsmalldatetime��ʱ���룬���Ե��Լ����ϲ��ܱȽϣ��ǵÿո�+ʱ:��:��
	where ExchangeTime between @start+' 00:00:00' and @end + ' 23:59:59'
	--������Ϊ����ֵ����
	return
end

select * from GetRecordByTime('2023-4-22','2023-4-23')

--����2���򻯰汾
create function GetRecordByTime(@start varchar(30),@end varchar(30))
returns table  --���ر�ֵ�����ݽṹ
--������
as
	--�������Ӳ�ѯ�Ľ��
	return
	select RealName ��ʵ����,BankCard.CardNo ����,MoneyInBank ��Ǯ���,
	MoneyOutBank ȡǮ���,ExchangeTime ����ʱ�� from CardExchange
	inner join BankCard on BankCard.CardNo = CardExchange.CardNo
	inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
	--��Ϊsmalldatetime��ʱ���룬���Ե��Լ����ϲ��ܱȽϣ��ǵÿո�+ʱ:��:��
	where ExchangeTime between @start+' 00:00:00' and @end + ' 23:59:59'
	--������Ϊ����ֵ����
go

