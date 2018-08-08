USE [master]
GO
/****** Object:  Database [TFRI]    Script Date: 9/24/2016 5:50:55 PM ******/
CREATE DATABASE [TFRI]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TFRI', FILENAME = N'C:\SQLData\TFRI.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'TFRI_log', FILENAME = N'C:\SQLData\TFRI_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [TFRI] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TFRI].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TFRI] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TFRI] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TFRI] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TFRI] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TFRI] SET ARITHABORT OFF 
GO
ALTER DATABASE [TFRI] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TFRI] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [TFRI] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TFRI] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TFRI] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TFRI] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TFRI] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TFRI] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TFRI] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TFRI] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TFRI] SET  DISABLE_BROKER 
GO
ALTER DATABASE [TFRI] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TFRI] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TFRI] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TFRI] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TFRI] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TFRI] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TFRI] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TFRI] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [TFRI] SET  MULTI_USER 
GO
ALTER DATABASE [TFRI] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TFRI] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TFRI] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TFRI] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [TFRI]
GO
/****** Object:  User [web_user]    Script Date: 9/24/2016 5:50:55 PM ******/
CREATE USER [web_user] FOR LOGIN [web_user] WITH DEFAULT_SCHEMA=[db_datareader]
GO
ALTER ROLE [db_datareader] ADD MEMBER [web_user]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [web_user]
GO
/****** Object:  Table [dbo].[AdminAssistant]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AdminAssistant](
	[AdminAssistantID] [int] IDENTITY(1,1) NOT NULL,
	[ContactID] [int] NOT NULL,
	[ContactAdminID] [int] NOT NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Contact]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contact](
	[ContactID] [int] IDENTITY(1,1) NOT NULL,
	[FName] [nvarchar](255) NULL,
	[LName] [nvarchar](255) NULL,
	[Sal] [nvarchar](100) NULL,
	[JobTitle] [nvarchar](255) NULL,
	[Notes] [nvarchar](1000) NULL,
	[Phone] [nvarchar](1000) NULL,
	[Email] [nvarchar](1000) NULL,
	[Address1] [nvarchar](255) NULL,
	[Address2] [nvarchar](255) NULL,
	[Address3] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[Province] [nvarchar](255) NULL,
	[PostalCode] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[Bio] [nvarchar](4000) NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
	[CreatedUserID] [int] NULL,
	[UpdatedUserID] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ContactAdminFor]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContactAdminFor](
	[ContactAdminForID] [int] IDENTITY(1,1) NOT NULL,
	[ContactID] [int] NOT NULL,
	[ContactAdminID] [int] NOT NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ContactAssistantFor]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContactAssistantFor](
	[ContactAssistantForID] [int] IDENTITY(1,1) NOT NULL,
	[ContactID] [int] NOT NULL,
	[ContactAssistantID] [int] NOT NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ContactEmail]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContactEmail](
	[ContactEmailID] [int] IDENTITY(1,1) NOT NULL,
	[ContactID] [int] NOT NULL,
	[Email] [nvarchar](200) NULL,
	[Note] [nvarchar](200) NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
	[CreatedUserID] [int] NULL,
	[UpdatedUserID] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ContactInstitution]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContactInstitution](
	[ContactInstitutionID] [int] IDENTITY(1,1) NOT NULL,
	[ContactID] [int] NOT NULL,
	[InstitutionID] [int] NOT NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
	[Role] [nvarchar](200) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ContactPhone]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContactPhone](
	[ContactPhoneID] [int] IDENTITY(1,1) NOT NULL,
	[ContactID] [int] NOT NULL,
	[Phone] [nvarchar](200) NULL,
	[Note] [nvarchar](200) NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
	[CreatedUserID] [int] NULL,
	[UpdatedUserID] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Institution]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Institution](
	[InstitutionID] [int] IDENTITY(1,1) NOT NULL,
	[ParentInstitutionID] [int] NULL,
	[InstitutionName] [nvarchar](500) NULL,
	[Address1] [nvarchar](255) NULL,
	[Address2] [nvarchar](255) NULL,
	[Address3] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[Province] [nvarchar](255) NULL,
	[PostalCode] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
	[CreatedUserID] [int] NULL,
	[UpdatedUserID] [int] NULL,
	[Notes] [nvarchar](4000) NULL,
	[Dept] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[InstitutionCommRep]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InstitutionCommRep](
	[InstitutionCommRepID] [int] IDENTITY(1,1) NOT NULL,
	[InstitutionID] [int] NULL,
	[ContactID] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PeopleGroup]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PeopleGroup](
	[PeopleGroupID] [int] IDENTITY(1,1) NOT NULL,
	[GroupName] [nvarchar](500) NOT NULL,
	[Notes] [nvarchar](2000) NOT NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PeopleGroupContact]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PeopleGroupContact](
	[PeopleGroupContactID] [int] IDENTITY(1,1) NOT NULL,
	[PeopleGroupID] [int] NOT NULL,
	[ContactID] [int] NOT NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PeopleGroupProject]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PeopleGroupProject](
	[PeopleGroupProjectID] [int] IDENTITY(1,1) NOT NULL,
	[PeopleGroupID] [int] NOT NULL,
	[ProjectID] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Program]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Program](
	[ProgramID] [int] IDENTITY(1,1) NOT NULL,
	[ProgramDescription] [nvarchar](500) NULL,
	[ProgramCode] [nvarchar](50) NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Project]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Project](
	[ProjectID] [int] IDENTITY(1,1) NOT NULL,
	[ProgramID] [int] NOT NULL,
	[ProjectNumber] [nvarchar](200) NULL,
	[ProjectTitle] [nvarchar](2000) NULL,
	[ProjectShortName] [nvarchar](1000) NULL,
	[LengthOfProjectYears] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[LetterOfOfferDate] [datetime] NULL,
	[NCEEndDate] [datetime] NULL,
	[CloseOutLetterSentDate] [datetime] NULL,
	[FollowUpDate] [datetime] NULL,
	[LastProjectMeetingDate] [datetime] NULL,
	[NextSACMeetingDate] [datetime] NULL,
	[LastProgressReportReceivedDate] [datetime] NULL,
	[NextProjectMeeting] [nvarchar](100) NULL,
	[TotalAmountAwarded] [decimal](18, 2) NULL,
	[TFRIAmount] [decimal](18, 2) NULL,
	[BudgetAmendedDate] [datetime] NULL,
	[ProjectStatusID] [int] NULL,
	[Renewal] [bit] NULL,
	[RenewedProjectID] [int] NULL,
	[Notes] [nvarchar](4000) NULL,
	[CommunicationsNotes] [nvarchar](4000) NULL,
	[PublicationsList] [nvarchar](4000) NULL,
	[ClosedUnusedFunds] [decimal](18, 2) NULL,
	[RefundReceivedDate] [datetime] NULL,
	[ProgressReportFrequency] [nvarchar](100) NULL,
	[LaySummary] [nvarchar](4000) NULL,
	[ScientificSummary] [nvarchar](4000) NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
	[CreatedUserID] [int] NULL,
	[UpdatedUserID] [int] NULL,
	[LastSACMeetingDate] [datetime] NULL,
	[ProgressReportMonths] [nvarchar](200) NULL,
	[ProjectMeetingFrequency] [nvarchar](200) NULL,
	[LastProgressMeetingDate] [datetime] NULL,
	[MentorProjectID] [int] NULL,
	[LengthOfProjectMonths] [int] NULL,
	[Keywords] [nvarchar](4000) NULL,
	[ExtraKeywords] [nvarchar](4000) NULL,
	[IsDeleted] [bit] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProjectLeader]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectLeader](
	[ProjectLeaderID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectID] [int] NOT NULL,
	[InstitutionID] [int] NULL,
	[ContactID] [int] NOT NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProjectManager]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectManager](
	[ProjectManagerID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectID] [int] NOT NULL,
	[ContactID] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProjectMentor]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectMentor](
	[ProjectMentorID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectID] [int] NOT NULL,
	[MentorProjectID] [int] NULL,
	[ContactID] [int] NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProjectStatus]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectStatus](
	[ProjectStatusID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectStatusDescription] [nvarchar](500) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubProject]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubProject](
	[SubProjectID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectID] [int] NOT NULL,
	[SubProjectName] [nvarchar](1000) NULL,
	[SubProjectDescription] [nvarchar](4000) NULL,
	[TotalAmountAwarded] [decimal](18, 2) NULL,
	[TFRIAmount] [decimal](18, 2) NULL,
	[BudgetAmendedDate] [datetime] NULL,
	[MOUSite] [int] NULL,
	[MOUStartDate] [datetime] NULL,
	[MOUEndDate] [datetime] NULL,
	[MOUExtendedOnDate] [datetime] NULL,
	[Notes] [nvarchar](4000) NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
	[CreatedUserID] [int] NULL,
	[UpdatedUserID] [int] NULL,
	[IsDeleted] [bit] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubProjectBudget]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubProjectBudget](
	[SubProjectBudgetID] [int] IDENTITY(1,1) NOT NULL,
	[SubProjectID] [int] NOT NULL,
	[PIID] [int] NOT NULL,
	[InstitutionID] [int] NOT NULL,
	[CoFunderID] [int] NOT NULL,
	[Year1Amt] [decimal](18, 2) NULL,
	[Year2Amt] [decimal](18, 2) NULL,
	[Year3Amt] [decimal](18, 2) NULL,
	[Year4Amt] [decimal](18, 2) NULL,
	[Year5Amt] [decimal](18, 2) NULL,
	[Year6Amt] [decimal](18, 2) NULL,
	[Year7Amt] [decimal](18, 2) NULL,
	[Year8Amt] [decimal](18, 2) NULL,
	[Year9Amt] [decimal](18, 2) NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL,
	[Managed] [nvarchar](20) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubProjectCoInvestigator]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubProjectCoInvestigator](
	[SubProjectCoInvestigatorID] [int] IDENTITY(1,1) NOT NULL,
	[SubProjectID] [int] NOT NULL,
	[ContactID] [int] NOT NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubProjectCollaborator]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubProjectCollaborator](
	[SubProjectCollaboratorID] [int] IDENTITY(1,1) NOT NULL,
	[SubProjectID] [int] NOT NULL,
	[ContactID] [int] NOT NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubProjectFinOfficer]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubProjectFinOfficer](
	[SubProjectFinOfficerID] [int] IDENTITY(1,1) NOT NULL,
	[SubProjectID] [int] NOT NULL,
	[ContactID] [int] NOT NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubProjectFinRep]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubProjectFinRep](
	[SubProjectFinRepID] [int] IDENTITY(1,1) NOT NULL,
	[SubProjectID] [int] NOT NULL,
	[ContactID] [int] NOT NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubProjectManager]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubProjectManager](
	[SubProjectManagerID] [int] IDENTITY(1,1) NOT NULL,
	[SubProjectID] [int] NOT NULL,
	[ContactID] [int] NOT NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubProjectPI]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubProjectPI](
	[SubProjectPIID] [int] IDENTITY(1,1) NOT NULL,
	[SubProjectID] [int] NOT NULL,
	[ContactID] [int] NOT NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[XXX_ProjectCoFunder]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XXX_ProjectCoFunder](
	[ProjectCoFunderID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectID] [int] NOT NULL,
	[InstitutionID] [int] NOT NULL,
	[BudgetAmount] [decimal](18, 2) NULL,
	[Managed] [nvarchar](20) NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[XXX_SubProjectCoFunder]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XXX_SubProjectCoFunder](
	[SubProjectCoFunderID] [int] IDENTITY(1,1) NOT NULL,
	[SubProjectID] [int] NOT NULL,
	[InstitutionID] [int] NOT NULL,
	[BudgetAmount] [decimal](18, 2) NULL,
	[Managed] [nvarchar](20) NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[vwPeople]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vwPeople]

as

/*

select * from vwPeople
select * from project
select * from contact
SELECT * FROM ContactPhone
SELECT * FROM ContactEmail



*/

