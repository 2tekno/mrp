create view vwProgramFilter

AS

SELECT ProgramID = 0, ProgramDescription = 'ALL'
UNION ALL
SELECT ProgramID,ProgramDescription 
FROM Program 
