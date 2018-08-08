IF OBJECT_ID('vwPeopleByGroup', 'V') IS NOT NULL
    DROP VIEW vwPeopleByGroup;
GO


create  view vwPeopleByGroup

AS

/*

select * from vwPeopleByGroup

select * from PeopleGroup
select * from PeopleGroupContact
select * from vwPeople

*/

WITH cte1 AS (
	SELECT
	 C.PeopleGroupID
	 ,A.PeopleGroupContactID
	,B.ContactID
	,B.FullName
	,C.GroupName
	FROM PeopleGroupContact A
	JOIN vwPeople B ON b.ContactID = A.ContactID
	JOIN PeopleGroup C ON C.PeopleGroupID = A.PeopleGroupID
)
SELECT 
*
FROM cte1



