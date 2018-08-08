CREATE TABLE [dbo].[Program](
	[ProgramID] [int] IDENTITY(1,1) NOT NULL,
	[ProgramDescription] [nvarchar](500) NULL,
	[ProgramCode] [nvarchar](50) NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
)