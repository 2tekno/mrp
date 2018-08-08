IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.spFundingByProvinceFY'))
   exec('CREATE PROCEDURE [dbo].[spFundingByProvinceFY] AS BEGIN SET NOCOUNT ON; END')
GO

ALTER PROC spFundingByProvinceFY

@startFiscalDate date,
--@projectTitle nvarchar(1000) = NULL,
@projectProgram nvarchar(1000) = NULL,
@projectStatus nvarchar(1000) = NULL

AS

/*

exec spFundingByProvinceFY '2011/04/01'
exec spFundingByProvinceFY '2012/04/01'
exec spFundingByProvinceFY '2013/04/01'


exec spFundingByProvinceFY 'research'

exec spFundingByProvinceFY NULL, 'PPG,Translational', 'Active'
 

*/

declare @yf int = 5

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

,cteBudget AS (

	SELECT 
	 SP.ProjectID
	,SP.SubProjectID
	,SP.SubProjectName
	,SP.SubProjectDescription

	,ApprovedBudget = ISNULL(Year1Amt,0) + ISNULL(Year2Amt,0) + ISNULL(Year3Amt,0) + ISNULL(Year4Amt,0) + ISNULL(Year5Amt,0) + ISNULL(Year6Amt,0) + ISNULL(Year7Amt,0) + ISNULL(Year8Amt,0) + ISNULL(Year9Amt,0)
	,TFRIAmount  = CASE WHEN ISNULL(Managed, '') = 'Yes' THEN
						ISNULL(Year1Amt,0) + ISNULL(Year2Amt,0) + ISNULL(Year3Amt,0) + ISNULL(Year4Amt,0) + ISNULL(Year5Amt,0) + ISNULL(Year6Amt,0) + ISNULL(Year7Amt,0) + ISNULL(Year8Amt,0) + ISNULL(Year9Amt,0)
						ELSE 0 END 

	,InstitutionName = B.InstitutionName
	,CoFunderName = C.InstitutionName
	,PIName = ISNULL(D.FName, '') + ' ' + ISNULL(D.LName, '')
	,InstitutionProvince	= B.Province
	,CoFunderProvince		= C.Province
	,PY1Amt = A.Year1Amt
	,PY2Amt = A.Year2Amt
	,PY3Amt = A.Year3Amt
	,PY4Amt = A.Year4Amt
	,PY5Amt = A.Year5Amt
	,PY6Amt = A.Year6Amt
	,PY7Amt = A.Year7Amt
	,PY8Amt = A.Year8Amt
	,PY9Amt = A.Year9Amt
	FROM SubProjectBudget A
	JOIN SubProject SP ON SP.SubProjectID = A.SubProjectID
	LEFT JOIN Institution B ON B.InstitutionID = A.InstitutionID
	LEFT JOIN Institution C ON C.InstitutionID = A.CoFunderID
	LEFT JOIN Contact D ON D.ContactID = A.PIID

	WHERE ISNULL(SP.IsDeleted, 0) != 1
)

,final AS (
	SELECT
	 a.ProjectID
	,ProjectNumber = REPLACE(REPLACE(a.ProjectNumber, CHAR(13), ''), CHAR(10), '')
	,a.ProjectShortName
	,ProjectTitle = REPLACE(REPLACE(a.ProjectTitle, CHAR(13), ''), CHAR(10), '')
	,b.SubProjectID
	,SubProjectName = REPLACE(REPLACE(b.[SubProjectName], CHAR(13), ''), CHAR(10), '')
	,b.[SubProjectDescription]
	,TFRIAmount			= ISNULL(b.TFRIAmount, 0)
	,ApprovedBudget = ISNULL(b.ApprovedBudget, 0)
	,StartDate	= CASE WHEN YEAR(a.StartDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20),a.StartDate, 107) END
	,EndDate	= CASE WHEN YEAR(a.StartDate) = 1900 THEN NULL ELSE CONVERT(VARCHAR(20), DATEADD(dd,-1,DATEADD(mm,ISNULL(a.LengthOfProjectYears*12 + a.LengthOfProjectMonths,0),a.StartDate)), 107) END

	,b.InstitutionName
	,b.CoFunderName
	,b.PIName
	,b.InstitutionProvince
	,b.CoFunderProvince
	,ProjectStatusDescription = ISNULL(e.[ProjectStatusDescription], '')
	,d.[ProgramDescription]
	,StartDateRaw = a.StartDate
	,b.PY1Amt
	,b.PY2Amt
	,b.PY3Amt
	,b.PY4Amt
	,b.PY5Amt
	,b.PY6Amt
	,b.PY7Amt
	,b.PY8Amt
	,b.PY9Amt
	,ProjectLengthMonths = ISNULL(a.LengthOfProjectYears, 0)*12 + ISNULL(a.LengthOfProjectMonths, 0)
	FROM Project a
	LEFT JOIN cteBudget		b ON b.ProjectID = a.ProjectID
	LEFT JOIN Program		d ON d.[ProgramID] = a.[ProgramID]
	LEFT JOIN ProjectStatus	e ON e.[ProjectStatusID] = a.[ProjectStatusID]
	WHERE ISNULL(a.IsDeleted, 0) != 1
)

, cte0 AS (
	SELECT 
	 ProjectID
	,ProjectShortName
	,ProjectNumber
	,ProjectTitle	
	,SubProjectID
	,SubProjectName
	,ProgramDescription
	,ProjectStatusDescription
	,InstitutionName
	,CoFunderName
	,PIName
	,InstitutionProvince
	,CoFunderProvince
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
	,FM1 = CAST(CAST(YEAR(StartDateRaw) AS nvarchar(4)) + '/04/01' AS date) 
	FROM final  
	WHERE ProjectLengthMonths > 0
	--AND CAST(CAST(YEAR(StartDateRaw) AS nvarchar(4)) + '/04/01' AS date) >= @startFiscalDate

	AND CAST(CAST(YEAR(StartDateRaw) AS nvarchar(4)) + '/04/01' AS date) between @startFiscalDate and dateadd(YY,@yf,@startFiscalDate)

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
--where ProjectNumber = '1018'
order by
ProjectID
,SubProjectID

