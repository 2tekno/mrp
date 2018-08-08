alter view vwContactAdminFor

as

/*

select * from vwContactAdminFor

*/


SELECT
 a.AdminAssistantID
,a.ContactID
,a.ContactAdminID
,b.FullName
,AdminFullName = c.FullName
FROM  AdminAssistant a
INNER JOIN vwPeople	b ON b.ContactID = a.ContactID
INNER JOIN vwPeople	c ON c.ContactID = a.ContactAdminID

