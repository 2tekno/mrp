
CREATE TABLE [dbo].[UserGroupSecurity](
	[UserGroupSecurity] [int] IDENTITY(1,1) NOT NULL,
	UPGID int null,
	UserID int NULL,
	RoleID int NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]


