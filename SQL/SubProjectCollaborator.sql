CREATE TABLE dbo.SubProjectCollaborator(

	SubProjectCollaboratorID int IDENTITY(1,1) NOT NULL,
	SubProjectID   int NOT NULL,
	
	ContactID int NOT NULL,

	Created datetime DEFAULT (getdate()) NULL,
	Updated datetime NULL

) 




