alter view vwProjectLeadersByProject

as

/*

select * from vwProjectLeadersByProject


*/


SELECT
a.[ProjectID]
,e.[InstitutionID]
,e.[InstitutionName]
,c.FullName
FROM Project a
INNER JOIN ProjectLeader		b ON b.ProjectID = a.ProjectID
LEFT JOIN vwPeople				c ON c.ContactID = b.ContactID
LEFT JOIN ContactInstitution	d ON d.[ContactID] = c.ContactID
INNER JOIN Institution	e ON e.[InstitutionID] = d.[InstitutionID]





