--查询所有列所有行
select * from Department
select * from [Rank]
select * from People

--查询指定列(姓名，性别，生日，月薪，电话)
select PeopleName,PeopleSex,PeopleBirth,PeopleSalary,PeoplePhone from People
--别名
--查询(姓名，性别，生日，月薪，电话)(显示中文列名)
select PeopleName 姓名,PeopleSex 性别,PeopleBirth 生日,PeopleSalary 月薪,PeoplePhone 电话
from People
--查询员工所在城市(不需要重复数据显示)
select distinct(PeopleAddress) from People
--假设准备加工资（上调20%），查询出加工资前后的数据对比的员工数据
select PeopleName,PeopleSex,PeopleSalary,
PeopleSalary*1.2 加薪后工资 
from People
