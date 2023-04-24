--(1)查询出武汉地区所有的员工信息，要求显示部门名称以及员工的详细资料（显示中文别名）
select 
PeopleId 员工编号,DepartmentName 部门名称,PeopleName 员工姓名,
PeopleSex 员工性别,PeopleBirth 生日,PeopleSalary 月薪,PeoplePhone 电话,PeopleAddress 地址
from People
LEFT JOIN Department on Department.DepartmentId = People.PeopleId
where PeopleAddress = '武汉'

--(2)查询出武汉地区所有的员工信息，要求显示部门名称，职级名称以及员工的详细资料（显示中文别名）
select 
PeopleId 员工编号,Department.DepartmentId 部门编号,DepartmentName 部门名称,
[Rank].RankId 职级编号,RankName 职级,PeopleName 员工姓名,
PeopleSex 员工性别,PeopleBirth 生日,PeopleSalary 月薪,PeoplePhone 电话,PeopleAddress 地址
from People
LEFT JOIN Department on Department.DepartmentId = People.PeopleId
LEFT JOIN [Rank] on [Rank].RankId = People.RankId
where PeopleAddress = '武汉'

--(3)根据部门分组统计员工人数，员工工资总和，平均工资，最高工资和最低工资。
select
DepartmentName 部门名称,
count(*) 员工人数,
sum(PeopleSalary) 员工工资总和,
avg(PeopleSalary) 平均工资,
max(PeopleSalary) 最高工资,
min(PeopleSalary) 最低工资
from People
Inner JOIN Department on Department.DepartmentId = People.DepartmentId
--多字段查询
GROUP BY Department.DepartmentId,DepartmentName

--(4)根据部门分组统计员工人数，员工工资总和，平均工资，最高工资和最低工资
--平均工资在10000以下的不参与统计，并且根据平均工资降序排列
select
DepartmentName 部门名称,
count(*) 员工人数,
sum(PeopleSalary) 员工工资总和,
avg(PeopleSalary) 平均工资,
max(PeopleSalary) 最高工资,
min(PeopleSalary) 最低工资
from People
Inner JOIN Department on Department.DepartmentId = People.DepartmentId
--多字段查询
GROUP BY Department.DepartmentId,DepartmentName
HAVING round(avg(PeopleSalary),2) >= 10000
ORDER BY  round(avg(PeopleSalary),2) desc

--(5)根据部门名称，然后根据职位名称
--分组统计员工人数，员工工资总和，平均工资，最高工资和最低工资
select
DepartmentName 部门名称,
RankName 职级名称,
count(*) 员工人数,
sum(PeopleSalary) 员工工资总和,
avg(PeopleSalary) 平均工资,
max(PeopleSalary) 最高工资,
min(PeopleSalary) 最低工资
from People
INNER JOIN Department on Department.DepartmentId = People.DepartmentId
INNER JOIN [Rank] on [Rank].RankId = People.RankId
--多字段查询
GROUP BY Department.DepartmentId,DepartmentName,[Rank].RankId,RankName

--自连接（自己连自己）
create table Dept
(
	DeptId int Primary key,--部门编号
	DeptName varchar(50),--部门名称
	ParentId int,--上级部门编号
)
--一级部门
insert into Dept(DeptId,DeptName,ParentId)
VALUES(1,'软件部',0)
insert into Dept(DeptId,DeptName,ParentId)
VALUES(2,'硬件部',0)
--二级部门
insert into Dept(DeptId,DeptName,ParentId)
VALUES(3,'软件研发部',1)
insert into Dept(DeptId,DeptName,ParentId)
VALUES(4,'软件测试部',1)
insert into Dept(DeptId,DeptName,ParentId)
VALUES(5,'软件实施部',1)
insert into Dept(DeptId,DeptName,ParentId)
VALUES(6,'硬件研发部',2)
insert into Dept(DeptId,DeptName,ParentId)
VALUES(7,'硬件测试部',2)
insert into Dept(DeptId,DeptName,ParentId)
VALUES(8,'硬件实施部',2)

select * from Dept
--显示以下效果
--部门编号   部门名称      上级部门
--3				  软件研发部  	 软件部
--4					软件测试部     软件部
--........
--用别名区分同一个表，作为两个表使用
--子表的上级部门编号，等于父表的编号
--A表是儿子，B表是父亲
--查询二级部门
select 
A.DeptId 部门编号,
A.DeptName 部门名称,
B.DeptName 上级部门
from Dept A 
inner join Dept B
on A.ParentId = B.DeptId