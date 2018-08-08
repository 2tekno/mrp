
CREATE TABLE [dbo].[Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[LoginName] [nvarchar](50) NULL,
	[Password] [nvarchar](200) NULL,
	[Sal] [nvarchar](20) NULL,
	[LName] [nvarchar](50) NULL,
	[FName] [nvarchar](50) NULL,
	[JobTitle] [nvarchar](50) NULL,
	[Email] [nvarchar](200) NULL,
	[Notes] [nvarchar](4000) NULL,
	[Created] [datetime] NULL DEFAULT (getdate()),
	[Updated] [datetime] NULL,
	[Inactive] [bit] NULL
) ON [PRIMARY]

GO




