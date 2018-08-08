alter view vwSalutation


/*

select * from vwSalutation order by SortOrder

*/
as

SELECT Sal = '',SortOrder = 0
UNION
SELECT Sal = 'Dr.',SortOrder = 1
UNION
SELECT Sal = 'Mr.',SortOrder = 2
UNION
SELECT Sal = 'Mrs.',SortOrder = 3
UNION
SELECT Sal = 'Prof.',SortOrder = 4
UNION
SELECT Sal = 'Ms',SortOrder = 5

