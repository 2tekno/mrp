USE [MRPTEST]
GO


DROP TABLE [dbo].[Vendors]
GO

CREATE TABLE [dbo].[Vendors](
	[VendorID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NULL,
	[Description] [nvarchar](255) NULL,
	[ContactName] [nvarchar](100) NULL,
	[Created] [datetime] NULL,
	[TermID] [int] NULL,
	[IsDeleted] [bit] NULL,
	[CategoryID] [int] NULL,
	[TaxingSchemaID] [int] NULL,
	[CurrencyID] [int] NULL
) ON [PRIMARY]
GO


