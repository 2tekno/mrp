USE [MRPTEST]
GO

DROP VIEW [dbo].[vwPOrderItems]
GO

/*

select * from [vwPOrderList]
-- where id = 24
order by OrderNo desc

*/



CREATE view [dbo].[vwPOrderItems] as 

SELECT 
 A.POrderItemID
,A.POrderID
,A.Qty
,A.Price
,B.Description
,B.ItemNumber
FROM  POrderItems A 
JOIN Products B ON B.ProductID = A.ProductID





GO


