CREATE TABLE dbo.PeopleGroup(

	PeopleGroupID int IDENTITY(1,1) NOT NULL,
	
	GroupName	nvarchar(500) NOT NULL,
	Notes		nvarchar(2000)  NULL,

	Created datetime DEFAULT (getdate()) NULL,
	Updated datetime NULL

) 




