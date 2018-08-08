
CREATE TABLE [dbo].[ProjectDiary](
	[ProjectDiaryID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectID] [int] NOT NULL,
	[ProjectDiaryDate] [date] NULL,
	[ProjectDiaryEntry] [nvarchar](500) NULL,
	[CreatedUserID] [int] NULL,
	[UpdatedUserID] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]

GO


