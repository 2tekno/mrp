IF OBJECT_ID('vwProjectCount', 'V') IS NOT NULL
    DROP VIEW vwProjectCount;
GO


create view vwProjectCount

as

/*

select * from vwProjectCount




*/



SELECT Qty = count(*),ProjectID
FROM SubProject
 where ISNULL(IsDeleted,0) = 0
GROUP BY ProjectID

