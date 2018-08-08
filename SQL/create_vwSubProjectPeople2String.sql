DROP VIEW [dbo].[vwSubProjectPeople2String]
GO

CREATE view [dbo].[vwSubProjectPeople2String]

as


/*

select * from vwSubProjectPeople2String
where SubProjectID =275

select * from vwSubProjectPeople2String
where ProjectID =37
and ProjectRole = 'Project Co-Investigator'



*/


SELECT * FROM (
SELECT
ProjectID,SubProjectID,ProjectRole,
STUFF((
SELECT '; ' + FullName
FROM vwPeopleBySubProject
WHERE (ProjectID = a.ProjectID AND SubProjectID = A.SubProjectID  AND ProjectRole = a.ProjectRole)
FOR XML PATH (''))
,1,2,'') AS People
FROM vwPeopleBySubProject a
GROUP BY ProjectID,SubProjectID,ProjectRole
) a
WHERE a.People IS NOT NULL
GO


