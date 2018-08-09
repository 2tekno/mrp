USE [MRPTEST]
GO

DROP VIEW [dbo].[vwPOrderList]
GO

/*

select * from [vwPOrderList]
-- where id = 24
order by OrderNo desc

*/



CREATE view [dbo].[vwPOrderList] as 

select 
 a.Id
,a.OrderNo
,a.OrderDate
,a.DeliveryDate
,a.Total
,a.IsConfirmed
,b.Name
,b.Id as CustomerId
,c.Description as OrderStatus
,d.Phone
,d.HomePhone
,d.CellPhone 

,UserName = ISNULL(Users.Description, '')
,OrderStatusColor=c.Color
from POrders a 
left join Customers b on b.Id = a.CustomerId
left join OrderStatus c on a.StatusId=c.Id 
left join Contacts d on d.CustomerId=c.Id 

LEFT JOIN dbo.Users Users ON Users.Id = a.UserId





GO


