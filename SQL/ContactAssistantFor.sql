CREATE TABLE dbo.ContactAssistantFor(

	ContactAssistantForID	int IDENTITY(1,1) NOT NULL,
	ContactID				int NOT NULL,
	ContactAssistantID		int NOT NULL,

	Created datetime DEFAULT (getdate()) NULL,
	Updated datetime NULL

) 




