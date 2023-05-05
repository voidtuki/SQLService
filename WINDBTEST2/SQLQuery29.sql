--�洢����
use DBTEST2

--��1��û�����������û����������Ĵ洢����
--����洢����ʵ�ֲ�ѯ���˻������͵����п��˻���Ϣ����ʾ���п��ţ��������˻����
--����1������
drop proc proc_MinMoneyCard
create proc proc_MinMoneyCard
as
	select top 1 CardNo,RealName,CardMoney from BankCard
	inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
	order by CardMoney
go

--���ô洢����
exec proc_MinMoneyCard

--����2���������ͣ�����˲��У������Բ������
create proc proc_MinMoneyCard
as
	select CardNo,RealName,CardMoney from BankCard
	inner join AccountInfo on BankCard.AccountId = AccountInfo.AccountId
	where CardMoney = 
	(select Min(CardMoney) from BankCard)
go

--���ô洢����
exec proc_MinMoneyCard

--��2�������������û����������Ĵ洢����
--ģ�����п���Ǯ�������������п��ţ���Ǯ��ʵ�ִ�Ǯ����
drop proc proc_Cunqian
create proc proc_Cunqian
@CardNo varchar(30),
@money money
as
	--��Ǯ���������п������
	update BankCard set CardMoney = CardMoney + @money
	where CardNo = @CardNo

	--�����Ǯ���ݵ�������Ϣ��
	insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
	values(@CardNo,@money,0,GETDATE())
go

--���ô洢����
select * from BankCard
select * from CardExchange
exec proc_Cunqian '6225125478544587',1000

--��3�������������û����������������з���ֵ�Ĵ洢���̣�����ֵ����������
--ģ�����п�ȡǮ�������������п��ţ�ȡǮ��ʵ��ȡǮ����
--ȡǮ�ɹ�������1��ȡǮʧ�ܷ���-1
alter table BankCard add constraint CardMoney check(CardMoney >= 0)

drop proc proc_Quqian
create proc proc_Quqian
@CardNo varchar(30),
@money money
as
	--ȡǮ�������п���
	update BankCard set CardMoney = CardMoney - @money
	where CardNo = @CardNo

	--�����ж�
	if @@ERROR <> 0
		return -1

	--���ȡǮ��Ϣ��������Ϣ��
	insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
	values(@CardNo,0,@money,GETDATE())

	return 1
go

--���ô洢����
select * from BankCard
select * from CardExchange

--����һ���������ܽ��
declare @returnValue int
exec @returnValue = proc_Quqian '6225123412357896',1000
select @returnValue

--��4�����������������������Ĵ洢����
--��ѯ��ĳʱ��ε����д�ȡ����Ϣ�Լ�����ܽ�ȡ���ܽ��
--���뿪ʼʱ�䣬����ʱ�䣬��ʾ��ȡ�����Ϣ��ͬʱ�����ش���ܽ�ȡ���ܽ�
drop proc proc_selectExChange
create proc proc_selectExChange
@start varchar(30),
@end varchar(30),
--��������������η���output
@sumIn money output,
@sumOut money output
as
	--����ƴ���ַ���һ�����Ͽո�
	--��Ǯ�ܽ��
	select @sumIn = (select sum(MoneyInBank) from CardExchange
	where ExchangeTime between @start + ' 00:00:00' and @end + ' 23:59:59')
	--ȡǮ�ܽ��
	select @sumOut = (select sum(MoneyOutBank) from CardExchange
	where ExchangeTime between @start + ' 00:00:00' and @end + ' 23:59:59')

	--�鿴������Ϣ����ʼʱ��-����ʱ��
	select * from CardExchange where ExchangeTime between
	@start + ' 00:00:00' and @end + ' 23:59:59'
go

--���ô洢����
select * from BankCard
select * from CardExchange
--�������������������������������Ҫ��output���η�
declare @sumIn money
declare @sumOut money
exec proc_selectExChange '2023-1-1','2023-12-31',@sumIn output,@sumOut output
select @sumIn
select @sumOut

--��5������ͬʱ������������Ĵ洢����
--�������������뿨�ź����룬�������������ȷ���������볤��<8���Զ�������8λ����
drop proc proc_pwdUpgrade
create proc proc_pwdUpgrade
@cardNo varchar(30),
--ͬʱ��������������������ͣ�ȡ���ڴ���֮ǰ�Ƿ�ֵ
@cardPwd varchar(30) output
as
	--�ж��Ƿ���ڴ����п�
	if not exists(select * from BankCard where CardNo = @cardNo and CardPwd = @cardPwd)
		set @cardPwd = ''
	else
	begin
		--�����ж����볤�ȣ���������
		declare @len int = 8 - len(@cardPwd)
		declare @i int = 0
		--������볤��С��8������ȫ����Ҫ�Զ�������������λ��Ϊ�����
		while @i < @len
		begin
			--������Ȳ�����
			--floor����������Ϊ������rand�����������ƴ���ַ���ǿת
			set @cardPwd = @cardPwd + convert(varchar(1),floor(rand()*10))
			set @i = @i + 1
		end

		--�������п���
		update BankCard set CardPwd = @cardPwd where CardNo = @cardNo
	end
go

--���ô洢����
select * from BankCard

--������������ֵ����ô��Ϊ�����������
declare @cardPwd  varchar(30) = '123456'
exec proc_pwdUpgrade '6225125478544587',@cardPwd output
--���ĺ������
select @cardPwd