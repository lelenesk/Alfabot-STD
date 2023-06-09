USE [Alfabot]
GO
/****** Object:  UserDefinedFunction [dbo].[TPNValidator]    Script Date: 2023. 05. 28. 21:52:14 ******/
DROP FUNCTION [dbo].[TPNValidator]
GO
/****** Object:  UserDefinedFunction [dbo].[TPNValidator]    Script Date: 2023. 05. 28. 21:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    FUNCTION [dbo].[TPNValidator]
	(@TPN VARCHAR(20), 
	 @iscomp BIT,
	 @birthdate VARCHAR(15))
RETURNS INT
--1 HIBÁS FORMÁTUM
--2 NEM VALID ADAT
--3 NEM CÉG VAGY NEM MAGÁNSZEMÉLY
--4 hiba
--0 ELLENŐRZŐ SZÁM és születési dátum (magánszemély esetén) OK
AS
BEGIN
	DECLARE @I INT
	DECLARE @K INT
	DECLARE @R INT
	
	SET @TPN = TRIM(REPLACE(@TPN, '-', ''))
    IF @TPN IS NULL OR @iscomp IS NULL OR @TPN LIKE '%[^0-9]%' OR LEN(@TPN) > 11 OR LEN(@TPN) < 9 AND @birthdate IS NULL
		SET @R =  1
    ELSE IF LEN(@TPN) = 11 AND @iscomp = 1
		IF SUBSTRING(@TPN, 9, 1) IN ('1', '2', '3', '4', '5') AND RIGHT(@TPN, 2) NOT BETWEEN 2 AND 20 AND RIGHT(@TPN, 2) NOT BETWEEN 22 AND 44 AND RIGHT(@TPN, 2) <> 51 AND @birthdate IS NULL
			SET @R =  2
		ELSE
			BEGIN
	        SET @I = 10 - (LEFT(@TPN, 1) * 9 + SUBSTRING(@TPN, 2, 1) * 7 + SUBSTRING(@TPN, 3, 1) * 3 + 
				SUBSTRING(@TPN, 4, 1) + SUBSTRING(@TPN, 5, 1) * 9 + SUBSTRING(@TPN, 6, 1) * 7 + 
				SUBSTRING(@TPN, 7, 1) * 3) % 10
			IF @I = 10 SET @I = 0
			IF @I = SUBSTRING(@TPN, 8, 1)
				SET @R =  0
			ELSE
				SET @R =  2

			END
	ELSE IF LEN(@TPN) = 10 AND @iscomp = 0 AND @birthdate IS NOT NULL
		BEGIN
		SET @I = DATEDIFF(DAY, '1867.01.01', @birthdate)
		IF SUBSTRING(@TPN, 1, 1) = 8 AND @I = CAST(SUBSTRING(@TPN, 2, 5)AS INT)
			BEGIN
			SET @K = (LEFT(@TPN, 1) * 1 + SUBSTRING(@TPN, 2, 1) * 2 + SUBSTRING(@TPN, 3, 1) * 3 + 
				SUBSTRING(@TPN, 4, 1) * 4 + SUBSTRING(@TPN, 5, 1) * 5 + SUBSTRING(@TPN, 6, 1) * 6 + 
				SUBSTRING(@TPN, 7, 1) * 7 + SUBSTRING(@TPN, 8, 1) * 8 + SUBSTRING(@TPN, 9, 1) * 9) % 11
			IF @K = 10
				SET @R = 2
			ELSE IF @K <> SUBSTRING(@TPN, 10, 1)
				SET @R = 2
			ELSE
				SET @R = 0
			END
		ELSE
			SET @r = 4
		END
	ELSE
		SET @R = 3
	RETURN @R 
END
GO
