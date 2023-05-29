USE [Alfabot]
GO
/****** Object:  StoredProcedure [dbo].[SP_yearlyview]    Script Date: 2023. 05. 28. 21:52:14 ******/
DROP PROCEDURE [dbo].[SP_yearlyview]
GO
/****** Object:  StoredProcedure [dbo].[SP_yearlyview]    Script Date: 2023. 05. 28. 21:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_yearlyview]
	AS
	SET NOCOUNT ON

	DECLARE @cols AS NVARCHAR(MAX),
		    @cols2 AS NVARCHAR(MAX) = N'FORMAT(StartDate, ''yyyy MMMMMMMMMMMMMMM'', ''hu-HU'')',
            @query AS NVARCHAR(MAX)
		
	SELECT @cols = STUFF(
		(
			SELECT DISTINCT
				', ' + QUOTENAME(CONVERT(CHAR(30), FORMAT(StartDate, 'yyyy MMMMMMMMMMMMMMM', 'hu-HU'), 120))
			FROM dbo.[Contract]
			WHERE StartDate >= DATEADD(YEAR, -1, GETDATE()) AND StartDate !> GETDATE()
			ORDER BY 1 DESC
			FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)'), 1, 2, '')

	SET @query = 'SELECT OwnerID, ' + @cols + ' FROM (SELECT OwnerID, Price, CONVERT(CHAR(30),' + @cols2 + ', 120) AS Month
					FROM  dbo.[Contract]
				 ) a
				 PIVOT (
					 SUM(Price)
				   FOR Month IN (' + @cols + ')
				  ) b
				 ORDER BY OwnerID'

	TRUNCATE TABLE tmpResult

	INSERT dbo.tmpResult
	EXEC(@query)

	SELECT CONCAT_WS(' ', P.LastName, P.FirstName,
	P.FirstName2, P.CompanyName, P.CompanyType) AS [Dolgozó neve],
	FORMAT(R.Május, 'C0', 'Hu-hu'),
	FORMAT(R.Április, 'C0', 'Hu-hu'),
	FORMAT(R.Március, 'C0', 'Hu-hu'),
	FORMAT(r.Február, 'C0', 'Hu-hu'),
	FORMAT(R.Január, 'C0', 'Hu-hu'),
	FORMAT(r.December, 'C0', 'Hu-hu'),
	FORMAT(r.November, 'C0', 'Hu-hu'),
	FORMAT(r.Október, 'C0', 'Hu-hu'),
	FORMAT(r.Szeptember, 'C0', 'Hu-hu'),
	FORMAT(R.Agusztus, 'C0', 'Hu-hu'),
	FORMAT(r.Július, 'C0', 'Hu-hu'),
	FORMAT(r.Június, 'C0', 'Hu-hu'),
	FORMAT(r.MájusT, 'C0', 'Hu-hu')
	FROM tmpResult AS R
	INNER JOIN dbo.[Partner] AS P ON R.OwnerID = P.PartnerID
GO
