USE [Alfabot]
GO
/****** Object:  View [dbo].[vContractData]    Script Date: 2023. 05. 28. 21:52:14 ******/
DROP VIEW [dbo].[vContractData]
GO
/****** Object:  View [dbo].[vContractData]    Script Date: 2023. 05. 28. 21:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vContractData] AS
	
	SELECT 
		c.ContractID,
		C.ContractNumber AS 'Szerződésszám',
		DM6.[Value]  AS 'Biztosító társaság',
		DM4.[Value] AS 'Módozat',
		PR.ProductName AS 'Termék (fantázia) neve',
		CONCAT_WS(' ', P.Title, P.LastName, P.FirstName, P.FirstName2, P.CompanyName, P.CompanyType) AS 'Ügyfél teljes neve',
		DM1.[Value] AS 'Fizetésimód',
		DM3.[Value] AS 'Fizetési ütem',
		DM2.[Value] AS 'Szerződés állapota',
		FORMAT(C.Anndate, 'MMMMMMMMMMMMMMM dd' , 'hu-HU')  AS 'Évforduló',
		FORMAT(C.StartDate, 'yyyy MMMMMMMMMMMMMMM dd' , 'hu-HU') AS 'Kockázatviselés Kezdete',
		FORMAT(C.EndDate, 'yyyy MMMMMMMMMMMMMMM dd' , 'hu-HU') AS 'Kockázatviselés vége',
		FORMAT(C.Price, 'C0', 'Hu-hu') AS 'Éves Díj',
		FORMAT(C.FirstMoney, 'C0', 'Hu-hu') AS 'Szerzési jutalék'
	FROM dbo.[Contract] AS C
	LEFT JOIN  dbo.[Partner] AS P ON C.PartnerID = P.PartnerID
	LEFT JOIN Product AS PR ON C.ProductID = PR.ProductID
	LEFT JOIN dbo.DictMain AS DM1 ON C.PaymentTypeID = DM1.ValueID
	LEFT JOIN dbo.DictMain AS DM2 ON C.ContractStateID = DM2.ValueID
	LEFT JOIN dbo.DictMain AS DM3 ON C.PayPeriodID = DM3.ValueID
	LEFT JOIN dbo.DictMain AS DM4 ON PR.ProductType = DM4.ValueID
	LEFT JOIN dbo.DictMain AS DM6 ON PR.CompanyID = DM6.ValueID
GO
