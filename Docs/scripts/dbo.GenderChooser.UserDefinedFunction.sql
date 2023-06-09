USE [Alfabot]
GO
/****** Object:  UserDefinedFunction [dbo].[GenderChooser]    Script Date: 2023. 05. 28. 21:52:14 ******/
DROP FUNCTION [dbo].[GenderChooser]
GO
/****** Object:  UserDefinedFunction [dbo].[GenderChooser]    Script Date: 2023. 05. 28. 21:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[GenderChooser]
	(@S varchar(100))
RETURNS tinyint
AS
BEGIN
	DECLARE @Gender TINYINT
	IF @S = 'René' SET @Gender = 1
	ELSE IF @S IN ('Antigoné', 'Ariadné', 'Aténé', 'ené', 'Dafné', 'Röné') SET @Gender = 2
	ELSE IF RIGHT(@S,3) = 'éné'
		SELECT @Gender = 2 FROM DictFirstName WHERE FirstName = LEFT(@S,LEN(@S)-3)+'e' AND Gender = 1
	ELSE IF RIGHT(@S,3) = 'áné'
		SELECT @Gender = 2 FROM DictFirstName WHERE FirstName = LEFT(@S,LEN(@S)-3)+'a' AND Gender = 1
	ELSE IF RIGHT(@S,2) = 'né'
		SELECT @Gender = 2 FROM DictFirstName WHERE FirstName = LEFT(@S,LEN(@S)-2) AND Gender = 1
	ELSE 
		SELECT @Gender = Gender FROM DictFirstName WHERE FirstName = @S
	RETURN @Gender
END
GO
