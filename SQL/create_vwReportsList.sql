USE [TFRI]
GO

/****** Object:  View [dbo].[vwReportsList]    Script Date: 2017-02-04 2:48:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER VIEW [dbo].[vwReportsList]
AS

/*

select * from vwReportsList

*/


SELECT 
 SortOrder = 1
,ReportName = 'ProjectStatusReport'
,ReportLabel = 'Project Status Report'

UNION

SELECT 
 SortOrder = 2
,ReportName = 'FundingByCoFunders'
,ReportLabel = 'Funding By CoFunders'

UNION

SELECT 
 SortOrder = 3
,ReportName = 'ProgramFinancialsByProjectYear'
,ReportLabel = 'Program Financials By ProjectYear'

UNION

SELECT 
 SortOrder = 4
,ReportName = 'ProgramManagement'
,ReportLabel = 'Program Management'


--UNION

--SELECT 
-- SortOrder = 4
--,ReportName = 'ProgramManagement3'
--,ReportLabel = 'Program Management - Copy'

UNION

SELECT 
 SortOrder = 5
,ReportName = 'TFRIFundingByProvince'
,ReportLabel = 'TFRI Funding By Province'

--UNION

--SELECT 
-- SortOrder = 5
--,ReportName = 'TFRIFundingByProvince2'
--,ReportLabel = 'TFRI Funding By Province - Copy'

UNION

SELECT 
 SortOrder = 6
,ReportName = 'ProgramFinancialsByFiscalYear'
,ReportLabel = 'Program Financials By Fiscal Year'

--UNION

--SELECT 
-- SortOrder = 7
--,ReportName = 'ContactList'
--,ReportLabel = 'Contact List'

UNION

SELECT 
 SortOrder = 8
,ReportName = 'ContactList'
,ReportLabel = 'Contact List'

--UNION

--SELECT 
-- SortOrder = 9
--,ReportName = 'ScientificProgressReport '
--,ReportLabel = 'Scientific Progress Report '



GO


