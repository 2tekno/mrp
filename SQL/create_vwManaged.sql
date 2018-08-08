create view vwManaged

as

/*

select * from vwManaged


*/


SELECT
Managed = 'Yes'

UNION

SELECT
Managed = 'No'

