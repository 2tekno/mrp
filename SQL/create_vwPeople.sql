IF OBJECT_ID('vwPeople', 'V') IS NOT NULL
    DROP VIEW vwPeople;
GO


create view vwPeople

as

/*

select * from vwPeople
select * from project
select * from contact
SELECT * FROM ContactPhone
SELECT * FROM ContactEmail



*/

WITH phones AS (
	SELECT
	ContactID,
	STUFF((
	SELECT ', ' + Phone
	FROM ContactPhone
	WHERE (ContactID = a.ContactID )
	FOR XML PATH (''))
	,1,2,'') AS Phones
	FROM ContactPhone a
	GROUP BY ContactID
) 

,emails AS (
	SELECT
	ContactID,
	STUFF((
	SELECT ', ' + Email
	FROM ContactEmail
	WHERE (ContactID = a.ContactID )
	FOR XML PATH (''))
	,1,2,'') AS Emails
	FROM ContactEmail a
	GROUP BY ContactID
) 


SELECT 
a.ContactID
,[FName]
,[LName]
,FullName = [LName] + ', ' + [FName]
,[Sal]
,b.Phones
,c.Emails
,JobTitle
,[Address] = ISNULL([Address1], '') + ' ' + ISNULL([Address2], '') + ' ' + ISNULL([Address3], '') + ' ' + ISNULL([City], '') + ' ' + ISNULL([Province], '') + ' ' + ISNULL([PostalCode], '')
,[Country]
,City
,Province
,PostalCode
,d.Institutions
,Inactive = ISNULL(A.Inactive, 0)
 FROM [Contact] a
 LEFT JOIN phones b ON b.ContactID = a.ContactID
 LEFT JOIN emails c ON c.ContactID = a.ContactID
 LEFT JOIN vwInstitutionByContact2List d ON d.ContactID = a.ContactID
 --WHERE ISNULL(A.Inactive, 0) = 0
