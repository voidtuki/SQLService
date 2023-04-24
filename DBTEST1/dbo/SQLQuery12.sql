--外连接（左外联，右外联，全外联）
--左外联：以左表为主表进行数据显示，主外键关系找不到的数据null取代
--查询员工信息，显示部门名称
select * from People
left join Department on People.DepartmentId = Department.DepartmentId

select * from Department
left join People on People.DepartmentId = Department.DepartmentId
--查询员工信息，显示职级名称
select * from People
left join [Rank] on People.RankId = [Rank].RankId

--右连：A left join B = B right join A
--下面两个查询含义相同
select * from People
left join Department on People.DepartmentId = Department.DepartmentId

select * from Department 
right join People on People.DepartmentId = Department.DepartmentId

--全外联：两张表的数据，无论是否符合关系，都要显示