DROP VIEW [dbo].[vwInstitution]
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
,Acronym
,MOUStartDate	= CASE WHEN YEAR(MOUStartDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),MOUStartDate, 107) END
,MOUEndDate	= CASE WHEN YEAR(MOUEndDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),MOUEndDate, 107) END
,MOUExtendedOnDate	= CASE WHEN YEAR(MOUExtendedOnDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),MOUExtendedOnDate, 107) END
FROM Institution
GO


