USE [Alfabot]
GO
/****** Object:  StoredProcedure [dbo].[EventHandler]    Script Date: 2023. 05. 28. 21:52:14 ******/
DROP PROCEDURE [dbo].[EventHandler]
GO
/****** Object:  StoredProcedure [dbo].[EventHandler]    Script Date: 2023. 05. 28. 21:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE        PROCEDURE [dbo].[EventHandler]
	@BN INT = 7,
	@ANN INT = 30
AS
	SET NOCOUNT ON

	DROP TABLE IF EXISTS #nameday
	DROP TABLE IF EXISTS #birthday
	DROP TABLE IF EXISTS #annyiversary
	DROP TABLE IF EXISTS #summary
	
	CREATE TABLE #nameday(PartnerID VARCHAR(5), OwnerID VARCHAR(5), [Name] VARCHAR(80), [date+place] VARCHAR(100),[reasondate] VARCHAR(50),
								[contractstate] VARCHAR(50), [contracttype] VARCHAR(50),
								[contract] VARCHAR(100),[contractnumber] VARCHAR(30), price VARCHAR(25), trnNum Varchar(4), balance VARCHAR(25),
								Balancetype VARCHAR(30), lastmoney VARCHAR(25), trnType VARCHAR(40), [DATE] VARCHAR(40),[address] VARCHAR(200),
								phone VARCHAR(20), email VARCHAR(100),meet VARCHAR(20), comment VARCHAR(200), evtype VARCHAR(4), evname VARCHAR(30), contractid VARCHAR(5))

	CREATE TABLE #birthday(PartnerID VARCHAR(5), OwnerID VARCHAR(5), [Name] VARCHAR(80), [date+place] VARCHAR(100),[reasondate] VARCHAR(50),
								[contractstate] VARCHAR(50), [contracttype] VARCHAR(50),
								[contract] VARCHAR(100),[contractnumber] VARCHAR(30), price VARCHAR(25), trnNum Varchar(4), balance VARCHAR(25),
								Balancetype VARCHAR(30), lastmoney VARCHAR(25), trnType VARCHAR(40), [DATE] VARCHAR(40),[address] VARCHAR(200),
								phone VARCHAR(20), email VARCHAR(100),meet VARCHAR(20), comment VARCHAR(200), evtype VARCHAR(4), evname VARCHAR(30), contractid VARCHAR(5))

	CREATE TABLE #annyiversary(PartnerID VARCHAR(5), OwnerID VARCHAR(5), [Name] VARCHAR(80), [date+place] VARCHAR(100),[reasondate] VARCHAR(50),
								[contractstate] VARCHAR(50), [contracttype] VARCHAR(50),
								[contract] VARCHAR(100),[contractnumber] VARCHAR(30), price VARCHAR(25), trnNum Varchar(4), balance VARCHAR(25),
								Balancetype VARCHAR(30), lastmoney VARCHAR(25), trnType VARCHAR(40), [DATE] VARCHAR(40),[address] VARCHAR(200),
								phone VARCHAR(20), email VARCHAR(100),meet VARCHAR(20), comment VARCHAR(200), evtype VARCHAR(4), evname VARCHAR(30), contractid VARCHAR(5))

	CREATE TABLE #summary(PartnerID VARCHAR(5), OwnerID VARCHAR(5), [Name] VARCHAR(80), [date+place] VARCHAR(100),[reasondate] VARCHAR(50),
								[contractstate] VARCHAR(50), [contracttype] VARCHAR(50),
								[contract] VARCHAR(100),[contractnumber] VARCHAR(30), price VARCHAR(25), trnNum Varchar(4), balance VARCHAR(25),
								Balancetype VARCHAR(30), lastmoney VARCHAR(25), trnType VARCHAR(40), [DATE] VARCHAR(40),[address] VARCHAR(200),
								phone VARCHAR(20), email VARCHAR(100),meet VARCHAR(20), comment VARCHAR(200), evtype VARCHAR(4), evname VARCHAR(30), contractid VARCHAR(5))

DECLARE @BNtoday date = DATEADD(DAY, @BN, GETDATE())
DECLARE @ANNtoday date = DATEADD(DAY, @ANN, GETDATE())


INSERT INTO #nameday
SELECT 
DISTINCT P.PartnerID,
P.OwnerID,
CONCAT_WS(' ', p.Title, p.LastName, P.FirstName, p.FirstName2) AS 'Név',
CONCAT_WS(' ', FORMAT(p.BornDate, 'yyyy MMMMMMMMMMMMMMMMMMMMM dd','hu-hu'), p.BirthPlace),
SUBSTRING(FORMAT(@BNtoday, 'D','hu-hu'), 6, (LEN(FORMAT(@BNtoday, 'D','hu-hu')) - 5)),
DM2.[Value] AS 'Állapot',
DM3.[Value] AS 'Módozat',
CONCAT_WS(' ', DM4.[Value], PO.ProductName) 'Típus',
C.ContractNumber AS 'Kötvényszám',
FORMAT(C.Price, 'C0', 'hu-HU') 'Éves Díj',
COUNT(F1.ContractDetailID) 'Tranzakciók száma',
MAX(FORMAT(F1.RolledMoney, 'C0', 'hu-HU')) AS 'Egyenleg',
MAX(CASE
    WHEN F1.Income IS NULL THEN 'Befizetés'
    WHEN F1.Cost IS NULL THEN 'Kivetés'
END) AS 'Utolsó Tétel',
MAX(CASE
    WHEN F1.Income IS NULL THEN FORMAT(F1.Cost, 'C0', 'hu-HU')
    WHEN F1.Cost IS NULL THEN FORMAT(F1.Income, 'C0', 'hu-HU')
END) AS 'Összeg',
MAX(DM5.[Value]) AS 'Tranzakció típusa',
MAX(F1.[Date]) AS 'Időpontja',
CONCAT_WS(' ', [CityH] ,[AddressH]),
P.Phone1,
P.Email1,
DM1.[Value], 
P.PartnerComment,
DM6.ValueID,
DM6.[Value],
C.ContractID
FROM [dbo].[Partner] AS P
LEFT JOIN dbo.DictNameDay AS ND ON P.FirstName = ND.FName
LEFT JOIN dbo.Contract AS C ON P.PartnerID = C.ContractID
JOIN dbo.Product AS PO ON C.ProductID = PO.ProductID
JOIN dbo.DictMain AS DM1 ON P.MeetTypeID = DM1.ValueID 
JOIN dbo.DictMain AS DM2  ON C.ContractStateID = DM2.ValueID
JOIN dbo.DictMain AS DM3  ON PO.ProductType = DM3.ValueID
JOIN dbo.DictMain AS DM4  ON PO.CompanyID = DM4.ValueID

JOIN dbo.DictMain AS DM6 ON DM6.[Value] = 'Névnap'
JOIN dbo.Finance AS F1 ON C.ContractID = F1.ContractID
LEFT OUTER JOIN dbo.Finance F2 ON (C.ContractID = F2.ContractID AND 
    (F1.ContractDetailID < F2.ContractDetailID 

	))
JOIN dbo.DictMain AS DM5 ON F1.BalanceTypeID = DM5.ValueID
WHERE (CAST(CAST(left(ND.NDate, 2) AS INT) AS VARCHAR(2)) = MONTH(@BNtoday)) AND 
(CAST(CAST(substring(ND.NDate, 4, 2) AS INT) AS VARCHAR(2)) = DAY(@BNtoday))
GROUP BY
P.PartnerID, P.OwnerID,CONCAT_WS(' ', p.Title, p.LastName, P.FirstName, p.FirstName2),
CONCAT_WS(' ', FORMAT(p.BornDate, 'yyyy MMMMMMMMMMMMMMMMMMMMM dd','hu-hu'), p.BirthPlace),
SUBSTRING(FORMAT(p.BornDate, 'D','hu-hu'), 6, (LEN(FORMAT(p.BornDate, 'D','hu-hu')) - 5)),
DM2.[Value],DM3.[Value],CONCAT_WS(' ', DM4.[Value], PO.ProductName),
C.ContractNumber,FORMAT(C.Price, 'C0', 'hu-HU'),CONCAT_WS(' ', [CityH] ,[AddressH]),
P.Phone1,P.Email1,DM1.[Value], P.PartnerComment,DM6.ValueID,DM6.[Value],C.ContractID

INSERT INTO #birthday
SELECT 
DISTINCT P.PartnerID,
P.OwnerID,
CONCAT_WS(' ', p.Title, p.LastName, P.FirstName, p.FirstName2) AS 'Név',
CONCAT_WS(' ', FORMAT(p.BornDate, 'yyyy MMM dd','hu-hu'), p.BirthPlace),
SUBSTRING(FORMAT(p.BornDate, 'yyyy MMMMMMMMMMMMMMMMMMMMM dd','hu-hu'), 6, (LEN(FORMAT(p.BornDate, 'yyyy MMMMMMMMMMMMMMMMMMMMM dd','hu-hu')) - 5)),
DM2.[Value] AS 'Állapot',
DM3.[Value] AS 'Módozat',
CONCAT_WS(' ', DM4.[Value], PO.ProductName) 'Típus',
C.ContractNumber AS 'Kötvényszám',
FORMAT(C.Price, 'C0', 'hu-HU') 'Éves Díj',
COUNT(F1.ContractDetailID) 'Tranzakciók száma',
MAX(FORMAT(F1.RolledMoney, 'C0', 'hu-HU')) AS 'Egyenleg',
MAX(CASE
    WHEN F1.Income IS NULL THEN 'Befizetés'
    WHEN F1.Cost IS NULL THEN 'Kivetés'
END) AS 'Utolsó Tétel',
MAX(CASE
    WHEN F1.Income IS NULL THEN FORMAT(F1.Cost, 'C0', 'hu-HU')
    WHEN F1.Cost IS NULL THEN FORMAT(F1.Income, 'C0', 'hu-HU')
END) AS 'Összeg',
MAX(DM5.[Value]) AS 'Tranzakció típusa',
MAX(F1.[Date]) AS 'Időpontja',
CONCAT_WS(' ', [CityH] ,[AddressH]),
P.Phone1,
P.Email1,
DM1.[Value], 
P.PartnerComment,
DM6.ValueID,
DM6.[Value],
C.ContractID
FROM [dbo].[Partner] AS P
LEFT JOIN dbo.Contract AS C ON P.PartnerID = C.ContractID
JOIN dbo.Product AS PO ON C.ProductID = PO.ProductID
JOIN dbo.DictMain AS DM1 ON P.MeetTypeID = DM1.ValueID 
JOIN dbo.DictMain AS DM2  ON C.ContractStateID = DM2.ValueID
JOIN dbo.DictMain AS DM3  ON PO.ProductType = DM3.ValueID
JOIN dbo.DictMain AS DM4  ON PO.CompanyID = DM4.ValueID
JOIN dbo.DictMain AS DM6 ON DM6.[Value] = 'Születésnap'
JOIN dbo.Finance AS F1 ON C.ContractID = F1.ContractID
LEFT OUTER JOIN dbo.Finance F2 ON (C.ContractID = F2.ContractID AND 
    (F1.ContractDetailID < F2.ContractDetailID 

	))
JOIN dbo.DictMain AS DM5 ON F1.BalanceTypeID = DM5.ValueID
WHERE MONTH(P.BornDate) = MONTH(@BNtoday) AND  DAY(P.BornDate) = DAY(@BNtoday)
GROUP BY
P.PartnerID, P.OwnerID,CONCAT_WS(' ', p.Title, p.LastName, P.FirstName, p.FirstName2),
CONCAT_WS(' ', FORMAT(p.BornDate, 'yyyy MMM dd','hu-hu'), p.BirthPlace),
SUBSTRING(FORMAT(p.BornDate, 'yyyy MMMMMMMMMMMMMMMMMMMMM dd','hu-hu'), 6, (LEN(FORMAT(p.BornDate, 'yyyy MMMMMMMMMMMMMMMMMMMMM dd','hu-hu')) - 5)),
DM2.[Value],DM3.[Value],CONCAT_WS(' ', DM4.[Value], PO.ProductName),
C.ContractNumber,FORMAT(C.Price, 'C0', 'hu-HU'),CONCAT_WS(' ', [CityH] ,[AddressH]),
P.Phone1,P.Email1,DM1.[Value], P.PartnerComment,DM6.ValueID,DM6.[Value],C.ContractID

INSERT INTO #annyiversary
SELECT 
P.PartnerID,
P.OwnerID,
CONCAT_WS(' ', p.Title, p.LastName, P.FirstName, p.FirstName2, P.CompanyName, P.CompanyType) AS 'Név',
CONCAT_WS(' ',FORMAT(COALESCE(p.startdate, p.BornDate), 'yyyy MMMMMMMMMMMMMMMMMMMMM dd','hu-hu'), P.BirthPlace),
SUBSTRING(FORMAT(C.Anndate, 'yyyy MMMMMMMMMMMMMMMMMMMMM dd','hu-hu'), 6, (LEN(FORMAT(C.Anndate, 'yyyy MMMMMMMMMMMMMMMMMMMMM dd','hu-hu'))- 5)),
DM2.[Value] AS 'Állapot',
DM3.[Value] AS 'Módozat',
CONCAT_WS(' ', DM4.[Value], PO.ProductName) 'Típus',
C.ContractNumber AS 'Kötvényszám',
FORMAT(C.Price, 'C0', 'hu-HU') 'Éves Díj',
COUNT(F1.ContractDetailID) 'Tranzakciók száma',
MAX(FORMAT(F1.RolledMoney, 'C0', 'hu-HU')) AS 'Egyenleg',
MAX(CASE
    WHEN F1.Income IS NULL THEN 'Befizetés'
    WHEN F1.Cost IS NULL THEN 'Kivetés'
END) AS 'Utolsó Tétel',
MAX(CASE
    WHEN F1.Income IS NULL THEN FORMAT(F1.Cost, 'C0', 'hu-HU')
    WHEN F1.Cost IS NULL THEN FORMAT(F1.Income, 'C0', 'hu-HU')
END) AS 'Összeg',
MAX(DM5.[Value]) AS 'Tranzakció típusa',
MAX(F1.[Date]) AS 'Időpontja',
CONCAT_WS(' ', [CityH] ,[AddressH]),
P.Phone1,
P.Email1,
DM1.[Value], 
P.PartnerComment,
MAX(DM6.ValueID),
DM6.[Value],
C.ContractID
FROM [dbo].[Partner] AS P
LEFT JOIN dbo.Contract AS C ON P.PartnerID = C.ContractID
JOIN dbo.Product AS PO ON C.ProductID = PO.ProductID
JOIN dbo.DictMain AS DM1 ON P.MeetTypeID = DM1.ValueID 
JOIN dbo.DictMain AS DM2  ON C.ContractStateID = DM2.ValueID
JOIN dbo.DictMain AS DM3  ON PO.ProductType = DM3.ValueID
JOIN dbo.DictMain AS DM4  ON PO.CompanyID = DM4.ValueID
JOIN dbo.DictMain AS DM6 ON DM6.[Value] = 'Évforduló' AND DM6.[ValueID] = 50
JOIN dbo.Finance AS F1 ON C.ContractID = F1.ContractID
LEFT OUTER JOIN dbo.Finance F2 ON (C.ContractID = F2.ContractID AND 
    (F1.ContractDetailID < F2.ContractDetailID 

	))
JOIN dbo.DictMain AS DM5 ON F1.BalanceTypeID = DM5.ValueID
WHERE F2.ContractID IS NULL AND MONTH(C.Anndate) = MONTH(@ANNtoday) AND DAY(C.Anndate) = DAY(@ANNtoday)
GROUP BY 
C.ContractNumber,P.PartnerID,P.OwnerID,
CONCAT_WS(' ', p.Title, p.LastName, P.FirstName, p.FirstName2, P.CompanyName, P.CompanyType),
CONCAT_WS(' ',FORMAT(COALESCE(p.startdate, p.BornDate), 'yyyy MMMMMMMMMMMMMMMMMMMMM dd','hu-hu'), P.BirthPlace),
SUBSTRING(FORMAT(C.Anndate, 'yyyy MMMMMMMMMMMMMMMMMMMMM dd','hu-hu'), 6, (LEN(FORMAT(C.Anndate, 'yyyy MMMMMMMMMMMMMMMMMMMMM dd','hu-hu'))- 5)),
DM2.[Value],DM3.[Value],CONCAT_WS(' ', DM4.[Value], PO.ProductName),C.ContractNumber,FORMAT(C.Price, 'C0', 'hu-HU'),
CONCAT_WS(' ', [CityH] ,[AddressH]),P.Phone1,P.Email1,DM1.[Value], P.PartnerComment,DM6.[Value],C.ContractID


INSERT INTO #summary
SELECT *
FROM( 
SELECT * FROM #nameday
UNION ALL
SELECT * FROM #birthday
UNION ALL 
SELECT * FROM #annyiversary) AS [ALL]


INSERT [dbo].[Event] ([EventTypeID], [EventDate], [Description], [PartnerID], [ContractID], [TaskID])
SELECT S.[Evtype], GETDATE(), CONCAT_WS(' ', S.[Name], S.evname, s.reasondate,  S.meet, S.phone, S.email, s.[contract], S.price),
S.PartnerID, S.contractid, NULL
FROM #summary AS S

SELECT * FROM #summary
GO
