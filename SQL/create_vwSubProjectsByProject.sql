
DROP VIEW [dbo].[vwSubProjectsByProject]
GO



create view [dbo].[vwSubProjectsByProject]

AS


/*

select * from vwSubProjectsByProject

SELECT * FROM vwCoFundersByProject


select * from vwPeopleBySubProject2List
where SubProjectID in (275)
order by SubProjectID



*/


WITH cteBudget AS (

	SELECT 
	SubProjectID
	,TotalAmountAwarded = SUM(TotalAmountAwarded)
	,TFRIAmount = SUM(TFRIAmount)
	FROM vwSubProjectBudget
	GROUP bY SubProjectID

)

SELECT
 a.ProjectID
,a.SubProjectID
,a.SubProjectName
,Total = ISNULL(SUM(b.TotalAmountAwarded), 0)
,TFRIAmt = ISNULL(SUM(b.TFRIAmount), 0)
,SubProjectPILIst = c.People
,SubProjectFOLIst = c1.People
,Institutions = d.Institutions
FROM SubProject a
LEFT JOIN cteBudget b ON b.SubProjectID = a.SubProjectID
LEFT JOIN vwPeopleBySubProject2List c ON c.SubProjectID = a.SubProjectID AND c.ProjectRole = 'Sub-Project PI'

LEFT JOIN vwPeopleBySubProject2List c1 ON c1.SubProjectID = a.SubProjectID AND c1.ProjectRole = 'Financial Officer'

LEFT JOIN vwInstitutionBySubProject2List d ON d.SubProjectID = a.SubProjectID
WHERE ISNULL(a.[IsDeleted], 0) = 0
GROUP BY 
a.ProjectID
,a.SubProjectID
,a.SubProjectName
,c.People
,c1.People
,d.Institutions
GO


