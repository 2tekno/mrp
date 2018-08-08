alter view vwRenewedProject

as

/*

SELECT * FROM vwRenewedProject ORDER BY ProjectTitle

SELECT ProjectShortName = ProjectNumber+ ' ' +ProjectShortName FROM vwProject ORDER BY ProjectNumber



*/

SELECT
 ProjectID = 0
,ProjectNumberTitle = ''
,ProjectNumber = ''

UNION ALL

SELECT
 ProjectID
,ProjectNumberTitle = ProjectNumber+ '    ' + ProjectShortName
,ProjectNumber
FROM Project a
WHERE ISNULL(IsDeleted, 0) = 0

