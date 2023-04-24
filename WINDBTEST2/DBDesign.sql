--���ݿ���ư���

create database DBTEST2

--ҵ������˵��
--ģ������ҵ����Ƽ��װ���������ݿ��ṹ��Ҫ�����������»�����������
--1�����п�����ע�������Ϣ�����������������п�����һ���˿��԰���������п����������ֻ�ܰ���3�ţ���Ҫ�������¿ͻ������Ͽͻ�
--2����Ǯ
--3����ѯ���
--4��ȡǮ
--5��ת��
--6���鿴���׼�¼
--7���˻���ʧ
--8���˻�ע��

--�����
-- 1���˻���Ϣ���洢������Ϣ
-- 2�����п����洢���п���Ϣ
-- 3��������Ϣ���洢��Ǯ��ȡǮ�ļ�¼��
-- 4��ת����Ϣ���洢ת����Ϣ��¼��
-- 5��״̬��Ϣ�仯���洢���п�״̬�仯�ļ�¼��״̬�У�1��������2����ʧ��3�����ᣬ4��ע����

--��ṹ���
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

--������Ϣ���洢��Ǯ��ȡǮ�ļ�¼��
create table CardExchange
(
	ExchangeId int primary key identity(1,1), -- �����Զ����
	CardNo varchar(30) not null, -- ���п��ţ������п����γ��������ϵ��
	MoneyInBank money not null, -- ��Ǯ���
	MoneyOutBank money not null, -- ȡǮ���
	ExchangeTime smalldatetime not null -- ����ʱ��
)

--ת����Ϣ���洢ת����Ϣ��¼��
create table CardTransfer
(
	TransferId int primary key identity(1,1), -- ת���Զ����
	CardNoOut varchar(30) not null, -- ת�����п��ţ������п����γ��������ϵ��
	CardNoIn varchar(30) not null, -- ת�����п��ţ������п����γ��������ϵ��
	TransferMoney money not null, -- ���׽��
	TransferTime smalldatetime not null, -- ����ʱ��
)

--״̬��Ϣ�仯���洢���п�״̬�仯�ļ�¼��״̬��1��������2����ʧ��3�����ᣬ4��ע����
create table CardStateChange
(
	StateId int primary key identity(1,1), -- ״̬��Ϣ�Զ����
	CardNo varchar(30) not null, -- ���п��ţ������п����γ��������ϵ��
	OldState int not null, -- ���п�ԭʼ״̬
	NewState int not null, -- ���п���״̬
	StateWhy varchar(200) not null, -- ״̬�任ԭ��
	StateTime smalldatetime not null, -- ��¼����ʱ��
)

--��Ӳ�������
--Ϊ�����������ŷ������˽��п��������Ĳ���
--�������֤��420107198905064135
--�������֤��420107199507104133
--�ŷ����֤��420107199602034138


insert into AccountInfo(AccountCode,AccountPhone,RealName,Opentime)
values('420107198905064135','13554785425','����',GETDATE())
insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
values('6225125478544587',1,'123456',0,1)

insert into AccountInfo(AccountCode,AccountPhone,RealName,Opentime)
values('420107199507104133','13454788854','����',GETDATE())
insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
values('6225547858741263',2,'123456',0,1)

insert into AccountInfo(AccountCode,AccountPhone,RealName,Opentime)
values('420107199602034138','13456896321','�ŷ�',GETDATE())
insert into BankCard(CardNo,AccountId,CardPwd,CardMoney,CardState)
values('622554785874125656',3,'123456',0,1)

drop table BankCard
drop table AccountInfo

select * from AccountInfo
select * from BankCard


--���д�Ǯ������������Ǯ2000Ԫ�������Ǯ8000Ԫ���ŷɴ�Ǯ50000Ԫ
select * from CardExchange
select * from BankCard
update BankCard set CardMoney = CardMoney + 2000 where CardNo = '6225125478544587'
insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
values('6225125478544587',2000,0,GETDATE())

update BankCard set CardMoney = CardMoney + 8000 where CardNo = '6225547858741263'
insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
values('6225547858741263',8000,0,GETDATE())

update BankCard set CardMoney = CardMoney + 50000 where CardNo = '622554785874125656'
insert into CardExchange(CardNo,MoneyInBank,MoneyOutBank,ExchangeTime)
values('622554785874125656',50000,0,GETDATE())

--ת�ˣ��������ŷ�ת��1000Ԫ
select * from AccountInfo
INNER JOIN BankCard on AccountInfo.AccountId = BankCard.AccountId
INNER JOIN CardExchange on CardExchange.CardNo = BankCard.CardNo

select * from CardTransfer

update BankCard set CardMoney = CardMoney - 1000 where CardNo = '6225125478544587'
update BankCard set CardMoney = CardMoney + 1000 where CardNo = '622554785874125656'
insert into CardTransfer(CardNoOut,CardNoIn,TransferMoney,TransferTime)
values('6225125478544587','622554785874125656',1000,GETDATE())
