create view vwProjectStatusFilter
AS

SELECT ProjectStatusID = 0, ProjectStatusDescription = 'ALL'

UNION ALL

SELECT 
ProjectStatusID,ProjectStatusDescription
FROM ProjectStatus