CREATE TABLE dbo.ContactInstitution(

	ContactInstitutionID	int IDENTITY(1,1) NOT NULL,
	ContactID				int NOT NULL,
	InstitutionID			int NOT NULL,

	[Role] nvarchar(200) NULL,

	Created datetime DEFAULT (getdate()) NULL,
	Updated datetime NULL

) 




