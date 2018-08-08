--select 
--Institution
--from ContactRaw
--group by Institution


--select *
--from ContactRaw
--order by Institution


--*******************************************
truncate table Contact
insert into Contact (
[FName]
,[LName]
,[Sal]
,[JobTitle]
,[Notes]
,[Phone]
,[Email]
,[Institution]
,[Address1]
,[Address2]
,[Address3]
,[City]
,[Province]
,[PostalCode]
,[Country]
)
select
[FName]
,[LName]
,[Sal]
,[JobTitle]
,[Notes]
,[Phone]
,[Email]
,[Institution]
,[Address1]
,[Address2]
,[Address3]
,[City]
,[Province]
,[PostalCode]
,[Country]
from ContactRaw



-- insert into ContactEmail
truncate table ContactEmail
insert into ContactEmail (ContactID,Email)
select ContactID,Email 
from Contact
where Email is not null


-- insert into ContactPhone
truncate table ContactPhone
insert into ContactPhone (ContactID,Phone )
select ContactID,Phone 
from Contact
where Phone is not null


-- insert into Institution
truncate table Institution
insert into Institution (
InstitutionName
,Province
,Country
)
select 
Institution
,Province
,Country
from Contact
where Institution is not null
and Province is not null
and Country is not null
group by
Institution
,Province
,Country

-- insert into ContactInstitution
truncate table ContactInstitution
insert into ContactInstitution (ContactID, InstitutionID)
select a.ContactID,b.InstitutionID
from Contact a
join Institution b ON b.InstitutionName = a.Institution AND b.Province = a.Province

-- insert into Project
truncate table Project
insert into Project (
[ProjectNumber]
,[ProgramID]
,[ProjectShortName]
,[ProjectTitle]
,[StartDate]
,[EndDate]
,[NCEEndDate]
,[ProjectStatusID]
,[CloseOutLetterSentDate]
,[FollowUpDate]
,[LetterOfOfferDate]
)
select
[Project]
,b.[ProgramID]

--,a.[Program Type]

,[Project Long Name]
,[Project Long Name]
,[Start Date]
,[End Date]
,[NCE End Date]
,ISNULL(c.[ProjectStatusID],0)

--,a.[Status]


,cast([Close Out Ltr] as date)
,cast([FUdate] as date)
,[LOO Date]
from ProjectRaw a
LEFT JOIN Program b ON b.ProgramDescription = a.[Program Type]
LEFT JOIN ProjectStatus c ON c.[ProjectStatusDescription] = a.[Status]