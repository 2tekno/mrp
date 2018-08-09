USE [MRPTEST]
GO

ALTER TABLE [dbo].[Orders] DROP CONSTRAINT [DF_Order_CreateDate]
GO

DROP TABLE [dbo].[Orders]
GO

CREATE TABLE [dbo].[Orders](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[OrderNo] [int] NULL,
	[OrderDate] [datetime] NULL,
	[CustomerID] [int] NULL,
	[CustomerPO] [nvarchar](50) NULL,
	[ShipDate] [datetime] NULL,
	[StatusID] [int] NULL,
	[SalesPersonID] [int] NULL,
	[ShipMethodID] [int] NULL,
	[Note] [nvarchar](1000) NULL,
	[Created] [datetime] NULL,
	[TermID] [int] NULL,
	[UserID] [int] NULL,
	[CompanyID] [int] NULL,
	[CurrencyID] [int] NULL,
	[Subtotal] [money] NULL,
	[Discount] [decimal](12, 2) NULL,
	[DiscountAmount] [money] NULL,
	[Total] [money] NULL,
	[IsConfirmed] [bit] NULL,
	[Canceled] [bit] NULL,
	[RevisedBy] [int] NULL,
	[UpdatedBy] [int] NULL
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Order_CreateDate]  DEFAULT (getdate()) FOR [Created]
GO


