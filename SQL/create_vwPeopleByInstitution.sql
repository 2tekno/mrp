alter view vwPeopleByInstitution

AS

/*

select * from vwPeopleByInstitution

select * from [dbo].[ContactInstitution]

*/

WITH cte1 AS (

	SELECT * FROM ContactInstitution
)
,cte2 AS (
SELECT

C.InstitutionID
,A.ContactID
,A.FullName
,C.InstitutionName
,B.Role
FROM vwPeople A
JOIN cte1 B ON b.ContactID = A.ContactID
JOIN [dbo].[Institution] C ON C.InstitutionID = B.InstitutionID
)
SELECT 
*
FROM cte2



