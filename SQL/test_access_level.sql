select * from FieldList where Form = 'Project'
select * from UsersPermissionGroup
select * from Users

SELECT distinct  
B.UserID,A.UPGID,A.GroupName,RoleID = ISNULL(B.RoleID,0) FROM UsersPermissionGroup A LEFT JOIN UserGroupSecurity B ON B.UPGID = A.UPGID AND B.UserID=1

--SELECT distinct  
--B.UserID,A.UPGID,A.GroupName,RoleID = ISNULL(B.RoleID,0) FROM UsersPermissionGroup A LEFT JOIN UserGroupSecurity B ON B.UPGID = A.UPGID AND B.UserID=2

select *
from UserGroupSecurity
where UserID=1


------------------ final
SELECT
A.Form
,B.GroupName
,A.FieldName
--,RoleID = ISNULL(C.RoleID,0)
,AccessLevel = EN.Text
,C.UserID
FROM FieldList A
JOIN UsersPermissionGroup B ON B.GroupName = A.UserPermissionGroup
LEFT JOIN UserGroupSecurity C ON C.UPGID = B.UPGID --AND C.UserID=3
JOIN vwAccessLevelEnum EN ON EN.Id = ISNULL(C.RoleID,0)
JOIN Users U ON U.UserID = C.UserID
WHERE A.Form = 'Project'
AND C.UserID=3
