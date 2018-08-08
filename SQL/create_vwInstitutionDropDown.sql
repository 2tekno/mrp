
alter view vwInstitutionDropDown

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