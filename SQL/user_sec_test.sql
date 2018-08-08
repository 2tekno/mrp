declare @userID int = 3
declare @formName nvarchar(50)  = 'Institution'
--select * from [dbo].[Users]
select * from UsersPermissionGroup
--SELECT * FROM FieldList
--where Form = 'Project'


select * from UserGroupSecurity
where UserID = @userID

/*

RoleID values:

0 - read only
1 - add-edit-delete
2 - admin
*/



SELECT 
 A.FieldName
,B.GroupName

,UserLevel = CASE WHEN C.RoleID = 0 THEN 'read only'
					WHEN C.RoleID = 1 THEN 'add-edit-delete'
					WHEN C.RoleID = 2 THEN 'admin' END

FROM FieldList A
LEFT JOIN UsersPermissionGroup	B ON B.GroupName = A.UserPermissionGroup 
LEFT JOIN UserGroupSecurity		C ON C.UPGID = B.UPGID AND C.UserID = @userID
where A.Form = @formName
