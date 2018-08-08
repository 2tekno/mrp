CREATE TABLE [dbo].[ProjectLeader](

	ProjectLeaderID int IDENTITY(1,1) NOT NULL,
	ProjectID		int NOT NULL,
	InstitutionID	int NULL,
	ContactID		int NOT NULL,

	Created datetime  DEFAULT (getdate()) NULL,
	Updated datetime NULL
)