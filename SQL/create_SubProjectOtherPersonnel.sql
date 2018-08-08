DROP TABLE [dbo].[SubProjectOtherPersonnel]
GO


CREATE TABLE [dbo].[SubProjectOtherPersonnel](
	[SubProjectOtherPersonnelID] [int] IDENTITY(1,1) NOT NULL,
	[SubProjectID] [int] NOT NULL,
	[ContactID] [int] NOT NULL,
	[Role] nvarchar(100) NUll,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[SubProjectOtherPersonnel] ADD  DEFAULT (getdate()) FOR [Created]
GO


