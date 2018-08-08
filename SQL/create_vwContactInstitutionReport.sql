IF OBJECT_ID('vwContactInstitutionReport', 'V') IS NOT NULL
    DROP VIEW vwContactInstitutionReport;
GO


create view vwContactInstitutionReport

AS


/*

select * from vwContactInstitutionReport
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


FROM  vwPeople	a
LEFT JOIN ContactInstitution	b ON b.[ContactID] = a.ContactID
INNER JOIN [dbo].[Institution]	c ON c.[InstitutionID] = b.[InstitutionID]
LEFT JOIN ContactPhone			d ON d.[ContactID] = a.ContactID AND d.[Primary] = 1
LEFT JOIN ContactEmail			f ON f.[ContactID] = a.ContactID AND d.[Primary] = 1




