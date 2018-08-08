alter view vwProjectByInstitutionProvince

AS

/*

select * from vwProjectByInstitutionProvince

*/


WITH cte1 AS (
	SELECT
	 b.ProjectID
	,a.InstitutionID
	,c.InstitutionName
	,c.Province
	FROM SubProjectBudget a
	JOIN SubProject b ON b.SubProjectID = a.SubProjectID
	JOIN Institution c ON c.InstitutionID = a.InstitutionID
	GROUP BY
     b.ProjectID
	,a.InstitutionID
	,c.InstitutionName
	,c.Province
)

SELECT
a.*
,b.ProjectNumber
,b.ProjectShortName
,b.ProjectTitle
FROM cte1 a
JOIN Project b ON a.ProjectID = b.ProjectID