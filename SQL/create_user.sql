USE [master]
GO

CREATE LOGIN [web_user3] WITH PASSWORD=N'E#355840'
	, DEFAULT_DATABASE=[master]
	, DEFAULT_LANGUAGE=[us_english]
	, CHECK_EXPIRATION=OFF
	, CHECK_POLICY=OFF
GO

ALTER LOGIN [web_user] ENABLE
GO


USE [TFRI]
GO

CREATE USER [web_user] FOR LOGIN [web_user] WITH DEFAULT_SCHEMA=[db_datareader]
GO

ALTER ROLE [db_datawriter] ADD MEMBER [web_user]
GO
ALTER ROLE [db_datareader] ADD MEMBER [web_user]
GO
ALTER AUTHORIZATION ON SCHEMA::[db_owner] TO [web_user]
GO