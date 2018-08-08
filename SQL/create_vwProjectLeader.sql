create view vwProjectLeader

as

/*

select * from vwProjectLeader


*/


SELECT
 a.ProjectID
,ProjectLeader = c.FullName

FROM Project a
INNER JOIN ProjectLeader b ON b.ProjectID = a.ProjectID
LEFT JOIN vwPeople		 c ON c.ContactID = b.ContactID
