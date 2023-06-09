USE [Alfabot]
GO
/****** Object:  StoredProcedure [dbo].[UploadNameDays]    Script Date: 2023. 05. 28. 21:52:14 ******/
DROP PROCEDURE [dbo].[UploadNameDays]
GO
/****** Object:  StoredProcedure [dbo].[UploadNameDays]    Script Date: 2023. 05. 28. 21:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[UploadNameDays]
	AS
	SET NOCOUNT ON

	DROP TABLE IF EXISTS [dbo].[DictNameDay]
CREATE TABLE [dbo].[DictNameDay](
	[DayID] [INT] IDENTITY(1,1) NOT NULL,
	[FName] [VARCHAR](50) NULL,
	[NDate] [VARCHAR](6) NULL,
 CONSTRAINT [PK_DictNameDay] PRIMARY KEY CLUSTERED 
(
	[DayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

DECLARE @path VARCHAR(260)
SELECT @path = G.GlobalValue
FROM [Alfabot].[dbo].[Global] AS G
WHERE G.GlobalName = 'NamedayFile'

DECLARE @NamedayTable NVARCHAR(MAX)
DECLARE @N VARCHAR(6) = '$.Name'
DECLARE @D VARCHAR(6) = '$.Day'

SET @NamedayTable =
N'DECLARE @RawData VARCHAR(MAX)
SELECT @RawData =
BulkColumn
FROM OPENROWSET(BULK N'''  + @path + N''', SINGLE_BLOB) JSON
INSERT INTO dbo.DictNameDay ([FName], [NDate])
SELECT  [FName], [NDate]
FROM OPENJSON (@RawData)
with ([FName] [varchar](50)''' + @N + N''', [NDate] [varchar](10)''' + @D + N''')'

EXEC sp_executesql @NamedayTable
GO
