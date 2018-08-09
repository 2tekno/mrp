USE [MRPTEST]
GO

ALTER TABLE [dbo].[POrderItems] DROP CONSTRAINT [DF_POrderItems_CreateDate]
GO


DROP TABLE [dbo].[POrderItems]
GO


CREATE TABLE [dbo].[POrderItems](
	[POrderItemID] [int] IDENTITY(1,1) NOT NULL,
	[POrderID] [int] NULL,
	[ProductID] [int] NULL,
	[Qty] [decimal](18, 4) NULL,
	[Price] [money] NULL,
	[Created] [datetime] NULL,
	[ItemDescription] [nvarchar](500) NULL,
	[UomID] [int] NULL,
	[ItemNumber] [nvarchar](100) NULL,
	[TaxExemptCodes] [nvarchar](100) NULL,
 CONSTRAINT [PK_POrderItems] PRIMARY KEY CLUSTERED 
(
	[POrderItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[POrderItems] ADD  CONSTRAINT [DF_POrderItems_CreateDate]  DEFAULT (getdate()) FOR [Created]
GO


