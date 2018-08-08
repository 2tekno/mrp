IF OBJECT_ID('vwInstitutionCount', 'V') IS NOT NULL
    DROP VIEW vwInstitutionCount;
GO


create view vwInstitutionCount

as

/*

select * from vwInstitutionCount


*/


SELECT Qty = count(*),ParentInstitutionID = ISNULL(ParentInstitutionID,0)
FROM Institution
GROUP BY ISNULL(ParentInstitutionID,0)

