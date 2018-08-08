IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.spProgramManagementReport'))
   exec('CREATE PROCEDURE [dbo].[spProgramManagementReport] AS BEGIN SET NOCOUNT ON; END')
GO


ALTER PROC spProgramManagementReport

@projectProgram nvarchar(1000) = NULL,
@projectStatus nvarchar(1000) = NULL

AS

;WITH cteBudget AS (

	SELECT 
	 SP.ProjectID
	,SP.SubProjectID
	,SP.SubProjectName
	,SP.SubProjectDescription

	,TotalAmountAwarded = ISNULL(Year1Amt,0) + ISNULL(Year2Amt,0) + ISNULL(Year3Amt,0) + ISNULL(Year4Amt,0) + ISNULL(Year5Amt,0) + ISNULL(Year6Amt,0) + ISNULL(Year7Amt,0) + ISNULL(Year8Amt,0) + ISNULL(Year9Amt,0)
	,TFRIAmount  = CASE WHEN ISNULL(Managed, '') = 'Yes' THEN
						ISNULL(Year1Amt,0) + ISNULL(Year2Amt,0) + ISNULL(Year3Amt,0) + ISNULL(Year4Amt,0) + ISNULL(Year5Amt,0) + ISNULL(Year6Amt,0) + ISNULL(Year7Amt,0) + ISNULL(Year8Amt,0) + ISNULL(Year9Amt,0)
						ELSE 0 END 

	,InstitutionName = B.InstitutionName
	,CoFunderName = C.InstitutionName
	,PIName = ISNULL(D.FName, '') + ' ' + ISNULL(D.LName, '')
	,InstitutionProvince	= B.Province
	,CoFunderProvince		= C.Province

	FROM SubProjectBudget A
	JOIN SubProject SP ON SP.SubProjectID = A.SubProjectID
	LEFT JOIN Institution B ON B.InstitutionID = A.InstitutionID
	LEFT JOIN Institution C ON C.InstitutionID = A.CoFunderID
	LEFT JOIN Contact D ON D.ContactID = A.PIID

	WHERE ISNULL(SP.IsDeleted, 0) != 1
)


SELECT
a.ProjectID
,b.[SubProjectName]
,b.[SubProjectDescription]
,TFRIAmount			= ISNULL(b.TFRIAmount, 0)
,TotalAmountAwarded = ISNULL(b.TotalAmountAwarded, 0)

--,BudgetAmendedDate	= CASE WHEN YEAR(a.BudgetAmendedDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.BudgetAmendedDate, 107) END

,StartDate	= CASE WHEN YEAR(a.StartDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.StartDate, 107) END
,EndDate	= CASE WHEN YEAR(a.StartDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20), DATEADD(dd,-1,DATEADD(mm,ISNULL(a.LengthOfProjectYears*12 + a.LengthOfProjectMonths,0),a.StartDate)), 107) END

,b.InstitutionName
,b.CoFunderName
,b.PIName
,b.InstitutionProvince
,b.CoFunderProvince

FROM Project a
LEFT JOIN cteBudget b ON b.ProjectID = a.ProjectID
WHERE ISNULL(a.IsDeleted, 0) != 1





