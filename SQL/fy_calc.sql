IF OBJECT_ID('tempdb.dbo.#tmp', 'U') IS NOT NULL 
  DROP TABLE #tmp;


SELECT 
*
,FY1 = cast(((PY1Amt/12)*FN1) as decimal(18,2))
,FY2 = cast(0.00 as decimal(18,2))
,FY3 = cast(0.00 as decimal(18,2))
,FY4 = cast(0.00 as decimal(18,2))
,FY5 = cast(0.00 as decimal(18,2))
,FY6 = cast(0.00 as decimal(18,2))
into #tmp
FROM vwFY


UPDATE #tmp
SET FY2 = (12 - (PY1Amt - (PY1Amt/12) * FN1) /(PY1Amt/12)) * (PY2Amt/12) +  (PY1Amt - FY1) 
WHERE PY1Amt !=0


UPDATE #tmp
SET FY3 = (PY1Amt+PY2Amt) - (FY1+FY2)
WHERE FN3 !=12

UPDATE #tmp
SET FY3 = (12 - (PY2Amt - (PY2Amt/12) * FN2) /(PY2Amt/12)) * (PY3Amt/12) +  (PY2Amt - FY2) 
WHERE PY2Amt !=0
AND FN3 =12 


UPDATE #tmp
SET FY4 = (PY1Amt+PY2Amt+PY3Amt) - (FY1+FY2+FY3)
WHERE FN4 !=12

UPDATE #tmp
SET FY4 = (12 - (PY3Amt - (PY3Amt/12) * FN3) /(PY3Amt/12)) * (PY4Amt/12) +  (PY3Amt - FY3) 
WHERE PY3Amt !=0
AND FN4 =12 

UPDATE #tmp
SET FY5 = (PY1Amt+PY2Amt+PY3Amt+PY4Amt) - (FY1+FY2+FY3+FY4)
WHERE FN5 !=12

UPDATE #tmp
SET FY5 = (12 - (PY4Amt - (PY4Amt/12) * FN4) /(PY4Amt/12)) * (PY4Amt/12) +  (PY4Amt - FY4) 
WHERE PY4Amt !=0
AND FN5 =12           


UPDATE #tmp
SET FY6 = (PY1Amt+PY2Amt+PY3Amt+PY4Amt+PY5Amt) - (FY1+FY2+FY3+FY4+FY5)
WHERE FN6 !=12

UPDATE #tmp
SET FY6 = (12 - (PY5Amt - (PY5Amt/12) * FN5) /(PY5Amt/12)) * (PY5Amt/12) +  (PY5Amt - FY5) 
WHERE PY5Amt !=0
AND FN6 =12 


select * 
,TotalPY = PY1Amt + PY2Amt + PY3Amt + PY4Amt + PY5Amt
,TotalFY = FY1 + FY2 + FY3 + FY4 + FY5 + FY6
from #tmp

