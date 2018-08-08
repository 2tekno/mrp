IF OBJECT_ID('vwSubProject', 'V') IS NOT NULL
    DROP VIEW vwSubProject;
GO


create view vwSubProject

as

/*

select * from vwSubProject

*/


WITH cteBudget AS (

	SELECT 
	SubProjectID
	,TotalAmountAwarded = SUM(ISNULL(Year1Amt,0) + ISNULL(Year2Amt,0) + ISNULL(Year3Amt,0) + ISNULL(Year4Amt,0) + ISNULL(Year5Amt,0) + ISNULL(Year6Amt,0) + ISNULL(Year7Amt,0) + ISNULL(Year8Amt,0) + ISNULL(Year9Amt,0))
	,TFRIAmount  = SUM(CASE WHEN ISNULL(Managed, '') = 'Yes' THEN
						ISNULL(Year1Amt,0) + ISNULL(Year2Amt,0) + ISNULL(Year3Amt,0) + ISNULL(Year4Amt,0) + ISNULL(Year5Amt,0) + ISNULL(Year6Amt,0) + ISNULL(Year7Amt,0) + ISNULL(Year8Amt,0) + ISNULL(Year9Amt,0)
						ELSE 0 END )
	FROM SubProjectBudget
	GROUP bY SubProjectID

)


SELECT
 a.SubProjectID
,a.ProjectID
,a.[SubProjectName]
,a.[SubProjectDescription]
,TFRIAmount =  ISNULL(b.TFRIAmount, 0)
,TotalAmountAwarded = ISNULL(b.TotalAmountAwarded, 0)

,BudgetAmendedDate	= CASE WHEN YEAR(a.BudgetAmendedDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.BudgetAmendedDate, 107) END
,MOUStartDate	= CASE WHEN YEAR(a.MOUStartDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.MOUStartDate, 107) END
,MOUEndDate	= CASE WHEN YEAR(a.MOUEndDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.MOUEndDate, 107) END
,MOUExtendedOnDate	= CASE WHEN YEAR(a.MOUExtendedOnDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.MOUExtendedOnDate, 107) END
,MOUSite = ISNULL(a.MOUSite, 0)
,a.Notes
FROM SubProject a
LEFT JOIN cteBudget b ON b.SubProjectID = a.SubProjectID
WHERE ISNULL(a.IsDeleted, 0) != 1


GO


