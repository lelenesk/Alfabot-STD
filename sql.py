from sqlalchemy import text
import pyodbc


def get_vpartnerdata(name, engine):

    with engine.connect() as connection:
        query = f"SELECT * FROM dbo.vPartnerData WHERE [Ügyfél teljes neve] LIKE '%{name}%'"
        result = connection.execute(text(query))
        table = result.first()

        return table


def get_vcontractdata(name, engine):

    with engine.connect() as connection:
        query = f"SELECT * FROM dbo.vContractData WHERE [Ügyfél teljes neve] LIKE '%{name}%'"
        result = connection.execute(text(query))
        table = result.first()

        return table


def get_eventhandler(bn, ann, con):
    c = pyodbc.connect(con, autocommit=True)
    q_text = f"EXEC dbo.EventHandler @BN = '{bn}', @ANN = '{ann}'"
    curs = c.cursor()
    data = curs.execute(q_text)
    table = []
    for row in data.fetchall():
        table.append(list(row))

    return table


def get_vmonthlysales(con):
    c = pyodbc.connect(con, autocommit=True)
    q_text = f"SELECT * FROM dbo.vMonthlySales"
    curs = c.cursor()
    data = curs.execute(q_text)
    table = []
    for row in data.fetchall():
        table.append(list(row))

    return table


def get_vpartnerstat(engine):
    with engine.connect() as connection:
        query = f"SELECT * FROM dbo.vPartnerStat"
        result = connection.execute(text(query))
        table = result.first()

        return table


def get_banknovalidator(bankno, con):
    c = pyodbc.connect(con, autocommit=True)

    if bankno == '':
        bankno = None

    q_text = f"SELECT [dbo].[BankNoValidator](?)"
    curs = c.cursor()
    data = curs.execute(q_text, bankno)
    scalar_value = data.fetchone()

    return scalar_value[0]


def get_taxnovalidator(taxno, type, date, con):
    c = pyodbc.connect(con, autocommit=True)

    if date == '':
        date = None
    if taxno == '':
        taxno = None
    if type == '':
        type = None

    q_text = f"SELECT [dbo].[TPNValidator](?,?,?)"
    curs = c.cursor()
    data = curs.execute(q_text, taxno, str(type), date)
    scalar_value = data.fetchone()

    return scalar_value[0]


def get_citychehcker(cityno, city, con):
    c = pyodbc.connect(con, autocommit=True)

    if city == '':
        city = None
    if cityno == '':
        cityno = None

    q_text = f"SELECT [dbo].[CityChecker](?,?)"
    curs = c.cursor()
    data = curs.execute(q_text, city, cityno)
    scalar_value = data.fetchone()

    return scalar_value[0]


def get_distanchecker(city1, city2, con):
    c = pyodbc.connect(con, autocommit=True)

    if city1 == '':
        city1 = None
    if city2 == '':
        city2 = None

    q_text = f"SELECT [dbo].[DistanceInKM](?,?)"
    curs = c.cursor()
    data = curs.execute(q_text, city1, city2)
    scalar_value = data.fetchone()

    return scalar_value[0]


def get_genderchooser(name, con):
    c = pyodbc.connect(con, autocommit=True)

    if name == '':
        name = None

    q_text = f"SELECT [dbo].[GenderChooser](?)"
    curs = c.cursor()
    try:
        data = curs.execute(q_text, name)
        scalar_value = data.fetchone()
        return scalar_value[0]
    except:
        return 100


def get_moneyformatter(num, con):
    c = pyodbc.connect(con, autocommit=True)

    if num == '':
        num = None

    q_text = f"SELECT [dbo].[MoneyFormatter](?)"
    curs = c.cursor()
    try:
        data = curs.execute(q_text, num)
        scalar_value = data.fetchone()
        return scalar_value[0]
    except:
        return 100


def windows_login(sysadmin_con, ln, pw):
    c = pyodbc.connect(sysadmin_con, autocommit=True)
    q_text = f"""
    USE [master]
    CREATE LOGIN [{ln}] WITH PASSWORD=N'{pw}', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
    USE [Alfabot]
    CREATE USER [{ln}] FOR LOGIN [{ln}]
    USE [Alfabot]
    ALTER ROLE [db_owner] ADD MEMBER [{ln}]
"""
    curs = c.cursor()
    curs.execute(q_text)
