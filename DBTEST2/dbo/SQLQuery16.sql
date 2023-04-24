--信息打印
--终端输出
print 'hello,sql'
--表格输出
select 'hello,sql'

--变量：（1）局部变量 （2）全局变量
--（1）局部变量：以@开头，先声明，再赋值
declare @str varchar(20)
set @str = 'i like sql'
--select @str = 'i like sql'
print @str
--set和select进行赋值的时候的区别
--set:赋值变量指定的值,一条
--select:一般用于表中查询出的数据赋值给变量,
--如果查询结果有多条,取最后一条赋值,多条
--exp:select @a = 字段名 from 表名
--当前表最后一个字段的值赋值给a






--（2）全局变量：（1）以@@作为前缀
--				 （2）由系统进行定义和维护,只读

--@@ERROR：返回执行的上一个语句的错误号
--@@IDENTITY：返回最后插入的标识值
--@@MAX_CONNECTIONS：返回允许同时进行的最大用户连接数
--@@ROWCOUNT：返回受上一语句影响的行数
--@@SERVERNAME：返回运行 SQL Server 的本地服务器的名称
--@@SERVICENAME：返回 SQL Server 正在其下运行的注册表项的名称
--@@TRANCOUNT：返回当前连接的活动事务数
--@@LOCK_TIMEOUT：返回当前会话的当前锁定超时设置（毫秒）

select * from AccountInfo
--示例
--(1)为赵云此人进行开户开卡操作,赵云身份证：420107199904054233