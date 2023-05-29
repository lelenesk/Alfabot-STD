USE [Alfabot]
GO

/****** Object:  Trigger [dbo].[TR_Partner]    Script Date: 2023. 05. 28. 23:16:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   TRIGGER [dbo].[TR_Partner]
ON [dbo].[Partner]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY 
IF EXISTS (SELECT 1 FROM INSERTED AS I FULL OUTER JOIN DELETED D ON I.PartnerID = D.PartnerID WHERE
	(D.PartnerID IS NULL OR I.PartnerID IS NULL))
	BEGIN
    INSERT INTO [dbo].[Partnerlog](
				[PartnerID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[PartnerID], '�j felvitel', '-', CONCAT_WS(' ', I.LastName, I.FirstName, 'PID', I.PartnerID, I.PartnerComment), SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I

    INSERT INTO [dbo].[Partnerlog](
				[PartnerID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
    SELECT D.[PartnerID], 'T�rl�s', CONCAT_WS(' ', D.LastName, D.FirstName, 'PID', D.PartnerID, D.PartnerComment), '-', SYSDATETIME(), SUSER_SNAME()								
    FROM DELETED AS D
    END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.PartnerID = D.PartnerID WHERE I.OwnerID <> D.Ownerid)
	BEGIN
    INSERT INTO [dbo].[Partnerlog](
				[PartnerID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[PartnerID], 'M�dos�t�s-OwnerID', I.OwnerID, I.LastName, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.PartnerID = D.PartnerID
	WHERE I.OwnerID <> D.Ownerid
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.PartnerID = D.PartnerID WHERE I.LastName <> D.LastName)
	BEGIN
    INSERT INTO [dbo].[Partnerlog](
				[PartnerID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[PartnerID], 'M�dos�t�s-LastName', D.LastName, I.LastName, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.PartnerID = D.PartnerID
	WHERE I.LastName <> D.LastName
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.PartnerID = D.PartnerID WHERE I.FirstName <> D.FirstName)
	BEGIN
    INSERT INTO [dbo].[Partnerlog](
				[PartnerID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[PartnerID], 'M�dos�t�s-FirstName', D.FirstName, I.FirstName, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.PartnerID = D.PartnerID
	WHERE I.FirstName <> D.FirstName
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.PartnerID = D.PartnerID WHERE I.CompanyName <> D.CompanyName)
	BEGIN
    INSERT INTO [dbo].[Partnerlog](
				[PartnerID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[PartnerID], 'M�dos�t�s-CompanyName', D.CompanyName, I.CompanyName, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.PartnerID = D.PartnerID
	WHERE I.CompanyName <> D.CompanyName
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.PartnerID = D.PartnerID WHERE I.CompanyType <> D.CompanyType)
	BEGIN
    INSERT INTO [dbo].[Partnerlog](
				[PartnerID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[PartnerID], 'M�dos�t�s-CompanyType', D.CompanyType, I.CompanyType, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.PartnerID = D.PartnerID
	WHERE I.CompanyType <> D.CompanyType
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.PartnerID = D.PartnerID WHERE I.UserName <> D.Username)
	BEGIN
    INSERT INTO [dbo].[Partnerlog](
				[PartnerID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[PartnerID], 'M�dos�t�s-Felh.N�v.', D.UserName, I.UserName, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.PartnerID = D.PartnerID
	WHERE I.UserName <> D.Username
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.PartnerID = D.PartnerID WHERE I.ContactPerson <> D.ContactPerson)
	BEGIN
    INSERT INTO [dbo].[Partnerlog](
				[PartnerID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[PartnerID], 'M�dos�t�s-Kapcs.Tart�(c�g)', D.ContactPerson, I.ContactPerson, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.PartnerID = D.PartnerID
	WHERE I.ContactPerson <> D.ContactPerson
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.PartnerID = D.PartnerID WHERE I.TaxPayerNo <> D.TaxPayerNo)
	BEGIN
    INSERT INTO [dbo].[Partnerlog](
				[PartnerID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[PartnerID], 'M�dos�t�s-Ad�sz�m', D.TaxPayerNo, I.TaxPayerNo, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.PartnerID = D.PartnerID
	WHERE I.TaxPayerNo <> D.TaxPayerNo
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.PartnerID = D.PartnerID WHERE I.IDNumber1 <> D.IDNumber1)
	BEGIN
	INSERT INTO [dbo].[Partnerlog](
				[PartnerID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[PartnerID], 'M�dos�t�s-ID1', D.IDNumber1, I.IDNumber1, SYSDATETIME(), SUSER_SNAME()
	FROM INSERTED AS I INNER JOIN DELETED D ON I.PartnerID = D.PartnerID
	WHERE I.IDNumber1 <> D.IDNumber1
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.PartnerID = D.PartnerID WHERE I.IDNumber2 <> D.IDNumber2)
	BEGIN
	INSERT INTO [dbo].[Partnerlog](
				[PartnerID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[PartnerID], 'M�dos�t�s-ID2', D.IDNumber2, I.IDNumber2, SYSDATETIME(), SUSER_SNAME()
	FROM INSERTED AS I INNER JOIN DELETED D ON I.PartnerID = D.PartnerID
	WHERE I.IDNumber2 <> D.IDNumber2
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.PartnerID = D.PartnerID WHERE I.CountryCodeH <> D.CountryCodeH)
	BEGIN
	INSERT INTO [dbo].[Partnerlog](
				[PartnerID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[PartnerID], 'M�dos�t�s-Orsz�gk�d', D.CountryCodeH, I.CountryCodeH, SYSDATETIME(), SUSER_SNAME()
	FROM INSERTED AS I INNER JOIN DELETED D ON I.PartnerID = D.PartnerID
	WHERE I.CountryCodeH <> D.CountryCodeH
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.PartnerID = D.PartnerID WHERE I.PostalCodeH <> D.PostalCodeH)
	BEGIN
	INSERT INTO [dbo].[Partnerlog](
				[PartnerID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[PartnerID], 'M�dos�t�s-Irsza', D.PostalCodeH, I.PostalCodeH, SYSDATETIME(), SUSER_SNAME()
	FROM INSERTED AS I INNER JOIN DELETED D ON I.PartnerID = D.PartnerID
	WHERE I.PostalCodeH <> D.PostalCodeH
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.PartnerID = D.PartnerID WHERE I.CityH <> D.CityH)
	BEGIN
    INSERT INTO [dbo].[Partnerlog](
				[PartnerID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[PartnerID], 'M�dos�t�s-V�ros', D.CityH, I.CityH, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.PartnerID = D.PartnerID
	WHERE I.CityH <> D.CityH
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.PartnerID = D.PartnerID WHERE I.AddressH <> D.AddressH)
	BEGIN
    INSERT INTO [dbo].[Partnerlog](
				[PartnerID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[PartnerID], 'M�dos�t�s-C�m', D.AddressH, I.AddressH, SYSDATETIME(), SUSER_SNAME()
    FROM INSERTED AS I INNER JOIN DELETED D ON I.PartnerID = D.PartnerID
	WHERE I.AddressH <> D.AddressH
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.PartnerID = D.PartnerID WHERE I.Phone1 <> D.Phone1)
	BEGIN
	INSERT INTO [dbo].[Partnerlog](
				[PartnerID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[PartnerID], 'M�dos�t�s-Tel.sz�m.', D.Phone1, I.Phone1, SYSDATETIME(), SUSER_SNAME()
	FROM INSERTED AS I INNER JOIN DELETED D ON I.PartnerID = D.PartnerID
	WHERE I.Phone1 <> D.Phone1
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.PartnerID = D.PartnerID WHERE I.Email1 <> D.Email1)
	BEGIN
	INSERT INTO [dbo].[Partnerlog](
				[PartnerID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[PartnerID], 'M�dos�t�s-Email c�m', D.Email1, I.Email1, SYSDATETIME(), SUSER_SNAME()
	FROM INSERTED AS I INNER JOIN DELETED D ON I.PartnerID = D.PartnerID
	WHERE I.Email1 <> D.Email1
	END
ELSE IF EXISTS (SELECT 1 FROM INSERTED AS I JOIN DELETED D ON I.PartnerID = D.PartnerID WHERE I.BankAccountNo <> D.BankAccountNo)
	BEGIN
	INSERT INTO [dbo].[Partnerlog](
				[PartnerID], [ActionType], [FromValue], [ToValue], [ActionDate], [ModUser])
	SELECT I.[PartnerID], 'M�dos�t�s-Banksz�mla', D.BankAccountNo, I.BankAccountNo, SYSDATETIME(), SUSER_SNAME()
	FROM INSERTED AS I INNER JOIN DELETED D ON I.PartnerID = D.PartnerID
	WHERE I.BankAccountNo <> D.BankAccountNo
	END
END TRY
	BEGIN CATCH
        RAISERROR(20001, -1,-1, 'Hiba a Partnerlog Triggerben')
    END CATCH
END

GO

ALTER TABLE [dbo].[Partner] ENABLE TRIGGER [TR_Partner]
GO


