CREATE TABLE [dbo].[Role](
	[RoleID] [int] IDENTITY(1,1) NOT NULL,
	[RoleDescription] [nvarchar](255) NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
)