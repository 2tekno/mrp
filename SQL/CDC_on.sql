--EXEC sp_changedbowner 'sa'

ALTER TABLE [dbo].[Contact] ADD CONSTRAINT [PK_ContactID] PRIMARY KEY  CLUSTERED (ContactID)  ON [PRIMARY] 
ALTER TABLE [dbo].[Institution] ADD CONSTRAINT [PK_InstitutionID] PRIMARY KEY  CLUSTERED (InstitutionID)  ON [PRIMARY] 
ALTER TABLE [dbo].[Project] ADD CONSTRAINT [PK_ProjectID] PRIMARY KEY  CLUSTERED (ProjectID)  ON [PRIMARY] 
ALTER TABLE [dbo].[SubProject] ADD CONSTRAINT [PK_SubProjectID] PRIMARY KEY  CLUSTERED (SubProjectID)  ON [PRIMARY] 
ALTER TABLE [dbo].[SubProjectBudget] ADD CONSTRAINT [PK_SubProjectBudgetID] PRIMARY KEY  CLUSTERED (SubProjectBudgetID)  ON [PRIMARY] 


USE TEST
GO  
EXEC sys.sp_cdc_enable_db  
GO  


USE TEST  
GO  
EXEC sys.sp_cdc_enable_table  
@source_schema = N'dbo',  
@source_name   = N'Contact',  
@role_name     = N'MyRole',  
@supports_net_changes = 1  
GO  

EXEC sys.sp_cdc_enable_table  
@source_schema = N'dbo',  
@source_name   = N'Institution',  
@role_name     = N'MyRole',  
@supports_net_changes = 1  
GO  

EXEC sys.sp_cdc_enable_table  
@source_schema = N'dbo',  
@source_name   = N'Project',  
@role_name     = N'MyRole',  
@supports_net_changes = 1  
GO  

EXEC sys.sp_cdc_enable_table  
@source_schema = N'dbo',  
@source_name   = N'SubProject',  
@role_name     = N'MyRole',  
@supports_net_changes = 1  
GO  

EXEC sys.sp_cdc_enable_table  
@source_schema = N'dbo',  
@source_name   = N'SubProjectBudget',  
@role_name     = N'MyRole',  
@supports_net_changes = 1  
GO  


--***************************** extract data from CDC ************


declare @begin_lsn binary(10), @end_lsn binary(10)
-- get the first LSN for customer changes
select @begin_lsn = sys.fn_cdc_get_min_lsn('dbo_Contact')

-- get the last LSN for customer changes
select @end_lsn = sys.fn_cdc_get_max_lsn()
-- get net changes; group changes in the range by the pk
select * from cdc.fn_cdc_get_net_changes_dbo_Contact(@begin_lsn, @end_lsn, 'all'); 
-- get individual changes in the range
select * from cdc.fn_cdc_get_all_changes_dbo_Contact(@begin_lsn, @end_lsn, 'all');

--***************************************************************

declare @begin_lsn binary(10), @end_lsn binary(10)
-- get the first LSN for customer changes
select @begin_lsn = sys.fn_cdc_get_min_lsn('dbo_Institution')

-- get the last LSN for customer changes
select @end_lsn = sys.fn_cdc_get_max_lsn()
-- get net changes; group changes in the range by the pk
select * from cdc.fn_cdc_get_net_changes_dbo_Institution(@begin_lsn, @end_lsn, 'all'); 
-- get individual changes in the range
select * from cdc.fn_cdc_get_all_changes_dbo_Institution(@begin_lsn, @end_lsn, 'all');