	
alter view vwSubProjectBudget

AS
	
	
SELECT 
SubProjectID
,InstitutionID
,CoFunderID
,Managed
,TotalAmountAwarded = SUM(ISNULL(Year1Amt,0) + ISNULL(Year2Amt,0) + ISNULL(Year3Amt,0) + ISNULL(Year4Amt,0) + ISNULL(Year5Amt,0) + ISNULL(Year6Amt,0) + ISNULL(Year7Amt,0) + ISNULL(Year8Amt,0) + ISNULL(Year9Amt,0))
,TFRIAmount  = SUM(CASE WHEN ISNULL(Managed, '') = 'Yes' THEN
					ISNULL(Year1Amt,0) + ISNULL(Year2Amt,0) + ISNULL(Year3Amt,0) + ISNULL(Year4Amt,0) + ISNULL(Year5Amt,0) + ISNULL(Year6Amt,0) + ISNULL(Year7Amt,0) + ISNULL(Year8Amt,0) + ISNULL(Year9Amt,0)
					ELSE 0 END )
FROM SubProjectBudget
GROUP BY 
SubProjectID
,InstitutionID
,CoFunderID
,Managed