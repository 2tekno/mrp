create view vwInstitutionByContact2List

AS

WITH cte1 AS (

	SELECT DISTINCT
	 a.ContactID
	,b.InstitutionName
	FROM ContactInstitution a
	JOIN Institution b ON b.InstitutionID = a.InstitutionID
)
SELECT
a.ContactID
,Institutions = 
(
	SELECT STUFF((SELECT '; ' + b.InstitutionName 
	FROM cte1 b
	WHERE  b.ContactID = a.ContactID
	FOR XML PATH('')),1, 2, '') AS Institutions
)
FROM cte1 a
GROUP BY
a.ContactID
