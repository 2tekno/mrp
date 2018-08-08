CREATE TABLE [dbo].[CommunicationRep](
	CommunicationRepID int IDENTITY(1,1) NOT NULL,
	InstitutionID int NOT NULL,
	ContactID int NOT NULL,

	Created datetime  DEFAULT (getdate()) NULL,
	Updated datetime NULL
)