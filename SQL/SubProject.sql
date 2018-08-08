CREATE TABLE dbo.SubProject(
	
	SubProjectID			int IDENTITY(1,1) NOT NULL,
	ProjectID				int NOT NULL,
	SubProjectName			nvarchar(1000) NULL,
	SubProjectDescription	nvarchar(4000) NULL,
	
	TotalAmountAwarded		decimal(18,2) NULL,
	TFRIAmount				decimal(18,2) NULL,
	BudgetAmendedDate		datetime NULL,

	MOUSite					int  NULL,
	MOUStartDate			datetime NULL,
	MOUEndDate				datetime NULL,
	MOUExtendedOnDate		datetime NULL,

	Notes					nvarchar(4000) NULL,
	IsDeleted bit NULL,
	Created datetime  DEFAULT (getdate()) NULL,
	Updated datetime NULL,
	CreatedUserID		int NULL,
	UpdatedUserID		int NULL


)