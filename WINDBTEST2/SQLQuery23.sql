--����
--��߼�����ѯЧ��

--���������ķ�ʽ��
--1��ͨ����ʽ��CREATE INDEX����
--2���ڴ���Լ��ʱ��Ϊ�����Ķ���
--		1.����Լ�����ۼ�������
--		2.ΨһԼ����Ψһ������

--���������﷨��
--create [unique] [clustered|nonclustered]
--index <index name> on <table or view name>(<column name> [asc|desc][,..n])

--��1����AccountInfo���е�AccountCode�ֶ��������
create unique nonclustered index index_code
on AccountInfo(AccountCode)

--�����鿴��sys.indexes��������
select * from sys.indexes where name = 'index_code'

--ɾ������
drop index index_code on AccountInfo
--��ʾָ���������в�ѯ
select * from AccountInfo with(index = index_code)
where AccountCode = '420107199507104133'