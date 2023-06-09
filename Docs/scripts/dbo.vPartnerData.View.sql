USE [Alfabot]
GO
/****** Object:  View [dbo].[vPartnerData]    Script Date: 2023. 05. 28. 21:52:14 ******/
DROP VIEW [dbo].[vPartnerData]
GO
/****** Object:  View [dbo].[vPartnerData]    Script Date: 2023. 05. 28. 21:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vPartnerData] AS

	WITH clientdata AS (
		SELECT DISTINCT P.PartnerID AS 'Partnerazonosító', 
				P.OwnerID AS 'üzletkötő azonosító',
				CONCAT_WS(' ',  P2.Title, P2.LastName, P2.FirstName, P2.FirstName2, P2.CompanyName, P2.CompanyType) AS 'Üzletkötő neve',
				CONCAT_WS(' ', P.Title, P.LastName, P.FirstName, P.FirstName2, P.CompanyName, P.CompanyType) AS 'Ügyfél teljes neve',
				P.UserName AS 'Felhasználónév',
				P.BirthPlace AS 'Születési Hely',
				CONCAT_WS(' ', P.BornDate, P.StartDate) AS 'Születési/Indulási Időpont',
				P.TaxPayerNo AS 'Adószám',
				P.IDNumber1 AS 'Szem.Ig./Cégjegyzékszám',
				P.IDNumber2 AS '2.Az.Okm./TEÁOR kód',
				P.ContactPerson AS 'Kapcsolattartó(Ha Cég)',
				CONCAT_WS(' ', P.PostalCodeH, P.CityH, P.AddressH) AS 'Állandó Lakcím',
				CONCAT_WS(' ', P.CountryCodeP, P.PostalCodeP, P.CityP, P.AddressP) AS 'Levelezési cím',
				P.Phone1 AS 'Elsődleges Tel.szám.', 
				P.Phone2 AS 'Másodlagos Tel.szám.', 
				P.Email1 AS 'Elsődleges Email cím',  
				P.Email2 AS 'Másodlagos Email cím', 
				P.BankAccountNo AS 'Bankszámlaszám',
				DM1.[Value] AS 'Ismertség típusa'
				FROM Partner AS P
				LEFT JOIN Partner AS P2 ON P.OwnerID = P2.PartnerID
				JOIN dbo.DictMain AS DM1 ON p.MeetTypeID = DM1.ValueID),
	[events] AS (
				SELECT P.PartnerID,
				STRING_AGG (CAST(E.EventID AS NVARCHAR(MAX)),',') AS 'Eseményazonsítók'
				FROM Event AS E
				LEFT JOIN Partner AS P ON  E.PartnerID = P.PartnerID
				GROUP BY P.partnerid),
	[tasks] AS (
				SELECT P.PartnerID,
				STRING_AGG (CAST(T.TaskID AS NVARCHAR(MAX)),',') AS 'Feladatazonosítók'
				FROM Task AS T
				LEFT JOIN Partner AS P ON  T.PartnerID = P.PartnerID
				GROUP BY P.partnerid)
	SELECT C.*, E.[Eseményazonsítók], T.[Feladatazonosítók]
	FROM clientdata AS C
	JOIN [events] AS E ON C.[Partnerazonosító] = E.PartnerID
	JOIN [tasks] AS T ON C.[Partnerazonosító] = T.PartnerID
GO
