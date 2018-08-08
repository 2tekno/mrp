CREATE TABLE ContactPhone(
	
	ContactPhoneID			int IDENTITY(1,1) NOT NULL,
	ContactID			    int NOT NULL,
	Phone			        nvarchar(200) NULL,
	Note			        nvarchar(200) NULL,

	Created datetime  DEFAULT (getdate()) NULL,
	Updated datetime NULL,
	CreatedUserID		int NULL,
	UpdatedUserID		int NULL


)