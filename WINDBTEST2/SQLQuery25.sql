use DBTEST2

create table Member
(
	MemberId int primary key identity(1,1),
	MemberAccount nvarchar(20) unique check(len(MemberAccount) between 6 and 12),
	MemberPwd nvarchar(20),
	MemberNickname nvarchar(20),
	MemberPhone nvarchar(20)
)

insert into Member(MemberAccount,MemberPwd,MemberNickname,MemberPhone)
values('liubei','123456','刘备','4659874564')
insert into Member(MemberAccount,MemberPwd,MemberNickname,MemberPhone)
values('guanyu','123456','关羽','42354234124')
insert into Member(MemberAccount,MemberPwd,MemberNickname,MemberPhone)
values('zhangfei','123456','张飞','41253445')
insert into Member(MemberAccount,MemberPwd,MemberNickname,MemberPhone)
values('zhangyun','123456','赵云','75675676547')
insert into Member(MemberAccount,MemberPwd,MemberNickname,MemberPhone)
values('machao','123456','马超','532523523')

select * from Member

--创建游标（scroll：滚动游标（向上向下），没有scroll，只进（只能向下移动））
declare mycur cursor scroll
for select MemberAccount from Member

--游标打开
open mycur

--提取某行数据
fetch first from mycur --第一行
fetch last from mycur --最后一行
fetch absolute 2 from mycur --提取第二行，绝对
fetch relative 2 from mycur --当前行下移2行，相对
fetch next from mycur --下移一行
fetch prior from mycur --上移一行

--提取游标数据存入变量，进行查询所有列信息
declare @acc varchar(20)
fetch absolute 2 from mycur into @acc --游标查询结果给入变量
select * from Member where MemberAccount = @acc

--遍历游标
declare @acc1 varchar(20)
fetch absolute 1 from mycur into @acc1 --游标停在第一行
--@@fetch_status:0，提取成功；-1，提取失败；-2，不存在
while @@FETCH_STATUS = 0
	begin
		print '提取成功'+@acc1
		fetch next from mycur into @acc1
	end

--利用游标进行数据的修改和删除
select * from Member
fetch absolute 2 from mycur
--游标当前位置修改与删除
update Member set MemberPwd = '654321' where current of mycur

fetch absolute 2 from mycur
delete from Member where current of mycur

--关闭游标
close mycur

--删除游标
deallocate mycur

--创建指向某行多列的游标，循环显示多列数据
declare mycur cursor scroll
for select MemberAccount,MemberPwd,MemberNickname from Member

open mycur

declare @acc2 varchar(20)
declare @pwd varchar(20)
declare @nickname varchar(20)
--一行多列，在into后加上多个变量即可
fetch absolute 1 from mycur into @acc2,@pwd,@nickname
while @@FETCH_STATUS = 0
	begin
		print '用户名：'+@acc2+'，密码： '+@pwd+'，昵称： '+@nickname
		fetch next from mycur into @acc2,@pwd,@nickname
	end

close mycur

deallocate mycur