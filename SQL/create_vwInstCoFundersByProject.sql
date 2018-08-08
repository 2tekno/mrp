IF OBJECT_ID('vwInstCoFundersByProject', 'V') IS NOT NULL
    DROP VIEW vwInstCoFundersByProject;
GO


create view [dbo].[vwInstCoFundersByProject]

AS


/*

select * from vwInstCoFundersByProject ORDER BY InstitutionName




*/

WITH cte2 AS (
	SELECT
	a.ProjectID
	,b.CoFunderID

	FROM SubProject a
	JOIN SubProjectBudget b ON b.SubProjectID = a.SubProjectID
	JOIN Project c ON c.ProjectID = a.ProjectID
	WHERE ISNULL(a.IsDeleted, 0) != 1
	AND ISNULL(c.IsDeleted, 0) != 1
	GROUP BY 
	a.ProjectID
	,b.CoFunderID
)

SELECT
a.*
,b.InstitutionName
,b.InstitutionID
,c.ProjectNumber
,c.ProjectShortName
,c.ProjectTitle
FROM cte2 a
JOIN Institution b ON b.InstitutionID = a.CoFunderID
JOIN Project c ON c.ProjectID = a.ProjectID


GO


