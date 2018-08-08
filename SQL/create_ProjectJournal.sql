
CREATE TABLE [dbo].[ProjectJournal](
	[ProjectJournalID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectID] [int] NOT NULL,
    ProjectJournalDate date NULL,
	JournalEntry nvarchar(500) NULL,
	CreatedUserID int NULL,
	UpdatedUserID int NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]
GO

