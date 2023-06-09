USE [Alfabot]
GO
/****** Object:  View [dbo].[vPartnerStat]    Script Date: 2023. 05. 28. 21:52:14 ******/
DROP VIEW [dbo].[vPartnerStat]
GO
/****** Object:  View [dbo].[vPartnerStat]    Script Date: 2023. 05. 28. 21:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    VIEW [dbo].[vPartnerStat] AS

SELECT 
    CONCAT_WS(' ',
        'Férfiak aránya:',
        CAST(COUNT(CASE WHEN P.Gender = 0 THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(4,1)),'%'
    ) AS 'Férfiak aránya:',
    CONCAT_WS(' ',
        'Nők aránya:',
        CAST(COUNT(CASE WHEN P.Gender = 1 THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(4,1)), '%'
    ) AS 'Nők aránya:',
    CONCAT_WS(' ',
        'Magánszemélyek aránya:',
        CAST(COUNT(CASE WHEN P.Gender IS NOT NULL THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(4,1)), '%'
    ) AS 'Magánszemélyek aránya:',
    CONCAT_WS(' ',
        'Cégek aránya:',
        CAST(COUNT(CASE WHEN P.IsCompany = 'true' THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(4,1)), '%'
    ) AS 'Cégek aránya',
    CONCAT_WS(' ',
        'Férfiak aránya(Term.szem. képest):',
        CAST(COUNT(CASE WHEN P.Gender = 0 AND P.IsCompany = 'false' THEN 1 END) * 100.0 / 
		COUNT(CASE WHEN P.IsCompany = 'false' THEN 1 END) AS DECIMAL(4,1)), '%'
    ) AS 'Férfiak aránya(Term.szem. képest):',
    CONCAT_WS(' ',
        'Nők aránya(Term.szem. képest):',
        CAST(COUNT(CASE WHEN P.Gender = 1 AND P.IsCompany = 'false' THEN 1 END) * 100.0 / 
		COUNT(CASE WHEN P.IsCompany = 'false' THEN 1 END) AS DECIMAL(4,1)), '%'
    ) AS 'Nők aránya(Term.szem. képest):',
    CONCAT_WS(' ',
		'Hánynak van levelezési címe is:',
        COUNT(CASE WHEN P.AddressP IS NOT NULL THEN 1 END)
	)AS 'Hánynak van levelezési címe is:',
	CONCAT_WS(' ',
	'Ismertség típusa: Ajánlás',
	CAST(COUNT(CASE WHEN P.MeetTypeID = 1 THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(4,1)), '%'
	) AS 'Ismertség típusa százalékos eloszlásban: Ajánlás',
	CONCAT_WS(' ',
	'Ismertség típusa: (Személyes)',
	CAST(COUNT(CASE WHEN P.MeetTypeID = 2 THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(4,1)),'%'
	) AS 'Ismertség típusa százalékos eloszlásban: Személyes',
	CONCAT_WS(' ',
	'Ismertség típusa: (Telefon)',
	CAST(COUNT(CASE WHEN P.MeetTypeID = 3 THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(4,1)),'%'
	) AS 'Ismertség típusa százalékos eloszlásban: Telefon',
		CONCAT_WS(' ',
	'Ismertség típusa: (Online)',
	CAST(COUNT(CASE WHEN P.MeetTypeID = 4 THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(4,1)),'%'
	) AS 'Ismertség típusa százalékos eloszlásban: Online',
	CONCAT_WS(' ',
	'Ismertség típusa: (Iroda)',
	CAST(COUNT(CASE WHEN P.MeetTypeID = 5 THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(4,1)),'%'
	) AS 'Ismertség típusa százalékos eloszlásban: Iroda',
	CONCAT_WS(' ',
	'Legtöbb szerződést kötötte:',
	(SELECT TOP (1) CONCAT_WS(' ', P2.LastName, P2.FirstName, P2.CompanyName, P2.CompanyType, COUNT(*), 'db')
	FROM dbo.[Contract] AS C
	JOIN dbo.[Partner] AS P2 ON C.PartnerID = P2.PartnerID
	GROUP BY P2.PartnerID, P2.LastName, P2.FirstName, P2.CompanyName, P2.CompanyType
	ORDER BY COUNT(*) DESC)) AS 'Legtöbb szerződést kötötte:',
	CONCAT_WS(' ',
	'Legdrágább szerződést kötötte:',
	(SELECT TOP (1) CONCAT_WS(' ', P2.LastName, P2.FirstName, P2.CompanyName, P2.CompanyType, FORMAT(C.Price, 'C0', 'hu-HU'))
	FROM dbo.[Contract] AS C
	JOIN dbo.[Partner] AS P2 ON C.PartnerID = P2.PartnerID
	ORDER BY C.Price DESC)) AS 'Legdrágább szerződést kötötte:',
	CONCAT_WS(' ',
	'Legutolsó szerződést kötötte:',
	(SELECT TOP (1)  CONCAT_WS(' ', P2.LastName, P2.FirstName, P2.CompanyName, P2.CompanyType)
	FROM dbo.[Contract] AS C
	JOIN dbo.[Partner] AS P2 ON C.PartnerID = P2.PartnerID
	ORDER BY C.ContractID DESC)) AS 'Legutolsó szerződést kötötte:',
	CONCAT_WS(' ',
	'Legutolsó befizetést tette:',
	(SELECT TOP (1) CONCAT_WS(' ', P2.LastName, P2.FirstName, P2.CompanyName, P2.CompanyType)
	FROM dbo.[Finance] AS F
	JOIN dbo.[Contract] AS C ON F.ContractID = C.PartnerID
	JOIN dbo.[Partner] AS P2 ON C.PartnerID = P2.PartnerID
	ORDER BY F.[Date] DESC)) AS 'Legutolsó befizetést tette:',
	CONCAT_WS(' ',
	'Legnagyobb összeget fizette(egy tétel):',
	(SELECT TOP (1) CONCAT_WS(' ', P2.LastName, P2.FirstName, P2.CompanyName, P2.CompanyType)
	FROM dbo.[Finance] AS F
	JOIN dbo.[Contract] AS C ON F.ContractID = C.PartnerID
	JOIN dbo.[Partner] AS P2 ON C.PartnerID = P2.PartnerID
	GROUP BY P2.PartnerID, P2.LastName, P2.FirstName, P2.CompanyName, P2.CompanyType, F.Income
	ORDER BY F.Income DESC)) AS 'Legnagyobb összeget fizette(egy tétel):',
	CONCAT_WS(' ',
	'Legnagyobb összeget fizette(összesen):',
	(SELECT TOP (1) CONCAT_WS(' ', P2.LastName, P2.FirstName, P2.CompanyName, P2.CompanyType)
	FROM dbo.[Finance] AS F
	JOIN dbo.[Contract] AS C ON F.ContractID = C.PartnerID
	JOIN dbo.[Partner] AS P2 ON C.PartnerID = P2.PartnerID
	GROUP BY P2.PartnerID, P2.LastName, P2.FirstName, P2.CompanyName, P2.CompanyType
	ORDER BY SUM(f.Income) DESC)) AS 'Legnagyobb összeget fizette(összesen):',
	CONCAT_WS(' ', 
	'Legtöbb ügyet generálta (Taskok száma):',
	(SELECT TOP (1) CONCAT_WS(' ', P2.LastName, P2.FirstName, P2.CompanyName, P2.CompanyType)
	FROM dbo.[Task] AS T
	JOIN dbo.[Partner] AS P2 ON T.PartnerID = P2.PartnerID
	GROUP BY P2.PartnerID, P2.LastName, P2.FirstName, P2.CompanyName, P2.CompanyType
	ORDER BY COUNT(T.TaskID) DESC)) AS 'Legtöbb ügyet generálta (Taskok száma):'
	FROM dbo.[Partner]  AS P
GO
