DROP VIEW [dbo].[vwPeopleByProjectForPersonnelTab]
GO

create view [dbo].[vwPeopleByProjectForPersonnelTab]

AS

/*




SELECT * FROM vwPeopleByProjectForPersonnelTab 
WHERE ProjectID = 37
and ProjectRole = 'Project Co-Investigator'



*/

WITH cte1 AS (
	SELECT DISTINCT
	 B.ProjectID
	,A.ContactID
	,ProjectRole = 'Project Co-Investigator'
	FROM SubProjectCoInvestigator A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT DISTINCT
	 B.ProjectID
	,A.ContactID
	,ProjectRole = 'Project Collaborator'
	FROM SubProjectCollaborator A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID


	UNION ALL

	SELECT DISTINCT
	 B.ProjectID
	,A.FinancialOfficerID
	,ProjectRole = 'Financial Officer'
	FROM SubProjectBudget A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID
	WHERE A.FinancialOfficerID IS NOT NULL

	UNION ALL

	SELECT DISTINCT
	 B.ProjectID
	,A.[PIID]
	,ProjectRole = 'Principal Investigator'
	FROM SubProjectBudget A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID
	WHERE A.[PIID] IS NOT NULL

	UNION ALL

	SELECT DISTINCT
	 B.ProjectID
	,A.ContactID
	,ProjectRole = 'Financial Representative'
	FROM SubProjectFinRep A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT DISTINCT
	 B.ProjectID
	,A.ContactID
	,ProjectRole = 'Sub-Project Manager'
	FROM SubProjectManager A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT DISTINCT
	 B.ProjectID
	,A.ContactID
	,ProjectRole = 'Sub-Project PI'
	FROM SubProjectPI A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT DISTINCT
	 B.ProjectID
	,A.ContactID
	,ProjectRole = 'OtherPersonnel'
	FROM SubProjectOtherPersonnel A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

)
,cte2 AS (
	SELECT DISTINCT
	 B.ProjectID
	,A.ContactID
	,A.FullName
	,B.ProjectRole

	FROM vwPeople A
	JOIN cte1 B ON b.ContactID = A.ContactID
)

SELECT 
*
FROM cte2



GO


