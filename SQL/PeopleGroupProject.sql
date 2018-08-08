CREATE TABLE dbo.PeopleGroupProject(

	PeopleGroupProjectID int IDENTITY(1,1) NOT NULL,
	
	PeopleGroupID	int NOT NULL,
	ProjectID		int NULL,

	Created datetime DEFAULT (getdate()) NULL,
	Updated datetime NULL

) 




