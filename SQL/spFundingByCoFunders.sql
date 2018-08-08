IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.spFundingByCoFunders'))
   exec('CREATE PROCEDURE [dbo].[spFundingByCoFunders] AS BEGIN SET NOCOUNT ON; END')
GO


ALTER PROC spFundingByCoFunders

@startFiscalDate date,
@cofunder nvarchar(max) = NULL,
@projectProgram nvarchar(max) = NULL

AS

/*

exec spFundingByCoFunders '2016-04-01'
exec spFundingByCoFunders '2014-04-01'


  select sum(ApprovedBudget)  from vwFundingByCoFunders  
	WHERE ProjectLengthMonths > 0
	and CoFunder is not null

*/

declare @endFiscalDate date = DATEADD(YEAR,5,@startFiscalDate)
declare @xmlprojectProgram xml
declare @xmlcofunder xml


set @xmlprojectProgram = N'<root><r>' + replace(@projectProgram,',','</r><r>') + '</r></root>'
set @xmlcofunder = N'<root><r>' + replace(@cofunder,',','</r><r>') + '</r></root>'


IF OBJECT_ID('tempdb.dbo.#tmp', 'U') IS NOT NULL 
  DROP TABLE #tmp;


;WITH ctePrograms AS (
        select t.value('.','varchar(max)') as item
        from @xmlprojectProgram.nodes('//root/r') as a(t)
)

,cteCoFunder AS (
        select t.value('.','varchar(max)') as item
        from @xmlcofunder.nodes('//root/r') as a(t)
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
	,InstitutionName
	,CoFunder
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
	,FM1 = CAST(CAST(YEAR( DATEADD(day,-1,StartDateRaw) ) AS nvarchar(4)) + '/04/01' AS date) 
    from vwFundingByCoFunders  
	WHERE ProjectLengthMonths > 0
	AND (@projectProgram IS NULL OR ProgramDescription IN (SELECT item FROM ctePrograms))
	AND (@cofunder IS NULL OR CoFunderID IN (SELECT item FROM cteCoFunder))

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
FROM ( SELECT ROW_NUMBER() OVER (ORDER BY ProjectID) AS Row, * FROM cte0 ) a

DECLARE @minYear DATE

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

DECLARE @ProjectID int
DECLARE @FM1 date
--DECLARE @CoFund nvarchar(100)

DECLARE @Row int

DECLARE @fiscalRecords TABLE(
    ProjectID int,
    FY date NOT NULL,
	--CoFund nvarchar(100) ,
	Row int,
    Amount decimal(18,2) NULL
);


SET @rows = (SELECT MAX(Row) FROM #tmp)


--declare @m int, @k int

WHILE (@counter <= @rows)
BEGIN
    
	SELECT @months = ProjectLengthMonths, @FN1=FN1, @FN2=FN2, @FN3=FN3, @FN4=FN4, @FN5=FN5, @FN6=FN6
	,@PY1Amt=PY1Amt
	,@PY2Amt=PY2Amt
	,@PY3Amt=PY3Amt
	,@PY4Amt=PY4Amt
	,@PY5Amt=PY5Amt
	,@PY6Amt=PY6Amt
	,@ProjectID = ProjectID
	,@FM1 = FM1
	--,@CoFund = CoFunder
	,@Row = [Row]
	FROM #tmp WHERE Row = @counter
	
	-------------------------------------------------------------- FY1
	SET @famt = (@FN1 * @PY1Amt/12) 
	INSERT INTO @fiscalRecords(ProjectID, Amount, FY, [Row]) VALUES (@ProjectID, @famt, @FM1, @Row)
	UPDATE #tmp SET FY1 = @famt
	WHERE Row = @counter

	-------------------------------------------------------------- FY2
	SET @famt = (12-@FN1) * @PY1Amt/12 + ((@FN2-(12-@FN1)) * @PY2Amt/12)
	INSERT INTO @fiscalRecords(ProjectID, Amount, FY, [Row]) VALUES (@ProjectID, @famt,DATEADD(YEAR,1,@FM1), @Row)
	UPDATE #tmp SET FY2 = @famt
	WHERE Row = @counter

	-------------------------------------------------------------- FY3 
	SET @famt = ((12-@FN1) * @PY2Amt/12) + ((@FN3-(12-@FN1)) * @PY3Amt/12)
	INSERT INTO @fiscalRecords(ProjectID, Amount, FY, [Row]) VALUES (@ProjectID, @famt,DATEADD(YEAR,2,@FM1), @Row)
	UPDATE #tmp SET FY3 = @famt
	WHERE Row = @counter

	-------------------------------------------------------------- FY4
	SET @famt = ((12-@FN1) * @PY3Amt/12) + ((@FN4-(12-@FN1)) * @PY4Amt/12)
	INSERT INTO @fiscalRecords(ProjectID, Amount, FY, [Row]) VALUES (@ProjectID,@famt,DATEADD(YEAR,3,@FM1), @Row)
	UPDATE #tmp SET FY4 = @famt
	WHERE Row = @counter

	-------------------------------------------------------------- FY5
	SET @famt = ((12-@FN1) * @PY4Amt/12) + ((@FN5-(12-@FN1)) * @PY5Amt/12)
	INSERT INTO @fiscalRecords(ProjectID, Amount, FY, [Row]) VALUES (@ProjectID,@famt,DATEADD(YEAR,4,@FM1), @Row)
	UPDATE #tmp SET FY5 = @famt 
	WHERE Row = @counter

	-------------------------------------------------------------- FY6
	SET @famt = ((12-@FN1) * @PY5Amt/12) + ((@FN6-(12-@FN1)) * @PY6Amt/12)
	INSERT INTO @fiscalRecords(ProjectID, Amount, FY, [Row]) VALUES (@ProjectID, @famt,DATEADD(YEAR,5,@FM1), @Row)
	UPDATE #tmp SET FY6 = @Row
	WHERE Row = @counter

    SET @counter = @counter + 1
END




select A.* 
,TotalFY =  A.FY1 +  A.FY2 +  A.FY3 +  A.FY4 +  A.FY5 +  A.FY6
,B.FY
,B.Amount
from #tmp A
LEFT JOIN @fiscalRecords B ON B.ProjectID = A.ProjectID AND B.[Row] = A.[Row]
where 1=1
and B.FY between @startFiscalDate and @endFiscalDate
and B.Amount != 0
AND A.CoFunder IS NOT NULL
order by StartDateRaw

