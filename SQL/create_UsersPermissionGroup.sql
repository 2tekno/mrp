drop table UsersPermissionGroup
go

CREATE TABLE [dbo].[UsersPermissionGroup](
	[UPGID] [int] IDENTITY(1,1) NOT NULL,
	[GroupName] [nvarchar](100) NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]

GO

INSERT INTO [UsersPermissionGroup] ([GroupName]) VALUES ('Contact');
INSERT INTO [UsersPermissionGroup] ([GroupName]) VALUES ('Finance');
INSERT INTO [UsersPermissionGroup] ([GroupName]) VALUES ('Research');
INSERT INTO [UsersPermissionGroup] ([GroupName]) VALUES ('Institution');


