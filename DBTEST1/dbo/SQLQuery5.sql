--条件查询
select * from People

--单条件
--查询性别为女的员工信息
select * from People where PeopleSex = '女'
--查询工资大于等于10000元的员工信息
select * from People where PeopleSalary >= 10000

--多条件
--查询出性别为女，工资大于等于10000元的员工信息
select * from People where PeopleSex = '女' and PeopleSalary >= 10000
--查询月薪大于10000员工，或者月薪大于等于8000的女员工
select * from People where (PeopleSalary >= 10000) 
or (PeopleSex = '女' and PeopleSalary >= 8000)

--查询出生年月再1980-1-1之后，而且月薪大于等于10000的女员工
select * from People where PeopleBirth >= '1980-1-1'
and ((PeopleSex = '女' and PeopleSalary >= 10000))

--查询月薪在10000-20000之间的员工信息
--写法1
select * from People where PeopleSalary >= 10000 and PeopleSalary <= 20000
--写法2
select * from People where PeopleSalary between 10000 and 20000

--查询出地址在武汉或者北京的员工信息
--写法1
select * from People where PeopleAddress = '武汉' or PeopleAddress = '北京'
--写法2
select * from People where PeopleAddress in('武汉','北京')
