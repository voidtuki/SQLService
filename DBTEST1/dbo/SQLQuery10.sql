--多表查询

select * from Department
select * from People

--笛卡尔乘积
select * from People,Department
--查询结果将Department所有记录和People表所有记录依次排列组合
--形成新的结果

--简单多表查询
--查询员工信息，显示部门名称
select * from People,Department
where People.DepartmentId = Department.DepartmentId

--查询员工信息，显示职级名称
select * from People,[Rank]
where People.RankId = [Rank].RankId

--三表查询
--显示员工信息，显示部门信息，显示职级名称
select * from People,Department,[Rank]
where People.DepartmentId = Department.DepartmentId
and People.RankId = [Rank].RankId
