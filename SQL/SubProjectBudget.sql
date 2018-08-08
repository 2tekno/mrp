CREATE TABLE dbo.SubProjectBudget(

	SubProjectBudgetID	int IDENTITY(1,1) NOT NULL,
	SubProjectID			int NOT NULL,
	
	PIID			int NOT NULL,
	InstitutionID	int NOT NULL,
	CoFunderID		int NOT NULL,

	Managed nvarchar(20) NULL,
	Year1Amt decimal(18,2) NULL,
	Year2Amt decimal(18,2) NULL,
	Year3Amt decimal(18,2) NULL,
	Year4Amt decimal(18,2) NULL,
	Year5Amt decimal(18,2) NULL,
	Year6Amt decimal(18,2) NULL,
	Year7Amt decimal(18,2) NULL,
	Year8Amt decimal(18,2) NULL,
	Year9Amt decimal(18,2) NULL,

	Created datetime DEFAULT (getdate()) NULL,
	Updated datetime NULL

) 




