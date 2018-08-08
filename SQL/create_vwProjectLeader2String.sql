
create view vwProjectLeader2String

as


/*

select * from vwProjectLeader2String

select * from vwPeopleByProject


*/


SELECT * FROM (
SELECT
a.ProjectID
,ProjectLeaders = 
(
SELECT STUFF((SELECT ', ' + b.FullName 
FROM vwProjectLeadersByProject b
WHERE b.ProjectID = a.ProjectID
FOR XML PATH('')),1, 2, '') AS ProjectLeaders
)
FROM Project a
) a
WHERE a.ProjectLeaders IS NOT NULL