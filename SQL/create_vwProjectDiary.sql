
DROP VIEW [dbo].[vwProjectDiary]
GO


CREATE  view [dbo].[vwProjectDiary]

as

/*

SELECT * FROM ProjectDiary 



*/


SELECT
*
,ProjectDiaryDateFormatted	= CASE WHEN YEAR(ProjectDiaryDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),ProjectDiaryDate, 107) END
FROM ProjectDiary



