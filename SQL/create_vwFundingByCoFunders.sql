IF OBJECT_ID('vwFundingByCoFunders', 'V') IS NOT NULL
    DROP VIEW vwFundingByCoFunders;
GO

create view vwFundingByCoFunders

AS

/*

report 7 5 TFRI Funding by CoFunders

select * from vwFundingByCoFunders



*/


WITH cte1 AS (

SELECT
a.* 
,b.InstitutionName
,CoFunder = bb.InstitutionName

,b.Province

,c.ProjectTitle	
,StartDate	= CASE WHEN YEAR(c.StartDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),c.StartDate, 107) END
,EndDate	= CASE WHEN YEAR(c.StartDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20), DATEADD(dd,-1,DATEADD(mm,ISNULL(c.LengthOfProjectYears*12 + c.LengthOfProjectMonths,0),c.StartDate)), 107) END
,ProjectLengthMonths = ISNULL(c.LengthOfProjectYears, 0)*12 + ISNULL(c.LengthOfProjectMonths, 0)
,StartDateRaw = c.StartDate

,c.ProjectShortName
,c.ProjectNumber
,d.ProgramDescription
,e.People
,ee.ProjectStatusDescription
FROM vwSubProjectFinance a
LEFT JOIN Institution b ON b.InstitutionID = a.InstitutionID
LEFT JOIN Institution bb ON bb.InstitutionID = a.CoFunderID

JOIN Project c ON c.ProjectID = a.ProjectID
JOIN Program d ON d.ProgramID = c.ProgramID
LEFT JOIN vwProjectPeople2String e ON e.ProjectID = c.ProjectID AND e.ProjectRole = 'Sub-Project PI'

LEFT JOIN ProjectStatus	ee ON ee.ProjectStatusID = c.ProjectStatusID

)

,x AS (
		SELECT
		 ProjectID
		,TotalAmountAwarded = ISNULL(SUM(Total), 0)
		,TFRIAmount = ISNULL(SUM(TFRIAmt), 0)
		FROM vwSubProjectsByProject
		GROUP BY ProjectID
)
,cte2 AS (
	SELECT
	ProgramDescription
	,ProjectNumber
	,ProjectID
	,ProjectShortName
	,ProjectTitle
	,StartDate
	,EndDate
	,ProjectLengthMonths
	,StartDateRaw
	,InstitutionName
	,CoFunder
	,CoFunderID
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
	ProgramDescription
	,ProjectNumber
	,ProjectID
	,ProjectShortName
	,ProjectTitle
	,StartDate
	,EndDate
	,ProjectLengthMonths
	,StartDateRaw
	,InstitutionName
	,CoFunder
	,CoFunderID
	,ProjectStatusDescription
)

SELECT
ProgramDescription
,ProjectNumber
,cte2.ProjectID
,ProjectShortName
,ProjectTitle
,StartDate
,EndDate
,StartDateD = StartDate
,EndDateD = EndDate
,ProjectLengthMonths
,StartDateRaw
,InstitutionName
,CoFunder
,CoFunderID
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
,TotalAmountAwarded = ISNULL(x.TotalAmountAwarded, 0)
FROM cte2
LEFT JOIN x ON x.ProjectID = cte2.ProjectID
