IF OBJECT_ID('vwContactList', 'V') IS NOT NULL
    DROP VIEW vwContactList;
GO


create view vwContactList

as

/*

select * from vwContactList
order by FullName

select * from Contact



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
,FullName = [LName] + ', ' + ISNULL([FName],'')
,[Sal]
,b.Phones
,c.Emails
,JobTitle
,[Address] = ISNULL([Address1], '') + ' ' + ISNULL([Address2], '') + ' ' + ISNULL([Address3], '') + ' ' + ISNULL([City], '') + ' ' + ISNULL([Province], '') + ' ' + ISNULL([PostalCode], '')
,[Country]
,A.City
,a.Province
,a.PostalCode
,d.Institutions
,ExecAssistants = ISNULL(e.FullName,'')
,ProjectNumber = CASE WHEN ISNULL(f.ProjectNumber, '') !='' THEN ISNULL(f.ProjectNumber, '') + ' - ' + ISNULL(f.ProjectShortName, '') ELSE '' END
,ProjectRole = ISNULL(f.ProjectRole, '')
,GroupName = ISNULL(g.GroupName, '')
,Inactive = ISNULL(A.Inactive, 0)
 FROM [Contact] a
 LEFT JOIN phones b ON b.ContactID = a.ContactID
 LEFT JOIN emails c ON c.ContactID = a.ContactID
 LEFT JOIN vwInstitutionByContact2List d ON d.ContactID = a.ContactID
 LEFT JOIN vwContactAdminFor e ON e.ContactAdminID = a.ContactID
 LEFT JOIN vwPeopleByProject f ON f.ContactID = a.ContactID
 LEFT JOIN vwPeopleByGroup g ON g.ContactID = a.ContactID
