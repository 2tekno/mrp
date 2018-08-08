IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.spProgramFinancialsByFiscalYear'))
   exec('CREATE PROCEDURE [dbo].[spProgramFinancialsByFiscalYear] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROC spProgramFinancialsByFiscalYear

@startFiscalDate date,
@projectProgram nvarchar(1000) = NULL,
@projectStatus nvarchar(1000) = NULL

AS

/*

exec spProgramFinancialsByFiscalYear '2011-04-01'
exec spProgramFinancialsByFiscalYear '2012-04-01'
exec spProgramFinancialsByFiscalYear '2013-04-01'


exec spProgramFinancialsByFiscalYear '2014/04/01' ,'Translational'

exec spProgramFinancialsByFiscalYear 'research'

exec spProgramFinancialsByFiscalYear NULL, 'PPG,Translational', 'Active'


select * from vwProgramFinancialsByProjectYear  


select * from vwProgramFinancialsByProjectYear  --vwProject
--where ProjectNumber in ('2009-15','2009-17')
order by StartDate

*/


declare @xmlprojectProgram xml
declare @xmlprojectStatus xml

set @xmlprojectProgram = N'<root><r>' + replace(@projectProgram,',','</r><r>') + '</r></root>'
set @xmlprojectStatus = N'<root><r>' + replace(@projectStatus,',','</r><r>') + '</r></root>'

IF OBJECT_ID('tempdb.dbo.#tmp', 'U') IS NOT NULL 
  DROP TABLE #tmp;


;WITH ctePrograms AS (
        select t.value('.','varchar(max)') as item
        from @xmlprojectProgram.nodes('//root/r') as a(t)
)

,cteStatus AS (
        select t.value('.','varchar(max)') as item
        from @xmlprojectStatus.nodes('//root/r') as a(t)
)
, cte0 AS (
	SELECT 
	 ProjectID
	,ProjectShortName
	,ProjectNumber
	,ProjectTitle	
	,ProgramDescription
	,ProjectStatusDescription
	,ApprovedBudget
	,ProjectLengthMonths
	,PY1Amt
	,PY2Amt
	,PY3Amt
	,PY4Amt
	,PY5Amt
	,PY6Amt
	,StartDate
	,EndDate
	,StartDateRaw = CAST(StartDateRaw As date)
	,EndDateRaw = CAST(EndDateRaw As date)
	,FM1 = CAST(CAST(YEAR(StartDateRaw) AS nvarchar(4)) + '/04/01' AS date) 
	FROM vwProgramFinancialsByProjectYear  
	WHERE ProjectLengthMonths > 0
	
	--AND CAST(CAST(YEAR(StartDateRaw) AS nvarchar(4)) + '/04/01' AS date) >= @startFiscalDate

	AND @startFiscalDate BETWEEN CAST(CAST(YEAR(StartDateRaw) AS nvarchar(4)) + '/04/01' AS date) AND CAST(EndDateRaw AS date)


	AND (@projectProgram IS NULL OR ProgramDescription IN (SELECT item FROM ctePrograms))
	AND (@projectStatus IS NULL OR ProjectStatusDescription IN (SELECT item FROM cteStatus))
)
  
SELECT 
*
,FN1 = cast(00 as int)  
,FN2 = cast(00 as int)  
,FN3 = cast(00 as int)  
,FN4 = cast(00 as int)  
,FN5 = cast(00 as int)  
,FN6 = cast(00 as int)  

,FY1 = cast(0.00 as decimal(18,2))  
,FY2 = cast(0.00 as decimal(18,2))
,FY3 = cast(0.00 as decimal(18,2))
,FY4 = cast(0.00 as decimal(18,2))
,FY5 = cast(0.00 as decimal(18,2))
,FY6 = cast(0.00 as decimal(18,2))
into #tmp
FROM ( SELECT ROW_NUMBER() OVER (ORDER BY ProjectID) AS Row, *
	   FROM cte0
    	--WHERE ProjectID IN (36,1,53) 
	 ) a


UPDATE #tmp
SET FN1 =  CASE WHEN (
	        CASE WHEN (12 - DATEDIFF(MONTH, FM1, StartDateRaw)) > 12 THEN (12 - DATEDIFF(MONTH, FM1, StartDateRaw)) - 12 
			ELSE 12 - DATEDIFF(MONTH, FM1, StartDateRaw) END) > ProjectLengthMonths THEN ProjectLengthMonths
			ELSE 
			CASE WHEN (12 - DATEDIFF(MONTH, FM1, StartDateRaw)) > 12 THEN (12 - DATEDIFF(MONTH, FM1, StartDateRaw)) - 12 
			ELSE 12 - DATEDIFF(MONTH, FM1, StartDateRaw) END END


UPDATE #tmp SET FN2 = CASE WHEN ProjectLengthMonths - FN1 > 12 THEN 12 ELSE ProjectLengthMonths - FN1 END
UPDATE #tmp SET FN3 = CASE WHEN ProjectLengthMonths - (FN1+FN2) > 12 THEN 12 ELSE ProjectLengthMonths - (FN1+FN2) END
UPDATE #tmp SET FN4 = CASE WHEN ProjectLengthMonths - (FN1+FN2+FN3) > 12 THEN 12 ELSE ProjectLengthMonths - (FN1+FN2+FN3) END
UPDATE #tmp SET FN5 = CASE WHEN ProjectLengthMonths - (FN1+FN2+FN3+FN4) > 12 THEN 12 ELSE ProjectLengthMonths - (FN1+FN2+FN3+FN4) END
UPDATE #tmp SET FN6 = CASE WHEN ProjectLengthMonths - (FN1+FN2+FN3+FN4+FN5) > 12 THEN 12 ELSE ProjectLengthMonths - (FN1+FN2+FN3+FN4+FN5) END


DECLARE @rows int
DECLARE @counter int = 1
DECLARE @months int, @FN1 int, @FN2 int, @FN3 int, @FN4 int, @FN5 int, @FN6 int
SET @rows = (SELECT MAX(Row) FROM #tmp)

declare @m int, @k int

WHILE (@counter <= @rows)
BEGIN
    
	SELECT @months = ProjectLengthMonths, @FN1=FN1, @FN2=FN2, @FN3=FN3, @FN4=FN4, @FN5=FN5, @FN6=FN6
	FROM #tmp WHERE Row = @counter
	
	UPDATE #tmp
	SET FY1 = (FN1 * PY1Amt/12 )
	WHERE Row = @counter
	SET @months = @months - @FN1

	IF @months >= 12 
	BEGIN
	   SET @m = @FN2-@FN1
	   SET @k = @FN1
	END
	IF @months < 12 
	BEGIN
	   SET @m = @FN2
	   SET @k = 0
	END
	
	UPDATE #tmp
	SET FY2 = (@m * PY1Amt/12 ) + (@k * PY2Amt/12)
	WHERE Row = @counter
	SET @months = @months - @FN2

	IF @months >= 12 
	BEGIN
	   SET @m = @FN3-@FN1
	   SET @k = @FN1
	END
	IF @months < 12 
	BEGIN
	   SET @m = @FN3
	   SET @k = 0
	END
	
	UPDATE #tmp
	SET FY3 = (@m * PY2Amt/12 ) + (@k * PY3Amt/12)
	WHERE Row = @counter
	SET @months = @months - @FN3

	IF @months >= 12 
	BEGIN
	   SET @m = @FN4-@FN1
	   SET @k = @FN1
	END
	IF @months < 12 
	BEGIN
	   SET @m = @FN4
	   SET @k = 0
	END
	
	IF @FN4 !=0
	BEGIN
		UPDATE #tmp
		SET FY4 = (@m * PY3Amt/12 ) + (@k * PY4Amt/12)
		WHERE Row = @counter
	END
	SET @months = @months - @FN4


	IF @months >= 12 
	BEGIN
	   SET @m = @FN5-@FN1
	   SET @k = @FN1
	END
	IF @months < 12 
	BEGIN
	   SET @m = @FN5
	   SET @k = 0
	END
	
	UPDATE #tmp
	SET FY5 = (@m * PY4Amt/12 ) + (@k * PY5Amt/12)
	WHERE Row = @counter
	SET @months = @months - @FN5


	IF @FN6 !=0
	BEGIN
		UPDATE #tmp
		SET FY6 = (PY1Amt + PY2Amt + PY3Amt + PY4Amt + PY5Amt) - (FY1 + FY2 + FY3 + FY4 + FY5)
		WHERE Row = @counter
	END

    SET @counter = @counter + 1
END


UPDATE #tmp
SET 
 FY6=FY5
,FY5=FY4
,Fy4=FY3
,FY3=FY2
,FY2=FY1
,FY1=0
WHERE datediff(YY,@startFiscalDate,DATEADD(d,1,FM1)) = 2

UPDATE #tmp
SET 
 FY6=FY4
,FY5=FY3
,Fy4=FY2
,FY3=FY1
,FY2=0
,FY1=0
WHERE datediff(YY,@startFiscalDate,DATEADD(d,1,FM1)) = 3


UPDATE #tmp
SET 
 FY6=FY3
,FY5=FY2
,Fy4=FY1
,FY3=0
,FY2=0
,FY1=0
WHERE datediff(YY,@startFiscalDate,DATEADD(d,1,FM1)) = 4

UPDATE #tmp
SET 
 FY6=FY2
,FY5=FY1
,Fy4=0
,FY3=0
,FY2=0
,FY1=0
WHERE datediff(YY,@startFiscalDate,DATEADD(d,1,FM1)) = 5

UPDATE #tmp
SET 
 FY6=FY1
,FY5=0
,Fy4=0
,FY3=0
,FY2=0
,FY1=0
WHERE datediff(YY,@startFiscalDate,DATEADD(d,1,FM1)) = 6


select * 
,TotalFY = FY1 + FY2 + FY3 + FY4 + FY5 + FY6
from #tmp
WHERE 1=1

order by StartDate