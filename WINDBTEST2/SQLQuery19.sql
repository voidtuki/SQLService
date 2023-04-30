--循环结构（while）
--（1）循环打印1-10
declare @i int = 1
while @i <= 10
begin
	print @i
	set @i = @i +1
end

--（2）循环打印九九乘法表
--特殊字符;char(9) 制表符，char(10)换行符
declare @a int = 1
while @a <= 9
begin
	--使用字符串累加
	declare @str varchar(1000) = ''
	declare @b int = 1
	while @b <= @a
		begin
			set @str = @str +
			Convert(varchar,@a)+'*'+Convert(varchar,@b)
			+'='+ Convert(varchar,@a*@b) + char(9)
			--自增
			set @b = @b + 1
		end
	set @a = @a + 1
	print @str
end

