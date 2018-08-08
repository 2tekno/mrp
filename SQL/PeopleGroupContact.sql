CREATE TABLE dbo.PeopleGroupContact(

	PeopleGroupContactID int IDENTITY(1,1) NOT NULL,
	
	PeopleGroupID	int NOT NULL,
	ContactID		int NOT NULL,

	Created datetime DEFAULT (getdate()) NULL,
	Updated datetime NULL

) 




