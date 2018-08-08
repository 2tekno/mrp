select TABLE_NAME,COLUMN_NAME,DATA_TYPE,MAXIMUM_LENGTH = ISNULL(CHARACTER_MAXIMUM_LENGTH, '')
from TFRI.information_schema.columns
order by table_name, ordinal_position

--select *
--from TFRI.information_schema.columns
--order by table_name, ordinal_position
