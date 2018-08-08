CREATE TABLE [dbo].[ProjectPartner](
	[ProjectPartnerID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectID] [int] NOT NULL,
	[InstitutionID] [int] NOT NULL,
	Amount decimal(18,2) NULL,
	[Created] [datetime] NULL,
	[Updated] [datetime] NULL
)