CREATE TABLE dbo.ContactAdminFor(

	ContactAdminForID	int IDENTITY(1,1) NOT NULL,
	ContactID			int NOT NULL,
	ContactAdminID		int NOT NULL,

	Created datetime DEFAULT (getdate()) NULL,
	Updated datetime NULL

) 




