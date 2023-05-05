--函数
use DBTEST2

--（4）查询银行卡信息，将银行卡状态1,2,3,4分别转换为汉字“正常，挂失，冻结，注销”，
--根据银行卡余额显示银行卡等级30万以下为“普通用户”，30万以上为“VIP用户”，
--分别显示卡号，身份证，姓名，余额，用户等级，银行卡状态
select CardNo 卡号,AccountCode 身份证,RealName 姓名,CardMoney 余额,
dbo.GetGrade(CardMoney) 用户等级,dbo.GetState(CardState) 银行卡状态 from BankCard
inner join AccountInfo
on AccountInfo.AccountId = BankCard.AccountId

--用户等级函数
create function GetGrade(@cardmoney money) returns varchar(30)
as
begin
	declare @result varchar(30)
	if @cardmoney >= 300000
		set @result = 'VIP用户'
	else
		set @result = '普通用户'
	return @result
end

--求银行卡状态函数
create function GetState(@state int) returns varchar(30)
as
begin
	declare @result varchar(30)
	if @state = 1
		set @result = '正常'
	else if @state = 2
		set @result = '挂失'
	else if @state = 3
		set @result = '冻结'
	else if @state = 4
		set @result = '注销'
	else
		set @result = '异常'

	return @result
end

--（5）编写函数，根据出生日期求年龄，年龄求实岁，例如：
--生日为2000-5-5，当前为2018-5-3，年龄为17岁
--生日为2000-5-5，当前为2018-5-6，年龄为18岁
create table Emp
(
	EmpId int primary key identity(1,2), --自动编号
	empName varchar(20), --姓名
	empSex varchar(4),   --性别
	empBirth smalldatetime --生日
)
insert into Emp(empName,empSex,empBirth) values('刘备','男','2008-5-8')
insert into Emp(empName,empSex,empBirth) values('关羽','男','1998-10-10')
insert into Emp(empName,empSex,empBirth) values('张飞','男','1999-7-5')
insert into Emp(empName,empSex,empBirth) values('赵云','男','2003-12-12')
insert into Emp(empName,empSex,empBirth) values('马超','男','2003-1-5')
insert into Emp(empName,empSex,empBirth) values('黄忠','男','1988-8-4')
insert into Emp(empName,empSex,empBirth) values('魏延','男','1998-5-2')
insert into Emp(empName,empSex,empBirth) values('简雍','男','1992-2-20')
insert into Emp(empName,empSex,empBirth) values('诸葛亮','男','1993-3-1')
insert into Emp(empName,empSex,empBirth) values('徐庶','男','1994-8-5')

select * from Emp

--方案1
select *,year(GETDATE())-year(empBirth) 年龄 from Emp

--方案2 函数
select *,dbo.GetAge(empBirth) 年龄 from Emp

create function GetAge(@birth varchar(30)) returns int
begin
	declare @age int
	set @age = year(GETDATE()) - year(@birth)

	--判断月份是否小于生日月份
	if month(GETDATE()) < month(@birth)
		set @age = @age - 1
	--同月份，判断天数是否小于生日
	if month(GETDATE()) = month(@birth) and day(GETDATE()) < day(@birth)
		set @age = @age - 1
	return @age
end
