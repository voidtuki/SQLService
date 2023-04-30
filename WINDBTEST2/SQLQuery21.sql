create table Student
(
	StuId int primary key identity(1,2),--自动编号
	StuName varchar(20),
	StuSex varchar(4)
)

insert into Student(StuName,StuSex) values('刘备','男')
insert into Student(StuName,StuSex) values('关羽','男')
insert into Student(StuName,StuSex) values('张飞','男')
insert into Student(StuName,StuSex) values('赵云','男')
insert into Student(StuName,StuSex) values('马超','男')
insert into Student(StuName,StuSex) values('黄忠','男')
insert into Student(StuName,StuSex) values('魏延','男')
insert into Student(StuName,StuSex) values('简雍','男')
insert into Student(StuName,StuSex) values('诸葛亮','男')
insert into Student(StuName,StuSex) values('徐庶','男')
insert into Student(StuName,StuSex) values('周仓','男')
insert into Student(StuName,StuSex) values('关平','男')
insert into Student(StuName,StuSex) values('张苞','男')
insert into Student(StuName,StuSex) values('曹操','男')
insert into Student(StuName,StuSex) values('曹仁','男')
insert into Student(StuName,StuSex) values('曹丕','男')
insert into Student(StuName,StuSex) values('曹植','男')
insert into Student(StuName,StuSex) values('曹彰','男')
insert into Student(StuName,StuSex) values('典韦','男')
insert into Student(StuName,StuSex) values('许褚','男')
insert into Student(StuName,StuSex) values('夏侯敦','男')
insert into Student(StuName,StuSex) values('郭嘉','男')
insert into Student(StuName,StuSex) values('荀彧','男')
insert into Student(StuName,StuSex) values('贾诩','男')
insert into Student(StuName,StuSex) values('孙权','男')
insert into Student(StuName,StuSex) values('孙坚','男')
insert into Student(StuName,StuSex) values('孙策','男')
insert into Student(StuName,StuSex) values('太史慈','男')
insert into Student(StuName,StuSex) values('大乔','女')
insert into Student(StuName,StuSex) values('小乔','女')

select * from Student

--分页
--假设每页5条数据

--方法1
--查询第一页
select top 5 * from Student
--第二页
select top 5 * from Student
where StuId not in (select top 5 StuId from Student)
--第三页
select top 5 * from Student
where StuId not in (select top 10 StuId from Student)

--格式
--select top 页码大小 * from Student
--where StuId not in (select top 页码大小*(当前页-1) StuId from Student)

--分页方案一：top方式分页
declare @PageSize int = 5;
declare @PageIndex int = 3;
select top(@PageSize) * from Student
--上一页页尾@PageSize*(@PageIndex-1)
where StuId not in (select top(@PageSize*(@PageIndex-1)) StuId from Student)

--方案2：使用row_number分页
--根据行号来查询
--select * from
--(select ROW_NUMBER() voer(order by StuId) RowId,* from Student) Temp
--where RowId between (当前页-1)*页码大小+1 and 当前页*页码大小

declare @PageSize1 int = 5
declare @PageIndex1 int = 3
select * from
--将行号单独列出，作为一张临时表
(select ROW_NUMBER() over(order by StuId) RowId,* from Student) Temp
where RowId between (@PageIndex1-1)*@PageSize1+1 and @PageIndex1*@PageSize1