

select s.name
from sys.schemas s
where s.principal_id = USER_ID('web_user')


alter authorization on schema:: db_owner to dbo;
alter authorization on schema:: db_datareader to dbo;
alter authorization on schema:: db_datawriter to dbo;

USE [TFRI]
GO
/****** Object:  User [web_user2]    Script Date: 7/17/2018 5:25:43 PM ******/
DROP USER [web_user]
GO