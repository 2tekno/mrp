IF OBJECT_ID('vwPeopleGroupCount', 'V') IS NOT NULL
    DROP VIEW vwPeopleGroupCount;
GO


create view vwPeopleGroupCount

as

/*

select * from vwPeopleGroupCount


select *
from [dbo].[PeopleGroupContact]


*/



SELECT Qty = count(*),PeopleGroupID
FROM PeopleGroupContact
GROUP BY PeopleGroupID

