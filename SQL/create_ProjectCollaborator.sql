

CREATE TABLE [dbo].[ProjectCollaborator](
	[ProjectCollaboratorID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectID] [int] NOT NULL,
	[ContactID] [int] NOT NULL,
	[Created] [datetime] NULL DEFAULT (getdate()),
	[Updated] [datetime] NULL
) ON [PRIMARY]

GO


