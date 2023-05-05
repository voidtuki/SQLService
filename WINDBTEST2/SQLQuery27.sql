--����
use DBTEST2

--��4����ѯ���п���Ϣ�������п�״̬1,2,3,4�ֱ�ת��Ϊ���֡���������ʧ�����ᣬע������
--�������п������ʾ���п��ȼ�30������Ϊ����ͨ�û�����30������Ϊ��VIP�û�����
--�ֱ���ʾ���ţ����֤�����������û��ȼ������п�״̬
select CardNo ����,AccountCode ���֤,RealName ����,CardMoney ���,
dbo.GetGrade(CardMoney) �û��ȼ�,dbo.GetState(CardState) ���п�״̬ from BankCard
inner join AccountInfo
on AccountInfo.AccountId = BankCard.AccountId

--�û��ȼ�����
create function GetGrade(@cardmoney money) returns varchar(30)
as
begin
	declare @result varchar(30)
	if @cardmoney >= 300000
		set @result = 'VIP�û�'
	else
		set @result = '��ͨ�û�'
	return @result
end

--�����п�״̬����
create function GetState(@state int) returns varchar(30)
as
begin
	declare @result varchar(30)
	if @state = 1
		set @result = '����'
	else if @state = 2
		set @result = '��ʧ'
	else if @state = 3
		set @result = '����'
	else if @state = 4
		set @result = 'ע��'
	else
		set @result = '�쳣'

	return @result
end

--��5����д���������ݳ������������䣬������ʵ�꣬���磺
--����Ϊ2000-5-5����ǰΪ2018-5-3������Ϊ17��
--����Ϊ2000-5-5����ǰΪ2018-5-6������Ϊ18��
create table Emp
(
	EmpId int primary key identity(1,2), --�Զ����
	empName varchar(20), --����
	empSex varchar(4),   --�Ա�
	empBirth smalldatetime --����
)
insert into Emp(empName,empSex,empBirth) values('����','��','2008-5-8')
insert into Emp(empName,empSex,empBirth) values('����','��','1998-10-10')
insert into Emp(empName,empSex,empBirth) values('�ŷ�','��','1999-7-5')
insert into Emp(empName,empSex,empBirth) values('����','��','2003-12-12')
insert into Emp(empName,empSex,empBirth) values('��','��','2003-1-5')
insert into Emp(empName,empSex,empBirth) values('����','��','1988-8-4')
insert into Emp(empName,empSex,empBirth) values('κ��','��','1998-5-2')
insert into Emp(empName,empSex,empBirth) values('��Ӻ','��','1992-2-20')
insert into Emp(empName,empSex,empBirth) values('�����','��','1993-3-1')
insert into Emp(empName,empSex,empBirth) values('����','��','1994-8-5')

select * from Emp

--����1
select *,year(GETDATE())-year(empBirth) ���� from Emp

--����2 ����
select *,dbo.GetAge(empBirth) ���� from Emp

create function GetAge(@birth varchar(30)) returns int
begin
	declare @age int
	set @age = year(GETDATE()) - year(@birth)

	--�ж��·��Ƿ�С�������·�
	if month(GETDATE()) < month(@birth)
		set @age = @age - 1
	--ͬ�·ݣ��ж������Ƿ�С������
	if month(GETDATE()) = month(@birth) and day(GETDATE()) < day(@birth)
		set @age = @age - 1
	return @age
end
