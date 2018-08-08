
alter view vwProjectPeople2String

as


/*

select * from vwProjectPeople2String
where ProjectID = 37


select * from vwPeopleByProject


*/


SELECT * FROM (
SELECT
ProjectID,ProjectRole,
STUFF((
SELECT '; ' + FullName
FROM vwPeopleByProject
WHERE (ProjectID = a.ProjectID AND ProjectRole = a.ProjectRole)
FOR XML PATH (''))
,1,2,'') AS People
FROM vwPeopleByProject a
GROUP BY ProjectID,ProjectRole
) a
WHERE a.People IS NOT NULL