--聚合函数

--(1)求员工总人数
select count(*) 人数 from People

--(2)求最大值，求最高工资
select max(PeopleSalary) 最高工资 from People

--(3)求最小时，求最小工资
select min(PeopleSalary) 最低工资 from People

--(4)求和，求所有员工的工资总和
select sum(PeopleSalary) 工资总和 from People

--(5)求平均值，求所用员工的平均工资
select round(avg(PeopleSalary),2) 平均工资 from People
--round函数会4舍5入
select round(25.5555,2)

--(6)求数量，最大值，最小值，总和，平均值，在一行显示 
select count(*) 人数,max(PeopleSalary) 最高工资,min(PeopleSalary) 最低工资,sum(PeopleSalary) 工资总和,
round(avg(PeopleSalary),2) 平均工资 from People

--(7)查询出武汉地区的员工人数，总工资，最高工资，最低工资和平均工资
select count(*) 员工人数,sum(PeopleSalary) 总工资,max(PeopleSalary) 最高工资,min(PeopleSalary) 最低工资,
round(avg(PeopleSalary),2) 平均工资 from People
where PeopleAddress = '武汉'

--(8)求出工资比平均工资高的人员信息
select * from People 
where PeopleSalary > 
(select round(avg(PeopleSalary),2) from People)

--(9)求数量，年龄最大值，年龄最小值，年龄总和，年龄平均值，在一行显示
--方案1
select count(*) 员工人数,
max(YEAR(GETDATE()) - YEAR(PeopleBirth)) 年龄最大值,
min(YEAR(GETDATE()) - YEAR(PeopleBirth)) 年龄最小值,
sum(YEAR(GETDATE()) - YEAR(PeopleBirth)) 年龄总和,
avg(YEAR(GETDATE()) - YEAR(PeopleBirth)) 年龄平均值 
from People

--方案2 DATEDIFF(year, PeopleBirth, GETDATE()) ，第一个参数单位
--第3个日期减去第2个日期
select count(*) 员工人数,
max(DATEDIFF(year, PeopleBirth, GETDATE() ) )年龄最大值,
min(DATEDIFF(year, PeopleBirth, GETDATE() ) )年龄最小值,
sum(DATEDIFF(year, PeopleBirth, GETDATE() ) )年龄总和,
avg(DATEDIFF(year, PeopleBirth, GETDATE() ) )年龄平均值 
from People

--(10)计算出月薪在10000以上的男性员工的最大年龄，最小年龄和平均年龄
--插入字段
select '月薪10000以上' 月薪,'男' 性别,
max(DATEDIFF(year, PeopleBirth, GETDATE()) ) 年龄最大值,
min(DATEDIFF(year, PeopleBirth, GETDATE()) ) 年龄最小值,
avg(DATEDIFF(year, PeopleBirth, GETDATE()) )年龄平均值 
from People
where PeopleSalary > 10000 and PeopleSex = '男'

--(11)统计出所在地在"武汉或上海"的所有女员工数量以及最大年龄，最小年龄和平均年龄
select '武汉或上海的女员工' 描述,
count(*) 女员工数量,
max(DATEDIFF(year, PeopleBirth, GETDATE())) 年龄最大值,
min(DATEDIFF(year, PeopleBirth, GETDATE())) 年龄最小值,
avg(DATEDIFF(year, PeopleBirth, GETDATE())) 年龄平均值
from People
where PeopleAddress IN ('上海','武汉')
and PeopleSex = '女'

--(12)求出年龄比平均年龄高的人员信息
--方案1
select '高于平均年龄的员工' 描述,
* from People
where YEAR(GETDATE()) - YEAR(PeopleBirth) > 
(select avg(YEAR(GETDATE()) - YEAR(PeopleBirth)) from People)

--方案2
select '高于平均年龄的员工' 描述,
* from People
where DATEDIFF(year, PeopleBirth, GETDATE()) > 
(select avg(DATEDIFF(year, PeopleBirth, GETDATE())) from People)

