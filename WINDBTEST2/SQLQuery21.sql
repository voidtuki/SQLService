create table Student
(
	StuId int primary key identity(1,2),--�Զ����
	StuName varchar(20),
	StuSex varchar(4)
)

insert into Student(StuName,StuSex) values('����','��')
insert into Student(StuName,StuSex) values('����','��')
insert into Student(StuName,StuSex) values('�ŷ�','��')
insert into Student(StuName,StuSex) values('����','��')
insert into Student(StuName,StuSex) values('��','��')
insert into Student(StuName,StuSex) values('����','��')
insert into Student(StuName,StuSex) values('κ��','��')
insert into Student(StuName,StuSex) values('��Ӻ','��')
insert into Student(StuName,StuSex) values('�����','��')
insert into Student(StuName,StuSex) values('����','��')
insert into Student(StuName,StuSex) values('�ܲ�','��')
insert into Student(StuName,StuSex) values('��ƽ','��')
insert into Student(StuName,StuSex) values('�Ű�','��')
insert into Student(StuName,StuSex) values('�ܲ�','��')
insert into Student(StuName,StuSex) values('����','��')
insert into Student(StuName,StuSex) values('��ا','��')
insert into Student(StuName,StuSex) values('��ֲ','��')
insert into Student(StuName,StuSex) values('����','��')
insert into Student(StuName,StuSex) values('��Τ','��')
insert into Student(StuName,StuSex) values('����','��')
insert into Student(StuName,StuSex) values('�ĺ��','��')
insert into Student(StuName,StuSex) values('����','��')
insert into Student(StuName,StuSex) values('����','��')
insert into Student(StuName,StuSex) values('��ڼ','��')
insert into Student(StuName,StuSex) values('��Ȩ','��')
insert into Student(StuName,StuSex) values('���','��')
insert into Student(StuName,StuSex) values('���','��')
insert into Student(StuName,StuSex) values('̫ʷ��','��')
insert into Student(StuName,StuSex) values('����','Ů')
insert into Student(StuName,StuSex) values('С��','Ů')

select * from Student

--��ҳ
--����ÿҳ5������

--����1
--��ѯ��һҳ
select top 5 * from Student
--�ڶ�ҳ
select top 5 * from Student
where StuId not in (select top 5 StuId from Student)
--����ҳ
select top 5 * from Student
where StuId not in (select top 10 StuId from Student)

--��ʽ
--select top ҳ���С * from Student
--where StuId not in (select top ҳ���С*(��ǰҳ-1) StuId from Student)

--��ҳ����һ��top��ʽ��ҳ
declare @PageSize int = 5;
declare @PageIndex int = 3;
select top(@PageSize) * from Student
--��һҳҳβ@PageSize*(@PageIndex-1)
where StuId not in (select top(@PageSize*(@PageIndex-1)) StuId from Student)

--����2��ʹ��row_number��ҳ
--�����к�����ѯ
--select * from
--(select ROW_NUMBER() voer(order by StuId) RowId,* from Student) Temp
--where RowId between (��ǰҳ-1)*ҳ���С+1 and ��ǰҳ*ҳ���С

declare @PageSize1 int = 5
declare @PageIndex1 int = 3
select * from
--���кŵ����г�����Ϊһ����ʱ��
(select ROW_NUMBER() over(order by StuId) RowId,* from Student) Temp
where RowId between (@PageIndex1-1)*@PageSize1+1 and @PageIndex1*@PageSize1