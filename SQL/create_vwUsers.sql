DROP VIEW [dbo].[vwUsers]
GO


CREATE view [dbo].[vwUsers]

AS

/*

select * from vwUsers



*/


SELECT 
*
,InactiveStr = CASE WHEN ISNULL(Inactive, 0) = 0 THEN 'No'
					WHEN ISNULL(Inactive, 0) = 1 THEN 'Yes' END
,IsAdminStr = CASE WHEN ISNULL(IsAdmin, 0) = 0 THEN 'No'
					WHEN ISNULL(IsAdmin, 0) = 1 THEN 'Yes' END
,FullName = ISNULL(FName, '') + ' ' + ISNULL(LName, '')
FROM Users





