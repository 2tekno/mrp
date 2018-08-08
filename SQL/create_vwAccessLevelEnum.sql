IF OBJECT_ID('vwAccessLevelEnum', 'V') IS NOT NULL
    DROP VIEW vwAccessLevelEnum;
GO


create view vwAccessLevelEnum

as

/*

select * from vwAccessLevelEnum


*/


SELECT Id = 0, Text = 'Read-Only' UNION
SELECT Id = 1, Text = 'Add-Edit-Delete' UNION
SELECT Id = 2, Text = 'Admin' UNION
SELECT Id = 3, Text = 'Edit but No Delete' 