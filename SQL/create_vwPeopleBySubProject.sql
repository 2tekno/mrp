DROP VIEW [dbo].[vwPeopleBySubProject]
GO

create view [dbo].[vwPeopleBySubProject]

AS

/*

select * from vwPeopleBySubProject 
where ProjectID = 89

where ProjectRole = 'Sub-Project PI'



select * from vwPeopleBySubProject
where ProjectID =37
and ProjectRole = 'Project Co-Investigator'


*/

WITH cte1 AS (
	SELECT DISTINCT
	 B.ProjectID
	,A.ContactID
	,B.SubProjectID
	,ProjectRole = 'Project Co-Investigator'
	FROM SubProjectCoInvestigator A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT DISTINCT
	 B.ProjectID
	,A.ContactID
	,B.SubProjectID
	,ProjectRole = 'Project Collaborator'
	FROM SubProjectCollaborator A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	--UNION ALL

	--SELECT
	-- A.ContactID
	--,B.SubProjectID
	--,ProjectRole = 'Financial Officer'
	--FROM SubProjectFinOfficer A
	--JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT DISTINCT
	 B.ProjectID
	,A.FinancialOfficerID
	,B.SubProjectID
	,ProjectRole = 'Financial Officer'
	FROM SubProjectBudget A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID
	WHERE A.FinancialOfficerID IS NOT NULL

	UNION ALL

	SELECT DISTINCT
	 B.ProjectID
	,A.[PIID]
	,B.SubProjectID
	,ProjectRole = 'Principal Investigator'
	FROM SubProjectBudget A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID
	WHERE A.[PIID] IS NOT NULL

	UNION ALL

	SELECT DISTINCT
	 B.ProjectID
	,A.ContactID
	,B.SubProjectID
	,ProjectRole = 'Financial Representative'
	FROM SubProjectFinRep A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT DISTINCT
	 B.ProjectID
	,A.ContactID
	,B.SubProjectID
	,ProjectRole = 'Sub-Project Manager'
	FROM SubProjectManager A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT DISTINCT
	 B.ProjectID
	,A.ContactID
	,B.SubProjectID
	,ProjectRole = 'Sub-Project PI'
	FROM SubProjectPI A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT DISTINCT
	 B.ProjectID
	,A.ContactID
	,B.SubProjectID
	,ProjectRole = 'OtherPersonnel'
	FROM SubProjectOtherPersonnel A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

)
,cte2 AS (
	SELECT DISTINCT
	 B.ProjectID
	,A.ContactID
	,B.SubProjectID
	,A.FullName
	,B.ProjectRole

	FROM vwPeople A
	JOIN cte1 B ON b.ContactID = A.ContactID
	--JOIN vwProject C ON C.ProjectID = B.ProjectID
)

SELECT 
*
FROM cte2



GO


