DROP VIEW [dbo].[vwContactInstitution]
GO


CREATE view [dbo].[vwContactInstitution]

as

/*

select * from vwContactInstitution
SELECT * FROM ContactInstitution
SELECT * FROM Institution  ORDER BY InstitutionName

*/


SELECT

b.[ContactInstitutionID]
,a.ContactID
,c.[InstitutionID]
,c.[InstitutionName]
,b.Role
,b.[Primary]

FROM  vwPeople	a
LEFT JOIN ContactInstitution	b ON b.[ContactID] = a.ContactID
INNER JOIN [dbo].[Institution]	c ON c.[InstitutionID] = b.[InstitutionID]

GO


