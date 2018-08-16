USE [MRPTEST]
GO

ALTER TABLE [dbo].[Products] DROP CONSTRAINT [DF_Products_CreateDate]
GO

DROP TABLE [dbo].[Products]
GO


CREATE TABLE [dbo].[Products](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductCategoryID] [int] NULL,
	[Description] [nvarchar](255) NULL,
	[SalesNotes] [nvarchar](255) NULL,
	[ItemNumber] [nvarchar](100) NULL,
	[BarCode] [nvarchar](100) NULL,
	[VIN] [nvarchar](100) NULL,
	[Price] [money] NULL,
	[Created] [datetime] NULL,
	[UomID] [int] NULL,
	[IsDeleted] [bit] NULL,
	[TemplateID] [int] NULL,
	[InventoryItem] [bit] NULL,
	[KitItem] [bit] NULL,
	[ISell] [bit] NULL,
	[IBuy] [bit] NULL,
	[IMake] [bit] NULL,
	[PurchaseNotes] [nvarchar](255) NULL,
	[PurchasePrice] [money] NULL,
	[MinQtyForOrder] [decimal](18, 4) NULL,
	[IsActive] [bit] NULL,
	[Cost] [money] NULL,
	[LaborCost] [money] NULL,
	[Margin] [decimal](12, 2) NULL,
	[PreferredVendorID] [int] NULL,
	[UsePrefferedVendor] [bit] NULL,
	[IsLockedTemplate] [bit] NULL,
	[LocationID] [int] NULL,
	[TaxSchemaID] [int] NULL,
	[LeadTime] [int] NULL,
	[SafetyStock] [decimal](18, 4) NULL,
	[BOMID] [int] NULL,
	[MinQty] [decimal](18, 4) NULL,
	[MaxQty] [decimal](18, 4) NULL,
	[IsSerializedItem] [bit] NULL,
	[IsFinishedProduct] [bit] NULL,
	[CFTemplateID] [int] NULL,
	[CustomFieldIDMember] [int] NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_CreateDate]  DEFAULT (getdate()) FOR [Created]
GO


