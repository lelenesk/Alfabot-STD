USE [Alfabot]
GO
/****** Object:  UserDefinedFunction [dbo].[MoneyFormatter]    Script Date: 2023. 05. 28. 21:52:14 ******/
DROP FUNCTION [dbo].[MoneyFormatter]
GO
/****** Object:  UserDefinedFunction [dbo].[MoneyFormatter]    Script Date: 2023. 05. 28. 21:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[MoneyFormatter](@N int) RETURNS varchar(1000)	AS
		BEGIN
			DECLARE @NM smallint, @NK smallint, @NE smallint, @EM varchar(1000), 
				@EK varchar(1000), @EE varchar(1000), @E varchar(1000)
			IF @N = 0 RETURN 'Nulla'
			ELSE IF @N IS NULL RETURN ''
			SET @NM = @N/1000000
			SET @NK = (@N - @NM*1000000)/1000
			SET @NE = @N - @NM*1000000 - @NK*1000
			SET @EM = ISNULL(dbo.Counthree(@NM) + 'millió','')
			SET @EK = ISNULL(dbo.Counthree(@NK) + 'ezer','')
			SET @EE = ISNULL(dbo.Counthree(@NE),'')
			SET @E = @EM + IIF(@EM<>'' AND @EK<>'','-','') + @EK + 
				IIF(@N>2000 AND @EE<>'','-','') + @EE
			RETURN UPPER(LEFT(@E,1)) + SUBSTRING(@E,2,1000)
		END
GO
