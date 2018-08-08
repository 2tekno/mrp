create view vwProvinceFilter

AS

SELECT Province = 'ALL', [SortOrder] = -1
UNION ALL
SELECT Province, [SortOrder]
FROM vwProvince
WHERE Province != ''