WITH phones AS (
	SELECT
	ContactID,
	STUFF((
	SELECT ', ' + Phone
	FROM ContactPhone
	WHERE (ContactID = a.ContactID )
	FOR XML PATH (''))
	,1,2,'') AS Phones
	FROM ContactPhone a
	GROUP BY ContactID
) 

,emails AS (
	SELECT
	ContactID,
	STUFF((
	SELECT ', ' + Email
	FROM ContactEmail
	WHERE (ContactID = a.ContactID )
	FOR XML PATH (''))
	,1,2,'') AS Emails
	FROM ContactEmail a
	GROUP BY ContactID
) 


SELECT 
a.ContactID
,[FName]
,[LName]
,FullName = [LName] + ', ' + [FName]
,[Sal]
,b.Phones
,c.Emails
,JobTitle
,[Address] = [Address1] + [Address2] + [City] + [Province] + [PostalCode]
,[Country]

 FROM [Contact] a
 LEFT JOIN phones b ON b.ContactID = a.ContactID
 LEFT JOIN emails c ON c.ContactID = a.ContactID

GO
/****** Object:  View [dbo].[vwContactAdminFor]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vwContactAdminFor]

as

/*

select * from vwContactAdminFor

*/


SELECT
 a.AdminAssistantID
,a.ContactID
,a.ContactAdminID
,b.FullName
,AdminFullName = c.FullName
FROM  AdminAssistant a
INNER JOIN vwPeople	b ON b.ContactID = a.ContactID
INNER JOIN vwPeople	c ON c.ContactID = a.ContactAdminID


