create view vwInstitutionFilter

AS

SELECT InstitutionName = 'ALL', [InstitutionID] = 0
UNION ALL
SELECT InstitutionName, [InstitutionID]
FROM Institution
