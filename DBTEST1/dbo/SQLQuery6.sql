--排序
--查询所有员工信息，根据工资排序，降序
--asc(ascend)：升序（默认值，可以不写） desc(descend)：降序
select * from People order by PeopleSalary desc
select * from People order by PeopleSalary

--查询所有员工信息，根据名字长度排序(降序)
select * from People order by len(PeopleName) desc

--查询出工资最高的5个人的信息
select top 5 * from People order by PeopleSalary desc
--查询出工资最高的10%的员工信息
select top 10 percent * from People order by PeopleSalary desc
--null:空值
insert into People(DepartmentId,RankId,PeopleName,PeopleSex,PeopleBirth,
PeopleSalary,PeoplePhone,PeopleAddTime)
values(1,1,'马云','男','1977-7-7',50000,'13858858585',GETDATE())
--查询出地址没有填写的员工信息，is null
select * from People where PeopleAddress is null
--查询出地址已经填写的员工信息，is not null
select * from People where PeopleAddress is not null

--查询出80后的员工信息
--写法1
select * from People where PeopleBirth >= '1980-1-1'
and PeopleBirth <= '1989-12-31'
--写法2
select * from People where PeopleBirth between  '1980-1-1' and '1989-12-31'
select * from People where year(PeopleBirth) between 1980 and 1989

--查询30-40岁之间，并且工资在15000-30000之间的员工信息
--假设 年龄 = 当前年份-生日年份
--写法1
select * from People where  (year(getdate())- year(PeopleBirth) >= 30 and year(getdate()) - year(PeopleBirth) <= 40)
and
(PeopleSalary >= 15000 and PeopleSalary <= 30000)
--写法2
select * from People where  (year(getdate())- year(PeopleBirth)between 30 and 40)
and
(PeopleSalary between 15000 and 30000)

--查询出星座是巨蟹座的员工信息（6.22-7.22）
select * from People where
(month(PeopleBirth)=6 and day(PeopleBirth)>=22)
or
(month(PeopleBirth)=7 and day(PeopleBirth)<=22)

--子查询
--查询出工资赵云高的人的信息
select * from People where PeopleSalary > 
(select PeopleSalary from People where PeopleName = '赵云')

--查询出和赵云在一个城市的人的信息
select * from People where PeopleAddress =
(select PeopleAddress from People where PeopleName = '赵云')

--查询出生肖是鼠的人员信息
--鼠,牛,虎,兔,龙,蛇,马,羊,猴,鸡,狗,猪
--4  5  6  7  8  9  10 11  0 1  2  3
select * from People where year(PeopleBirth) % 12 = 4

--查询所有员工信息，添加一列，显示生肖
--写法1
select *,
case
	when year(PeopleBirth) % 12 = 4 then '鼠'
	when year(PeopleBirth) % 12 = 5 then '牛'
	when year(PeopleBirth) % 12 = 6 then '虎'
	when year(PeopleBirth) % 12 = 7 then '兔'
	when year(PeopleBirth) % 12 = 8 then '龙'
	when year(PeopleBirth) % 12 = 9 then '蛇'
	when year(PeopleBirth) % 12 = 10 then '马'
	when year(PeopleBirth) % 12 = 11 then '羊'
	when year(PeopleBirth) % 12 = 0 then '猴'
	when year(PeopleBirth) % 12 = 1 then '鸡'
	when year(PeopleBirth) % 12 = 2 then '狗'
	when year(PeopleBirth) % 12 = 3 then '猪'
	else ''
end 生肖
from People

--写法2
select *,
case year(PeopleBirth) % 12
	when 4 then '鼠'
	when 5 then '牛'
	when 6 then '虎'
	when 7 then '兔'
	when 8 then '龙'
	when 9 then '蛇'
	when 10 then '马'
	when 11 then '羊'
	when 0 then '猴'
	when 1 then '鸡'
	when 2 then '狗'
	when 3 then '猪'
	else ''
end 生肖
from People