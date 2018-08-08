IF OBJECT_ID('vwSubProjectCount', 'V') IS NOT NULL
    DROP VIEW vwSubProjectCount;
GO


create view vwSubProjectCount

as

/*

select * from vwSubProjectCount




*/



SELECT Qty = count(*),SubProjectID
FROM SubProjectBudget
GROUP BY SubProjectID