GO
/****** Object:  View [dbo].[vwProjectLeadersByProject]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwProjectLeadersByProject]

as

/*

select * from vwProjectLeadersByProject


*/


SELECT
a.[ProjectID]
,e.[InstitutionID]
,e.[InstitutionName]
,c.FullName
FROM Project a
INNER JOIN ProjectLeader		b ON b.ProjectID = a.ProjectID
LEFT JOIN vwPeople				c ON c.ContactID = b.ContactID
LEFT JOIN ContactInstitution	d ON d.[ContactID] = c.ContactID
INNER JOIN Institution	e ON e.[InstitutionID] = d.[InstitutionID]






GO
/****** Object:  View [dbo].[vwProjectLeader2String]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vwProjectLeader2String]

as


SELECT * FROM (
SELECT
a.ProjectID
,ProjectLeaders = 
(
SELECT STUFF((SELECT ', ' + b.FullName 
FROM vwProjectLeadersByProject b
WHERE b.ProjectID = a.ProjectID
FOR XML PATH('')),1, 2, '') AS ProjectLeaders
)
FROM Project a
) a
WHERE a.ProjectLeaders IS NOT NULL
GO
/****** Object:  View [dbo].[vwSubProject]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vwSubProject]

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

--,BudgetAmendedDate = CONVERT(VARCHAR(10),a.BudgetAmendedDate, 101)
--,MOUStartDate = CONVERT(VARCHAR(10),a.MOUStartDate, 101)
--,MOUEndDate = CONVERT(VARCHAR(10),a.MOUEndDate, 101)
--,MOUExtendedOnDate = CONVERT(VARCHAR(10),a.MOUExtendedOnDate, 101)

,BudgetAmendedDate	= CASE WHEN YEAR(a.BudgetAmendedDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.BudgetAmendedDate, 107) END
,MOUStartDate	= CASE WHEN YEAR(a.MOUStartDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.MOUStartDate, 107) END
,MOUEndDate	= CASE WHEN YEAR(a.MOUEndDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.MOUEndDate, 107) END
,MOUExtendedOnDate	= CASE WHEN YEAR(a.MOUExtendedOnDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.MOUExtendedOnDate, 107) END
,MOUSite = ISNULL(a.MOUSite, 0)
,a.Notes
FROM SubProject a
LEFT JOIN cteBudget b ON b.SubProjectID = a.SubProjectID



GO
/****** Object:  View [dbo].[vwInstitutionBySubProject2List]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vwInstitutionBySubProject2List]

AS

WITH cte1 AS (

	SELECT DISTINCT
	 a.SubProjectID
	,b.InstitutionName
	FROM SubProjectBudget a
	JOIN Institution b ON b.InstitutionID = a.InstitutionID
)
SELECT
a.SubProjectID
,Institutions = 
(
	SELECT STUFF((SELECT '; ' + b.InstitutionName 
	FROM cte1 b
	WHERE b.SubProjectID = a.SubProjectID
	FOR XML PATH('')),1, 2, '') AS Institutions
)
FROM cte1 a
GROUP BY
a.SubProjectID

GO
/****** Object:  View [dbo].[vwPeopleBySubProject]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vwPeopleBySubProject]

AS

/*

select * from vwPeopleBySubProject 
where ProjectRole = 'Sub-Project PI'

*/

