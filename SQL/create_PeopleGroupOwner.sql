DROP TABLE [dbo].[PeopleGroupOwner]
GO

CREATE TABLE [dbo].[PeopleGroupOwner](
	[PeopleGroupOwnerID] [int] IDENTITY(1,1) NOT NULL,
	[PeopleGroupID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PeopleGroupOwner] ADD  DEFAULT (getdate()) FOR [Created]
GO


