
-- insert into ContactEmail
truncate table ContactEmail
insert into ContactEmail (ContactID,Email)
select ContactID,Email 
from ContactNew
where Email is not null


-- insert into ContactPhone
truncate table ContactPhone
insert into ContactPhone (ContactID,Phone )
select ContactID,Phone 
from ContactNew
where Phone is not null


-- insert into Institution
truncate table Institution
insert into Institution (
InstitutionName
,Province
--,Country
)
select 
Institution
,Province
--,Country
from ContactNew
where Institution is not null
and Province is not null
--and Country is not null
group by
Institution
,Province
--,Country


-- insert into ContactInstitution
truncate table ContactInstitution
insert into ContactInstitution (ContactID, InstitutionID)
select a.ContactID,b.InstitutionID
from ContactNew a
join Institution b ON b.InstitutionName = a.Institution AND b.Province = a.Province