WITH cte1 AS (
	SELECT
	 A.ContactID
	,B.SubProjectID
	,ProjectRole = 'Project Co-Investigator'
	FROM SubProjectCoInvestigator A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT
	 A.ContactID
	,B.SubProjectID
	,ProjectRole = 'Project Collaborator'
	FROM SubProjectCollaborator A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT
	 A.ContactID
	,B.SubProjectID
	,ProjectRole = 'Financial Officer'
	FROM SubProjectFinOfficer A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT
	 A.ContactID
	,B.SubProjectID
	,ProjectRole = 'Financial Representative'
	FROM SubProjectFinRep A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT
	 A.ContactID
	,B.SubProjectID
	,ProjectRole = 'Sub-Project Manager'
	FROM SubProjectManager A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT
	 A.ContactID
	,B.SubProjectID
	,ProjectRole = 'Sub-Project PI'
	FROM SubProjectPI A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

)
,cte2 AS (
	SELECT DISTINCT
	 A.ContactID
	,B.SubProjectID
	,A.FullName
	,B.ProjectRole

	FROM vwPeople A
	JOIN cte1 B ON b.ContactID = A.ContactID
	--JOIN vwProject C ON C.ProjectID = B.ProjectID
)

SELECT 
*
FROM cte2




GO
/****** Object:  View [dbo].[vwPeopleBySubProject2List]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vwPeopleBySubProject2List]

as

/*

select * from vwPeopleBySubProject2List


*/

WITH cte1 AS (
	SELECT
	a.SubProjectID
	,a.ProjectRole
	,People = 
	(
	SELECT STUFF((SELECT '; ' + b.FullName 
	FROM vwPeopleBySubProject b
	WHERE b.SubProjectID = a.SubProjectID
	AND b.ProjectRole = a.ProjectRole
	FOR XML PATH('')),1, 2, '') AS People
	)
	FROM vwPeopleBySubProject a
	GROUP BY
	a.SubProjectID
	,a.ProjectRole

)

SELECT 
b.ProjectID
,a.*
FROM cte1 a
JOIN SubProject b ON b.SubProjectID = a.SubProjectID

