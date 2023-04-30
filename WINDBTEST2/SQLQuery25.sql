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
values('liubei','123456','����','4659874564')
insert into Member(MemberAccount,MemberPwd,MemberNickname,MemberPhone)
values('guanyu','123456','����','42354234124')
insert into Member(MemberAccount,MemberPwd,MemberNickname,MemberPhone)
values('zhangfei','123456','�ŷ�','41253445')
insert into Member(MemberAccount,MemberPwd,MemberNickname,MemberPhone)
values('zhangyun','123456','����','75675676547')
insert into Member(MemberAccount,MemberPwd,MemberNickname,MemberPhone)
values('machao','123456','��','532523523')

select * from Member

--�����α꣨scroll�������α꣨�������£���û��scroll��ֻ����ֻ�������ƶ�����
declare mycur cursor scroll
for select MemberAccount from Member

--�α��
open mycur

--��ȡĳ������
fetch first from mycur --��һ��
fetch last from mycur --���һ��
fetch absolute 2 from mycur --��ȡ�ڶ��У�����
fetch relative 2 from mycur --��ǰ������2�У����
fetch next from mycur --����һ��
fetch prior from mycur --����һ��

--��ȡ�α����ݴ�����������в�ѯ��������Ϣ
declare @acc varchar(20)
fetch absolute 2 from mycur into @acc --�α��ѯ����������
select * from Member where MemberAccount = @acc

--�����α�
declare @acc1 varchar(20)
fetch absolute 1 from mycur into @acc1 --�α�ͣ�ڵ�һ��
--@@fetch_status:0����ȡ�ɹ���-1����ȡʧ�ܣ�-2��������
while @@FETCH_STATUS = 0
	begin
		print '��ȡ�ɹ�'+@acc1
		fetch next from mycur into @acc1
	end

--�����α�������ݵ��޸ĺ�ɾ��
select * from Member
fetch absolute 2 from mycur
--�α굱ǰλ���޸���ɾ��
update Member set MemberPwd = '654321' where current of mycur

fetch absolute 2 from mycur
delete from Member where current of mycur

--�ر��α�
close mycur

--ɾ���α�
deallocate mycur

--����ָ��ĳ�ж��е��α꣬ѭ����ʾ��������
declare mycur cursor scroll
for select MemberAccount,MemberPwd,MemberNickname from Member

open mycur

declare @acc2 varchar(20)
declare @pwd varchar(20)
declare @nickname varchar(20)
--һ�ж��У���into����϶����������
fetch absolute 1 from mycur into @acc2,@pwd,@nickname
while @@FETCH_STATUS = 0
	begin
		print '�û�����'+@acc2+'�����룺 '+@pwd+'���ǳƣ� '+@nickname
		fetch next from mycur into @acc2,@pwd,@nickname
	end

close mycur

deallocate mycur