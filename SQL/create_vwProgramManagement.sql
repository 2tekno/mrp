IF OBJECT_ID('vwProgramManagement', 'V') IS NOT NULL
    DROP VIEW vwProgramManagement;
GO


create  view vwProgramManagement

as

/*

SELECT * FROM vwProgramManagement 
where ProjectNumber like '1021'
ORDER BY ProjectNumber



*/

WITH sp AS (
			SELECT ProjectID, TFRIAmount = SUM(TFRIAmount), TotalAmountAwarded = SUM(TotalAmountAwarded) 
			FROM vwSubProject 
			GROUP BY ProjectID
)
,x AS (
		SELECT
		 ProjectID
		,TotalAmountAwarded = ISNULL(SUM(Total), 0)
		,TFRIAmount = ISNULL(SUM(TFRIAmt), 0)
		FROM vwSubProjectsByProject
		GROUP BY ProjectID
)
,z AS (
	SELECT
	ProjectID
	,ProjectRole
	,People
	FROM vwProjectPeople2String
	WHERE ProjectRole = 'Sub-Project PI'

)

SELECT
 a.ProjectID
,a.[ProjectShortName]
,a.[ProjectNumber]
,a.ProjectTitle
--,TotalAmountAwarded = ISNULL(x.TotalAmountAwarded, 0)
--,TFRIAmount = ISNULL(x.TFRIAmount, 0)
,ProjectStatusDescription = ISNULL(e.[ProjectStatusDescription], '')
,d.[ProgramDescription]

,ProjectLeaders = g.ProjectLeaders

,StartDate						= CASE WHEN YEAR(a.StartDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.StartDate, 107) END
,EndDate	= CASE WHEN YEAR(a.StartDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20), DATEADD(dd,-1,DATEADD(mm,ISNULL(a.LengthOfProjectYears*12 + a.LengthOfProjectMonths,0),a.StartDate)), 107) END

,[PI] = z.People


,xx.MOUStartDate
,xx.SubProjectName
,xx.TFRIAmount
,xx.TotalAmountAwarded
,zz.Institutions

FROM Project a
LEFT JOIN Program				 d ON d.[ProgramID] = a.[ProgramID]
LEFT JOIN ProjectStatus			 e ON e.[ProjectStatusID] = a.[ProjectStatusID]
LEFT JOIN vwProjectLeader2String g ON g.ProjectID = a.ProjectID
LEFT JOIN sp					sp ON sp.ProjectID = a.ProjectID
LEFT JOIN x                      x ON x.ProjectID = a.ProjectID 
LEFT JOIN z z ON z.ProjectID = a.ProjectID 
LEFT JOIN vwSubProject xx ON XX.ProjectID = a.ProjectID
LEFT JOIN vwInstitutionBySubProject2List zz ON zz.SubProjectID = xx.SubProjectID
WHERE ISNULL(a.IsDeleted, 0) != 1
