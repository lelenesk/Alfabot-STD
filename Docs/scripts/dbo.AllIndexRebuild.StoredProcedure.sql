USE [Alfabot]
GO
/****** Object:  StoredProcedure [dbo].[AllIndexRebuild]    Script Date: 2023. 05. 28. 21:52:14 ******/
DROP PROCEDURE [dbo].[AllIndexRebuild]
GO
/****** Object:  StoredProcedure [dbo].[AllIndexRebuild]    Script Date: 2023. 05. 28. 21:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[AllIndexRebuild]
AS
 SET NOCOUNT ON
	DECLARE curTable CURSOR FOR SELECT name FROM sys.tables
	DECLARE @name varchar(200), @S varchar(1000)
	OPEN curTable
	FETCH NEXT FROM curTable INTO @name
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @S = 'ALTER INDEX ALL ON ' + @name + ' REBUILD'
			EXEC (@S)
			FETCH NEXT FROM curTable INTO @name
		END
	CLOSE curTable
	DEALLOCATE curTable
GO
