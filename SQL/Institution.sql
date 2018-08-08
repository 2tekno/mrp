CREATE TABLE dbo.Institution(

	InstitutionID			int IDENTITY(1,1) NOT NULL,
	ParentInstitutionID		int NULL,
	InstitutionName			nvarchar(500) NULL,

	Address1	nvarchar(255) NULL,
	Address2	nvarchar(255) NULL,
	Address3	nvarchar(255) NULL,
	City		nvarchar(255) NULL,
	Province	nvarchar(255) NULL,
	PostalCode	nvarchar(255) NULL,
	Country		nvarchar(255) NULL,
	Notes		nvarchar(MAX) NULL,

	Created		datetime DEFAULT (getdate()) NULL,
	Updated		datetime NULL,
	CreatedUserID		int NULL,
	UpdatedUserID		int NULL

)