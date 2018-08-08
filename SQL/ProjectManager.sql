CREATE TABLE dbo.ProjectManager(

	ProjectManagerID	int IDENTITY(1,1) NOT NULL,
	ProjectID			int NOT NULL,

	ContactID			int NULL,

	Created datetime  DEFAULT (getdate()) NULL,
	Updated datetime NULL

)