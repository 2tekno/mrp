USE [MRPTEST]
GO

ALTER TABLE [dbo].[OrderItems] DROP CONSTRAINT [DF_OrderItems_Processed]
GO

ALTER TABLE [dbo].[OrderItems] DROP CONSTRAINT [DF_OrderItems_CreateDate]
GO

/****** Object:  Table [dbo].[OrderItems]    Script Date: 8/9/2018 1:06:31 PM ******/
DROP TABLE [dbo].[OrderItems]
GO


CREATE TABLE [dbo].[OrderItems](
	[OrderItemID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NULL,
	[ProductID] [int] NULL,
	[OrderItemNumber] [nvarchar](100) NULL,
	[Qty] [decimal](18, 4) NULL,
	[Price] [money] NULL,
	[Cost] [money] NULL,
	[Discount] [float] NULL,
	[Created] [datetime] NULL,
	[Processed] [bit] NULL,
	[DateProcessed] [datetime] NULL

 CONSTRAINT [PK_OrderItems] PRIMARY KEY CLUSTERED 
(
	[OrderItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[OrderItems] ADD  CONSTRAINT [DF_OrderItems_CreateDate]  DEFAULT (getdate()) FOR [Created]
GO

ALTER TABLE [dbo].[OrderItems] ADD  CONSTRAINT [DF_OrderItems_Processed]  DEFAULT ((0)) FOR [Processed]
GO


