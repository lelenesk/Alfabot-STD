USE [Alfabot]
GO
/****** Object:  UserDefinedFunction [dbo].[BankNoValidator]    Script Date: 2023. 05. 28. 21:52:14 ******/
DROP FUNCTION [dbo].[BankNoValidator]
GO
/****** Object:  UserDefinedFunction [dbo].[BankNoValidator]    Script Date: 2023. 05. 28. 21:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[BankNoValidator]
	(@BNO varchar(34))
RETURNS INT
--0 helyes szám
--1 több/kevesebb karakter
--2 valahol szám helyett betű van
--3 fake bank
--4 ellenörző szám nem stimmel
--5 ismeretlen hiba
--6 nem magyar bank
AS
BEGIN
	DECLARE @F int
	DECLARE @S int
	DECLARE @T varchar(24)
	DECLARE @K int
	DECLARE @R int

	SET @BNO = TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@BNO, '-', ''), ' ', ''), '  ', ''), '  ', ''), '   ', ''))
    IF @BNO IS NULL OR LEN(@BNO) NOT IN (16, 24, 28)
		SET @R =  1
	ELSE IF @BNO LIKE '%[A-Z]%'
		IF LEN(@BNO) != 28
			SET @R = 1
		ELSE IF LEN(@BNO) = 28 AND UPPER(SUBSTRING(@BNO, 1, 2)) NOT LIKE '[A-Z][A-Z]' AND SUBSTRING(@BNO, 3, 26) NOT LIKE '%[^A-Z]%'
			SET @R = 2
		ELSE IF  LEN(@BNO) = 28 AND UPPER(SUBSTRING(@BNO, 1, 2)) LIKE '[A-Z][A-Z]' AND SUBSTRING(@BNO, 3, 26) LIKE '%[^A-Z]%' AND UPPER(SUBSTRING(@BNO, 1, 2)) NOT LIKE 'HU'
		SET @R = 6
		ELSE
			BEGIN
			SET @T = SUBSTRING(@BNO, 5, 24)
			IF SUBSTRING(@T, 1, 3) NOT IN (100, 101, 102, 107, 108, 109, 114, 115, 116, 117, 118, 120, 121, 126, 128, 131,
										 135, 137, 144, 146, 148, 151, 162, 163, 167, 168, 175, 184, 194, 196, 197, 222, 296,
										 297, 298, 586, 612, 880, 884, 903, 181, 644, 807, 179, 183, 180, 142, 172, 136, 185,
										 177, 170, 182, 178, 619, 603, 171, 147, 111, 104, 103, 190, 141, 503, 652, 881, 655,
										 657, 160, 506, 527, 176, 539, 572, 808, 700, 803, 659)
			SET @R =  3
		ELSE IF @T NOT LIKE '%[^A-Z]%'
			SET @R =  2
		ELSE
			BEGIN --ellenőrzés 24
			SET @K = (LEFT(@T, 1) * 9 + SUBSTRING(@T, 2, 1) * 7 + SUBSTRING(@T, 3, 1) * 3 + 
				SUBSTRING(@T, 4, 1) + SUBSTRING(@T, 5, 1) * 9 + SUBSTRING(@T, 6, 1) * 7 + 
				SUBSTRING(@T, 7, 1) * 3 + SUBSTRING(@T, 8, 1)) % 10
			IF @K <> 0
				SET @R = 4
			ELSE
				BEGIN
				SET @F = SUBSTRING(@T, 9, 1) * 9 + SUBSTRING(@T, 10, 1) * 7 + SUBSTRING(@T, 11, 1) * 3 + 
					SUBSTRING(@T, 12, 1) + SUBSTRING(@T, 13, 1) * 9 + SUBSTRING(@T, 14, 1) * 7 + 
					SUBSTRING(@T, 15, 1) * 3 + SUBSTRING(@T, 16, 1)
				SET @S = SUBSTRING(@T, 17, 1) * 9 + SUBSTRING(@T, 18, 1) * 7 + SUBSTRING(@T, 19, 1) * 3 + 
					SUBSTRING(@T, 20, 1) + SUBSTRING(@T, 21, 1) * 9 + SUBSTRING(@T, 22, 1) * 7 + 
					SUBSTRING(@T, 23, 1) * 3 + SUBSTRING(@T, 24, 1)

				IF (@F + @S) % 10 = 0
					SET @R = 0
				ELSE
					SET @R = 4
				END
			END
		END
	ELSE IF LEN(@BNO) = 16 AND @BNO LIKE '%[^A-Z]%'
		IF SUBSTRING(@BNO, 1, 3) NOT IN (100, 101, 102, 107, 108, 109, 114, 115, 116, 117, 118, 120, 121, 126, 128, 131,
										 135, 137, 144, 146, 148, 151, 162, 163, 167, 168, 175, 184, 194, 196, 197, 222, 296,
										 297, 298, 586, 612, 880, 884, 903, 181, 644, 807, 179, 183, 180, 142, 172, 136, 185,
										 177, 170, 182, 178, 619, 603, 171, 147, 111, 104, 103, 190, 141, 503, 652, 881, 655,
										 657, 160, 506, 527, 176, 539, 572, 808, 700, 803, 659)
			SET @R =  3
		ELSE IF @BNO NOT LIKE '%[^A-Z]%'
			SET @R =  2
		ELSE
			BEGIN  --ellenőrzés 16
			SET @K = (LEFT(@BNO, 1) * 9 + SUBSTRING(@BNO, 2, 1) * 7 + SUBSTRING(@BNO, 3, 1) * 3 + 
				SUBSTRING(@BNO, 4, 1) + SUBSTRING(@BNO, 5, 1) * 9 + SUBSTRING(@BNO, 6, 1) * 7 + 
				SUBSTRING(@BNO, 7, 1) * 3 + SUBSTRING(@BNO, 8, 1)) % 10
			IF @K <> 0
				SET @R = 4
			ELSE
				BEGIN
				SET @F = 0
				SET @K = (SUBSTRING(@BNO, 9, 1) * 9 + SUBSTRING(@BNO, 10, 1) * 7 + SUBSTRING(@BNO, 11, 1) * 3 + 
					SUBSTRING(@BNO, 12, 1) + SUBSTRING(@BNO, 13, 1) * 9 + SUBSTRING(@BNO, 14, 1) * 7 + 
					SUBSTRING(@BNO, 15, 1) * 3 + SUBSTRING(@BNO, 16, 1)) % 10
				IF @K = 0
					BEGIN
					SET @S = 0
					IF @F = 0 AND @S = 0
						SET @R = 0
					END
				ELSE
					SET @R = 4
				END
			END
	ELSE IF LEN(@BNO) = 24 AND @BNO LIKE '%[^A-Z]%'
		IF SUBSTRING(@BNO, 1, 3) NOT IN (100, 101, 102, 107, 108, 109, 114, 115, 116, 117, 118, 120, 121, 126, 128, 131,
										 135, 137, 144, 146, 148, 151, 162, 163, 167, 168, 175, 184, 194, 196, 197, 222, 296,
										 297, 298, 586, 612, 880, 884, 903, 181, 644, 807, 179, 183, 180, 142, 172, 136, 185,
										 177, 170, 182, 178, 619, 603, 171, 147, 111, 104, 103, 190, 141, 503, 652, 881, 655,
										 657, 160, 506, 527, 176, 539, 572, 808, 700, 803, 659)
			SET @R =  3
		ELSE IF @BNO NOT LIKE '%[^A-Z]%'
			SET @R =  2
		ELSE
			BEGIN --ellenőrzés 24
			SET @K = (LEFT(@BNO, 1) * 9 + SUBSTRING(@BNO, 2, 1) * 7 + SUBSTRING(@BNO, 3, 1) * 3 + 
				SUBSTRING(@BNO, 4, 1) + SUBSTRING(@BNO, 5, 1) * 9 + SUBSTRING(@BNO, 6, 1) * 7 + 
				SUBSTRING(@BNO, 7, 1) * 3 + SUBSTRING(@BNO, 8, 1)) % 10
			IF @K <> 0
				SET @R = 4
			ELSE
				BEGIN
				SET @F = SUBSTRING(@BNO, 9, 1) * 9 + SUBSTRING(@BNO, 10, 1) * 7 + SUBSTRING(@BNO, 11, 1) * 3 + 
					SUBSTRING(@BNO, 12, 1) + SUBSTRING(@BNO, 13, 1) * 9 + SUBSTRING(@BNO, 14, 1) * 7 + 
					SUBSTRING(@BNO, 15, 1) * 3 + SUBSTRING(@BNO, 16, 1)
				SET @S = SUBSTRING(@BNO, 17, 1) * 9 + SUBSTRING(@BNO, 18, 1) * 7 + SUBSTRING(@BNO, 19, 1) * 3 + 
					SUBSTRING(@BNO, 20, 1) + SUBSTRING(@BNO, 21, 1) * 9 + SUBSTRING(@BNO, 22, 1) * 7 + 
					SUBSTRING(@BNO, 23, 1) * 3 + SUBSTRING(@BNO, 24, 1)

				IF (@F + @S) % 10 = 0
					SET @R = 0
				ELSE
					SET @R = 4
				END
			END
	ELSE
		SET @R = 5	
	RETURN @R 
END
GO
