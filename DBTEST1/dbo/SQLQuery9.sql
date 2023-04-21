--分组查询

--统计员工人数，员工工资总和，最高工资和最低工资
select
count(*) 员工人数,
sum(PeopleSalary) 工资总和,
max(PeopleSalary) 最高工资,
min(PeopleSalary) 最低工资
from People

--(1)根据员工所在地区分组统计员工人数，员工工资总和，最高工资和最低工资
--方案1
select  '武汉' 地区,
count(*) 员工人数,
sum(PeopleSalary) 工资总和,
max(PeopleSalary) 最高工资,
min(PeopleSalary) 最低工资
from People
where PeopleAddress = '武汉'
union
select  '北京' 地区,
count(*) 员工人数,
sum(PeopleSalary) 工资总和,
max(PeopleSalary) 最高工资,
min(PeopleSalary) 最低工资
from People
where PeopleAddress = '北京'

--方案2
select
PeopleAddress 地区,
count(*) 员工人数,
sum(PeopleSalary) 工资总和,
max(PeopleSalary) 最高工资,
min(PeopleSalary) 最低工资
from People
GROUP BY PeopleAddress


--(2)根据员工所在地区分组统计员工人数，员工工资总和，平均工资，最高工资和最低工资，
--1985年及以后出身的员工不参与统计
select
PeopleAddress 地区,
count(*) 员工人数,
sum(PeopleSalary) 工资总和,
avg(PeopleSalary) 平均工资,
max(PeopleSalary) 最高工资,
min(PeopleSalary) 最低工资
from People
where PeopleBirth < '1985-1-1'
--where不能加到group by之后
GROUP BY PeopleAddress


--(3)根据员工所在地区分组统计员工人数，员工工资总和，平均工资，最高工资和最低工资，
--要求筛选出员工人数至少在2人及以上的记录，并且1985年及以后出身的员工不参与统计
select
PeopleAddress 地区,
count(*) 员工人数,
sum(PeopleSalary) 工资总和,
avg(PeopleSalary) 平均工资,
max(PeopleSalary) 最高工资,
min(PeopleSalary) 最低工资
from People
where
--普通条件，写在where中，group by前
--聚合函数不能出现在where中，作为条件
PeopleBirth < '1985-1-1'
GROUP BY PeopleAddress
--聚合函数的结果作为条件，写在group by后
having count(*) >= 2