DROP VIEW [dbo].[vwPeopleBySubProject2List]
GO


create view [dbo].[vwPeopleBySubProject2List]

as

/*

select * from vwPeopleBySubProject2List
where SubProjectID =89

*/

WITH cte1 AS (
	SELECT
	a.SubProjectID
	,a.ProjectRole
	,People = 
	(
	SELECT STUFF((SELECT '; ' + b.FullName 
	FROM vwPeopleBySubProject b
	WHERE b.SubProjectID = a.SubProjectID
	AND b.ProjectRole = a.ProjectRole
	FOR XML PATH('')),1, 2, '') AS People
	)
	FROM vwPeopleBySubProject a
	GROUP BY
	a.SubProjectID
	,a.ProjectRole

)

SELECT 
b.ProjectID
,a.*
FROM cte1 a
JOIN SubProject b ON b.SubProjectID = a.SubProjectID
GO


