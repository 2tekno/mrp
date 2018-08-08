
DECLARE @currentDate NVARCHAR(200)

SET @currentDate = 'C:\SQLData\Backup\TFRI_' + replace(convert(varchar, getdate(), 111), '/', '_') + '.bak'

--SELECT @currentDate

BACKUP DATABASE [TFRI] 
	TO  DISK = @currentDate WITH NOFORMAT, NOINIT,  
	NAME = N'TFRI Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  
	STATS = 10
GO


