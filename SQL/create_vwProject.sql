
/****** Object:  View [dbo].[vwProject]    Script Date: 4/7/2018 11:30:43 AM ******/
DROP VIEW [dbo].[vwProject]
GO

/****** Object:  View [dbo].[vwProject]    Script Date: 4/7/2018 11:30:43 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE  view [dbo].[vwProject]

as

/*

SELECT * FROM vwProject 
where ProjectNumber like '2010-30%'
ORDER BY ProjectShortName

SELECT * FROM vwSubProject

SELECT ProjectShortName = ProjectNumber+ ' ' +ProjectShortName FROM vwProject ORDER BY ProjectNumber


SELECT * FROM Project where ProjectID = 14
SELECT * FROM vwSubProject where ProjectID = 14

select * from [dbo].[vwPeopleRolesByProject]

select * from SubProjectCoFunder

select * from SubProjectBudget


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
,a.MentorProjectID
,a.[ProjectShortName]
,a.[ProjectNumber]
,a.ProjectTitle
,TotalAmountAwarded = ISNULL(x.TotalAmountAwarded, 0)
,a.LaySummary
,a.ScientificSummary
,Renewal = ISNULL(a.Renewal, 0)
,RenewedProjectID = ISNULL(a.RenewedProjectID,0)
,TFRIAmount = ISNULL(x.TFRIAmount, 0)
,a.ClosedUnusedFunds

,ProjectStatusDescription = ISNULL(e.[ProjectStatusDescription], '')
,a.[ProjectStatusID]
,d.[ProgramDescription]
,d.ProgramID
,ProjectLeaders = g.ProjectLeaders

,StartDate						= CASE WHEN YEAR(a.StartDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.StartDate, 107) END

--,EndDate	= CASE WHEN YEAR(a.StartDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20), DATEADD(dd,-1,DATEADD(mm,ISNULL(a.LengthOfProjectYears*12 + a.LengthOfProjectMonths,0),a.StartDate)), 107) END

,EndDate	= CASE WHEN YEAR(a.StartDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20), 
CASE WHEN NCEEndDate >= 
DATEADD(dd,-1,DATEADD(mm,ISNULL(a.LengthOfProjectYears*12 + a.LengthOfProjectMonths,0),a.StartDate)) THEN NCEEndDate ELSE
DATEADD(dd,-1,DATEADD(mm,ISNULL(a.LengthOfProjectYears*12 + a.LengthOfProjectMonths,0),a.StartDate)) END
, 107) END

,CalculatedEndDate = DATEADD(dd,-1,DATEADD(mm,ISNULL(a.LengthOfProjectYears*12 + a.LengthOfProjectMonths,0),a.StartDate))

,LetterOfOfferDate				= CASE WHEN YEAR(a.LetterOfOfferDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.LetterOfOfferDate, 107) END

,NCEEndDate						= CASE WHEN YEAR(a.NCEEndDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.NCEEndDate, 107) END
,CloseOutLetterSentDate			= CASE WHEN YEAR(a.CloseOutLetterSentDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.CloseOutLetterSentDate, 107) END
,FollowUpDate					= CASE WHEN YEAR(a.FollowUpDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.FollowUpDate, 107) END
,RefundReceivedDate				= CASE WHEN YEAR(a.RefundReceivedDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.RefundReceivedDate, 107) END
,BudgetAmendedDate				= CASE WHEN YEAR(a.BudgetAmendedDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.BudgetAmendedDate, 107) END

,LastProgressMeetingDate		= CASE WHEN YEAR(a.LastProgressMeetingDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.LastProgressMeetingDate, 107) END
,LastProjectMeetingDate		= CASE WHEN YEAR(a.LastProjectMeetingDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.LastProjectMeetingDate, 107) END

,NextSACMeetingDate				= CASE WHEN YEAR(a.NextSACMeetingDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.NextSACMeetingDate, 107) END
,LastProgressReportReceivedDate = CASE WHEN YEAR(a.LastProgressReportReceivedDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.LastProgressReportReceivedDate, 107) END

,a.ProgressReportFrequency
,a.ProjectMeetingFrequency
,LastSACMeetingDate	=CASE WHEN YEAR(a.LastSACMeetingDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.LastSACMeetingDate, 107) END

,NextProjectMeetingDate	=CASE WHEN YEAR(a.NextProjectMeetingDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.NextProjectMeetingDate, 107) END

,a.ProgressReportMonths
,a.Notes
,a.PublicationsList
,a.CommunicationsNotes
,a.NextProjectMeeting
,LengthOfProjectYears = ISNULL(a.LengthOfProjectYears,0)
,LengthOfProjectMonths = ISNULL(a.LengthOfProjectMonths,0)
,Keywords = '"' + ISNULL(a.Keywords,'') + '"'
,ExtraKeywords = a.ExtraKeywords
,[PI] = z.People

,LastMetricsReportReceived	= CASE WHEN YEAR(a.LastMetricsReportReceived) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.LastMetricsReportReceived, 107) END

FROM Project a
LEFT JOIN Program				 d ON d.[ProgramID] = a.[ProgramID]
LEFT JOIN ProjectStatus			 e ON e.[ProjectStatusID] = a.[ProjectStatusID]
LEFT JOIN vwProjectLeader2String g ON g.ProjectID = a.ProjectID
LEFT JOIN sp					sp ON sp.ProjectID = a.ProjectID
LEFT JOIN x                      x ON x.ProjectID = a.ProjectID 
LEFT JOIN z z ON z.ProjectID = a.ProjectID 
WHERE ISNULL(a.IsDeleted, 0) != 1

GO


