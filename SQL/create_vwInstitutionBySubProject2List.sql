create view vwInstitutionBySubProject2List

AS

WITH cte1 AS (

	SELECT DISTINCT
	 a.SubProjectID
	,b.InstitutionName
	FROM SubProjectBudget a
	JOIN Institution b ON b.InstitutionID = a.InstitutionID
)
SELECT
a.SubProjectID
,Institutions = 
(
	SELECT STUFF((SELECT '; ' + b.InstitutionName 
	FROM cte1 b
	WHERE b.SubProjectID = a.SubProjectID
	FOR XML PATH('')),1, 2, '') AS Institutions
)
FROM cte1 a
GROUP BY
a.SubProjectID
