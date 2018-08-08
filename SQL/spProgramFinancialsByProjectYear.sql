IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.spProgramFinancialsByProjectYear'))
   exec('CREATE PROCEDURE [dbo].[spProgramFinancialsByProjectYear] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROC spProgramFinancialsByProjectYear

@projectTitle nvarchar(1000) = NULL

AS


/*

report # 2  Program Financials By Project Year

exec spProgramFinancialsByProjectYear 'research'

*/


WITH cte1 AS (

	SELECT
	 ProjectID
	,PY1Amt = SUM(PY1Amt)
	,PY2Amt = SUM(PY2Amt)
	,PY3Amt = SUM(PY3Amt)
	,PY4Amt = SUM(PY4Amt)
	,PY5Amt = SUM(PY5Amt)
	,PY6Amt = SUM(PY6Amt)
	,PY7Amt = SUM(PY7Amt)
	,PY8Amt = SUM(PY8Amt)
	,PY9Amt = SUM(PY9Amt)
	,PartnerTotalBudget = SUM(PartnerTotalBudget)
	FROM vwSubProjectFinance
	GROUP BY ProjectID

)
,cte2 AS (

	SELECT
	 a.ProjectID
	,a.ProjectShortName
	,a.ProjectNumber
	,a.ProjectTitle	
	,d.ProgramDescription
	,e.ProjectStatusDescription
	,StartDate	= CASE WHEN YEAR(a.StartDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.StartDate, 107) END
	--,EndDate	= CASE WHEN YEAR( a.StartDate ) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),DATEADD(yy,ISNULL(a.LengthOfProjectYears,0),a.StartDate), 107) END
	--,EndDate	= CASE WHEN YEAR( a.StartDate ) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),DATEADD(mm,ISNULL(a.LengthOfProjectYears*12 + a.LengthOfProjectMonths,0),a.StartDate), 107) END
	
	,EndDate	= CASE WHEN YEAR(a.StartDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20), DATEADD(dd,-1,DATEADD(mm,ISNULL(a.LengthOfProjectYears*12 + a.LengthOfProjectMonths,0),a.StartDate)), 107) END

	,ProjectLengthMonths = ISNULL(a.LengthOfProjectYears, 0)*12 + ISNULL(a.LengthOfProjectMonths, 0)
	,StartDateRaw = a.StartDate
	,PY1Amt = ISNULL(c.PY1Amt, 0)
	,PY2Amt = ISNULL(c.PY2Amt, 0)
	,PY3Amt = ISNULL(c.PY3Amt, 0)
	,PY4Amt = ISNULL(c.PY4Amt, 0)
	,PY5Amt = ISNULL(c.PY5Amt, 0)
	,PY6Amt = ISNULL(c.PY6Amt, 0)
	,PY7Amt = ISNULL(c.PY7Amt, 0)
	,PY8Amt = ISNULL(c.PY8Amt, 0)
	,PY9Amt = ISNULL(c.PY9Amt, 0)
	,PartnerTotalBudget = ISNULL(c.PartnerTotalBudget, 0)
	FROM Project a
	LEFT JOIN Program		d ON d.ProgramID = a.ProgramID
	LEFT JOIN ProjectStatus	e ON e.ProjectStatusID = a.ProjectStatusID
	LEFT JOIN cte1 c ON c.ProjectID = a.ProjectID
	WHERE ISNULL(a.IsDeleted, 0) = 0
)

SELECT
*
,ApprovedBudget = PY1Amt + PY2Amt + PY3Amt + PY4Amt + PY5Amt + PY6Amt + PY7Amt + PY8Amt + PY9Amt
FROM cte2
WHERE 1=1
AND (@projectTitle IS NULL OR ProjectTitle like '%'+@projectTitle+'%')

