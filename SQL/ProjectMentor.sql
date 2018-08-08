CREATE TABLE dbo.ProjectMentor(

	ProjectMentorID		int IDENTITY(1,1) NOT NULL,
	ProjectID			int NOT NULL,
	MentorProjectID		int NULL,

	ContactID			int NULL,

	Created				datetime  DEFAULT (getdate()) NULL,
	Updated				datetime NULL

)