
WITH f1 AS (

  SELECT *, PaidMonths1 = CASE WHEN PY1Amt != 0 THEN FY1Balance/(PY1Amt/12) ELSE 0 END
  FROM ( SELECT *, FY1Balance = PY1Amt-FY1Amt FROM ( SELECT *,FY1Amt = ((PY1Amt/12)*FN1)
  FROM vwFY  ) a ) a
)



,f2 AS ( SELECT *,FY2Amt = FY1Balance + (PY2Amt/12)*(FN2-PaidMonths1) FROM f1 )



,f3 AS ( 
  SELECT *,
  FY3Amt = CASE WHEN FN3=12
           THEN (PY1Amt+PY2Amt+PY3Amt) - (FY1Amt+FY2Amt) 
           ELSE (PY1Amt+PY2Amt) - (FY1Amt+FY2Amt) END   FROM f2 
)


,f4 AS (
 SELECT *,
 FY4Amt = CASE WHEN FN4=12
          THEN (PY1Amt+PY2Amt+PY3Amt+PY4Amt) - (FY1Amt+FY2Amt+FY3Amt) 
          ELSE (PY1Amt+PY2Amt+PY3Amt) - (FY1Amt+FY2Amt+FY3Amt) END   FROM f3 
)


select * from f4



,f5 AS (
 SELECT *,
 FY5Amt = CASE WHEN FN5=12
          THEN (PY1Amt+PY2Amt+PY3Amt+PY4Amt+PY5Amt) - (FY1Amt+FY2Amt+FY3Amt+FY4Amt) 
          ELSE (PY1Amt+PY2Amt+PY3Amt+PY4Amt) - (FY1Amt+FY2Amt+FY3Amt+FY4Amt) END   FROM f4 
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
and ProjectID in (10)
