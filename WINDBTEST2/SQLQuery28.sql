--触发器
use DBTEST2
--instead of：在执行操作之前被执行
--after：在执行操作之后被执行

--部门
create table Department
(
	DepartmentId varchar(10) primary key,--主键
	DepartmentName nvarchar(50) --部门名称
)

--人员信息
create table People
(
	PeopleId int primary key identity(1,1),--主键，自动增长
	DepartmentId varchar(10),--部门编号，外键，与部门表关联
	PeopleName nvarchar(20),--人员姓名
	PeopleSex nvarchar(2),--人员性别
	PeoplePhone nvarchar(20) --电话，联系方式
)

insert into Department(DepartmentId,DepartmentName)
values('001','总经办')
insert into Department(DepartmentId,DepartmentName)
values('002','市场部')
insert into Department(DepartmentId,DepartmentName)
values('003','人事部')
insert into Department(DepartmentId,DepartmentName)
values('004','财务部')
insert into Department(DepartmentId,DepartmentName)
values('005','软件部')
insert into People(DepartmentId,PeopleName,PeopleSex,PeoplePhone)
values('001','刘备','男','13558785478')
insert into People(DepartmentId,PeopleName,PeopleSex,PeoplePhone)
values('001','关羽','男','13558788785')
insert into People(DepartmentId,PeopleName,PeopleSex,PeoplePhone)
values('002','张飞','男','13698547125')

--（1）假设有部门表和员工表，在添加员工的时候，该员工的部门编号如果在部门表中找不到，
--则自动添加部门信息，部门名称为“新部门”。
--create trigger 触发器名称 on 表名 after/instead of 增删改查
--drop trigger
--alter trigger
create trigger tri_InsertPeple on People after insert
as
	--添加的内容会在inserted表中
	if not exists(select * from Department where DepartmentId = (select DepartmentId from inserted))
		begin
			insert into Department(DepartmentId,DepartmentName)
			values((select DepartmentId from inserted),'新部门')
		end
go

--测试触发器
select * from People
select * from Department

--存在部门
insert into People(DepartmentId,PeopleName,PeopleSex,PeoplePhone)
values('003','赵云','男','13698547125')
--不存在部门
insert into People(DepartmentId,PeopleName,PeopleSex,PeoplePhone)
values('006','马超','男','13698547125')

--（2）触发器实现，删除一个部门的时候将部门下所有员工全部删除
create trigger tri_Delete on Department after delete
as
	--要删除的内容在deleted表中
	delete from People where DepartmentId = (select DepartmentId from deleted)
go

--测试触发器
select * from People
select * from Department
delete from Department where DepartmentId = '006'

--（3）创建一个触发器，删除一个部门的时候判断该部门下是否有员工，有则不删除，没有则删除
drop trigger tri_DeleteDept
create trigger tri_DeleteDept on Department instead of delete
as
	if not exists(select * from People where DepartmentId = (select DepartmentId from deleted))
		delete from Department where DepartmentId = (select DepartmentId from deleted)
go

--测试触发器
select * from People
select * from Department
--没有员工删除
delete from Department where DepartmentId = '005'
--有员工不删除
delete from Department where DepartmentId = '001'

--（4）修改一个部门编号之后，将该部门下所有员工的部门编号同步进行修改
drop trigger tri_UpdateDept
create trigger tri_UpdateDept on Department after update
as
	--新编号是插入的，老编号是删除的
	update People set DepartmentId = (select DepartmentId from inserted)
	where DepartmentId = (select DepartmentId from deleted)
go

--测试触发器
select * from Department
select * from People

update Department set DepartmentId = '005' where DepartmentId = '001'