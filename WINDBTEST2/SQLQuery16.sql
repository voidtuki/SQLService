--��Ϣ��ӡ
--�ն����
print 'hello,sql'
--������
select 'hello,sql'

--��������1���ֲ����� ��2��ȫ�ֱ���
--��1���ֲ���������@��ͷ�����������ٸ�ֵ
declare @str varchar(20)
set @str = 'i like sql'
--select @str = 'i like sql'
print @str
--set��select���и�ֵ��ʱ�������
--set:��ֵ����ָ����ֵ,һ��
--select:һ�����ڱ��в�ѯ�������ݸ�ֵ������,
--�����ѯ����ж���,ȡ���һ����ֵ,����
--exp:select @a = �ֶ��� from ����
--��ǰ�����һ���ֶε�ֵ��ֵ��a






--��2��ȫ�ֱ�������1����@@��Ϊǰ׺
--				 ��2����ϵͳ���ж����ά��,ֻ��

--@@ERROR������ִ�е���һ�����Ĵ����
--@@IDENTITY������������ı�ʶֵ
--@@MAX_CONNECTIONS����������ͬʱ���е�����û�������
--@@ROWCOUNT����������һ���Ӱ�������
--@@SERVERNAME���������� SQL Server �ı��ط�����������
--@@SERVICENAME������ SQL Server �����������е�ע����������
--@@TRANCOUNT�����ص�ǰ���ӵĻ������
--@@LOCK_TIMEOUT�����ص�ǰ�Ự�ĵ�ǰ������ʱ���ã����룩


delete from AccountInfo where AccountId = 4
select * from AccountInfo
--ʾ��
--(1)Ϊ���ƴ��˽��п�����������,�������֤��420107199904054233
insert into AccountInfo(AccountCode,AccountPhone,RealName,OpenTime)
values('420107199904054233','15878547898','����',GETDATE())
--��֪�������Զ���ţ���ȡ���һ�β���ı��ֵ
declare @AccountId int
set @AccountId = @@IDENTITY
insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
values('6225123412357896',@AccountId,'123456',0,1)

--(2)��Ҫ����ŷɵ����п����ź����ŷ����֤��420107199602034138
--����1
select CardNo ���п���,CardMoney ��� from BankCard
inner join AccountInfo on AccountInfo.AccountId = BankCard.AccountId
where AccountCode = '420107199602034138'

--����2
declare @AccountId int
--ʹ�ò�ѯ�����Ϊ��������select
--select @AccountId = (select AccountId from AccountInfo where AccountCode = '420107199602034138')
select @AccountId =AccountId from AccountInfo where AccountCode = '420107199602034138'
select CardNo ���п���,CardMoney ��� from BankCard where AccountId = @AccountId


--go���
--(1)�ȴ�go���֮ǰ����ִ�����֮�����ִ�к���Ĵ���

use DBTEST2
drop database DBTEST3
create database DBTEST3
--�ȴ����ݿ⽨�����
go
--�л����ݿ�
use DBTEST3
--�˻���Ϣ���洢������Ϣ
create table AccountInfo
(
	AccountId int primary key identity(1,1), --�˻����
	AccountCode varchar(20) not null, -- ���֤����
	AccountPhone varchar(20) not null, -- �绰����
	RealName varchar(20) not null, -- ��ʵ����
	OpenTime smalldatetime not null, -- ����ʱ��
)

--���п����洢���п���Ϣ
create table BankCard
(
	CardNo varchar(30) primary key, -- ���п�����
	AccountId int not null, -- �˻���ţ����˻���Ϣ���γ��������ϵ��
	CardPwd varchar(30) not null, -- ���п�����
	CardMoney money not null, -- ���п����
	CardState int not null, -- 1��������2����ʧ��3�����ᣬ4��ע��
	CardTime smalldatetime default(GETDATE()) -- ����ʱ��
)

--(2)�����������һ����־�����������
declare @num int --@num���÷�Χ���ڴ�������ȫ��
set @num = 100
set @num = 200

declare @num1 int --@num���÷�Χ���ڴ���������go֮ǰ
set @num1 = 100
go
set @num1 = 200

go
declare @num1 int --@num���÷�Χ���ڴ�������������go֮��
set @num1 = 100
go
set @num1 = 200
