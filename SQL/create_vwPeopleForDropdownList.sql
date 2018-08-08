IF OBJECT_ID('vwPeopleForDropdownList', 'V') IS NOT NULL
    DROP VIEW vwPeopleForDropdownList;
GO


create view vwPeopleForDropdownList

as

/*

select * from vwPeople
SELECT * FROM vwPeopleForDropdownList ORDER BY LName, FName




*/

SELECT 
 ContactID = 0
,[FName] = ''
,[LName] = ''
,FullName = ''
,Sal = ''
,Inactive = 0

UNION ALL

SELECT 
a.ContactID
,[FName]
,[LName]
,FullName = [LName] + ', ' + [FName]
,[Sal]
,Inactive = ISNULL(A.Inactive, 0)
 FROM [Contact] a
