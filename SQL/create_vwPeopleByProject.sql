DROP VIEW [dbo].[vwPeopleByProject]
GO

create  view [dbo].[vwPeopleByProject]

AS

/*

select * from vwPeopleByProject 
where ProjectRole = 'Sub-Project PI'

*/

WITH cte1 AS (
	SELECT
	 ContactID
	,ProjectID
	,ProjectRole = 'Project Leader'
	FROM ProjectLeader

	UNION ALL

	SELECT
	 ContactID
	,ProjectID
	,ProjectRole = 'Project Manager'
	FROM ProjectManager

	UNION ALL

	SELECT
	 ContactID
	,ProjectID
	,ProjectRole = 'Project Mentor'
	FROM ProjectMentor

	UNION ALL

	SELECT
	 A.ContactID
	,B.ProjectID
	,ProjectRole = 'Project Co-Investigator'
	FROM SubProjectCoInvestigator A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT
	 A.ContactID
	,B.ProjectID
	,ProjectRole = 'Project Collaborator'
	FROM SubProjectCollaborator A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	--UNION ALL

	--SELECT
	-- A.ContactID
	--,B.ProjectID
	--,ProjectRole = 'Financial Officer'
	--FROM SubProjectFinOfficer A
	--JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT
	 A.FinancialOfficerID
	,B.ProjectID
	,ProjectRole = 'Financial Officer'
	FROM SubProjectBudget A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID
	WHERE A.FinancialOfficerID IS NOT NULL

	UNION ALL

	SELECT
	 A.[PIID]
	,B.ProjectID
	,ProjectRole = 'Principal Investigator'
	FROM SubProjectBudget A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID
	WHERE A.[PIID] IS NOT NULL

	UNION ALL

	SELECT
	 A.ContactID
	,B.ProjectID
	,ProjectRole = 'Financial Representative'
	FROM SubProjectFinRep A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT
	 A.ContactID
	,B.ProjectID
	,ProjectRole = 'Sub-Project Manager'
	FROM SubProjectManager A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT
	 A.ContactID
	,B.ProjectID
	,ProjectRole = 'Sub-Project PI'
	FROM SubProjectPI A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID


	UNION ALL

	SELECT
	 A.ContactID
	,A.ProjectID
	,ProjectRole = 'Project Collaborator'
	FROM ProjectCollaborator A
	


)
,cte2 AS (
	SELECT DISTINCT
	 A.ContactID
	,C.ProjectID
	,A.FullName
	,B.ProjectRole
	,C.ProjectNumber
	,C.ProjectShortName
	,D.ProjectStatusDescription
	,C.ProjectTitle
	FROM vwPeople A
	JOIN cte1 B ON b.ContactID = A.ContactID
	JOIN Project C ON C.ProjectID = B.ProjectID
	JOIN ProjectStatus D ON D.ProjectStatusID = C.ProjectStatusID
	WHERE ISNULL(C.IsDeleted, 0) = 0
)

SELECT 
*
FROM cte2



GO


