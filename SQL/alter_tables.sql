ALTER TABLE [dbo].[Institution] ADD [MOUStartDate] [datetime] NULL;
ALTER TABLE [dbo].[Institution] ADD [MOUEndDate] [datetime] NULL;
ALTER TABLE [dbo].[Institution] ADD [MOUExtendedOnDate] [datetime] NULL;

ALTER TABLE [dbo].[SubProjectBudget] ADD [FinancialOfficerID] INT NULL;

ALTER TABLE [dbo].[Project] ADD LastMetricsReportReceived [datetime] NULL;

ALTER TABLE [dbo].[Users] ADD UserName nvarchar(20) NULL;
ALTER TABLE [dbo].[Users] ADD IsAdmin bit NULL;
ALTER TABLE [dbo].[Users] ADD ChangePasswordWhenLogin bit NULL;

ALTER TABLE [dbo].[ContactEmail] ADD [Primary] bit NULL;  
ALTER TABLE [dbo].[ContactPhone] ADD [Primary] bit NULL;  
ALTER TABLE [dbo].[ContactInstitution] ADD [Primary] bit NULL;  

UPDATE ContactPhone
SET [Primary] = 0

UPDATE ContactEmail
SET [Primary] = 0

UPDATE [ContactInstitution]
SET [Primary] = 0


UPDATE [dbo].[Contact]
SET Inactive = 0
WHERE Inactive IS NULL
