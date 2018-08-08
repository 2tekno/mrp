IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.spProgramManagementReport'))
   exec('CREATE PROCEDURE [dbo].[spProgramManagementReport] AS BEGIN SET NOCOUNT ON; END')
GO


ALTER PROC spProgramManagementReport

@projectProgram nvarchar(1000) = NULL,
@projectStatus nvarchar(1000) = NULL

AS


/*

exec spProgramManagementReport  NULL, 'Active'
exec spProgramManagementReport 'PPG,Translational', 'Active'

=Fields!ProjectNumber.Value + " - " + Fields!ProjectTitle.Value
*/

declare @xmlprojectProgram xml
declare @xmlprojectStatus xml
set @xmlprojectProgram = N'<root><r>' + replace(@projectProgram,',','</r><r>') + '</r></root>'
set @xmlprojectStatus = N'<root><r>' + replace(@projectStatus,',','</r><r>') + '</r></root>'

;WITH ctePrograms AS (
        select t.value('.','varchar(max)') as item
        from @xmlprojectProgram.nodes('//root/r') as a(t)
)

,cteStatus AS (
        select t.value('.','varchar(max)') as item
        from @xmlprojectStatus.nodes('//root/r') as a(t)
)

,cteBudget AS (

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

,final AS (
	SELECT
	 a.ProjectID
	,ProjectNumber = REPLACE(REPLACE(a.ProjectNumber, CHAR(13), ''), CHAR(10), '')
	,a.ProjectShortName
	,ProjectTitle = REPLACE(REPLACE(a.ProjectTitle, CHAR(13), ''), CHAR(10), '')
	,b.SubProjectID
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
	,ProjectStatusDescription = ISNULL(e.[ProjectStatusDescription], '')
	,d.[ProgramDescription]
	FROM Project a
	LEFT JOIN cteBudget		b ON b.ProjectID = a.ProjectID
	LEFT JOIN Program		d ON d.[ProgramID] = a.[ProgramID]
	LEFT JOIN ProjectStatus	e ON e.[ProjectStatusID] = a.[ProjectStatusID]
	WHERE ISNULL(a.IsDeleted, 0) != 1
)


SELECT *
FROM final
WHERE 1=1

AND (@projectProgram IS NULL OR ProgramDescription IN (SELECT item FROM ctePrograms))
AND (@projectStatus IS NULL OR ProjectStatusDescription IN (SELECT item FROM cteStatus))

ORDER BY
ProjectID
,SubProjectID


