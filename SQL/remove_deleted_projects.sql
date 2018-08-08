select 
*
from Project
where ISNULL(IsDeleted, 0) = 1

select 
*
from SubProject
where ISNULL(IsDeleted, 0) = 1


delete Project
where ISNULL(IsDeleted, 0) = 1

delete SubProject
where ISNULL(IsDeleted, 0) = 1