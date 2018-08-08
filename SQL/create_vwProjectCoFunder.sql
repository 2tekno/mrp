alter view vwProjectCoFunder

as

/*

select * from Project
select * from ProjectCoFunder
select * from ProjectLeader
select * from ProjectManager
select * from ProjectMentor

select * from SubProject
select * from SubProjectPI

SELECT * FROM vwProject 
select * from vwPeople

select * from SubProjectMoneyDistr

*/


SELECT
 b.ProjectCoFunderID
,a.ProjectID
,c.InstitutionID
,c.InstitutionName
,b.BudgetAmount
,b.Managed

FROM Project a
INNER JOIN ProjectCoFunder		b ON b.ProjectID = a.ProjectID
INNER JOIN Institution	c ON c.InstitutionID = b.InstitutionID

