USE [Alfabot]
GO
/****** Object:  UserDefinedFunction [dbo].[Counthree]    Script Date: 2023. 05. 28. 21:52:14 ******/
DROP FUNCTION [dbo].[Counthree]
GO
/****** Object:  UserDefinedFunction [dbo].[Counthree]    Script Date: 2023. 05. 28. 21:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[Counthree] (@N smallint) RETURNS varchar(1000) AS
		BEGIN
			IF @N = 0 RETURN NULL
			DECLARE @H varchar(50) = CHOOSE(@N/100,'egy', 'kettő', 'három', 'négy', 
				'öt', 'hat', 'hét', 'nyolc', 'kilenc') + 'száz'
			DECLARE @T varchar(50) = CHOOSE((@N-@N/100*100)/10,'tíz', 'húsz', 'harminc', 
				'negyven', 'ötven', 'hatvan', 'hetven', 'nyolcvan', 'kilencven')
			DECLARE @E varchar(50) = CHOOSE(@N % 10,'egy', 'kettő', 'három', 'négy', 
				'öt', 'hat', 'hét', 'nyolc', 'kilenc')
			IF @T = 'tíz' AND @E IS NOT NULL SET @T = 'tizen'
			ELSE IF @T = 'húsz' AND @E IS NOT NULL SET @T = 'huszon'
			RETURN ISNULL(@H,'') + ISNULL(@T,'') + ISNULL(@E,'')
		END
GO
