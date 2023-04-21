--表关系
--一对多关系（专业--学生）
--就是专业有很多学生选择，但学生不一定选这个专业
drop table Profession
drop table Student

create table Profession --专业
(
	ProId int primary key identity(1,1), --专业编号
	ProName varchar(50) not null, --专业名称
)

create table Student --学生
(
	StuId int primary key identity(1,1), --学生编号
	ProId int references Profession(ProId), --专业编号
	StuName varchar(50) not null, --学生名字
	StuSex char(2) not null -- 学生性别
)

insert into Profession(ProName)
values('软件开发')
insert into Profession(ProName)
values('企业信息化')
insert into Student(ProId,StuName,StuSex)
values(1,'刘备','男')
insert into Student(ProId,StuName,StuSex)
values(2,'关羽','男')
insert into Student(ProId,StuName,StuSex)
values(1,'张飞','男')
insert into Student(ProId,StuName,StuSex)
values(2,'赵云','男')

delete from Student where StuId = 3

select * from Student
left join Profession
on Profession.ProId = Student.ProId

--一对一关系（学生基本信息--学生详细信息）
--可以用一对多来表示一对一，两个表的学号相同则为一对一
--一个学生对应一个自己的信息，一次只输入一个详细信息
--这里手动输入编号是方便后期维护，可以固定位置插入，空行
--也可以将下面两张表合在一起
drop table StudentBasicInfo
drop table StudentDetailInfo

create table StudentBasicInfo --学生基本信息
(
	StuNo varchar(20) primary key not null, --学号
	StuName varchar(20) not null, --姓名
	StuSex nvarchar(1) not null --性别 nvarchar = 2byte varchar/char = 1bytes
)
create table StudentDetailInfo --学生详细信息
(
	StuNo varchar(20) primary key not null,
	StuQQ varchar(20), --QQ
	StuPhone varchar(20), --电话
	StuMail varchar(100), --邮箱
	StuBirth date --生日
	
)

--插入数据的时候按照顺序先插入刘备的基本信息，在插入关羽的基本信息
insert into StudentBasicInfo(StuNo,StuName,StuSex)
values('QH001','刘备','男')
insert into StudentBasicInfo(StuNo,StuName,StuSex)
values('QH002','关羽','男')
--插入数据的时候按照顺序先插入关羽的详细信息，在插入刘备的详细信息
insert into
StudentDetailInfo(StuNo,StuQQ,stuPhone,StuMail,StuBirth)
values('QH002','156545214','13654525478','guanyu@163.com','1996-6-6')
insert into 
StudentDetailInfo(StuNo,StuQQ,stuPhone,StuMail,StuBirth)
values('QH001','186587854','15326545214','liubei@163.com','1998-8-8')

--一对多表示一对一
create table StudentBasicInfo  --学生基本信息
(
	StuNo int primary key identity(1,1),  --学号
	StuName varchar(20) not null, --姓名
	StuSex nvarchar(1) not null  --性别
)
create table StudentDetailInfo  --学生详细信息
(
	StuDetailNo int primary key identity(1,1),  --详细信息编号
	StuNo int references StudentBasicInfo(StuNo) --学号,外键
	StuQQ varchar(20), --QQ
	stuPhone varchar(20), --电话
	StuMail varchar(100), --邮箱
	StuBirth date         --生日
)

--多对多（选课成绩--学生）
--多门课对应多门课学生
--正反都是一对多
drop table Course
drop table Student
drop table Exam

create table Course --课程
(
	CourseId int primary key identity(1,1), -- 课程编号
	CourseName varchar(30) not null, --课程名称
	CourseContent text --课程介绍
)
create table Student --学生
(
	StuId int primary key identity(1,1), --学号
	StuName varchar(50) not null, --学生名字
	StuSex char(2) not null --学生性别
)

--关系表
create table Exam --考试信息表
(
	ExamId int primary key identity(1,1),--选课成绩编号
	StuId int references Student(StuId),--学生编号
	CourseId int not null, --课程编号
	Score int not null,--考试分数
	
)

insert into 
Course(CourseName,CourseContent)
values('HTML','静态网页制作')
insert into 
Course(CourseName,CourseContent)
values('WinForm','Widnows应用程序开发')

insert into
Student(StuName,StuSex)
values('刘备','男')
insert into
Student(StuName,StuSex)
values('关羽','男')

insert into
Exam(StuId,CourseId,Score)
values(1,1,90)
insert into
Exam(StuId,CourseId,Score)
values(1,2,80)
insert into
Exam(StuId,CourseId,Score)
values(2,2,85)

select * from Student
--不能反着写
-- inner join Course on Course.CourseId = Exam.CourseId
-- inner join Exam on Exam.StuId = Student.StuId
--先与关联表内连接，再用关联表与课程表内连接
inner join Exam on Exam.StuId = Student.StuId
inner join Course on Course.CourseId = Exam.CourseId