GO
/****** Object:  View [dbo].[vwSubProjectBudget]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	
CREATE view [dbo].[vwSubProjectBudget]

AS
	
	
SELECT 
SubProjectID
,InstitutionID
,CoFunderID
,Managed
,TotalAmountAwarded = SUM(ISNULL(Year1Amt,0) + ISNULL(Year2Amt,0) + ISNULL(Year3Amt,0) + ISNULL(Year4Amt,0) + ISNULL(Year5Amt,0) + ISNULL(Year6Amt,0) + ISNULL(Year7Amt,0) + ISNULL(Year8Amt,0) + ISNULL(Year9Amt,0))
,TFRIAmount  = SUM(CASE WHEN ISNULL(Managed, '') = 'Yes' THEN
					ISNULL(Year1Amt,0) + ISNULL(Year2Amt,0) + ISNULL(Year3Amt,0) + ISNULL(Year4Amt,0) + ISNULL(Year5Amt,0) + ISNULL(Year6Amt,0) + ISNULL(Year7Amt,0) + ISNULL(Year8Amt,0) + ISNULL(Year9Amt,0)
					ELSE 0 END )
FROM SubProjectBudget
GROUP BY 
SubProjectID
,InstitutionID
,CoFunderID
,Managed
GO
/****** Object:  View [dbo].[vwSubProjectsByProject]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwSubProjectsByProject]

AS


/*

select * from vwSubProjectsByProject

SELECT * FROM vwCoFundersByProject


select * from vwPeopleBySubProject2List

*/


WITH cteBudget AS (

	SELECT 
	SubProjectID
	,TotalAmountAwarded = SUM(TotalAmountAwarded)
	,TFRIAmount = SUM(TFRIAmount)
	FROM vwSubProjectBudget
	GROUP bY SubProjectID

)

SELECT
 a.ProjectID
,a.SubProjectID
,a.SubProjectName
,Total = ISNULL(SUM(b.TotalAmountAwarded), 0)
,TFRIAmt = ISNULL(SUM(b.TFRIAmount), 0)
,SubProjectPILIst = c.People
,Institutions = d.Institutions
FROM SubProject a
LEFT JOIN cteBudget b ON b.SubProjectID = a.SubProjectID
LEFT JOIN vwPeopleBySubProject2List c ON c.SubProjectID = a.SubProjectID AND c.ProjectRole = 'Sub-Project PI'
LEFT JOIN vwInstitutionBySubProject2List d ON d.SubProjectID = a.SubProjectID
GROUP BY 
a.ProjectID
,a.SubProjectID
,a.SubProjectName
,c.People
,d.Institutions

GO
/****** Object:  View [dbo].[vwProject]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwProject]

as

/*

SELECT * FROM vwProject ORDER BY ProjectShortName
SELECT * FROM vwSubProject

SELECT ProjectShortName = ProjectNumber+ ' ' +ProjectShortName FROM vwProject ORDER BY ProjectNumber

select top 3 * from Project order by ProjectID desc
select * from [dbo].[ProjectPartner] order by ProjectID desc



SELECT * FROM vwProject where ProjectID = 14
SELECT * FROM vwSubProject where ProjectID = 14

Biochemistry,Genetics,Colorectal


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
,d.[ProgramDescription]
,d.ProgramID
,ProjectLeaders = g.ProjectLeaders

,StartDate						= CASE WHEN YEAR(a.StartDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.StartDate, 107) END
,EndDate						= CASE WHEN YEAR( a.StartDate ) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),DATEADD(yy,ISNULL(a.LengthOfProjectYears,0),a.StartDate), 107) END

,LetterOfOfferDate				= CASE WHEN YEAR(a.LetterOfOfferDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.LetterOfOfferDate, 107) END

,NCEEndDate						= CASE WHEN YEAR(a.NCEEndDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.NCEEndDate, 107) END
,CloseOutLetterSentDate			= CASE WHEN YEAR(a.CloseOutLetterSentDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.CloseOutLetterSentDate, 107) END
,FollowUpDate					= CASE WHEN YEAR(a.FollowUpDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.FollowUpDate, 107) END
,RefundReceivedDate				= CASE WHEN YEAR(a.RefundReceivedDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.RefundReceivedDate, 107) END
,BudgetAmendedDate				= CASE WHEN YEAR(a.BudgetAmendedDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.BudgetAmendedDate, 107) END
,LastProgressMeetingDate		= CASE WHEN YEAR(a.LastProgressMeetingDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.LastProgressMeetingDate, 107) END
,NextSACMeetingDate				= CASE WHEN YEAR(a.NextSACMeetingDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.NextSACMeetingDate, 107) END
,LastProgressReportReceivedDate = CASE WHEN YEAR(a.LastProgressReportReceivedDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.LastProgressReportReceivedDate, 107) END

,a.ProgressReportFrequency
,a.ProjectMeetingFrequency
,LastSACMeetingDate	=CASE WHEN YEAR(a.LastSACMeetingDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.LastSACMeetingDate, 107) END
,a.ProgressReportMonths
,a.Notes
,a.PublicationsList
,a.CommunicationsNotes
,a.NextProjectMeeting
,LengthOfProjectYears = ISNULL(a.LengthOfProjectYears,0)
,LengthOfProjectMonths = ISNULL(a.LengthOfProjectMonths,0)
,Keywords = '"' + ISNULL(a.Keywords,'') + '"'
,ExtraKeywords = a.ExtraKeywords

FROM Project a
LEFT JOIN Program				 d ON d.[ProgramID] = a.[ProgramID]
LEFT JOIN ProjectStatus			 e ON e.[ProjectStatusID] = a.[ProjectStatusID]
LEFT JOIN vwProjectLeader2String g ON g.ProjectID = a.ProjectID
LEFT JOIN sp					sp ON sp.ProjectID = a.ProjectID
LEFT JOIN x                      x ON x.ProjectID = a.ProjectID 

GO
/****** Object:  View [dbo].[vwPeopleByProject]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwPeopleByProject]

AS

/*

select * from vwPeopleByProject 
where ProjectRole = 'Sub-Project PI'

*/

