--ѭ���ṹ��while��
--��1��ѭ����ӡ1-10
declare @i int = 1
while @i <= 10
begin
	print @i
	set @i = @i +1
end

--��2��ѭ����ӡ�žų˷���
--�����ַ�;char(9) �Ʊ����char(10)���з�
declare @a int = 1
while @a <= 9
begin
	--ʹ���ַ����ۼ�
	declare @str varchar(1000) = ''
	declare @b int = 1
	while @b <= @a
		begin
			set @str = @str +
			Convert(varchar,@a)+'*'+Convert(varchar,@b)
			+'='+ Convert(varchar,@a*@b) + char(9)
			--����
			set @b = @b + 1
		end
	set @a = @a + 1
	print @str
end

