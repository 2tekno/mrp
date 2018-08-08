
SELECT * FROM Contact


  --delete ContactNew
  --where LNAME is NULL

  --update ContactNew
  --set Inactive = 1
  --where PAST is not null


--truncate table [dbo].[AdminAssistant]
--truncate table [dbo].[ContactAdminFor]
--truncate table [dbo].[ContactAssistantFor]
--truncate table [dbo].[ContactEmail]
--truncate table [dbo].[ContactInstitution]
--truncate table [dbo].[ContactPhone]
--truncate table [dbo].[Institution]
--truncate table [dbo].[InstitutionCommRep]
--truncate table [dbo].[PeopleGroup]
--truncate table [dbo].[PeopleGroupContact]
--truncate table [dbo].[PeopleGroupProject]
--truncate table [dbo].[ProjectCoFunder]
--truncate table [dbo].[ProjectCollaborator]
--truncate table [dbo].[ProjectLeader]
--truncate table [dbo].[ProjectManager]
--truncate table [dbo].[ProjectMentor]
--truncate table [dbo].[ProjectSACMember]
--truncate table [dbo].[SubProjectCoFunder]
--truncate table [dbo].[SubProjectCoInvestigator]
--truncate table [dbo].[SubProjectCollaborator]
--truncate table [dbo].[SubProjectFinOfficer]
--truncate table [dbo].[SubProjectFinRep]
--truncate table [dbo].[SubProjectManager]
--truncate table [dbo].[SubProjectPI]


--INSERT INTO PeopleGroup (GroupName) VALUES ('TFF')  --1
--INSERT INTO PeopleGroup (GroupName) VALUES ('TFC')  --2
--INSERT INTO PeopleGroup (GroupName) VALUES ('EDU')  --3
--INSERT INTO PeopleGroup (GroupName) VALUES ('CCRA') --4
--INSERT INTO PeopleGroup (GroupName) VALUES ('RAC')  --5
--INSERT INTO PeopleGroup (GroupName) VALUES ('NODE') --6
--INSERT INTO PeopleGroup (GroupName) VALUES ('SCORE') --7
--INSERT INTO PeopleGroup (GroupName) VALUES ('BoD')   --8
--INSERT INTO PeopleGroup (GroupName) VALUES ('EXEC')  --9
--INSERT INTO PeopleGroup (GroupName) VALUES ('PARTNER')  --10
--INSERT INTO PeopleGroup (GroupName) VALUES ('OTHER')  --11
--INSERT INTO PeopleGroup (GroupName) VALUES ('FACULTY')  --12
--INSERT INTO PeopleGroup (GroupName) VALUES ('CASL')  --13

select * from PeopleGroup
select * from PeopleGroupContact

INSERT INTO PeopleGroupContact (ContactID,PeopleGroupID)
SELECT ContactID,1 FROM ContactNew
WHERE TFF IS NOT NULL

INSERT INTO PeopleGroupContact (ContactID,PeopleGroupID)
SELECT ContactID,2 FROM ContactNew
WHERE TFC IS NOT NULL

INSERT INTO PeopleGroupContact (ContactID,PeopleGroupID)
SELECT ContactID,3 FROM ContactNew
WHERE EDU IS NOT NULL

INSERT INTO PeopleGroupContact (ContactID,PeopleGroupID)
SELECT ContactID,4 FROM ContactNew
WHERE CCRA IS NOT NULL

INSERT INTO PeopleGroupContact (ContactID,PeopleGroupID)
SELECT ContactID,5 FROM ContactNew
WHERE RAC IS NOT NULL

INSERT INTO PeopleGroupContact (ContactID,PeopleGroupID)
SELECT ContactID,6 FROM ContactNew
WHERE NODE IS NOT NULL

INSERT INTO PeopleGroupContact (ContactID,PeopleGroupID)
SELECT ContactID,7 FROM ContactNew
WHERE SCOR IS NOT NULL

INSERT INTO PeopleGroupContact (ContactID,PeopleGroupID)
SELECT ContactID,8 FROM ContactNew
WHERE BoD IS NOT NULL

INSERT INTO PeopleGroupContact (ContactID,PeopleGroupID)
SELECT ContactID,9 FROM ContactNew
WHERE [EXEC] IS NOT NULL

INSERT INTO PeopleGroupContact (ContactID,PeopleGroupID)
SELECT ContactID,10 FROM ContactNew
WHERE [PARTNER] IS NOT NULL

INSERT INTO PeopleGroupContact (ContactID,PeopleGroupID)
SELECT ContactID,11 FROM ContactNew
WHERE OTHER IS NOT NULL

INSERT INTO PeopleGroupContact (ContactID,PeopleGroupID)
SELECT ContactID,12 FROM ContactNew
WHERE FACULTY IS NOT NULL

INSERT INTO PeopleGroupContact (ContactID,PeopleGroupID)
SELECT ContactID,13 FROM ContactNew
WHERE CASL IS NOT NULL
