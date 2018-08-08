IF OBJECT_ID('vwFiscalYearParameter', 'V') IS NOT NULL
    DROP VIEW vwFiscalYearParameter;
GO


CREATE VIEW vwFiscalYearParameter
AS

/*

SELECT * from vwFiscalYearParameter


*/

WITH cteLast AS (
	SELECT TOP 1
	StartDateLabel = YEAR(StartDate)+1
	,StartDateValue = CAST(CAST(YEAR(StartDate) AS nvarchar(4)) + '/04/01' AS date) 
	FROM Project
	ORDER BY StartDate DESC

)

SELECT DISTINCT
StartDateLabel = 'FY'+CAST(YEAR(StartDate) AS varchar(4))
,StartDateValue = CAST(CAST(YEAR(StartDate)-1 AS nvarchar(4)) + '/04/01' AS date) 
FROM Project

UNION

SELECT 'FY'+CAST(StartDateLabel AS varchar(4)),StartDateValue
FROM cteLast