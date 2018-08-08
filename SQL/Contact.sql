CREATE TABLE dbo.Contact(

	ContactID		int IDENTITY(1,1) NOT NULL,
	FName			nvarchar(255) NULL,
    LName			nvarchar(255) NULL,
	Sal				nvarchar(100) NULL,

	JobTitle		nvarchar(255) NULL,

	Notes			nvarchar(1000) NULL,
	
	Phone			nvarchar(1000) NULL,
	Email			nvarchar(1000) NULL,
	
	Address1		nvarchar(255) NULL,
	Address2		nvarchar(255) NULL,
	Address3		nvarchar(255) NULL,
	City			nvarchar(255) NULL,
	Province		nvarchar(255) NULL,
	PostalCode		nvarchar(255) NULL,
	Country			nvarchar(255) NULL,

	Bio				nvarchar(4000) NULL,

	Created			datetime DEFAULT (getdate()) NULL,
	Updated			datetime NULL,
	CreatedUserID		int NULL,
	UpdatedUserID		int NULL

)