IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.spContactList'))
   exec('CREATE PROCEDURE [dbo].[spContactList] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROC spContactList

@province nvarchar(max) = NULL,
@projects nvarchar(max) = NULL,
@projectRoles nvarchar(max) = NULL

AS

/*

exec spContactList ',ON,BC', '6,36'

exec spContactList null, null, null

exec spContactList null, null, ',Project Leader,Project Manager'
exec spContactList ',ON,BC', null, 'Project Leader,Project Manager'

select * from vwContactList

SELECT * FROM [dbo].[vwProvince] ORDER BY SortOrder


SELECT 
ProjectID
,ProjectNumber = ISNULL(ProjectNumber, '') + ' - ' + ISNULL(ProjectShortName, '') 
FROM vwProject
ORDER BY ProjectNumber

SELECT * FROM vwInstitutionByContact2List



select ProjectRole from vwContactList
group by ProjectRole order by ProjectRole


SELECT * FROM [dbo].[vwProvince] ORDER BY SortOrder

*/

declare @xmlprovince xml
declare @xmlproject xml
declare @xmlprojectRoles xml

set @xmlprovince = N'<root><r>' + replace(@province,',','</r><r>') + '</r></root>'
set @xmlproject = N'<root><r>' + replace(@projects,',','</r><r>') + '</r></root>'
set @xmlprojectRoles = N'<root><r>' + replace(@projectRoles,',','</r><r>') + '</r></root>'

;WITH cteProvince AS (
        select t.value('.','varchar(max)') as item
        from @xmlprovince.nodes('//root/r') as a(t)
)

,cteProjects AS (
        select t.value('.','varchar(max)') as item
        from @xmlproject.nodes('//root/r') as a(t)
)
,cteProjectRoles AS (
        select t.value('.','varchar(max)') as item
        from @xmlprojectRoles.nodes('//root/r') as a(t)
)
, phones AS (
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


SELECT distinct
a.ContactID
,[FName]
,[LName]
,FullName = [LName] + ', ' + ISNULL([FName],'')
,[Sal]
,b.Phones
,c.Emails
,JobTitle
,[Address] = ISNULL([Address1], '') + ' ' + ISNULL([Address2], '') + ' ' + ISNULL([Address3], '') --+ ' ' + ISNULL([City], '') + ' ' + ISNULL([Province], '') + ' ' + ISNULL([PostalCode], '')
,[Country]
,A.City
,Province = ISNULL(a.Province,'')
,a.PostalCode
,d.Institutions
,ExecAssistants = ISNULL(e.FullName,'')
,ProjectNumber = CASE WHEN ISNULL(f.ProjectNumber, '') !='' THEN ISNULL(f.ProjectNumber, '') + ' - ' + ISNULL(f.ProjectShortName, '') ELSE '' END
,ProjectID = ISNULL(f.ProjectID, 0)
,ProjectRole = ISNULL(f.ProjectRole, '')
--,GroupName = ISNULL(g.GroupName, '')
 FROM [Contact] a
 LEFT JOIN phones b ON b.ContactID = a.ContactID
 LEFT JOIN emails c ON c.ContactID = a.ContactID
 LEFT JOIN vwInstitutionByContact2List d ON d.ContactID = a.ContactID
 LEFT JOIN vwContactAdminFor e ON e.ContactAdminID = a.ContactID
 LEFT JOIN vwPeopleByProject f ON f.ContactID = a.ContactID
 LEFT JOIN vwPeopleByGroup g ON g.ContactID = a.ContactID
WHERE 1=1
AND (@projects IS NULL OR ISNULL(f.ProjectID, 0) IN (SELECT item FROM cteProjects))
AND (@province IS NULL OR ISNULL(a.Province,'') IN (SELECT item FROM cteProvince))
AND (@projectRoles IS NULL OR ISNULL(f.ProjectRole, '') IN (SELECT item FROM cteProjectRoles))