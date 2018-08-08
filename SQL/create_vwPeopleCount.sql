IF OBJECT_ID('vwPeopleCount', 'V') IS NOT NULL
    DROP VIEW vwPeopleCount;
GO


create view vwPeopleCount

as

/*

select * from vwPeopleCount


*/

WITH cte0 AS (
SELECT Qty = count(*)
,ContactID
FROM [dbo].[AdminAssistant]
GROUP BY ContactID

UNION ALL

SELECT Qty = count(*)
,ContactID
FROM [dbo].[ContactAdminFor]
GROUP BY ContactID

UNION ALL

SELECT Qty = count(*)
,ContactID
FROM [dbo].[ContactAssistantFor]
GROUP BY ContactID

UNION ALL

SELECT Qty = count(*)
,ContactID
FROM [dbo].[ContactInstitution]
GROUP BY ContactID

UNION ALL

SELECT Qty = count(*)
,ContactID
FROM [dbo].[InstitutionCommRep]
GROUP BY ContactID

UNION ALL

SELECT Qty = count(*)
,ContactID
FROM [dbo].[PeopleGroupContact]
GROUP BY ContactID

UNION ALL

SELECT Qty = count(*)
,ContactID
FROM [dbo].[ProjectCollaborator]
GROUP BY ContactID

UNION ALL

SELECT Qty = count(*)
,ContactID
FROM [dbo].[ProjectLeader]
GROUP BY ContactID

UNION ALL

SELECT Qty = count(*)
,ContactID
FROM [dbo].[ProjectManager]
GROUP BY ContactID

UNION ALL

SELECT Qty = count(*)
,ContactID
FROM [dbo].[ProjectMentor]
GROUP BY ContactID

UNION ALL

SELECT Qty = count(*)
,ContactID
FROM [dbo].[ProjectSACMember]
GROUP BY ContactID

UNION ALL

SELECT Qty = count(*)
,ContactID
FROM [dbo].[SubProjectCoInvestigator]
GROUP BY ContactID

UNION ALL

SELECT Qty = count(*)
,ContactID
FROM [dbo].[SubProjectCollaborator]
GROUP BY ContactID

UNION ALL

SELECT Qty = count(*)
,ContactID
FROM [dbo].[SubProjectFinOfficer]
GROUP BY ContactID

UNION ALL

SELECT Qty = count(*)
,ContactID
FROM [dbo].[SubProjectOtherPersonnel]
GROUP BY ContactID

UNION ALL

SELECT Qty = count(*)
,ContactID
FROM [dbo].[SubProjectPI]
GROUP BY ContactID

)

SELECT Qty = count(*),ContactID
FROM cte0
GROUP BY ContactID