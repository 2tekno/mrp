IF OBJECT_ID('dbo.FieldList', 'U') IS NOT NULL 
  DROP TABLE dbo.FieldList; 

GO


CREATE TABLE [dbo].[FieldList](
	[Form] [nvarchar](500) NULL,
	[FieldLabel] [nvarchar](500) NULL,
	UserPermissionGroup [nvarchar](500) NULL,
	FieldName [nvarchar](500) NULL
	
) ON [PRIMARY]
GO



BULK INSERT FieldList
FROM 'C:\MyProjects\TFRI_Pug\SQL\list_columns.csv'
WITH
(

    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)

/*
DECLARE @Directory VARCHAR(256);
SET @Directory = 'C:\some\directory\name\';
DECLARE @sql NVARCHAR(MAX);

SET @sql = '
INSERT INTO dbo.MyTable
    SELECT *
    FROM OPENROWSET(BULK ''' + @Directory + 'importfile.txt'',
                    FORMATFILE = '''+@Directory +'importfileFormatFile.Xml''
                   ) AS t1
';

exec sp_executesql @sql;
*/

select * from FieldList
