--数据库结构设计三范式
--第一范式
--相对，是对属性的原子性，要求属性具有原子性，不可再分解
drop table Student

--以下联系方式可以在分，不是最小单元
--把字段信息都放在一个地方，加大查询难度
--错误演示
create table Student --学生表
(
		StuId varchar(20) primary key,--学号
		StuName varchar(20) not null,--学生姓名
		StuContact varchar(50) not null, --联系方式 
)

--正确演示
create table Student --学生表
(
		StuId varchar(20) primary key,--学号
		StuName varchar(20) not null,--学生姓名
  	Tel varchar(20) not null, --联系电话
  	QQ varchar(20) not null,  --联系QQ
)

insert into Student(StuId,StuName,StuContact)
VALUES ('001','刘备','QQ:185699887;Tel:13885874587')
select * from Student

--第二范式
--是对记录的唯一性，要求记录有唯一标识，即实体的唯一性，即不存在部分依赖
--选课成绩表
drop table StudentCourse

--姓名依赖学号，课程名称依赖课程编号，会有冗余，维护数据很麻烦
--错误演示
create table StudentCourse
(
	StuId varchar(20),--学号
	StuName varchar(20) not null,--学生姓名
	CourseId varchar(20) not null,--课程编号
	CourseName varchar(20) not null, --选课课程名称
	CourseScore int not null, --考试成绩
)

--正确演示

--拆分为两张表，解决一些问题
--两张表互不依赖，用关系表连接一些信息
create table Course --课程
(
	CourseId int primary key identity(1,1),--课程编号
	CourseName varchar(30) not null, --课程名称
	CourseContent text --课程介绍
)
insert into Course(CourseName,CourseContent) values('HTML','静态网页的制作')
insert into Course(CourseName,CourseContent) values('WinForm','Windows应用程序开发')

create table Student --学生
(
	StuId int primary key identity(1,1), --学生编号
	StuName varchar(50) not null, --学生名字
	StuSex char(2) not null --学生性别
)
insert into Student(StuName,StuSex) values('刘备','男')
insert into Student(StuName,StuSex) values('关羽','男')

--正确演示
--关联表
create Table Exam --考试信息表
(
	ExamId int primary key identity(1,1), --选课成绩编号
	StuId int not null, --学生编号
	CourseId int not null,  --课程编号
	Score int not null, --考试分数
)
insert into Exam(StuId,CourseId,Score) values(1,1,90)
insert into Exam(StuId,CourseId,Score) values(1,2,80)
insert into Exam(StuId,CourseId,Score) values(2,2,85)

select * from Course
select * from Student
select * from Exam

select Student.StuId,StuName,CourseName,Score from Student
inner join Exam on Student.StuId = Exam.StuId
inner join Course on Course.CourseId = Exam.CourseId



insert into StudentCourse(StuId,StuName,CourseId,CourseName,CourseScore)
values('001','刘备','001','语文',80)
insert into StudentCourse(StuId,StuName,CourseId,CourseName,CourseScore)
values('001','刘备','002','数学',70)
insert into StudentCourse(StuId,StuName,CourseId,CourseName,CourseScore)
values('002','关羽','003','英语',80)
insert into StudentCourse(StuId,StuName,CourseId,CourseName,CourseScore)
values('003','张飞','003','英语',90)

select * from StudentCourse

--第三范式
--错误演示
create table Student
(
	StuId varchar(20) primary key,--学号
	StuName varchar(20) not null,--学生姓名
	Professio
	ProfessionalId int not null,--专业编号
	ProfessionalName varchar(50),--专业名称
	ProfessionalRemark varchar(200), --专业介绍
)
insert into Student(StuId,StuName,ProfessionalId,ProfessionalName,ProfessionalRemark)
values('001','刘备',1,'计算机','最牛的专业')
insert into Student(StuId,StuName,ProfessionalId,ProfessionalName,ProfessionalRemark)
values('002','关羽',2,'工商管理','管理学的基础专业')
insert into Student(StuId,StuName,ProfessionalId,ProfessionalName,ProfessionalRemark)
values('003','张飞',1,'计算机','最牛的专业')
select * from Student

--正确演示
create table Professional
(
	ProfessionalId int primary key identity(1,1),--专业编号
	ProfessionalName varchar(50),--专业名称
	ProfessionalRemark varchar(200), --专业介绍
)

drop table Student

create table Student
(
	StuId varchar(20) primary key,--学号
	StuName varchar(20) not null,--学生姓名
	ProfessionalId int not null,--专业编号
)
insert into Professional(ProfessionalName,ProfessionalRemark) values('计算机','最牛的专业')
insert into Professional(ProfessionalName,ProfessionalRemark) values('工商管理','管理学的基础专业')
insert into Student(StuId,StuName,ProfessionalId) values('001','刘备',1)
insert into Student(StuId,StuName,ProfessionalId) values('002','关羽',2)
insert into Student(StuId,StuName,ProfessionalId) values('003','张飞',1)

select * from Professional
select * from Student