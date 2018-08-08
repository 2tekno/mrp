CREATE TABLE dbo.Project(

	ProjectID			int IDENTITY(1,1) NOT NULL,
	ProgramID			int NOT NULL,
	ProjectNumber		nvarchar(200) NULL,
	ProjectTitle		nvarchar(2000) NULL,
	ProjectShortName	nvarchar(1000) NULL,

	LengthOfProject		int NULL,
	StartDate			datetime NULL,
	EndDate				datetime NULL,

	LetterOfOfferDate		datetime NULL,
	NCEEndDate				datetime NULL,
	CloseOutLetterSentDate	datetime NULL,
	FollowUpDate			datetime NULL,

	LastProjectMeetingDate	datetime NULL,

	LastSACMeetingDate		datetime NULL,
	NextSACMeetingDate		datetime NULL,
	LastProgressReportReceivedDate	datetime NULL,
	NextProjectMeeting				nvarchar(100) NULL,

	ProgressReportMonths nvarchar(100) NULL,


	TotalAmountAwarded		decimal(18,2) NULL,
	TFRIAmount				decimal(18,2) NULL,
	BudgetAmendedDate		datetime NULL,

	ProjectStatusID			int NULL,
	Renewal					bit NULL,
	RenewedProjectID		int NULL,

	Notes			nvarchar(4000) NULL,
	CommunicationsNotes	nvarchar(4000) NULL,
	PublicationsList	nvarchar(4000) NULL,

	ClosedUnusedFunds  decimal(18,2) NULL,
	RefundReceivedDate datetime NULL,
	
	ProgressReportFrequency nvarchar(200) NULL,
    ProjectMeetingFrequency nvarchar(200) NULL,

	LaySummary			nvarchar(4000) NULL,
	ScientificSummary	nvarchar(4000) NULL,

	Created datetime  DEFAULT (getdate()) NULL,
	Updated datetime NULL,
	IsDeleted bit NULL,
	CreatedUserID		int NULL,
	UpdatedUserID		int NULL


--	Keywords nvarchar(2000) NULL,
	

)