WITH cte1 AS (
	SELECT
	 ContactID
	,ProjectID
	,ProjectRole = 'Project Leader'
	FROM ProjectLeader

	UNION ALL

	SELECT
	 ContactID
	,ProjectID
	,ProjectRole = 'Project Manager'
	FROM ProjectManager

	UNION ALL

	SELECT
	 ContactID
	,ProjectID
	,ProjectRole = 'Project Mentor'
	FROM ProjectMentor

	UNION ALL

	SELECT
	 A.ContactID
	,B.ProjectID
	,ProjectRole = 'Project Co-Investigator'
	FROM SubProjectCoInvestigator A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT
	 A.ContactID
	,B.ProjectID
	,ProjectRole = 'Project Collaborator'
	FROM SubProjectCollaborator A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT
	 A.ContactID
	,B.ProjectID
	,ProjectRole = 'Financial Officer'
	FROM SubProjectFinOfficer A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT
	 A.ContactID
	,B.ProjectID
	,ProjectRole = 'Financial Representative'
	FROM SubProjectFinRep A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT
	 A.ContactID
	,B.ProjectID
	,ProjectRole = 'Sub-Project Manager'
	FROM SubProjectManager A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT
	 A.ContactID
	,B.ProjectID
	,ProjectRole = 'Sub-Project PI'
	FROM SubProjectPI A
	JOIN SubProject B ON B.SubProjectID = A.SubProjectID

	UNION ALL

	SELECT DISTINCT
	 b.ContactID
	,c.ProjectID
	,ProjectRole = 'SAC Member'
	FROM PeopleGroup a
	JOIN PeopleGroupContact b ON b.PeopleGroupID = a.PeopleGroupID
	JOIN PeopleGroupProject c ON c.PeopleGroupID = a.PeopleGroupID


)
,cte2 AS (
	SELECT DISTINCT
	 A.ContactID
	,C.ProjectID
	,A.FullName
	,B.ProjectRole
	,C.ProjectNumber
	,C.ProjectShortName
	,C.ProjectStatusDescription
	,C.ProjectTitle
	FROM vwPeople A
	JOIN cte1 B ON b.ContactID = A.ContactID
	JOIN vwProject C ON C.ProjectID = B.ProjectID
)

SELECT 
*
FROM cte2




GO
/****** Object:  View [dbo].[vwPeopleByInstitution]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwPeopleByInstitution]

AS

/*

select * from vwPeopleByInstitution

select * from [dbo].[ContactInstitution]

*/

WITH cte1 AS (

	SELECT * FROM ContactInstitution
)
,cte2 AS (
SELECT

C.InstitutionID
,A.ContactID
,A.FullName
,C.InstitutionName
,B.Role
FROM vwPeople A
JOIN cte1 B ON b.ContactID = A.ContactID
JOIN [dbo].[Institution] C ON C.InstitutionID = B.InstitutionID
)
SELECT 
*
FROM cte2




GO
/****** Object:  View [dbo].[vwPeopleByGroup]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vwPeopleByGroup]

AS

/*

select * from vwPeopleByGroup

select * from [dbo].[PeopleGroup]
select * from [dbo].[PeopleGroupContact]

*/

WITH cte1 AS (

	SELECT *
	FROM PeopleGroupContact
)
,cte2 AS (
SELECT

C.PeopleGroupID
,A.ContactID
,A.FullName
,C.GroupName
FROM vwPeople A
JOIN cte1 B ON b.ContactID = A.ContactID
JOIN PeopleGroup C ON C.PeopleGroupID = B.PeopleGroupID
)
SELECT 
*
FROM cte2




GO
/****** Object:  View [dbo].[vwCoFundersByProject]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwCoFundersByProject]

AS


/*

select * from vwCoFundersByProject ORDER BY InstitutionName
--SELECT * FROM vwSubProject WHERE ProjectID =18
--select * from SubProjectCoFunder where SubProjectID = 4

*/

