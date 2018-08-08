alter view vwSubProjectFinance

AS

/*

select * from vwSubProjectFinance
select * from SubProject



select sum(ApprovedBudget) from vwSubProjectFinance


*/

WITH cte1 AS (
	SELECT
	 SubProject.ProjectID
	,SubProjectBudget.InstitutionID
	,SubProjectBudget.CoFunderID
	,PY1Amt = SUM(ISNULL(Year1Amt, 0))
	,PY2Amt = SUM(ISNULL(Year2Amt, 0))
	,PY3Amt = SUM(ISNULL(Year3Amt, 0))
	,PY4Amt = SUM(ISNULL(Year4Amt, 0))
	,PY5Amt = SUM(ISNULL(Year5Amt, 0))
	,PY6Amt = SUM(ISNULL(Year6Amt, 0))
	,PY7Amt = SUM(ISNULL(Year7Amt, 0))
	,PY8Amt = SUM(ISNULL(Year8Amt, 0))
	,PY9Amt = SUM(ISNULL(Year9Amt, 0))
	,PartnerTotalBudget = SUM(CASE WHEN ISNULL(SubProjectBudget.Managed, '') != 'Yes' 
										THEN ISNULL(Year1Amt, 0) + ISNULL(Year2Amt, 0) + ISNULL(Year3Amt, 0) + ISNULL(Year4Amt, 0) + ISNULL(Year5Amt, 0) +
											ISNULL(Year6Amt, 0) + ISNULL(Year7Amt, 0) + ISNULL(Year8Amt, 0) + ISNULL(Year9Amt, 0) 
										ELSE  0 END )
	FROM SubProjectBudget
	JOIN SubProject  ON SubProject.SubProjectID = SubProjectBudget.SubProjectID
	WHERE ISNULL(SubProject.IsDeleted, 0) = 0
	GROUP BY 
	 SubProject.ProjectID
	,SubProjectBudget.InstitutionID
	,SubProjectBudget.CoFunderID
)

SELECT
*
,ApprovedBudget = PY1Amt + PY2Amt + PY3Amt + PY4Amt + PY5Amt + PY6Amt + PY7Amt + PY8Amt + PY9Amt
FROM
cte1



