DROP VIEW [dbo].[vwPeopleRolesBySubProject]
GO


CREATE view [dbo].[vwPeopleRolesBySubProject]

as

/*

select * from vwPeopleRolesBySubProject
where SubProjectID =275

select * from vwSubProjectPeople2String 
--where ProjectRole = 'Financial Officer'
where SubProjectID =89


*/

SELECT
a.ProjectID
,sp.SubProjectID
,sp.SubProjectName
,[PI]				= ISNULL(b.People ,'')
,[Collaborators]	= ISNULL(c.People ,'')
,FinOfficers		= ISNULL(e.People, '') 
,CoInvestigators	= ISNULL(f.People, '')
,OtherPersonal		= ISNULL(g.People, '')


FROM Project a
JOIn SubProject sp ON sp.ProjectID = a.ProjectID

LEFT JOIN vwSubProjectPeople2String b ON b.SubProjectID = sp.SubProjectID AND b.ProjectRole = 'Sub-Project PI'
LEFT JOIN vwSubProjectPeople2String c ON c.SubProjectID = sp.SubProjectID AND c.ProjectRole = 'Project Collaborator'
LEFT JOIN vwSubProjectPeople2String e ON e.SubProjectID = sp.SubProjectID AND e.ProjectRole = 'Financial Officer'
LEFT JOIN vwSubProjectPeople2String f ON f.SubProjectID = sp.SubProjectID AND f.ProjectRole = 'Project Co-Investigator'
LEFT JOIN vwSubProjectPeople2String g ON g.SubProjectID = sp.SubProjectID AND g.ProjectRole = 'OtherPersonnel'



GO


