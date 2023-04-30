--索引
--提高检索查询效率

--创建索引的方式：
--1、通过显式的CREATE INDEX命令
--2、在创建约束时作为隐含的对象
--		1.主键约束（聚集索引）
--		2.唯一约束（唯一索引）

--创建索引语法：
--create [unique] [clustered|nonclustered]
--index <index name> on <table or view name>(<column name> [asc|desc][,..n])

--（1）给AccountInfo表中的AccountCode字段添加索引
create unique nonclustered index index_code
on AccountInfo(AccountCode)

--索引查看（sys.indexes）索引表
select * from sys.indexes where name = 'index_code'

--删除索引
drop index index_code on AccountInfo
--显示指定索引进行查询
select * from AccountInfo with(index = index_code)
where AccountCode = '420107199507104133'