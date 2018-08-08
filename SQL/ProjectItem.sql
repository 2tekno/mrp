CREATE TABLE [dbo].[ProjectItem](
	[ProjectItemID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectID] [int] NOT NULL,
	[ProjectItemTitle] [nvarchar](500) NULL,

	[ProjectNotes] [nvarchar](1000) NULL,
	
	[InstitutionID] [int] NOT NULL,
	[ProgramID] [int] NOT NULL,

	
	[PrincipalInvestigatorID] [int] NULL,

	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,

	[ProjectItemStatusID] [int] NULL,

	[EffectiveDate] [datetime] NULL,
	[ExpiryDate] [datetime] NULL,

	[Keywords] [nvarchar](2000) NULL,

	ApprovedBudget decimal(18,2) NULL,

	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
)