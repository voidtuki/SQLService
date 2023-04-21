--内连接查询
**查询员工信息，同时显示部门名称**

**查询员工信息，同时显示部门名称**

```
select * from People
inner join Department 
on People.DepartmentId = Department.DepartmentId 
```

**查询员工信息，同时显示职级名称**

```
select * from People
inner join Rank
on People.RankId = Rank.RankId
```

**查询员工信息，同时显示部门名称，职位名称**

```
select * from People 
inner join Department on People.DepartmentId = Department.DepartmentId 
inner join Rank on People.RankId = Rank.RankId
```

--简单多表查询和内连接的共同特点：不符合主外键关系的数据不会被显示出来
insert into People(DepartmentId,RankId,Peoplename,PeopleSex,PeoPleBirth
,PeopleSalary,PeoplePhone,PeopleAddress,PeopleAddTime)
VALUES (99,99,'刘德华','男','1975-8-9',8000,'13556857548','香港',GETDATE())


select * from Department
select * from People