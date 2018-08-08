CREATE TABLE dbo.InstitutionCommRep(

	InstitutionCommRepID	int IDENTITY(1,1) NOT NULL,
	InstitutionID			int NULL,
	ContactID				int NULL,

	Created datetime DEFAULT (getdate()) NULL,
	Updated datetime NULL
)