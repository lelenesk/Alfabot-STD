USE [Alfabot]
GO
/****** Object:  View [dbo].[vMonthlySales]    Script Date: 2023. 05. 28. 21:52:14 ******/
DROP VIEW [dbo].[vMonthlySales]
GO
/****** Object:  View [dbo].[vMonthlySales]    Script Date: 2023. 05. 28. 21:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    VIEW [dbo].[vMonthlySales] AS

SELECT *
FROM 
OPENROWSET( 'SQLNCLI',
                'Server=GEPHAZ;Trusted_Connection=yes;',
                'SET FMTONLY OFF; SET NOCOUNT ON; exec Alfabot.dbo.[SP_yearlyview]')
GO
