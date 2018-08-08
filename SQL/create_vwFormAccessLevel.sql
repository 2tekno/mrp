IF OBJECT_ID('vwFormAccessLevel', 'V') IS NOT NULL
    DROP VIEW vwFormAccessLevel;
GO


create view vwFormAccessLevel
as


/*

select * from vwFormAccessLevel
WHERE Form = 'Project'
AND UserID = 4


*/

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
--WHERE A.Form = 'Project'
--AND C.UserID=3