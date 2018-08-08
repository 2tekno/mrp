CREATE TABLE [dbo].[ProjectCoFunder](
	
	ProjectCoFunderID	int IDENTITY(1,1) NOT NULL,
	ProjectID			int NOT NULL,

	InstitutionID		int NOT NULL,
   
    BudgetAmount		decimal(18,2) NULL,
	Managed				nvarchar(20) NULL,

	Created				datetime  DEFAULT (getdate()) NULL,
	Updated				datetime NULL
)