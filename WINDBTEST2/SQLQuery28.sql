--������
use DBTEST2
--instead of����ִ�в���֮ǰ��ִ��
--after����ִ�в���֮��ִ��

--����
create table Department
(
	DepartmentId varchar(10) primary key,--����
	DepartmentName nvarchar(50) --��������
)

--��Ա��Ϣ
create table People
(
	PeopleId int primary key identity(1,1),--�������Զ�����
	DepartmentId varchar(10),--���ű�ţ�������벿�ű����
	PeopleName nvarchar(20),--��Ա����
	PeopleSex nvarchar(2),--��Ա�Ա�
	PeoplePhone nvarchar(20) --�绰����ϵ��ʽ
)

insert into Department(DepartmentId,DepartmentName)
values('001','�ܾ���')
insert into Department(DepartmentId,DepartmentName)
values('002','�г���')
insert into Department(DepartmentId,DepartmentName)
values('003','���²�')
insert into Department(DepartmentId,DepartmentName)
values('004','����')
insert into Department(DepartmentId,DepartmentName)
values('005','�����')
insert into People(DepartmentId,PeopleName,PeopleSex,PeoplePhone)
values('001','����','��','13558785478')
insert into People(DepartmentId,PeopleName,PeopleSex,PeoplePhone)
values('001','����','��','13558788785')
insert into People(DepartmentId,PeopleName,PeopleSex,PeoplePhone)
values('002','�ŷ�','��','13698547125')

--��1�������в��ű��Ա���������Ա����ʱ�򣬸�Ա���Ĳ��ű������ڲ��ű����Ҳ�����
--���Զ���Ӳ�����Ϣ����������Ϊ���²��š���
--create trigger ���������� on ���� after/instead of ��ɾ�Ĳ�
--drop trigger
--alter trigger
create trigger tri_InsertPeple on People after insert
as
	--��ӵ����ݻ���inserted����
	if not exists(select * from Department where DepartmentId = (select DepartmentId from inserted))
		begin
			insert into Department(DepartmentId,DepartmentName)
			values((select DepartmentId from inserted),'�²���')
		end
go

--���Դ�����
select * from People
select * from Department

--���ڲ���
insert into People(DepartmentId,PeopleName,PeopleSex,PeoplePhone)
values('003','����','��','13698547125')
--�����ڲ���
insert into People(DepartmentId,PeopleName,PeopleSex,PeoplePhone)
values('006','��','��','13698547125')

--��2��������ʵ�֣�ɾ��һ�����ŵ�ʱ�򽫲���������Ա��ȫ��ɾ��
create trigger tri_Delete on Department after delete
as
	--Ҫɾ����������deleted����
	delete from People where DepartmentId = (select DepartmentId from deleted)
go

--���Դ�����
select * from People
select * from Department
delete from Department where DepartmentId = '006'

--��3������һ����������ɾ��һ�����ŵ�ʱ���жϸò������Ƿ���Ա��������ɾ����û����ɾ��
drop trigger tri_DeleteDept
create trigger tri_DeleteDept on Department instead of delete
as
	if not exists(select * from People where DepartmentId = (select DepartmentId from deleted))
		delete from Department where DepartmentId = (select DepartmentId from deleted)
go

--���Դ�����
select * from People
select * from Department
--û��Ա��ɾ��
delete from Department where DepartmentId = '005'
--��Ա����ɾ��
delete from Department where DepartmentId = '001'

--��4���޸�һ�����ű��֮�󣬽��ò���������Ա���Ĳ��ű��ͬ�������޸�
drop trigger tri_UpdateDept
create trigger tri_UpdateDept on Department after update
as
	--�±���ǲ���ģ��ϱ����ɾ����
	update People set DepartmentId = (select DepartmentId from inserted)
	where DepartmentId = (select DepartmentId from deleted)
go

--���Դ�����
select * from Department
select * from People

update Department set DepartmentId = '005' where DepartmentId = '001'