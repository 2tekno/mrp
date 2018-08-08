alter view vwInstitutionsByProject

AS

WITH cte1 AS (
	SELECT
	 b.ProjectID
	--,a.InstitutionID
	,c.InstitutionName
	,c.Province
	FROM SubProjectBudget a
	JOIN SubProject b ON b.SubProjectID = a.SubProjectID
	JOIN Institution c ON c.InstitutionID = a.InstitutionID
	GROUP BY
     b.ProjectID
	,c.InstitutionName
	,c.Province
)


SELECT * FROM (
SELECT
ProjectID,Province,
STUFF((
SELECT ', ' + InstitutionName
FROM cte1
WHERE (ProjectID = a.ProjectID  AND Province = a.Province)
FOR XML PATH (''))
,1,2,'') AS Institutions
FROM cte1 a
GROUP BY ProjectID,Province
) a
WHERE a.Institutions IS NOT NULL
