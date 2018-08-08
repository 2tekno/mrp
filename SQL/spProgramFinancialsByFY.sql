IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.spProgramFinancialsByFY'))
   exec('CREATE PROCEDURE [dbo].[spProgramFinancialsByFY] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROC spProgramFinancialsByFY

--@startFiscalDate date,
@projectProgram nvarchar(1000) = NULL,
@projectStatus nvarchar(1000) = NULL

AS

/*

exec spProgramFinancialsByFY '2012-04-01'

exec spProgramFinancialsByFY 'Translational'




select * from vwProgramFinancialsByProjectYear  
where ProjectNumber in ('2010-30')
where ProjectLengthMonths > 0
order by StartDate

*/

--declare @endFiscalDate date = DATEADD(y,1,@startFiscalDate)
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
	,StartDateRaw = CAST(StartDateD As date)
	,EndDateRaw = CAST(EndDateD As date)
	,FM1 = CAST(CAST(YEAR(StartDateRaw) AS nvarchar(4)) + '/04/01' AS date) 
	FROM vwProgramFinancialsByProjectYear  
	WHERE ProjectLengthMonths > 0
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
,F0 = cast(0.00 as decimal(18,2))  
,F1 = cast(0.00 as decimal(18,2))  
,F2 = cast(0.00 as decimal(18,2))
,F3 = cast(0.00 as decimal(18,2))
,F4 = cast(0.00 as decimal(18,2))
,F5 = cast(0.00 as decimal(18,2))
,F6 = cast(0.00 as decimal(18,2))
,F7 = cast(0.00 as decimal(18,2))  
,F8 = cast(0.00 as decimal(18,2))
,F9 = cast(0.00 as decimal(18,2))
,F10 = cast(0.00 as decimal(18,2))

into #tmp
FROM ( SELECT ROW_NUMBER() OVER (ORDER BY ProjectID) AS Row, * FROM cte0 ) a

DECLARE @minYear DATE
--SET @minYear = (SELECT MIN(FM1) FROM #tmp)

SET @minYear = (
	SELECT MIN(CAST(StartDateRaw As date))
	FROM vwProgramFinancialsByProjectYear  
	WHERE ProjectLengthMonths > 0)

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

DECLARE @balance decimal(18,2)
DECLARE @PY1Amt decimal(18,2)
DECLARE @PY2Amt decimal(18,2)
DECLARE @PY3Amt decimal(18,2)
DECLARE @PY4Amt decimal(18,2)
DECLARE @PY5Amt decimal(18,2)
DECLARE @PY6Amt decimal(18,2)

DECLARE @famt decimal(18,2)

SET @rows = (SELECT MAX(Row) FROM #tmp)

declare @m int, @k int

WHILE (@counter <= @rows)
BEGIN
    
	SELECT @months = ProjectLengthMonths, @FN1=FN1, @FN2=FN2, @FN3=FN3, @FN4=FN4, @FN5=FN5, @FN6=FN6, @balance = ApprovedBudget
	,@PY1Amt=PY1Amt
	,@PY2Amt=PY2Amt
	,@PY3Amt=PY3Amt
	,@PY4Amt=PY4Amt
	,@PY5Amt=PY5Amt
	,@PY6Amt=PY6Amt
	FROM #tmp WHERE Row = @counter
	
	--------------------------------------------------------------
	SET @famt = (@FN1 * @PY1Amt/12) 
	UPDATE #tmp SET FY1 = @famt
	WHERE Row = @counter
	SET @months = @months - @FN1
	SET @balance = @balance - @famt

	IF @months >= 12 
	BEGIN
	   SET @m = @FN2-@FN1
	   SET @k = @FN2
	END
	IF @months < 12 
	BEGIN
	   SET @m = @FN2
	   SET @k = 0
	END
	--------------------------------------------------------------
	SET @famt = (@m * @PY1Amt/12) + (@k * @PY2Amt/12)
	UPDATE #tmp SET FY2 = CASE WHEN @famt >=@balance THEN @balance ELSE @famt END
	WHERE Row = @counter
	SET @months = @months - @FN2
	SET @balance = @balance - CASE WHEN @famt >=@balance THEN @balance ELSE @famt END

	IF @months >= 12 
	BEGIN
	   SET @m = @FN3-@FN2
	   SET @k = @FN3
	END
	IF @months < 12 
	BEGIN
	   SET @m = @FN3
	   SET @k = 0
	END
	--------------------------------------------------------------
	SET @famt = (@m * @PY2Amt/12) + (@k * @PY3Amt/12)
	UPDATE #tmp SET FY3 = CASE WHEN @famt >=@balance THEN @balance ELSE @famt END
	WHERE Row = @counter
	SET @months = @months - @FN3
	SET @balance = @balance - CASE WHEN @famt >=@balance THEN @balance ELSE @famt END

	IF @months >= 12 
	BEGIN
	   SET @m = @FN4-@FN3
	   SET @k = @FN4
	END
	IF @months < 12 
	BEGIN
	   SET @m = @FN4
	   SET @k = 0
	END
	--------------------------------------------------------------
	SET @famt = (@m * @PY3Amt/12) + (@k * @PY4Amt/12)
	UPDATE #tmp SET FY4 = CASE WHEN @famt >=@balance THEN @balance ELSE @famt END
	WHERE Row = @counter
	SET @months = @months - @FN4
	SET @balance = @balance - CASE WHEN @famt >=@balance THEN @balance ELSE @famt END

	IF @months >= 12 
	BEGIN
	   SET @m = @FN5-@FN4
	   SET @k = @FN5
	END
	IF @months < 12 
	BEGIN
	   SET @m = @FN5
	   SET @k = 0
	END
	--------------------------------------------------------------
	SET @famt = (@m * @PY4Amt/12) + (@k * @PY5Amt/12)
	UPDATE #tmp SET FY5 = CASE WHEN @famt >=@balance THEN @balance ELSE @famt END
	WHERE Row = @counter
	SET @months = @months - @FN5
	SET @balance = @balance - CASE WHEN @famt >=@balance THEN @balance ELSE @famt END

	IF @months >= 12 
	BEGIN
	   SET @m = @FN6-@FN5
	   SET @k = @FN6
	END
	IF @months < 12 
	BEGIN
	   SET @m = @FN6
	   SET @k = 0
	END

	--------------------------------------------------------------
	SET @famt = (@m * @PY5Amt/12) + (@k * @PY6Amt/12)
	UPDATE #tmp SET FY6 = CASE WHEN @famt >=@balance THEN @balance ELSE @famt END
	WHERE Row = @counter
	SET @balance = @balance - CASE WHEN @famt >=@balance THEN @balance ELSE @famt END

    SET @counter = @counter + 1
END




UPDATE #tmp
SET 
 F0=FY1
,F1=FY2
,F2=FY3
,F3=FY4
,F4=FY5
,F5=FY6
WHERE datediff(YY,@minYear, FM1) = 0

UPDATE #tmp
SET 
 F1=FY1
,F2=FY2
,F3=FY3
,F4=FY4
,F5=FY5
,F6=FY6
WHERE datediff(YY,@minYear, FM1) = 1

UPDATE #tmp
SET 
 F2=FY1
,F3=FY2
,F4=FY3
,F5=FY4
,F6=FY5
,F7=FY6
WHERE datediff(YY,@minYear, FM1) = 2

UPDATE #tmp
SET 
 F3=FY1
,F4=FY2
,F5=FY3
,F6=FY4
,F7=FY5
,F8=FY6
WHERE datediff(YY,@minYear, FM1) = 3

UPDATE #tmp
SET 
 F4=FY1
,F5=FY2
,F6=FY3
,F7=FY4
,F8=FY5
,F9=FY6
WHERE datediff(YY,@minYear, FM1) = 4

UPDATE #tmp
SET 
 F5=FY1
,F6=FY2
,F7=FY3
,F8=FY4
,F9=FY5
,F10=FY6
WHERE datediff(YY,@minYear, FM1) = 5

UPDATE #tmp
SET 
 F6=FY1
,F7=FY2
,F8=FY3
,F9=FY4
,F10=FY5
WHERE datediff(YY,@minYear, FM1) = 6

UPDATE #tmp
SET 
 F7=FY1
,F8=FY2
,F9=FY3
,F10=FY4
--,F10=FY5
WHERE datediff(YY,@minYear, FM1) = 7

select * 
--,TotalFY = F1 + F2 + F3 + F4 + F5 + F6 + F7 + F8 + F9 + F10
,TotalFY = FY1 + FY2 + FY3 + FY4 + FY5 + FY6
,MustTotalFY = ApprovedBudget
,Z = CASE WHEN ApprovedBudget != FY1 + FY2 + FY3 + FY4 + FY5 + FY6 THEN '*' ELSE NULL END
from #tmp
where 1=1
--and FM1 between @startFiscalDate and @endFiscalDate
--and ProjectID=53
--and ApprovedBudget != FY1 + FY2 + FY3 + FY4 + FY5 + FY6
order by StartDateRaw