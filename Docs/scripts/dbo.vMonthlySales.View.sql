USE [Alfabot]
GO

/****** Object:  View [dbo].[vMonthlySales]    Script Date: 23/06/2023 05:42:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE         VIEW [dbo].[vMonthlySales] AS

SELECT *
FROM 
OPENROWSET( 'SQLNCLI',
                'Server=GEPHAZ\GEPHAZ;Trusted_Connection=yes;',
                'SET FMTONLY OFF; SET NOCOUNT ON; exec Alfabot.dbo.[SP_yearlyview] WITH RESULT SETS
(
  (
	[üzletkötő neve]       varchar(80)       NULL,
    Month1        int       NULL,
	Month2        int       NULL,
	Month3        int       NULL,
	Month4        int       NULL,
	Month5        int       NULL,
	Month6        int       NULL,
	Month7        int       NULL,
	Month8        int       NULL,
	Month9        int       NULL,
	Month10       int       NULL,
	Month11       int       NULL,
	Month12       int       NULL,
	Month13       int       NULL
  ))')

GO
