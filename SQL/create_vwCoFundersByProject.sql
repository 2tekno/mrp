alter view vwCoFundersByProject

AS


/*

select * from vwCoFundersByProject ORDER BY InstitutionName
SELECT sum(BudgetAmount) FROM vwCoFundersByProject

117574679.68
118050309.68


*/

WITH cte1 AS (

	SELECT
	 SubProjectID
	,CoFunderID
	,Managed
	,TotalAmountAwarded = SUM(TotalAmountAwarded)
	,TFRIAmount = SUM(TFRIAmount)
	FROM vwSubProjectBudget
	GROUP BY
	 SubProjectID
	,CoFunderID
	,Managed


)
,cte2 AS (
	SELECT
	a.ProjectID
	,b.CoFunderID
	,b.Managed
	,BudgetAmount = ISNULL(SUM(b.TotalAmountAwarded), 0)
	FROM SubProject a
	LEFT JOIN cte1 b ON b.SubProjectID = a.SubProjectID
	WHERE ISNULL(a.IsDeleted, 0) != 1
	GROUP BY 
	a.ProjectID
	,b.CoFunderID
	,b.Managed
)

SELECT
a.*
,b.InstitutionName
FROM cte2 a
LEFT JOIN Institution b ON b.InstitutionID = a.CoFunderID

