
WITH cte0 AS (
	SELECT 
	 ProjectID
	,ProjectLengthMonths
	,StartDateRaw = CAST(StartDateRaw As date)
	,FM1 = CAST(CAST(YEAR(StartDateRaw) AS nvarchar(4)) + '/04/01' AS datetime) 
	from vwProgramFinancialsByFiscalYear
	where ProjectLengthMonths > 0
)

,cte1 AS (
	SELECT 
	ProjectID
	,ProjectLengthMonths
	,StartDateRaw
	,FM1
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
	ProjectID
	,ProjectLengthMonths
	,StartDateRaw
	,FN1
	,FN2 = CASE WHEN ProjectLengthMonths - FN1 > 12 THEN 12 
		   ELSE ProjectLengthMonths - FN1 END
	FROM cte1
)

,cte3 As (
	SELECT
	ProjectID
	,ProjectLengthMonths
	,StartDateRaw
	,FN1
	,FN2
	,FN3 = CASE WHEN ProjectLengthMonths - (FN1+FN2) > 12 THEN 12 
		   ELSE ProjectLengthMonths - (FN1+FN2) END
	FROM cte2
)

,cte4 As (
	SELECT
	ProjectID
	,ProjectLengthMonths
	,StartDateRaw
	,FN1
	,FN2
	,FN3
	,FN4 = CASE WHEN ProjectLengthMonths - (FN1+FN2+FN3) > 12 THEN 12 
		   ELSE ProjectLengthMonths - (FN1+FN2+FN3) END
	FROM cte3
)

,cte5 As (
	SELECT
	ProjectID
	,ProjectLengthMonths
	,StartDateRaw
	,FN1
	,FN2
	,FN3
	,FN4
	,FN5 = CASE WHEN ProjectLengthMonths - (FN1+FN2+FN3+FN4) > 12 THEN 12 
		   ELSE ProjectLengthMonths - (FN1+FN2+FN3+FN4) END
	FROM cte4
)

,cte6 As (
	SELECT
	ProjectID
	,ProjectLengthMonths
	,StartDateRaw
	,FN1
	,FN2
	,FN3
	,FN4
	,FN5
	,FN6 = CASE WHEN ProjectLengthMonths - (FN1+FN2+FN3+FN4+FN5) > 12 THEN 12 
		   ELSE ProjectLengthMonths - (FN1+FN2+FN3+FN4+FN5) END
	FROM cte5
)

,cte7 AS (
	SELECT
	A.*
	,B.PY1Amt
	,B.PY2Amt
	,B.PY3Amt
	,B.PY4Amt
	,B.PY5Amt
	,B.PY6Amt
	FROM cte6 A
	LEFT JOIN vwProgramFinancialsByFiscaalYear B ON B.ProjectID = A.ProjectID
)

,f1 AS (

  SELECT *, PaidMonths1 = CASE WHEN PY1Amt != 0 THEN FY1Balance/(PY1Amt/12) ELSE 0 END
  FROM ( SELECT *, FY1Balance = PY1Amt-FY1Amt FROM ( SELECT *,FY1Amt = (PY1Amt/12)*FN1 FROM cte7  ) a ) a
)

,f2 AS (
   SELECT *,FY2Amt = FY1Balance + (PY2Amt/12)*(FN2-PaidMonths1) FROM f1 
)


,f3 AS (
 SELECT *,FY3Amt = (PY1Amt+PY2Amt) - (FY1Amt+FY2Amt)  FROM f2 
)

,f4 AS (
 SELECT *,FY4Amt = (PY1Amt+PY2Amt+PY3Amt) - (FY1Amt+FY2Amt+FY3Amt)  FROM f3 
)

,f5 AS (
 SELECT *,FY5Amt = (PY1Amt+PY2Amt+PY3Amt+PY4Amt) - (FY1Amt+FY2Amt+FY3Amt+FY4Amt)  FROM f4
)


,f6 AS (
 SELECT *,FY6Amt = (PY1Amt+PY2Amt+PY3Amt+PY4Amt+PY5Amt) - (FY1Amt+FY2Amt+FY3Amt+FY4Amt+FY5Amt)  FROM f5
)


SELECT 
ProjectID
,ProjectLengthMonths
,StartDateRaw
,FN1,FN2,FN3,FN4,FN5,FN6,PY1Amt,PY2Amt,PY3Amt,PY4Amt,PY5Amt
,FY1Amt,FY2Amt,FY3Amt,FY4Amt,FY5Amt,FY6Amt
,TotalPY = PY1Amt + PY2Amt + PY3Amt + PY4Amt + PY5Amt
,TotalFY = FY1Amt + FY2Amt + FY3Amt + FY4Amt + FY5Amt + FY6Amt
FROM f6
WHERE 1=1
--and ProjectID in (1,15)
and PY4Amt !=0