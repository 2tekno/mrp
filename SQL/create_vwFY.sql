alter view vwFY

AS


/*

select * from vwFY


*/


WITH cte0 AS (
	SELECT 
	 ProjectID
	,ProjectLengthMonths
	,PY1Amt
	,PY2Amt
	,PY3Amt
	,PY4Amt
	,PY5Amt
	,PY6Amt
	,StartDateRaw = CAST(StartDateRaw As date)
	,FM1 = CAST(CAST(YEAR(StartDateRaw) AS nvarchar(4)) + '/04/01' AS date) 
	from vwProgramFinancialsByFiscalYear
	where ProjectLengthMonths > 0

)

,cte1 AS (
	SELECT 
	*
	,FN1 =  CASE WHEN (
	        CASE WHEN (12 - DATEDIFF(MONTH, FM1, StartDateRaw)) > 12 THEN (12 - DATEDIFF(MONTH, FM1, StartDateRaw)) - 12 
			ELSE 12 - DATEDIFF(MONTH, FM1, StartDateRaw) END) > ProjectLengthMonths THEN ProjectLengthMonths
			ELSE 
			CASE WHEN (12 - DATEDIFF(MONTH, FM1, StartDateRaw)) > 12 THEN (12 - DATEDIFF(MONTH, FM1, StartDateRaw)) - 12 
			ELSE 12 - DATEDIFF(MONTH, FM1, StartDateRaw) END END

	from cte0
)

,cte2 As (
	SELECT
	*
	,FN2 = CASE WHEN ProjectLengthMonths - FN1 > 12 THEN 12 
		   ELSE ProjectLengthMonths - FN1 END
	FROM cte1
)

,cte3 As (
	SELECT
    *
	,FN3 = CASE WHEN ProjectLengthMonths - (FN1+FN2) > 12 THEN 12 
		   ELSE ProjectLengthMonths - (FN1+FN2) END
	FROM cte2
)

,cte4 As (
	SELECT
    *
	,FN4 = CASE WHEN ProjectLengthMonths - (FN1+FN2+FN3) > 12 THEN 12 
		   ELSE ProjectLengthMonths - (FN1+FN2+FN3) END
	FROM cte3
)

,cte5 As (
	SELECT
    *
	,FN5 = CASE WHEN ProjectLengthMonths - (FN1+FN2+FN3+FN4) > 12 THEN 12 
		   ELSE ProjectLengthMonths - (FN1+FN2+FN3+FN4) END
	FROM cte4
)

,cte6 As (
	SELECT
     *
	,FN6 = CASE WHEN ProjectLengthMonths - (FN1+FN2+FN3+FN4+FN5) > 12 THEN 12 
		   ELSE ProjectLengthMonths - (FN1+FN2+FN3+FN4+FN5) END
	FROM cte5
)


select * from cte6

