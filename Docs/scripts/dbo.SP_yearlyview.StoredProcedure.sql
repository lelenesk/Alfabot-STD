USE [Alfabot]
GO

/****** Object:  StoredProcedure [dbo].[SP_yearlyview]    Script Date: 23/06/2023 05:42:49 ******/
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

	--DECLARE @tmpResult TABLE
	--(ownerid int, [1] int, [2] int, [3] int, [4] int, [5] int,
	--[6] int, [7] int, [8] int, [9] int, [10] int, [11] int, [12] int, [13] int)

	--INSERT into @tmpResult
	EXEC(@query)

	--SELECT  CONCAT_WS(' ', P.LastName, P.FirstName, P.FirstName2, P.CompanyName, P.CompanyType) as  [Dolgozó neve], r.*
	--FROM @tmpResult as r
	--JOIN dbo.[Partner] AS P ON r.ownerid = P.PartnerID
	
GO


