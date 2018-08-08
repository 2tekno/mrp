IF OBJECT_ID('vwContactListByGroup', 'V') IS NOT NULL
    DROP VIEW vwContactListByGroup;
GO


create view vwContactListByGroup

AS


/*

select * from vwContactListByGroup
select * from vwPeople


*/


SELECT
 a.Sal
,a.JobTitle
,a.FName
,a.LName
,c.[InstitutionName]
,b.Role
,Phone = d.Phone
,Email = f.Email
,StreetAddress = a.Address
,City = a.City
,Province = a.Province
,Postalcode = a.Postalcode
,b.[ContactInstitutionID]
,a.ContactID
,c.[InstitutionID]
,g.GroupName
,g.PeopleGroupID

FROM  vwPeople	a
LEFT JOIN ContactInstitution	b ON b.ContactID = a.ContactID
INNER JOIN [dbo].[Institution]	c ON c.InstitutionID = b.InstitutionID
LEFT JOIN ContactPhone			d ON d.ContactID = a.ContactID AND d.[Primary] = 1
LEFT JOIN ContactEmail			f ON f.ContactID = a.ContactID AND d.[Primary] = 1

LEFT JOIN PeopleGroupContact	p ON p.ContactID = a.ContactID
JOIN PeopleGroup				g ON g.PeopleGroupID = p.PeopleGroupID



