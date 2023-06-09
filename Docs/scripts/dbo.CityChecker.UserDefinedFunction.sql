USE [Alfabot]
GO
/****** Object:  UserDefinedFunction [dbo].[CityChecker]    Script Date: 2023. 05. 28. 21:52:14 ******/
DROP FUNCTION [dbo].[CityChecker]
GO
/****** Object:  UserDefinedFunction [dbo].[CityChecker]    Script Date: 2023. 05. 28. 21:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[CityChecker]
	(@C varchar(100),
	 @P varchar(5))
RETURNS VARCHAR(80)
--0 létező párositás
--1 hibás adat
--2 nincs találat
--HA két paramétert adunk meg és helyes is:visszadott irányítószám
AS
BEGIN
	DECLARE @R tinyint
	IF @C IS NULL AND @P IS NULL
	SET @R = '1'
	ELSE IF LEN(@P) >4 OR @P LIKE '[^A-Z]' OR @C LIKE '[^0-9]' OR LEN(@C) < 2 
	SET @R = '1'
	ELSE
		IF @C IS NOT NULL AND @P IS NULL
			IF EXISTS(SELECT 1 FROM dbo.DictCity WHERE PostalCode IN((
				SELECT PostalCode FROM dbo.DictCity WHERE CityName = @C )))
				RETURN (SELECT TOP (1) PostalCode FROM dbo.DictCity WHERE CityName = @C ORDER BY PostalCode)
			ELSE
				SET @R = '2'
		ELSE IF @C IS NULL AND @P IS NOT NULL
			IF EXISTS(SELECT 1 FROM dbo.DictCity WHERE CityName IN((
				SELECT CityName FROM dbo.DictCity WHERE Postalcode = @P)))
				RETURN (SELECT TOP (1) CityName FROM dbo.DictCity WHERE PostalCode = @P ORDER BY CityName)
			ELSE
				SET @R = '2'
		ELSE
			IF EXISTS(SELECT 1 FROM dbo.DictCity WHERE CityName = @C AND Postalcode = @P)
				SET @R = '0'
			ELSE
				SET @R = '2'
RETURN @R
END
GO
