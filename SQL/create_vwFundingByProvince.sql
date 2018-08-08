IF OBJECT_ID('vwFundingByProvince', 'V') IS NOT NULL
    DROP VIEW vwFundingByProvince;
GO


create view vwFundingByProvince

AS

/*

report # 5 TFRI Funding by Province

select * from vwFundingByProvince
where ProjectID = 48
order by InstitutionName


select * from vwSubProjectFinance

select sum(ApprovedBudget) from vwFundingByProvince
where ProjectID = 48

select sum(ApprovedBudget) from vwSubProjectFinance

*/



WITH cte0 AS (
	SELECT
	 SubProject.ProjectID
	,SubProject.SubProjectID
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
	,SubProject.SubProjectID
	,SubProjectBudget.InstitutionID
	,SubProjectBudget.CoFunderID
)
,cte00 AS (
	SELECT *,ApprovedBudget = PY1Amt + PY2Amt + PY3Amt + PY4Amt + PY5Amt + PY6Amt + PY7Amt + PY8Amt + PY9Amt
	FROM cte0
)


,cte1 AS (

SELECT
a.* 
,b.InstitutionName
,b.Province
,c.ProjectShortName
,c.ProjectNumber
,d.ProgramDescription
,StartDateD = c.StartDate
,EndDateD = c.EndDate
,c.ProjectTitle	
,StartDate	= CASE WHEN YEAR(c.StartDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),c.StartDate, 107) END
,EndDate	= CASE WHEN YEAR(c.StartDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20), DATEADD(dd,-1,DATEADD(mm,ISNULL(c.LengthOfProjectYears*12 + c.LengthOfProjectMonths,0),c.StartDate)), 107) END
,ProjectLengthMonths = ISNULL(c.LengthOfProjectYears, 0)*12 + ISNULL(c.LengthOfProjectMonths, 0)
,StartDateRaw = c.StartDate
,ee.ProjectStatusDescription

FROM cte00 a
LEFT JOIN Institution b ON b.InstitutionID = a.InstitutionID
JOIN Project c ON c.ProjectID = a.ProjectID
JOIN Program d ON d.ProgramID = c.ProgramID
LEFT JOIN ProjectStatus	ee ON ee.ProjectStatusID = c.ProjectStatusID
WHERE ISNULL(c.IsDeleted, 0) = 0
)
,cte2 AS (
	SELECT
	Province
	,ProjectID
	,ProgramDescription
	,ProjectNumber
	,ProjectTitle
	,ProjectShortName
	,InstitutionName
	,StartDate
	,EndDate
	,StartDateD
,EndDateD
	,ProjectLengthMonths
	,StartDateRaw
	,ProjectStatusDescription
	,PY1Amt = SUM(ISNULL(PY1Amt, 0))
	,PY2Amt = SUM(ISNULL(PY2Amt, 0))
	,PY3Amt = SUM(ISNULL(PY3Amt, 0))
	,PY4Amt = SUM(ISNULL(PY4Amt, 0))
	,PY5Amt = SUM(ISNULL(PY5Amt, 0))
	,PY6Amt = SUM(ISNULL(PY6Amt, 0))
	,PY7Amt = SUM(ISNULL(PY7Amt, 0))
	,PY8Amt = SUM(ISNULL(PY8Amt, 0))
	,PY9Amt = SUM(ISNULL(PY9Amt, 0))

	FROM cte1
	GROUP BY
	Province
	,ProjectID
	,ProgramDescription
	,ProjectNumber
	,ProjectShortName
	,ProjectTitle
	,InstitutionName
	,StartDate
	,EndDate
	,StartDateD
,EndDateD
	,ProjectLengthMonths
	,StartDateRaw
	,ProjectStatusDescription

)

SELECT
Province
,ProjectID
,ProgramDescription
,ProjectNumber
,ProjectShortName
,ProjectTitle
,InstitutionName
,StartDate
,EndDate
,StartDateD
,EndDateD
,ProjectLengthMonths
,StartDateRaw
,ProjectStatusDescription
,PY1Amt
,PY2Amt
,PY3Amt
,PY4Amt
,PY5Amt
,PY6Amt
,PY7Amt
,PY8Amt
,PY9Amt
,ApprovedBudget = PY1Amt + PY2Amt + PY3Amt + PY4Amt + PY5Amt + PY6Amt + PY7Amt + PY8Amt + PY9Amt
FROM cte2
