select * from Department
select * from [Rank]
select * from People

--修改数据
--语法：
--update 表名 set 字段1 = 值1，字段2 = 值2 where 条件
--工资调整，每个人加薪1000元
update People set PeopleSalary = PeopleSalary + 1000
--将员工编号为3的人加薪2000
--单条件
update People set PeopleSalary = PeopleSalary + 2000
where PeopleId = 54
--将软件部(编号2)人员工资低于10000的调整成10000
--多条件，使用逻辑运算关键字连接，and（逻辑与）、or（逻辑或）
update People set PeopleSalary = 10000
where DepartmentId = 2 and PeopleSalary < 10000

select * from People where DepartmentId = 2

--修改张三的工资是以前的两倍，并且把张三的地址改成北京
--多字段修改，','逗号隔开
update People set PeopleSalary = PeopleSalary * 2,PeopleAddress = '北京'
where PeopleName = '貂蝉'

--删除数据
--delete from 表名 where 条件
--删除员工表所有数据
delete from People
--删除市场部(编号1)中工资大于1万的人
delete from People where PeopleSalary > 10000 and DepartmentId = 1