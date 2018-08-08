DROP VIEW [dbo].[vwPeopleRolesByProject]
GO


CREATE view [dbo].[vwPeopleRolesByProject]

as

/*

select * from vwPeopleRolesByProject
WHERE ProjectID = 37

select * from vwProjectPeople2String 
select * from [dbo].[vwPeopleBySubProject2List]


*/

SELECT
a.ProjectID
,[PI] = ISNULL(b.People ,'')
,[Collaborators] = ISNULL(c.People ,'')
--,SACMembers = ISNULL(d.People, '') 
,FinOfficers = ISNULL(e.People, '') 
FROM Project a
LEFT JOIN vwProjectPeople2String b ON b.ProjectID = a.ProjectID AND b.ProjectRole = 'Sub-Project PI'
LEFT JOIN vwProjectPeople2String c ON c.ProjectID = a.ProjectID AND c.ProjectRole = 'Project Collaborator'
--LEFT JOIN vwProjectPeople2String d ON d.ProjectID = a.ProjectID AND d.ProjectRole = 'SAC Member'
LEFT JOIN vwProjectPeople2String e ON e.ProjectID = a.ProjectID AND e.ProjectRole = 'Financial Officer'

GO


