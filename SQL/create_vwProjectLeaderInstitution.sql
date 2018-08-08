create view vwProjectLeaderInstitution

as

/*

select * from vwProjectLeaderInstitution


*/


SELECT
 e.[InstitutionID]
,e.[InstitutionName]

FROM Project a
INNER JOIN ProjectLeader		b ON b.ProjectID = a.ProjectID
LEFT JOIN vwPeople				c ON c.ContactID = b.ContactID
LEFT JOIN ContactInstitution	d ON d.[ContactID] = c.ContactID
INNER JOIN [dbo].[Institution]	e ON e.[InstitutionID] = d.[InstitutionID]