WITH cte1 AS (

	SELECT
	 SubProjectID
	,CoFunderID
	--,InstitutionID
	,Managed
	,TotalAmountAwarded = SUM(TotalAmountAwarded)
	,TFRIAmount = SUM(TFRIAmount)
	FROM vwSubProjectBudget
	GROUP BY
	 SubProjectID
	--,InstitutionID
	,CoFunderID
	,Managed


)
,cte2 AS (
	SELECT
	a.ProjectID
	--,a.SubProjectID
	--,b.InstitutionID
	,b.CoFunderID
	,b.Managed
	,BudgetAmount = ISNULL(SUM(b.TotalAmountAwarded), 0)
	FROM SubProject a
	LEFT JOIN cte1 b ON b.SubProjectID = a.SubProjectID
	GROUP BY 
	a.ProjectID
	--,a.SubProjectID
	--,b.InstitutionID
	,b.CoFunderID
	,b.Managed
)

SELECT
a.*
,b.InstitutionName
FROM cte2 a
LEFT JOIN Institution b ON b.InstitutionID = a.CoFunderID


GO
/****** Object:  View [dbo].[vwProjectPeople2String]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vwProjectPeople2String]

as


/*

select * from vwProjectPeople2String

select * from vwPeopleByProject


*/


SELECT * FROM (
SELECT
ProjectID,ProjectRole,
STUFF((
SELECT ', ' + FullName
FROM vwPeopleByProject
WHERE (ProjectID = a.ProjectID AND ProjectRole = a.ProjectRole)
FOR XML PATH (''))
,1,2,'') AS People
FROM vwPeopleByProject a
GROUP BY ProjectID,ProjectRole
) a
WHERE a.People IS NOT NULL
GO
/****** Object:  View [dbo].[vwPeopleRolesByProject]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vwPeopleRolesByProject]

as

/*

select * from vwPeopleRolesByProject

select * from vwProjectPeople2String 

*/

SELECT
a.ProjectID
,[PI] = ISNULL(b.People ,'')
,[Collaborators] = ISNULL(c.People ,'')
,SACMembers = ISNULL(d.People, '') 
,FinOfficers = ISNULL(e.People, '') 
FROM Project a
LEFT JOIN vwProjectPeople2String b ON b.ProjectID = a.ProjectID AND b.ProjectRole = 'Sub-Project PI'
LEFT JOIN vwProjectPeople2String c ON c.ProjectID = a.ProjectID AND c.ProjectRole = 'Project Collaborator'
LEFT JOIN vwProjectPeople2String d ON d.ProjectID = a.ProjectID AND d.ProjectRole = 'SAC Member'
LEFT JOIN vwProjectPeople2String e ON e.ProjectID = a.ProjectID AND e.ProjectRole = 'Financial Officer'


GO
/****** Object:  View [dbo].[vwProjectLeader]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vwProjectLeader]

as

/*

select * from vwProjectLeader


*/


SELECT
 a.ProjectID
,ProjectLeader = c.FullName

FROM Project a
INNER JOIN ProjectLeader b ON b.ProjectID = a.ProjectID
LEFT JOIN vwPeople		 c ON c.ContactID = b.ContactID

GO
/****** Object:  View [dbo].[vwProjectLeaderInstitution]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vwProjectLeaderInstitution]

as

/*

select * from vwProjectLeaderInstitution


*/


SELECT
 e.[InstitutionID]
,e.[InstitutionName]

FROM Project a
INNER JOIN ProjectLeader		b ON b.ProjectID = a.ProjectID
LEFT JOIN vwPeople				c ON c.ContactID = b.ContactID
LEFT JOIN ContactInstitution	d ON d.[ContactID] = c.ContactID
INNER JOIN [dbo].[Institution]	e ON e.[InstitutionID] = d.[InstitutionID]


GO
/****** Object:  View [dbo].[vwContactInstitution]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwContactInstitution]

as

/*

select * from vwContactInstitution
SELECT * FROM ContactInstitution
SELECT * FROM Institution  ORDER BY InstitutionName

*/


SELECT

b.[ContactInstitutionID]
,a.ContactID
,c.[InstitutionID]
,c.[InstitutionName]
,b.Role

FROM  vwPeople	a
LEFT JOIN ContactInstitution	b ON b.[ContactID] = a.ContactID
INNER JOIN [dbo].[Institution]	c ON c.[InstitutionID] = b.[InstitutionID]


GO
/****** Object:  View [dbo].[vwInstitution]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vwInstitution]

as

SELECT 
[InstitutionID]
,[ParentInstitutionID] = ISNULL([ParentInstitutionID],0)
,[InstitutionName]
,[Address1]
,[Address2]
,[City]
,[Province]
,[PostalCode]
,[Country]
FROM Institution
GO
/****** Object:  View [dbo].[vwInstitutionDropDown]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vwInstitutionDropDown]

as

/*

SELECT * FROM vwInstitutionDropDown order by InstitutionName

*/

SELECT 
 [InstitutionID] = 0
,[ParentInstitutionID] = 0
,[InstitutionName] = ''
UNION ALL
SELECT 
 [InstitutionID]
