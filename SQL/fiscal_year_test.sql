select 
FM1 = CAST(CAST(YEAR(StartDateRaw) + 1 AS nvarchar(4)) + '/04/01' AS datetime) 
,FN1 = CAST(CAST(YEAR(StartDateRaw) + 1 AS nvarchar(4)) + '/04/01' AS datetime) 
,* 

from vwProgramFinancialsByFiscaalYear
where ProjectNumber = '1018'