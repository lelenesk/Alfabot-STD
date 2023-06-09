USE [Alfabot]
GO
/****** Object:  UserDefinedFunction [dbo].[DistanceInKM]    Script Date: 2023. 05. 28. 21:52:14 ******/
DROP FUNCTION [dbo].[DistanceInKM]
GO
/****** Object:  UserDefinedFunction [dbo].[DistanceInKM]    Script Date: 2023. 05. 28. 21:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[DistanceInKM](
		@C1 VARCHAR(80) = 'Budapest',  @C2 Varchar(80))
		RETURNS varchar(1000)
		AS
		BEGIN
			DECLARE @R DECIMAL(5,1)
			DECLARE @GPS1 GEOGRAPHY, @GPS2 GEOGRAPHY
            
			SELECT @GPS1=GPS FROM [dbo].[PostalCode] WHERE City= @C1 
			SELECT @GPS2=GPS FROM [dbo].[PostalCode] WHERE City= @C2
			SELECT @R = round(@GPS1.STDistance(@GPS2) / 1000, 1) 
			RETURN @R
		END	
GO