,[ParentInstitutionID]
,[InstitutionName]
FROM Institution
GO
/****** Object:  View [dbo].[vwInstitutionsByProject]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vwInstitutionsByProject]

AS

WITH cte1 AS (
	SELECT
	 b.ProjectID
	--,a.InstitutionID
	,c.InstitutionName
	,c.Province
	FROM SubProjectBudget a
	JOIN SubProject b ON b.SubProjectID = a.SubProjectID
	JOIN Institution c ON c.InstitutionID = a.InstitutionID
)


SELECT * FROM (
SELECT
ProjectID,Province,
STUFF((
SELECT ', ' + InstitutionName
FROM cte1
WHERE (ProjectID = a.ProjectID  AND Province = a.Province)
FOR XML PATH (''))
,1,2,'') AS Institutions
FROM cte1 a
GROUP BY ProjectID,Province
) a
WHERE a.Institutions IS NOT NULL

GO
/****** Object:  View [dbo].[vwManaged]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vwManaged]

as

/*

select * from vwManaged


*/


SELECT
Managed = 'Yes'

UNION

SELECT
Managed = 'No'


GO
/****** Object:  View [dbo].[vwProjectCoFunder]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwProjectCoFunder]

as

/*

select * from Project
select * from ProjectCoFunder
select * from ProjectLeader
select * from ProjectManager
select * from ProjectMentor

select * from SubProject
select * from SubProjectPI

SELECT * FROM vwProject 
select * from vwPeople

select * from SubProjectMoneyDistr

*/


SELECT
b.ProjectCoFunderID
,a.ProjectID
,c.InstitutionID
,c.InstitutionName
,b.BudgetAmount
,b.Managed

FROM Project a
INNER JOIN ProjectCoFunder		b ON b.ProjectID = a.ProjectID
INNER JOIN Institution	c ON c.InstitutionID = b.InstitutionID


GO
/****** Object:  View [dbo].[vwProvince]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vwProvince]


/*

select * from vwProvince order by SortOrder

*/
as

SELECT Province = '',SortOrder = 0
UNION
SELECT Province = 'BC',SortOrder = 1
UNION
SELECT Province = 'AB',SortOrder = 2
UNION
SELECT Province = 'ON',SortOrder = 3
UNION
SELECT Province = 'QC',SortOrder = 4
UNION
SELECT Province = 'MB',SortOrder = 5
UNION
SELECT Province = 'SK',SortOrder = 6
UNION
SELECT Province = 'NS',SortOrder = 7
UNION
SELECT Province = 'NB',SortOrder = 8
UNION
SELECT Province = 'NL',SortOrder = 9
UNION
SELECT Province = 'PE',SortOrder = 10
UNION
SELECT Province = 'NT',SortOrder = 11
UNION
SELECT Province = 'YT',SortOrder = 12
UNION
SELECT Province = 'NU',SortOrder = 13
UNION
SELECT Province = 'Other',SortOrder = 14

GO
/****** Object:  View [dbo].[vwRenewedProject]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwRenewedProject]

as

/*

SELECT * FROM vwRenewedProject ORDER BY ProjectTitle

SELECT ProjectShortName = ProjectNumber+ ' ' +ProjectShortName FROM vwProject ORDER BY ProjectNumber



*/


SELECT
 ProjectID
,ProjectNumberTitle = ProjectNumber+ '    ' + ProjectTitle
,ProjectNumber
FROM Project a


GO
/****** Object:  View [dbo].[vwSalutation]    Script Date: 9/24/2016 5:50:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwSalutation]


/*

select * from vwSalutation order by SortOrder

*/
as

SELECT Sal = '',SortOrder = 0
UNION
SELECT Sal = 'Dr.',SortOrder = 1
UNION
SELECT Sal = 'Mr.',SortOrder = 2
UNION
SELECT Sal = 'Mrs.',SortOrder = 3
UNION
SELECT Sal = 'Prof.',SortOrder = 4
UNION
SELECT Sal = 'Ms',SortOrder = 5


GO
ALTER TABLE [dbo].[AdminAssistant] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[Contact] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[ContactAdminFor] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[ContactAssistantFor] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[ContactEmail] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[ContactInstitution] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[ContactPhone] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[Institution] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[InstitutionCommRep] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[PeopleGroup] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[PeopleGroupContact] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[PeopleGroupProject] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[Project] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[ProjectLeader] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[ProjectManager] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[ProjectMentor] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[SubProject] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[SubProjectBudget] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[SubProjectCoInvestigator] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[SubProjectCollaborator] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[SubProjectFinOfficer] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[SubProjectFinRep] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[SubProjectManager] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[SubProjectPI] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[XXX_ProjectCoFunder] ADD  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[XXX_SubProjectCoFunder] ADD  DEFAULT (getdate()) FOR [Created]
GO
USE [master]
GO
ALTER DATABASE [TFRI] SET  READ_WRITE 
GO
