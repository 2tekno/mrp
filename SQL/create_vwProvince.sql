alter view vwProvince


/*

select * from vwProvince order by SortOrder

*/
as

SELECT Province = '',SortOrder = 0
UNION
SELECT Province = 'BC',SortOrder = 1
UNION
SELECT Province = 'AB',SortOrder = 2
UNION
SELECT Province = 'ON',SortOrder = 3
UNION
SELECT Province = 'QC',SortOrder = 4
UNION
SELECT Province = 'MB',SortOrder = 5
UNION
SELECT Province = 'SK',SortOrder = 6
UNION
SELECT Province = 'NS',SortOrder = 7
UNION
SELECT Province = 'NB',SortOrder = 8
UNION
SELECT Province = 'NL',SortOrder = 9
UNION
SELECT Province = 'PE',SortOrder = 10
UNION
SELECT Province = 'NT',SortOrder = 11
UNION
SELECT Province = 'YT',SortOrder = 12
UNION
SELECT Province = 'NU',SortOrder = 13
UNION
SELECT Province = 'Other',SortOrder = 14
