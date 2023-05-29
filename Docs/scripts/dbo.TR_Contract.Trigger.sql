USE [Alfabot]
GO

/****** Object:  Trigger [dbo].[TR_Contract]    Script Date: 2023. 05. 28. 23:16:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   TRIGGER [dbo].[TR_Contract]
ON [dbo].[Contract]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY 
IF EXISTS (SELECT 1 FROM INSERTED AS I FULL OUTER JOIN DELETED D ON I.ContractID = D.ContractID WHERE
	(D.ContractID IS NULL OR I.ContractID IS NULL))
	BEGIN
    INSERT INTO [dbo].[Contractlog](
				[ContractID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[ContracTID], 'Új felvitel', '-', CONCAT_WS(' ','PID:', I.PartnerID, 'OWID:', I.OwnerID , 'CID:',I.ContractID,
			'PRID', I.ContractNumber, I.FirstMoney, I.Discount, I.ContractComment), SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I

    INSERT INTO [dbo].[Contractlog](
				[ContractID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
   SELECT D.[ContracTID], 'Törlés', CONCAT_WS(' ','PID:', D.PartnerID, 'OWID:', D.OwnerID , 'CID:',D.ContractID,
			'PRID', D.ContractNumber, D.FirstMoney, D.Discount, D.ContractComment),'-', SYSDATETIME(), SUSER_SNAME()								
    FROM DELETED AS D
    END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.ContractID = D.ContractID WHERE I.ProductID <> D.ProductID)
	BEGIN
    INSERT INTO [dbo].[Contractlog](
				[ContractID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[ContractID], 'Módosítás-ProductID', D.ContractID, I.ContractID, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.ContractID = D.ContractID
	WHERE I.ProductID <> D.ProductID
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.ContractID = D.ContractID WHERE I.PartnerID <> D.PartnerID)
	BEGIN
    INSERT INTO [dbo].[Contractlog](
				[ContractID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[ContractID], 'Módosítás-PartnerID', D.PartnerID, I.PartnerID, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.ContractID = D.ContractID
	WHERE I.PartnerID <> D.PartnerID
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.ContractID = D.ContractID WHERE I.OwnerID <> D.OwnerID)
	BEGIN
    INSERT INTO [dbo].[Contractlog](
				[ContractID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[ContractID], 'Módosítás-OwnerID', D.OwnerID, I.OwnerID, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.ContractID = D.ContractID
	WHERE I.OwnerID <> D.OwnerID
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.ContractID = D.ContractID WHERE I.ContractNumber <> D.ContractNumber)
	BEGIN
    INSERT INTO [dbo].[Contractlog](
				[ContractID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[ContractID], 'Módosítás-Kötvényszám', D.ContractNumber, I.ContractNumber, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.ContractID = D.ContractID
	WHERE I.ContractNumber <> D.ContractNumber
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.ContractID = D.ContractID WHERE I.Price <> D.Price)
	BEGIN
    INSERT INTO [dbo].[Contractlog](
				[ContractID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[ContractID], 'Módosítás-Éves Díj', D.Price, I.Price, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.ContractID = D.ContractID
	WHERE I.Price <> D.Price
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.ContractID = D.ContractID WHERE I.EndDate <> D.EndDate)
	BEGIN
    INSERT INTO [dbo].[Contractlog](
				[ContractID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[ContractID], 'Módosítás-Szerzõdés vége', D.EndDate, I.EndDate, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.ContractID = D.ContractID
	WHERE I.EndDate <> D.EndDate
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.ContractID = D.ContractID WHERE I.PayPeriodID <> D.PayPeriodID)
	BEGIN
    INSERT INTO [dbo].[Contractlog](
				[ContractID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[ContractID], 'Módosítás-Fizetési ütem',DM2.[Value], DM1.[Value], SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.ContractID = D.ContractID
	JOIN dbo.DictMain AS DM1 ON I.PayPeriodID = DM1.[Value]
	JOIN dbo.DictMain AS DM2 ON D.PayPeriodID = DM2.[Value]
	WHERE I.PayPeriodID <> D.PayPeriodID
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.ContractID = D.ContractID WHERE I.PaymentTypeID <> D.PaymentTypeID)
	BEGIN
    INSERT INTO [dbo].[Contractlog](
				[ContractID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[ContractID], 'Módosítás-Fizetési mód', DM2.[Value], DM1.[Value], SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.ContractID = D.ContractID
	JOIN dbo.DictMain AS DM1 ON I.PaymentTypeID = DM1.[Value]
	JOIN dbo.DictMain AS DM2 ON D.PaymentTypeID = DM2.[Value]
	WHERE I.PaymentTypeID <> D.PaymentTypeID
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.ContractID = D.ContractID WHERE I.Anndate <> D.Anndate)
	BEGIN
    INSERT INTO [dbo].[Contractlog](
				[ContractID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[ContractID], 'Módosítás-Évforduló', D.Anndate, I.Anndate, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.ContractID = D.ContractID
	WHERE I.Anndate <> D.Anndate
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.ContractID = D.ContractID WHERE I.ContractStateID <> D.ContractStateID)
	BEGIN
    INSERT INTO [dbo].[Contractlog](
				[ContractID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[ContractID], 'Módosítás-Szerz.Állapot', DM2.[Value], DM1.[Value], SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.ContractID = D.ContractID
	JOIN dbo.DictMain AS DM1 ON I.ContractStateID = DM1.[Value]
	JOIN dbo.DictMain AS DM2 ON D.ContractStateID = DM2.[Value]
	WHERE I.ContractStateID <> D.ContractStateID
	END
END TRY
	BEGIN CATCH
        RAISERROR(20002, -1,-1, 'Hiba a Contractlog Triggerben')
    END CATCH
END

GO

ALTER TABLE [dbo].[Contract] ENABLE TRIGGER [TR_Contract]
GO


