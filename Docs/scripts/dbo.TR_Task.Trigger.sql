USE [Alfabot]
GO

/****** Object:  Trigger [dbo].[TR_Task]    Script Date: 2023. 05. 28. 23:15:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   TRIGGER [dbo].[TR_Task]
ON [dbo].[Task]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY 
IF EXISTS (SELECT 1 FROM INSERTED AS I FULL OUTER JOIN DELETED D ON I.TaskID = D.TaskID WHERE
	(D.TaskID IS NULL OR I.TaskID IS NULL))
	BEGIN
    INSERT INTO [dbo].[Tasklog](
				[TaskID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[TaskID], 'Új felvitel', '-', CONCAT_WS(' ','TID:', I.TaskTypeID, 'OWID:', I.MainOwner , 'CID:',I.ContractID), SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I

    INSERT INTO [dbo].[Tasklog](
				[TaskID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT D.[TaskID], 'Új felvitel', '-', CONCAT_WS(' ','TID:', D.TaskTypeID, 'OWID:', D.MainOwner , 'CID:',D.ContractID), SYSDATETIME(), SUSER_SNAME()
    FROM DELETED AS D
    END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.TaskID = D.TaskID WHERE I.TaskPriority <> D.TaskPriority)
	BEGIN
     INSERT INTO [dbo].[Tasklog](
				[TaskID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.TaskID, 'Módosítás-TaskPriority', I.TaskPriority, D.TaskPriority, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.TaskID = D.TaskID
	WHERE I.TaskPriority <> D.TaskPriority
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.TaskID = D.TaskID WHERE I.MainOwner <> D.MainOwner)
	BEGIN
     INSERT INTO [dbo].[Tasklog](
				[TaskID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.TaskID, 'Módosítás-MainOwner', I.MainOwner, D.MainOwner, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.TaskID = D.TaskID
	WHERE I.MainOwner <> D.MainOwner
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.TaskID = D.TaskID WHERE I.ActualDate <> D.ActualDate)
	BEGIN
     INSERT INTO [dbo].[Tasklog](
				[TaskID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.TaskID, 'Módosítás-.ActualDate', I.ActualDate, D.ActualDate, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.TaskID = D.TaskID
	WHERE I.ActualDate <> D.ActualDate
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.TaskID = D.TaskID WHERE I.EndDate <> D.EndDate)
	BEGIN
     INSERT INTO [dbo].[Tasklog](
				[TaskID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.TaskID, 'Módosítás-.EndDate', I.EndDate, D.EndDate, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.TaskID = D.TaskID
	WHERE I.EndDate <> D.EndDate
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.TaskID = D.TaskID WHERE I.PartnerID <> D.PartnerID)
	BEGIN
     INSERT INTO [dbo].[Tasklog](
				[TaskID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.TaskID, 'Módosítás-PartnerID', I.PartnerID, D.PartnerID, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.TaskID = D.TaskID
	WHERE I.PartnerID <> D.PartnerID
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.TaskID = D.TaskID WHERE I.ContractID <> D.ContractID)
	BEGIN
     INSERT INTO [dbo].[Tasklog](
				[TaskID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.TaskID, 'Módosítás-ContractID', I.ContractID, D.ContractID, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.TaskID = D.TaskID
	WHERE I.ContractID <> D.ContractID
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.TaskID = D.TaskID WHERE I.IsActive <> D.IsActive)
	BEGIN
     INSERT INTO [dbo].[Tasklog](
				[TaskID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.TaskID, 'Módosítás-IsActive', I.IsActive, D.IsActive, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.TaskID = D.TaskID
	WHERE I.IsActive <> D.IsActive
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.TaskID = D.TaskID WHERE I.IsVisible <> D.IsVisible)
	BEGIN
     INSERT INTO [dbo].[Tasklog](
				[TaskID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.TaskID, 'Módosítás-IsVisible', I.IsVisible, D.IsVisible, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.TaskID = D.TaskID
	WHERE I.IsVisible <> D.IsVisible
	END
END TRY
	BEGIN CATCH
        RAISERROR(20003, -1,-1, 'Hiba a Tasklog Triggerben')
    END CATCH
END






GO

ALTER TABLE [dbo].[Task] ENABLE TRIGGER [TR_Task]
GO


