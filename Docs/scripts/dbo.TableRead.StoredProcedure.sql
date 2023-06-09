USE [Alfabot]
GO
/****** Object:  StoredProcedure [dbo].[TableRead]    Script Date: 2023. 05. 28. 21:52:14 ******/
DROP PROCEDURE [dbo].[TableRead]
GO
/****** Object:  StoredProcedure [dbo].[TableRead]    Script Date: 2023. 05. 28. 21:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[TableRead]
	AS
	SET NOCOUNT ON

	DROP TABLE IF EXISTS #nevek
	TRUNCATE TABLE [dbo].[DictFirstName]
	CREATE TABLE #nevek (ID VARCHAR(4), [Name] VARCHAR(50), Gender VARCHAR(2))

	DECLARE @FirstNameTable NVARCHAR(MAX)
	DECLARE @path VARCHAR(260)

	SELECT @path = G.GlobalValue
	FROM [Alfabot].[dbo].[Global] AS G
	WHERE G.GlobalName = 'FirstnameFile'

	DECLARE @S1 VARCHAR(5) = ';'
	DECLARE @S2 VARCHAR(5) = '\n'
	DECLARE @S3 VARCHAR(5) = 'ACP'


	SET @FirstNameTable = 
	'BULK INSERT #nevek FROM N''' + @path + '''
	WITH (
		FIELDTERMINATOR = ''' + @S1 + ''',
		ROWTERMINATOR = ''' + @S2 + ''',
		CODEPAGE= ''' + @S3 + ''',
		FIRSTROW = 2)'
	EXEC sp_executesql @FirstNameTable
	
	INSERT [dbo].[DictFirstName] (FirstName, Gender) 
	SELECT N.Name, N.Gender
	FROM #nevek AS N

	SELECT * FROM #nevek
	ALTER TABLE [dbo].[Partner]  WITH NOCHECK ADD  CONSTRAINT [FK_Partner_DictFirstName_FirstName] FOREIGN KEY([FirstName])
	REFERENCES [dbo].[DictFirstName] ([FirstName])

	ALTER TABLE [dbo].[Partner] CHECK CONSTRAINT [FK_Partner_DictFirstName_FirstName]
GO
