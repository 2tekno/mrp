CREATE TABLE ContactEmail(
	
	ContactEmailID			int IDENTITY(1,1) NOT NULL,
	ContactID			    int NOT NULL,
	Email			        nvarchar(200) NULL,
	Note			        nvarchar(200) NULL,

	Created datetime  DEFAULT (getdate()) NULL,
	Updated datetime NULL,
	CreatedUserID		int NULL,
	UpdatedUserID		int NULL


)