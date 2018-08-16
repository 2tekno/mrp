USE [MRPTEST]
GO


DROP VIEW [dbo].[vwProducts]
GO

CREATE view [dbo].[vwProducts] 

AS


/*

SELECT Id,Description FROM Products W

*/


WITH cteTMP1 AS (
	SELECT *
	FROM Products
)


SELECT 
*
FROM cteTmp1
