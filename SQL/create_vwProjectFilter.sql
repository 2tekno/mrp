alter view vwProjectFilter

As

/*

select distinct A.* from vwProject A  LEFT JOIN vwProjectFilter B ON B.ProjectID = A.ProjectID where 1=1

select A.*, B.* from vwProject A  LEFT JOIN vwProjectFilter B ON B.ProjectID = A.ProjectID where 1=1


*/

SELECT 
B.ProjectID
,C.InstitutionID
,C.Province
,C.InstitutionName
FROM SubProjectBudget A
JOIN SubProject B ON B.SubProjectID = A.SubProjectID
JOIN Institution C ON C.InstitutionID = A.InstitutionID
WHERE ISNULL(B.IsDeleted, 0) = 0

