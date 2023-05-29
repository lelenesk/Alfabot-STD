import customtkinter as ctk
from sql import *
import tkinter as tk
from sqlalchemy import create_engine
from sqlalchemy.engine import URL
from configparser import ConfigParser
from ScrollableNotebook import *
from tkcalendar import DateEntry


def set_aut():
    parser = ConfigParser()
    parser.read('config.ini')

    with open('config.ini', 'w') as configfile:
        parser.write(configfile)

    driver = '{ODBC Driver 17 for SQL Server}'
    server = parser.get('Login', 'ServerName')
    ln = parser.get('Login', 'UserName')
    pw = parser.get('Login', 'Password')

    connection_string = f"DRIVER={driver};SERVER={server};DATABASE=Alfabot;UID={ln};PWD={pw}"
    connection_url = URL.create("mssql+pyodbc", query={"odbc_connect": connection_string})
    engine = create_engine(connection_url).execution_options(autocommit=True)

    con = f"Driver={driver};Server={server};Database=Alfabot;UID={ln};PWD={pw}"
    return engine, con


class LoginWidget(ctk.CTkFrame):
    def __init__(self, parent, login_check_func):
        super().__init__(master=parent)
        font = ctk.CTkFont(family="Helvetica", size=20, weight='bold')

        self.grid(column=0, columnspan=2, row=0, sticky='nsew')
        self.login_check_func = login_check_func
        self.label1 = ctk.CTkLabel(self, text='Szerver neve', font=font)
        self.label1.pack(expand=False, padx=10, pady=10)
        self.servarnameentry = ctk.CTkEntry(self, font=font)
        self.servarnameentry.pack(expand=False, padx=10, pady=10)
        self.label2 = ctk.CTkLabel(self, text='Felhasználónév', font=font)
        self.label2.pack(expand=False, padx=10, pady=10)
        self.uname_entry = ctk.CTkEntry(self, font=font)
        self.uname_entry.pack(expand=False, padx=10, pady=10)
        self.label3 = ctk.CTkLabel(self, text='Jelszó', font=font)
        self.label3.pack(expand=False, padx=10, pady=10)
        self.pw_entry = ctk.CTkEntry(self, font=font)
        self.pw_entry.pack(expand=False, padx=10, pady=10)
        self.button = ctk.CTkButton(self, text='Belépés', command=self.login_check, font=font)
        self.button.pack(expand=False, padx=10, pady=10)
        self.check_var = tk.IntVar()
        self.checkbox = ctk.CTkCheckBox(self, text="""
        Új Login létrehozása 
        (Windows autentikáció és 
        sysadmin jogosultság szükséges)""", variable=self.check_var, onvalue=1, offvalue=0, font=font)
        self.checkbox.pack(expand=False, padx=30, pady=30)

    def login_check(self):
        servername = self.servarnameentry.get()
        username = self.uname_entry.get()
        password = self.pw_entry.get()
        authentication = self.check_var.get()
        self.login_check_func(servername, username, password, authentication)


class MainArea(ctk.CTkFrame):
    def __init__(self, parent):
        super().__init__(master=parent)
        self.grid(row=0, column=1, columnspan=2, sticky='nsew')
        font = ctk.CTkFont(family="Helvetica", size=20, weight='bold')

        self.label = ctk.CTkLabel(self, text='Üdv, jó munkát!', font=font)
        self.label.grid(row=0, column=0, columnspan=2, padx=20, sticky="nsew")


class EmptyArea(ctk.CTkFrame):
    def __init__(self, parent):
        super().__init__(master=parent)
        self.grid(row=0, column=1, sticky='nsew')
        font = ctk.CTkFont(family="Helvetica", size=20, weight='bold')

        self.frame = ctk.CTkFrame(self)
        self.frame.grid(row=0, column=0, columnspan=3, rowspan=3, padx=20, sticky='nsew')
        self.label = ctk.CTkLabel(self.frame, font=font, text='El nem készült felület')
        self.label.grid(row=3, column=0, columnspan=3, rowspan=3,  padx=20, sticky='nsew')


class ClientSearchArea(ctk.CTkFrame):
    def __init__(self, parent):
        super().__init__(master=parent)
        self.grid(row=0, column=1, sticky='nsew')
        font = ctk.CTkFont(family="Helvetica", size=20, weight='bold')

        self.columnconfigure(0, weight=2, uniform='base3')
        self.columnconfigure(1, weight=2, uniform='base3')
        self.columnconfigure(2, weight=2, uniform='base3')
        self.columnconfigure(3, weight=2, uniform='base3')
        self.rowconfigure(0, weight=2, uniform='base2')
        self.rowconfigure(1, weight=2, uniform='base2')
        self.rowconfigure(2, weight=2, uniform='base2')
        self.rowconfigure(3, weight=2, uniform='base2')

        engine, con = set_aut()

        def button_func():
            partner_data = get_vpartnerdata(str(self.fentry1.get()), engine)

            self.table = ctk.CTkScrollableFrame(self)
            self.table.pack_propagate(False)
            self.table.columnconfigure(0, weight=2, uniform='base5')
            self.table.columnconfigure(1, weight=2, uniform='base5')
            self.table.columnconfigure(2, weight=2, uniform='base5')
            self.table.rowconfigure(0, weight=1, uniform='base5')
            self.table.rowconfigure(1, weight=1, uniform='base5')
            self.table.rowconfigure(2, weight=1, uniform='base5')
            self.table.rowconfigure(3, weight=1, uniform='base5')
            self.table.rowconfigure(4, weight=1, uniform='base5')
            self.table.rowconfigure(5, weight=1, uniform='base5')
            self.table.rowconfigure(6, weight=1, uniform='base5')
            self.table.rowconfigure(7, weight=1, uniform='base5')
            self.table.rowconfigure(8, weight=1, uniform='base5')
            self.table.rowconfigure(9, weight=1, uniform='base5')
            self.table.rowconfigure(10, weight=1, uniform='base5')
            self.table.rowconfigure(11, weight=1, uniform='base5')
            self.table.grid(row=1, column=0, columnspan=4, rowspan=3, pady=40, padx=20, sticky='nsew')

            self.label1 = ctk.CTkLabel(self.table, text='Partner azonosító', font=font, text_color='#539ce6')
            self.label1.grid(row=0, column=0, padx=10, pady=10, sticky='nsew')
            self.entry1 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50,
                                        hover=False, fg_color='#d3e8e8', font=font, text_color='Black',
                                        text=f"{partner_data[0]}")
            self.entry1.grid(row=1, column=0, padx=15, pady=15, sticky='nsew')

            self.label2 = ctk.CTkLabel(self.table, text='Üzletkötője:', font=font, text_color='#539ce6')
            self.label2.grid(row=0, column=1, padx=10, pady=10, sticky='nsew')
            self.entry2 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                        fg_color='#d3e8e8', font=font, text_color='Black', text=f"{partner_data[2]}")
            self.entry2.grid(row=1, column=1, padx=15, pady=15, sticky='nsew')

            self.label3 = ctk.CTkLabel(self.table, text='Teljes név', font=font, text_color='#539ce6')
            self.label3.grid(row=0, column=2, padx=10, pady=10, sticky='nsew')
            self.entry3 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                        fg_color='#d3e8e8', font=font, text_color='Black', text=f"{partner_data[3]}")
            self.entry3.grid(row=1, column=2, padx=15, pady=15, sticky='nsew')

            self.label4 = ctk.CTkLabel(self.table, text='Felhasználó név', font=font, text_color='#539ce6')
            self.label4.grid(row=2, column=0, padx=10, pady=10, sticky='nsew')
            self.entry4 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                        fg_color='#d3e8e8', font=font, text_color='Black', text=f"{partner_data[4]}")
            self.entry4.grid(row=3, column=0, padx=15, pady=15, sticky='nsew')

            self.label5 = ctk.CTkLabel(self.table, text='Szül.hely/Alapítás + Idő', font=font, text_color='#539ce6')
            self.label5.grid(row=2, column=1, padx=10, pady=10, sticky='nsew')
            self.entry5 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50,
                                        hover=False, fg_color='#d3e8e8', font=font, text_color='Black',
                                        text=f"{partner_data[5] + ' ' + partner_data[6]}")
            self.entry5.grid(row=3, column=1, padx=15, pady=15, sticky='nsew')

            self.label6 = ctk.CTkLabel(self.table, text='Adószám', font=font, text_color='#539ce6')
            self.label6.grid(row=2, column=2, padx=10, pady=10, sticky='nsew')
            self.entry6 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                        fg_color='#d3e8e8', font=font, text_color='Black', text=f"{partner_data[7]}")
            self.entry6.grid(row=3, column=2, padx=15, pady=15, sticky='nsew')

            self.label7 = ctk.CTkLabel(self.table, text='Okmány 1', font=font, text_color='#539ce6')
            self.label7.grid(row=4, column=0, padx=10, pady=10, sticky='nsew')
            self.entry7 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                        fg_color='#d3e8e8', font=font, text_color='Black', text=f"{partner_data[8]}")
            self.entry7.grid(row=5, column=0, padx=15, pady=15, sticky='nsew')

            self.label8 = ctk.CTkLabel(self.table, text='Okmány 2', font=font, text_color='#539ce6')
            self.label8.grid(row=4, column=1, padx=10, pady=10, sticky='nsew')
            self.entry8 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                        fg_color='#d3e8e8', font=font, text_color='Black', text=f"{partner_data[9]}")
            self.entry8.grid(row=5, column=1, padx=15, pady=15, sticky='nsew')

            self.label9 = ctk.CTkLabel(self.table, text='Kapcsolattartó(cég esetén)', font=font, text_color='#539ce6')
            self.label9.grid(row=4, column=2, padx=10, pady=10, sticky='nsew')
            self.entry9 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                        fg_color='#d3e8e8', font=font, text_color='Black',
                                        text=f"{str(partner_data[10]).replace('None', '  ')}")
            self.entry9.grid(row=5, column=2, padx=15, pady=15, sticky='nsew')

            self.label10 = ctk.CTkLabel(self.table, text='Állandó lakcím', font=font, text_color='#539ce6')
            self.label10.grid(row=6, column=0, padx=10, pady=10, sticky='nsew')
            self.entry10 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                         fg_color='#d3e8e8', font=font, text_color='Black',
                                         text=f"{partner_data[11]}")
            self.entry10.grid(row=7, column=0, padx=15, pady=15, sticky='nsew')

            self.label11 = ctk.CTkLabel(self.table, text='Levelezési cím(ha van)', font=font, text_color='#539ce6')
            self.label11.grid(row=6, column=1, padx=10, pady=10, sticky='nsew')
            self.entry11 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                         fg_color='#d3e8e8', font=font, text_color='Black',
                                         text=f"{str(partner_data[12]).replace('', '   ')}")
            self.entry11.grid(row=7, column=1, padx=15, pady=15, sticky='nsew')

            self.label12 = ctk.CTkLabel(self.table, text='Telefonszám', font=font, text_color='#539ce6')
            self.label12.grid(row=6, column=2, padx=10, pady=10, sticky='nsew')
            self.entry12 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                         fg_color='#d3e8e8', font=font, text_color='Black',
                                         text=f"{partner_data[13]}")
            self.entry12.grid(row=7, column=2, padx=15, pady=15, sticky='nsew')

            self.label13 = ctk.CTkLabel(self.table, text='Telefonszám(másodlagos)', font=font, text_color='#539ce6')
            self.label13.grid(row=8, column=0, padx=10, pady=10, sticky='nsew')
            self.entry13 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                         fg_color='#d3e8e8', font=font, text_color='Black',
                                         text=f"{str(partner_data[14]).replace('None', '  ')}")
            self.entry13.grid(row=9, column=0, padx=15, pady=15, sticky='nsew')

            self.label14 = ctk.CTkLabel(self.table, text='Email cím', font=font, text_color='#539ce6')
            self.label14.grid(row=8, column=1, padx=10, pady=10, sticky='nsew')
            self.entry14 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                         fg_color='#d3e8e8', font=font, text_color='Black',
                                         text=f"{partner_data[15]}")
            self.entry14.grid(row=9, column=1, padx=15, pady=15, sticky='nsew')

            self.label15 = ctk.CTkLabel(self.table, text='Email cím(másodlagos)', font=font, text_color='#539ce6')
            self.label15.grid(row=8, column=2, padx=10, pady=10, sticky='nsew')
            self.entry15 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                         fg_color='#d3e8e8', font=font, text_color='Black',
                                         text=f"{str(partner_data[16]).replace('None', '  ')}")
            self.entry15.grid(row=9, column=2, padx=15, pady=15, sticky='nsew')

            self.label16 = ctk.CTkLabel(self.table, text='Bankszámlaszám', font=font, text_color='#539ce6')
            self.label16.grid(row=10, column=0, padx=10, pady=10, sticky='nsew')
            self.entry16 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                         fg_color='#d3e8e8', font=font, text_color='Black',
                                         text=f"{partner_data[17]}")
            self.entry16.grid(row=11, column=0, padx=15, pady=15, sticky='nsew')

            self.label17 = ctk.CTkLabel(self.table, text='Ismeretség', font=font, text_color='#539ce6')
            self.label17.grid(row=10, column=1, padx=10, pady=10, sticky='nsew')
            self.entry17 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                         fg_color='#d3e8e8', font=font, text_color='Black',
                                         text=f"{partner_data[18]}")
            self.entry17.grid(row=11, column=1, padx=15, pady=15, sticky='nsew')

            self.label18 = ctk.CTkLabel(self.table, text='Ügyfélhez tartozó feladat azonoítók',
                                        font=font, text_color='#539ce6')
            self.label18.grid(row=10, column=2, padx=10, pady=10, sticky='nsew')
            self.entry18 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                         fg_color='#d3e8e8', font=font, text_color='Black',
                                         text=f"{partner_data[20]}")
            self.entry18.grid(row=11, column=2, padx=15, pady=15, sticky='nsew')

        self.frame1 = ctk.CTkFrame(self)
        self.frame1.pack_propagate(False)
        self.frame1.rowconfigure(0, weight=1, uniform='base8')
        self.frame1.rowconfigure(1, weight=1, uniform='base8')
        self.frame1.rowconfigure(2, weight=1, uniform='base8')
        self.frame1.columnconfigure(0, weight=1, uniform='base8')

        self.frame2 = ctk.CTkFrame(self)
        self.frame2.pack_propagate(False)
        self.frame2.rowconfigure(0, weight=1, uniform='base8')
        self.frame2.rowconfigure(1, weight=1, uniform='base8')
        self.frame2.rowconfigure(2, weight=1, uniform='base8')
        self.frame2.columnconfigure(0, weight=1, uniform='base8')

        self.frame3 = ctk.CTkFrame(self)
        self.frame3.pack_propagate(False)
        self.frame3.rowconfigure(0, weight=1, uniform='base8')
        self.frame3.rowconfigure(1, weight=1, uniform='base8')
        self.frame3.rowconfigure(2, weight=1, uniform='base8')
        self.frame3.columnconfigure(0, weight=1, uniform='base8')

        self.frame4 = ctk.CTkFrame(self)
        self.frame4.pack_propagate(False)
        self.frame4.rowconfigure(0, weight=1, uniform='base8')
        self.frame4.rowconfigure(1, weight=1, uniform='base8')
        self.frame4.rowconfigure(2, weight=1, uniform='base8')
        self.frame4.columnconfigure(0, weight=1, uniform='base8')

        self.frame1.grid(row=0, column=0, pady=20, padx=20, sticky='nsew')

        self.flabel1 = ctk.CTkLabel(self.frame1, text='Ügyfél neve', font=font)
        self.flabel1.grid(row=0, column=0, padx=5, sticky='nsew')
        self.fentry1 = ctk.CTkEntry(self.frame1, font=font)
        self.fentry1.grid(row=1, column=0, padx=5, sticky='nsew')
        self.fbutton1 = ctk.CTkButton(self.frame1, text='Keresd', command=button_func, font=font)
        self.fbutton1.grid(row=2, column=0, pady=5, sticky='nsew')

        self.frame2.grid(row=0, column=1, pady=20, padx=20, sticky='nsew')

        self.flabel2 = ctk.CTkLabel(self.frame2, text='Ügyfél címe', font=font)
        self.flabel2.grid(row=0, column=0, padx=5, sticky='nsew')
        self.fentry2 = ctk.CTkEntry(self.frame2, font=font, placeholder_text='inaktív func')
        self.fentry2.grid(row=1, column=0, padx=5, sticky='nsew')
        self.fbutton2 = ctk.CTkButton(self.frame2, text='Keresd', font=font)
        self.fbutton2.grid(row=2, column=0, pady=5, sticky='nsew')

        self.frame3.grid(row=0, column=2, pady=20, padx=20, sticky='nsew')

        self.flabel3 = ctk.CTkLabel(self.frame3, text='Telefonszám', font=font)
        self.flabel3.grid(row=0, column=0, padx=5, sticky='nsew')
        self.fentry3 = ctk.CTkEntry(self.frame3, font=font, placeholder_text='inaktív func')
        self.fentry3.grid(row=1, column=0, padx=5, sticky='nsew')
        self.fbutton3 = ctk.CTkButton(self.frame3, text='Keresd', font=font)
        self.fbutton3.grid(row=2, column=0, pady=5, sticky='nsew')

        self.frame4.grid(row=0, column=3, pady=20, padx=20, sticky='nsew')

        self.flabel4 = ctk.CTkLabel(self.frame4, text='Email', font=font)
        self.flabel4.grid(row=0, column=0, padx=5, sticky='nsew')
        self.fentry4 = ctk.CTkEntry(self.frame4, font=font, placeholder_text='inaktív func')
        self.fentry4.grid(row=1, column=0, padx=5, sticky='nsew')
        self.fbutton4 = ctk.CTkButton(self.frame4, text='Keresd', font=font)
        self.fbutton4.grid(row=2, column=0, pady=5, sticky='nsew')


class ContractSearchArea(ctk.CTkFrame):
    def __init__(self, parent):
        super().__init__(master=parent)
        self.grid(row=0, column=1, sticky='nsew')
        font = ctk.CTkFont(family="Helvetica", size=20, weight='bold')

        self.columnconfigure(0, weight=2, uniform='base3')
        self.columnconfigure(1, weight=2, uniform='base3')
        self.columnconfigure(2, weight=2, uniform='base3')
        self.columnconfigure(3, weight=2, uniform='base3')
        self.rowconfigure(0, weight=2, uniform='base2')
        self.rowconfigure(1, weight=2, uniform='base2')
        self.rowconfigure(2, weight=2, uniform='base2')
        self.rowconfigure(3, weight=2, uniform='base2')

        engine, con = set_aut()

        def button_func():
            contract_data = get_vcontractdata(str(self.fentry1.get()), engine)

            self.table = ctk.CTkScrollableFrame(self)
            self.table.pack_propagate(False)
            self.table.columnconfigure(0, weight=2, uniform='base5')
            self.table.columnconfigure(1, weight=2, uniform='base5')
            self.table.columnconfigure(2, weight=2, uniform='base5')
            self.table.rowconfigure(0, weight=1, uniform='base5')
            self.table.rowconfigure(1, weight=1, uniform='base5')
            self.table.rowconfigure(2, weight=1, uniform='base5')
            self.table.rowconfigure(3, weight=1, uniform='base5')
            self.table.rowconfigure(4, weight=1, uniform='base5')
            self.table.rowconfigure(5, weight=1, uniform='base5')
            self.table.rowconfigure(6, weight=1, uniform='base5')
            self.table.rowconfigure(7, weight=1, uniform='base5')
            self.table.rowconfigure(8, weight=1, uniform='base5')
            self.table.rowconfigure(9, weight=1, uniform='base5')
            self.table.grid(row=1, column=0, columnspan=4, rowspan=3, pady=40, padx=20, sticky='nsew')

            self.label1 = ctk.CTkLabel(self.table, text='Kötvényszám', font=font, text_color='#539ce6')
            self.label1.grid(row=0, column=0, padx=10, pady=10, sticky='nsew')
            self.entry1 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50,
                                        hover=False, fg_color='#d3e8e8', font=font, text_color='Black',
                                        text=f"{contract_data[1]}")
            self.entry1.grid(row=1, column=0, padx=15, pady=15, sticky='nsew')

            self.label2 = ctk.CTkLabel(self.table, text='Biztosító', font=font, text_color='#539ce6')
            self.label2.grid(row=0, column=1, padx=10, pady=10, sticky='nsew')
            self.entry2 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                        fg_color='#d3e8e8', font=font, text_color='Black', text=f"{contract_data[2]}")
            self.entry2.grid(row=1, column=1, padx=15, pady=15, sticky='nsew')

            self.label3 = ctk.CTkLabel(self.table, text='Módozat', font=font, text_color='#539ce6')
            self.label3.grid(row=0, column=2, padx=10, pady=10, sticky='nsew')
            self.entry3 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                        fg_color='#d3e8e8', font=font, text_color='Black', text=f"{contract_data[3]}")
            self.entry3.grid(row=1, column=2, padx=15, pady=15, sticky='nsew')

            self.label4 = ctk.CTkLabel(self.table, text='Termék', font=font, text_color='#539ce6')
            self.label4.grid(row=2, column=0, padx=10, pady=10, sticky='nsew')
            self.entry4 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                        fg_color='#d3e8e8', font=font, text_color='Black', text=f"{contract_data[4]}")
            self.entry4.grid(row=3, column=0, padx=15, pady=15, sticky='nsew')

            self.label5 = ctk.CTkLabel(self.table, text='Teljes név', font=font, text_color='#539ce6')
            self.label5.grid(row=2, column=1, padx=10, pady=10, sticky='nsew')
            self.entry5 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50,
                                        hover=False, fg_color='#d3e8e8', font=font, text_color='Black',
                                        text=f"{contract_data[5]}")
            self.entry5.grid(row=3, column=1, padx=15, pady=15, sticky='nsew')

            self.label6 = ctk.CTkLabel(self.table, text='Fizetési mód', font=font, text_color='#539ce6')
            self.label6.grid(row=2, column=2, padx=10, pady=10, sticky='nsew')
            self.entry6 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                        fg_color='#d3e8e8', font=font, text_color='Black', text=f"{contract_data[6]}")
            self.entry6.grid(row=3, column=2, padx=15, pady=15, sticky='nsew')

            self.label7 = ctk.CTkLabel(self.table, text='Fizetési ütem', font=font, text_color='#539ce6')
            self.label7.grid(row=4, column=0, padx=10, pady=10, sticky='nsew')
            self.entry7 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                        fg_color='#d3e8e8', font=font, text_color='Black', text=f"{contract_data[7]}")
            self.entry7.grid(row=5, column=0, padx=15, pady=15, sticky='nsew')

            self.label8 = ctk.CTkLabel(self.table, text='Szerződés állapota', font=font, text_color='#539ce6')
            self.label8.grid(row=4, column=1, padx=10, pady=10, sticky='nsew')
            self.entry8 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                        fg_color='#d3e8e8', font=font, text_color='Black', text=f"{contract_data[8]}")
            self.entry8.grid(row=5, column=1, padx=15, pady=15, sticky='nsew')

            self.label9 = ctk.CTkLabel(self.table, text='Évforduló', font=font, text_color='#539ce6')
            self.label9.grid(row=4, column=2, padx=10, pady=10, sticky='nsew')
            self.entry9 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                        fg_color='#d3e8e8', font=font, text_color='Black',
                                        text=f"{str(contract_data[9]).replace('None', '  ')}")
            self.entry9.grid(row=5, column=2, padx=15, pady=15, sticky='nsew')

            self.label10 = ctk.CTkLabel(self.table, text='Kockázatviselés kezdete', font=font, text_color='#539ce6')
            self.label10.grid(row=6, column=0, padx=10, pady=10, sticky='nsew')
            self.entry10 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                         fg_color='#d3e8e8', font=font, text_color='Black',
                                         text=f"{contract_data[10]}")
            self.entry10.grid(row=7, column=0, padx=15, pady=15, sticky='nsew')

            self.label11 = ctk.CTkLabel(self.table, text='Kockázatviselés vége(ha megszűnt)', font=font,
                                        text_color='#539ce6')
            self.label11.grid(row=6, column=1, padx=10, pady=10, sticky='nsew')
            self.entry11 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                         fg_color='#d3e8e8', font=font, text_color='Black',
                                         text=f"{str(contract_data[10])}")
            self.entry11.grid(row=7, column=1, padx=15, pady=15, sticky='nsew')

            self.label12 = ctk.CTkLabel(self.table, text='Éves díj', font=font, text_color='#539ce6')
            self.label12.grid(row=6, column=2, padx=10, pady=10, sticky='nsew')
            self.entry12 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                         fg_color='#d3e8e8', font=font, text_color='Black',
                                         text=f"{contract_data[12]}")
            self.entry12.grid(row=7, column=2, padx=15, pady=15, sticky='nsew')

            self.label13 = ctk.CTkLabel(self.table, text='Szerzési jutalék', font=font, text_color='#539ce6')
            self.label13.grid(row=8, column=0, padx=10, pady=10, sticky='nsew')
            self.entry13 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                         fg_color='#d3e8e8', font=font, text_color='Black',
                                         text=f"{str(contract_data[13]).replace('None', '  ')}")
            self.entry13.grid(row=9, column=0, padx=15, pady=15, sticky='nsew')

        self.frame1 = ctk.CTkFrame(self)
        self.frame1.pack_propagate(False)
        self.frame1.rowconfigure(0, weight=1, uniform='base8')
        self.frame1.rowconfigure(1, weight=1, uniform='base8')
        self.frame1.rowconfigure(2, weight=1, uniform='base8')
        self.frame1.columnconfigure(0, weight=1, uniform='base8')

        self.frame2 = ctk.CTkFrame(self)
        self.frame2.pack_propagate(False)
        self.frame2.rowconfigure(0, weight=1, uniform='base8')
        self.frame2.rowconfigure(1, weight=1, uniform='base8')
        self.frame2.rowconfigure(2, weight=1, uniform='base8')
        self.frame2.columnconfigure(0, weight=1, uniform='base8')

        self.frame3 = ctk.CTkFrame(self)
        self.frame3.pack_propagate(False)
        self.frame3.rowconfigure(0, weight=1, uniform='base8')
        self.frame3.rowconfigure(1, weight=1, uniform='base8')
        self.frame3.rowconfigure(2, weight=1, uniform='base8')
        self.frame3.columnconfigure(0, weight=1, uniform='base8')

        self.frame4 = ctk.CTkFrame(self)
        self.frame4.pack_propagate(False)
        self.frame4.rowconfigure(0, weight=1, uniform='base8')
        self.frame4.rowconfigure(1, weight=1, uniform='base8')
        self.frame4.rowconfigure(2, weight=1, uniform='base8')
        self.frame4.columnconfigure(0, weight=1, uniform='base8')

        self.frame1.grid(row=0, column=0, pady=20, padx=20, sticky='nsew')

        self.flabel1 = ctk.CTkLabel(self.frame1, text='Ügyfél neve', font=font)
        self.flabel1.grid(row=0, column=0, padx=5, sticky='nsew')
        self.fentry1 = ctk.CTkEntry(self.frame1, font=font)
        self.fentry1.grid(row=1, column=0, padx=5, sticky='nsew')
        self.fbutton1 = ctk.CTkButton(self.frame1, text='Keresd', command=button_func, font=font)
        self.fbutton1.grid(row=2, column=0, pady=5, sticky='nsew')

        self.frame2.grid(row=0, column=1, pady=20, padx=20, sticky='nsew')

        self.flabel2 = ctk.CTkLabel(self.frame2, text='Kötvényszám', font=font)
        self.flabel2.grid(row=0, column=0, padx=5, sticky='nsew')
        self.fentry2 = ctk.CTkEntry(self.frame2, font=font, placeholder_text='inaktív func')
        self.fentry2.grid(row=1, column=0, padx=5, sticky='nsew')
        self.fbutton2 = ctk.CTkButton(self.frame2, text='Keresd', font=font)
        self.fbutton2.grid(row=2, column=0, pady=5, sticky='nsew')

        self.frame3.grid(row=0, column=2, pady=20, padx=20, sticky='nsew')

        self.flabel3 = ctk.CTkLabel(self.frame3, text='Termék', font=font)
        self.flabel3.grid(row=0, column=0, padx=5, sticky='nsew')
        self.fentry3 = ctk.CTkEntry(self.frame3, font=font, placeholder_text='inaktív func')
        self.fentry3.grid(row=1, column=0, padx=5, sticky='nsew')
        self.fbutton3 = ctk.CTkButton(self.frame3, text='Keresd', font=font)
        self.fbutton3.grid(row=2, column=0, pady=5, sticky='nsew')

        self.frame4.grid(row=0, column=3, pady=20, padx=20, sticky='nsew')

        self.flabel4 = ctk.CTkLabel(self.frame4, text='Szerződés kötés dátuma', font=font)
        self.flabel4.grid(row=0, column=0, padx=5, sticky='nsew')
        self.fentry4 = ctk.CTkEntry(self.frame4, font=font, placeholder_text='inaktív func')
        self.fentry4.grid(row=1, column=0, padx=5, sticky='nsew')
        self.fbutton4 = ctk.CTkButton(self.frame4, text='Keresd', font=font)
        self.fbutton4.grid(row=2, column=0, pady=5, sticky='nsew')


class TaskEvHandlerArea(ctk.CTkFrame):
    def __init__(self, parent):
        super().__init__(master=parent)
        self.grid(row=0, column=1, sticky='nsew')
        font = ctk.CTkFont(family="Helvetica", size=20, weight='bold')

        self.columnconfigure(0, weight=2, uniform='base3')
        self.columnconfigure(1, weight=2, uniform='base3')
        self.columnconfigure(2, weight=2, uniform='base3')
        self.columnconfigure(3, weight=2, uniform='base3')
        self.rowconfigure(0, weight=2, uniform='base2')
        self.rowconfigure(1, weight=2, uniform='base2')
        self.rowconfigure(2, weight=2, uniform='base2')
        self.rowconfigure(3, weight=2, uniform='base2')

        engine, con = set_aut()

        self.frame = ctk.CTkFrame(self)
        self.frame.pack_propagate(False)
        self.frame.rowconfigure(0, weight=1, uniform='base8')
        self.frame.rowconfigure(1, weight=1, uniform='base8')
        self.frame.rowconfigure(2, weight=1, uniform='base8')
        self.frame.rowconfigure(3, weight=1, uniform='base8')
        self.frame.rowconfigure(4, weight=1, uniform='base8')
        self.frame.rowconfigure(5, weight=1, uniform='base8')
        self.frame.rowconfigure(6, weight=1, uniform='base8')
        self.frame.columnconfigure(0, weight=1, uniform='base8')
        self.frame.grid(row=0, column=1, padx=20, sticky='nsew')

        self.label1 = ctk.CTkLabel(self.frame, text='Születésnap', font=font)
        self.label1.grid(row=0, column=0,  padx=20, sticky='nsew')
        self.entry1 = ctk.CTkEntry(self.frame, font=font)
        self.entry1.grid(row=1, column=0,  padx=20, sticky='nsew')

        self.label2 = ctk.CTkLabel(self.frame, text='Névnap', font=font)
        self.label2.grid(row=2, column=0,  padx=20, sticky='nsew')
        self.entry2 = ctk.CTkEntry(self.frame, font=font)
        self.entry2.grid(row=3, column=0,  padx=20, sticky='nsew')

        self.label3 = ctk.CTkLabel(self.frame, text='Biztosítási évforduló', font=font)
        self.label3.grid(row=4, column=0,  padx=20, sticky='nsew')
        self.entry3 = ctk.CTkEntry(self.frame, font=font)
        self.entry3.grid(row=5, column=0,  padx=20, sticky='nsew')

        def button_func():

            birthday_value = self.entry1.get()
            nameday_value = self.entry2.get()
            ann_value = self.entry3.get()
            if birthday_value:
                bn_value = birthday_value
            else:
                bn_value = nameday_value
            data = get_eventhandler(str(bn_value), str(ann_value), con)

            style = ttk.Style()
            style.theme_use("default")
            style.configure("TNotebook",
                            tabmargins=[2, 5, 2, 0],
                            background='#282829', borderwidth=0)
            style.configure("TNotebook.Tab",
                            background="#539ce6",
                            compound='left',
                            expand=True,
                            font=font,
                            padding=[5, 1])
            style.map('TNotebook.Tab',
                      background=[('selected', "#ebeef5")],
                      expand=[("selected", [1, 1, 1, 0])])

            def add_tab(parent, contents, name):
                t_label1 = ctk.CTkFrame(self)
                t_label1.pack_propagate(False)
                t_label1.columnconfigure(0, weight=2, uniform='base5')
                t_label1.columnconfigure(1, weight=2, uniform='base5')
                t_label1.columnconfigure(2, weight=2, uniform='base5')
                t_label1.columnconfigure(3, weight=2, uniform='base5')

                labelm1 = ctk.CTkLabel(master=t_label1, text='Partneradatok:',
                                       text_color="black", wraplength=300, fg_color=("white", "#FFE45C"),
                                       height=80, corner_radius=6)
                labelm1.configure(font=font)
                labelm1.grid(row=0, rowspan=2, column=0, padx=5, pady=10, sticky="nsew")

                label2 = ctk.CTkLabel(master=t_label1, text=f'Név:\n{contents[2]}',
                                      text_color="white", wraplength=300, fg_color=("white", "#00468B"),
                                      height=70, corner_radius=6)
                label2.configure(font=font)

                label3 = ctk.CTkLabel(master=t_label1, justify='center', text=f'Esemény:\n{contents[22]}',
                                      text_color="white", wraplength=300,
                                      fg_color=("white", "#00468B"), height=70, corner_radius=6)
                label3.configure(font=font)

                label4 = ctk.CTkLabel(master=t_label1, text=f'Deadline:\n{contents[4]}',
                                      text_color="white", wraplength=300,
                                      fg_color=("white", "#00468B"), height=70, corner_radius=6)
                label4.configure(font=font)

                label2.grid(row=0, column=1, padx=0, pady=10, sticky="nsew")
                label3.grid(row=0, column=2, padx=10, pady=10, sticky="nsew")
                label4.grid(row=0, column=3, padx=0, pady=10, sticky="nsew")

                label5 = ctk.CTkLabel(master=t_label1, text=f'Telefonszám:\n{contents[17]}', text_color="white",
                                      wraplength=300, fg_color=("white", "#00468B"), height=70, corner_radius=6)
                label5.configure(font=font)

                label6 = ctk.CTkLabel(master=t_label1, text=f'Lakcím:\n{contents[16]}', text_color="white",
                                      wraplength=300,
                                      fg_color=("white", "#00468B"), height=70, corner_radius=6)
                label6.configure(font=font)

                label7 = ctk.CTkLabel(master=t_label1, text=f'Születési adatok:\n{contents[3]}', text_color="white",
                                      wraplength=300,
                                      fg_color=("white", "#00468B"), height=70, corner_radius=6)
                label7.configure(font=font)

                label5.grid(row=1, column=1, padx=0, pady=10, sticky="nsew")
                label6.grid(row=1, column=2, padx=10, pady=10, sticky="nsew")
                label7.grid(row=1, column=3, padx=0, pady=10, sticky="nsew")

                labelm3 = ctk.CTkLabel(master=t_label1, text='Szerződésadatok:',
                                       text_color="black", wraplength=300, fg_color=("white", "#FFE45C"),
                                       height=80, corner_radius=6)
                labelm3.configure(font=font)
                labelm3.grid(row=2, rowspan=2, column=0, padx=5, pady=10, sticky="nsew")

                label8 = ctk.CTkLabel(master=t_label1, text=f'Kötvényszám:\n{contents[8]}',
                                      text_color="white", wraplength=300, fg_color=("white", "#128FC8"),
                                      height=70, corner_radius=6)
                label8.configure(font=font)

                label9 = ctk.CTkLabel(master=t_label1, text=f'Terméknév:\n{contents[7]}',
                                      text_color="white", wraplength=300,
                                      fg_color=("white", "#128FC8"), height=70, corner_radius=6)
                label9.configure(font=font)

                label10 = ctk.CTkLabel(master=t_label1, text=f'Módozat:\n{contents[6]}',
                                       text_color="white", wraplength=300,
                                       fg_color=("white", "#128FC8"), height=70, corner_radius=6)
                label10.configure(font=font)

                label8.grid(row=2, column=1, padx=0, pady=10, sticky="nsew")
                label9.grid(row=2, column=2, padx=10, pady=10, sticky="nsew")
                label10.grid(row=2, column=3, padx=0, pady=10, sticky="nsew")

                label11 = ctk.CTkLabel(master=t_label1, text=f'Állapot:\n{contents[5]}', text_color="white",
                                       wraplength=300, fg_color=("white", "#128FC8"), height=70, corner_radius=6)
                label11.configure(font=font)

                label12 = ctk.CTkLabel(master=t_label1, text=f'Éves díj:\n{contents[9]}', text_color="white",
                                       wraplength=300,
                                       fg_color=("white", "#128FC8"), height=70, corner_radius=6)
                label12.configure(font=font)

                label13 = ctk.CTkLabel(master=t_label1, text=f'Egyenleg:\n{contents[11]}', text_color="white",
                                       wraplength=300,
                                       fg_color=("white", "#128FC8"), height=70, corner_radius=6)
                label13.configure(font=font)

                label11.grid(row=3, column=1, padx=0, pady=10, sticky="nsew")
                label12.grid(row=3, column=2, padx=10, pady=10, sticky="nsew")
                label13.grid(row=3, column=3, padx=0, pady=10, sticky="nsew")

                label5 = ctk.CTkLabel(master=t_label1, text=f'Telefonszám:\n{contents[17]}', text_color="white",
                                      wraplength=300, fg_color=("white", "#00468B"), height=70, corner_radius=6)
                label5.configure(font=font)

                label6 = ctk.CTkLabel(master=t_label1, text=f'e-mail:\n{contents[18]}', text_color="white",
                                      wraplength=300, fg_color=("white", "#00468B"), height=70, corner_radius=6)
                label6.configure(font=font)

                label7 = ctk.CTkLabel(master=t_label1, text=f'Cím:\n{contents[16]}', text_color="white",
                                      wraplength=300, fg_color=("white", "#00468B"), height=70, corner_radius=6)
                label7.configure(font=font)

                labelm3 = ctk.CTkLabel(master=t_label1, text='Egyéb információk:',
                                       text_color="black", wraplength=300, fg_color=("white", "#FFE45C"),
                                       height=80, corner_radius=6)
                labelm3.configure(font=font)
                labelm3.grid(row=4, rowspan=2, column=0, padx=5, pady=10, sticky="nsew")

                label8 = ctk.CTkLabel(master=t_label1, text=f'Ismertség eredete:\n{contents[19]}',
                                      text_color="black", wraplength=300, fg_color=("white", "#2ECBE9"),
                                      height=70, corner_radius=6)
                label8.configure(font=font)

                label9 = ctk.CTkLabel(master=t_label1, text=f'Email:\n{contents[18]}',
                                      text_color="black", wraplength=300,
                                      fg_color=("white", "#2ECBE9"), height=70, corner_radius=6)
                label9.configure(font=font)

                label10 = ctk.CTkLabel(master=t_label1, text=f'Kapcsolattartó azonosítója:\n{contents[1]}',
                                       text_color="black", wraplength=300,
                                       fg_color=("white", "#2ECBE9"), height=70, corner_radius=6)
                label10.configure(font=font)

                label8.grid(row=4, column=1, padx=0, pady=10, sticky="nsew")
                label9.grid(row=4, column=2, padx=10, pady=10, sticky="nsew")
                label10.grid(row=4, column=3, padx=0, pady=10, sticky="nsew")

                label11 = ctk.CTkLabel(master=t_label1, text=f'Utolsó tétel:\n{contents[13]}', text_color="black",
                                       wraplength=300, fg_color=("white", "#2ECBE9"), height=70, corner_radius=6)
                label11.configure(font=font)

                label12 = ctk.CTkLabel(master=t_label1, text=f'Tétel típusa:\n{contents[12]}', text_color="black",
                                       wraplength=300,
                                       fg_color=("white", "#2ECBE9"), height=70, corner_radius=6)
                label12.configure(font=font)

                label13 = ctk.CTkLabel(master=t_label1, text=f'időpontja:\n{contents[15]}', text_color="black",
                                       wraplength=300,
                                       fg_color=("white", "#2ECBE9"), height=70, corner_radius=6)
                label13.configure(font=font)

                label11.grid(row=5, column=1, padx=0, pady=10, sticky="nsew")
                label12.grid(row=5, column=2, padx=10, pady=10, sticky="nsew")
                label13.grid(row=5, column=3, padx=0, pady=10, sticky="nsew")

                parent.add(t_label1, text=name)

            self.tabControl = ScrollableNotebook(self, wheelscroll=True, tabmenu=True)
            self.tabControl.grid(row=1, column=0, columnspan=4, rowspan=4, padx=40, pady=20,
                                 sticky=tk.N + tk.S + tk.E + tk.W)
            for i in range(len(data)):
                add_tab(self.tabControl, data[i], str(data[i][22]) + "" + " " + str(i + 1))

        self.button = ctk.CTkButton(self.frame, text='Keresd', font=font, command=button_func)
        self.button.grid(row=6, column=0, padx=20)


class StatMonthlySalesArea(ctk.CTkFrame):
    def __init__(self, parent):
        super().__init__(master=parent)
        self.grid(row=0, column=1, sticky='nsew')
        font = ctk.CTkFont(family="Helvetica", size=20, weight='bold')

        self.columnconfigure(0, weight=2, uniform='base3')
        self.rowconfigure(0, weight=5, uniform='base2')
        self.rowconfigure(1, weight=5, uniform='base2')
        self.rowconfigure(2, weight=1, uniform='base2')

        engine, con = set_aut()
        data = get_vmonthlysales(con)

        col_names1 = ['Kolléga neve', 'Május', 'Április', 'Március', 'Február',
                      'Január', '2022 December']

        col_names2 = ['Kolléga neve', '2022 November', '2022 Október', '2022 Szeptember',
                      '2022 Agusztus', '2022 Július', '2022 Június', '2022 Május']
        df1 = []
        df2 = []
        for row in data:
            df1.append(row[0])
            df1.append(row[1])
            df1.append(row[2])
            df1.append(row[3])
            df1.append(row[4])
            df1.append(row[5])
            df1.append(row[6])
            df2.append(row[0])
            df2.append(row[7])
            df2.append(row[8])
            df2.append(row[9])
            df2.append(row[10])
            df2.append(row[11])
            df2.append(row[12])
            df2.append(row[13])

        style = ttk.Style()
        style.theme_use("default")
        style.configure("Treeview",
                        background="#2a2d2e",
                        foreground="white",
                        rowheight=40,
                        fieldbackground="#343638",
                        bordercolor="#343638",
                        borderwidth=0,
                        font=font)
        style.map('Treeview', background=[('selected', '#22559b')])
        style.configure("Treeview.Heading",
                        background="#565b5e",
                        foreground="white",
                        relief="flat",
                        font=font,
                        rowheight=60)
        style.configure("TScrollbar",
                        gripcount=0,
                        gripmargin=0,
                        background="#0881cc")
        style.map("Treeview.Heading",
                  background=[('active', '#3484F0')])

        #self.scrollbar1 = ttk.Scrollbar(self, style="TScrollbar", orient=tk.HORIZONTAL)
        self.tree1 = ttk.Treeview(self)#, xscrollcommand=self.scrollbar1.set)
        cols1 = len(col_names1)
        self.tree1["columns"] = tuple(range(cols1))
        self.tree1["show"] = "headings"

        for i in range(len(col_names1)):
            self.tree1.heading(i, text=f"{col_names1[i]}")

        for row in data:
            self.tree1.insert("", tk.END, values=row)

        self.tree1.grid(row=0, column=0, columnspan=2, sticky=tk.N + tk.S + tk.E + tk.W)
        #self.scrollbar1.grid(row=1, column=0, columnspan=2, sticky=tk.E + tk.W)
        #self.scrollbar1.config(command=self.tree1.xview)

        self.scrollbar2 = ttk.Scrollbar(self, style="TScrollbar", orient=tk.HORIZONTAL)
        self.tree2 = ttk.Treeview(self, xscrollcommand=self.scrollbar2.set)
        cols1 = len(col_names2)
        self.tree2["columns"] = tuple(range(cols1))
        self.tree2["show"] = "headings"

        for i in range(len(col_names2)):
            self.tree2.heading(i, text=f"{col_names2[i]}")

        for row in data:
            self.tree2.insert("", tk.END, values=row)

        self.tree2.grid(row=1, column=0, columnspan=2, sticky=tk.N + tk.S + tk.E + tk.W)
        self.scrollbar2.grid(row=2, column=0, columnspan=2, sticky=tk.E + tk.W)
        self.scrollbar2.config(command=self.tree2.xview)


class StatPartnerStatArea(ctk.CTkFrame):
    def __init__(self, parent):
        super().__init__(master=parent)
        self.grid(row=0, column=1, sticky='nsew')
        font = ctk.CTkFont(family="Helvetica", size=23, weight='bold')

        self.columnconfigure(0, weight=1, uniform='base3')
        self.rowconfigure(0, weight=1, uniform='base2')

        engine, con = set_aut()
        contract_data = get_vpartnerstat(engine)

        self.table = ctk.CTkScrollableFrame(self, orientation='vertical')
        self.table.columnconfigure(0, weight=1, uniform='base3')
        self.table.columnconfigure(1, weight=1, uniform='base3')
        self.table.rowconfigure(0, weight=1, uniform='base2')
        self.table.rowconfigure(1, weight=1, uniform='base2')
        self.table.rowconfigure(2, weight=1, uniform='base2')
        self.table.rowconfigure(3, weight=1, uniform='base2')
        self.table.rowconfigure(4, weight=1, uniform='base2')
        self.table.rowconfigure(5, weight=1, uniform='base2')
        self.table.rowconfigure(6, weight=1, uniform='base2')
        self.table.rowconfigure(7, weight=1, uniform='base2')
        self.table.rowconfigure(8, weight=1, uniform='base2')
        self.table.grid(row=0, column=0, pady=40, padx=20, sticky='nsew')

        self.entry1 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                    fg_color='#d3e8e8', font=font, text_color='darkblue', text=f"{contract_data[0]}")
        self.entry1.grid(row=0, column=0, pady=18, padx=18, sticky='nsew')

        self.entry2 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                    fg_color='#d3e8e8', font=font, text_color='darkblue', text=f"{contract_data[1]}")
        self.entry2.grid(row=1, column=0, pady=18, padx=18, sticky='nsew')

        self.entry3 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                    fg_color='#d3e8e8', font=font, text_color='darkblue', text=f"{contract_data[2]}")
        self.entry3.grid(row=2, column=0, pady=18, padx=18, sticky='nsew')

        self.entry4 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                    fg_color='#d3e8e8', font=font, text_color='darkblue', text=f"{contract_data[3]}")
        self.entry4.grid(row=3, column=0, pady=18, padx=18, sticky='nsew')

        self.entry5 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                    fg_color='#d3e8e8', font=font, text_color='darkblue', text=f"{contract_data[4]}")
        self.entry5.grid(row=4, column=0, pady=18, padx=18, sticky='nsew')

        self.entry6 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                    fg_color='#d3e8e8', font=font, text_color='darkblue', text=f"{contract_data[5]}")
        self.entry6.grid(row=5, column=0, pady=18, padx=18, sticky='nsew')

        self.entry7 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                    fg_color='#d3e8e8', font=font, text_color='darkblue', text=f"{contract_data[6]}")
        self.entry7.grid(row=6, column=0, pady=18, padx=18, sticky='nsew')

        self.entry8 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                    fg_color='#d3e8e8', font=font, text_color='darkgreen', text=f"{contract_data[7]}")
        self.entry8.grid(row=7, column=0, pady=18, padx=18, sticky='nsew')

        self.entry9 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                    fg_color='#d3e8e8', font=font, text_color='darkgreen',
                                    text=f"{str(contract_data[8])}")
        self.entry9.grid(row=8, column=0, pady=18, padx=18, sticky='nsew')

        self.entry10 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                     fg_color='#d3e8e8', font=font, text_color='darkgreen', text=f"{contract_data[9]}")
        self.entry10.grid(row=0, column=1, pady=18, padx=18, sticky='nsew')

        self.entry11 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                     fg_color='#d3e8e8', font=font, text_color='darkgreen',
                                     text=f"{str(contract_data[10])}")
        self.entry11.grid(row=1, column=1, pady=18, padx=18, sticky='nsew')

        self.entry12 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50,
                                     hover=False, fg_color='#d3e8e8', font=font, text_color='darkgreen',
                                     text=f"{contract_data[11]}")
        self.entry12.grid(row=2, column=1, pady=18, padx=18, sticky='nsew')

        self.entry13 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                     fg_color='#d3e8e8', font=font, text_color='Black',
                                     text=f"{str(contract_data[12])}")
        self.entry13.grid(row=3, column=1, pady=18, padx=18, sticky='nsew')

        self.entry14 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                     fg_color='#d3e8e8', font=font, text_color='Black',
                                     text=f"{str(contract_data[13])}")
        self.entry14.grid(row=4, column=1, pady=18, padx=18, sticky='nsew')

        self.entry15 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                     fg_color='#d3e8e8', font=font, text_color='darkred',
                                     text=f"{str(contract_data[14])}")
        self.entry15.grid(row=5, column=1, pady=18, padx=18, sticky='nsew')

        self.entry16 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                     fg_color='#d3e8e8', font=font, text_color='darkred',
                                     text=f"{str(contract_data[15])}")
        self.entry16.grid(row=6, column=1, pady=18, padx=18, sticky='nsew')

        self.entry17 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                     fg_color='#d3e8e8', font=font, text_color='Black',
                                     text=f"{str(contract_data[16])}")
        self.entry17.grid(row=7, column=1, pady=18, padx=18, sticky='nsew')

        self.entry18 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                     fg_color='#d3e8e8', font=font, text_color='Black',
                                     text=f"{str(contract_data[17])}")
        self.entry18.grid(row=8, column=1, pady=18, padx=18, sticky='nsew')

        self.entry19 = ctk.CTkButton(self.table, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                     fg_color='#d3e8e8', font=font, text_color='red',
                                     text=f"{str(contract_data[18])}")
        self.entry19.grid(row=9, column=0, columnspan=2, pady=18, padx=18, sticky='nsew')


class TestArea(ctk.CTkFrame):
    def __init__(self, parent):
        super().__init__(master=parent)
        self.grid(row=0, column=1, sticky='nsew')
        font = ctk.CTkFont(family="Helvetica", size=20, weight='bold')

        self.columnconfigure(0, weight=1, uniform='base3')
        self.columnconfigure(1, weight=1, uniform='base3')
        self.rowconfigure(0, weight=1, uniform='base2')
        self.rowconfigure(1, weight=1, uniform='base2')

        engine, con = set_aut()

        def button_func1():
            bankno_result = get_banknovalidator(self.entry1.get(), con)

            if bankno_result == 0:
                self.button2.configure(text='Érvényes számlaszám(nem biztos hogy létező is)', font=font,
                                       fg_color='green')
            elif bankno_result == 1:
                self.button2.configure(text='Hibás számlaszám(hossz, formátum)', font=font, fg_color='red')
            elif bankno_result == 2:
                self.button2.configure(text='Hibás számlaszám(karakter)', font=font, fg_color='red')
            elif bankno_result == 3:
                self.button2.configure(text='Nem létező bank', font=font, fg_color='red')
            elif bankno_result == 4:
                self.button2.configure(text='Elleneörző összeg hiba', font=font, fg_color='red')
            elif bankno_result == 5:
                self.button2.configure(text='Érvénytelen számlaszám', font=font, fg_color='yellow')
            elif bankno_result == 6:
                self.button2.configure(text='Nem magyar bank(IBAN)', font=font, fg_color='red')
            else:
                self.button2.configure(text='Ismeretlen hiba', font=font, fg_color='yellow')

        def button_func2():
            if self.combobox1.get() == 'Cég':
                choose = 1
            else:
                choose = 0
            taxno_result = get_taxnovalidator(self.entry3.get(), choose, self.dateentry4.get(), con)

            if taxno_result == 0:
                self.button4.configure(text='Érvényes szám(és születési dátum pár, ha van)',
                                       font=font, fg_color='green')
            elif taxno_result == 1:
                self.button4.configure(text='Hibás adószám(hossz, formátum)', font=font, fg_color='red')
            elif taxno_result == 2:
                self.button4.configure(text='hibás ellenőrzőszám', font=font, fg_color='red')
            elif taxno_result == 3:
                self.button4.configure(text='Cégnek/magánszemélynek próbál feltünni', font=font, fg_color='red')
            elif taxno_result == 4:
                self.button4.configure(text='Helytelen adat', font=font, fg_color='yellow')
            else:
                self.button4.configure(text='Ismeretlen hiba', font=font, fg_color='yellow')

        def button_func3():
            city_result = get_citychehcker(self.entry5.get(), self.entry6.get(), con)

            if city_result == '0':
                self.button6.configure(text='Létező párosítás', font=font, fg_color='green')
            elif city_result == '1':
                self.button6.configure(text='Hibás adat', font=font, fg_color='red')
            elif city_result == '2':
                self.button6.configure(text='Hibás párosítás', font=font, fg_color='red')
            elif type(city_result) == str:
                self.button6.configure(text=f'{city_result} a keresett adat', font=font, fg_color='yellow',
                                       text_color='black')
            else:
                self.button6.configure(text='Ismeretlen hiba', font=font, fg_color='yellow')

        def button_func4():
            distance_result = get_distanchecker(self.entry7.get(), self.entry8.get(), con)

            if type(distance_result) == str:
                self.button8.configure(text=f'{distance_result} KM a távolság', font=font, fg_color='yellow',
                                       text_color='black')
            else:
                self.button8.configure(text='Ellenőrizd a bevitt adatokat', font=font, fg_color='red')

        style = ttk.Style()
        style.theme_use('clam')
        style.configure('my.DateEntry',
                        fieldbackground='#282829',
                        background='#282829',
                        foreground='#539ce6',
                        arrowcolor='#539ce6')

        self.frame1 = ctk.CTkFrame(self)
        self.frame1.pack_propagate(False)
        self.frame1.columnconfigure(0, weight=1, uniform='base4')
        self.frame1.columnconfigure(1, weight=1, uniform='base4')
        self.frame1.columnconfigure(2, weight=1, uniform='base4')
        self.frame1.rowconfigure(0, weight=1, uniform='base4')
        self.frame1.rowconfigure(1, weight=1, uniform='base4')
        self.frame1.rowconfigure(2, weight=1, uniform='base4')
        self.frame1.rowconfigure(3, weight=1, uniform='base4')
        self.frame1.grid(row=0, column=0, pady=20, padx=20, sticky='nsew')

        self.label1 = ctk.CTkLabel(self.frame1, text='Bankszámlaszám', font=font)
        self.label1.grid(row=0, column=0, columnspan=3, pady=5, sticky='ew')

        self.entry1 = ctk.CTkEntry(self.frame1, font=font, height=50)
        self.entry1.grid(row=1, column=0, columnspan=3, pady=5, padx=20, sticky='ew')

        self.button1 = ctk.CTkButton(self.frame1, text='Mutasd', command=button_func1, font=font)
        self.button1.grid(row=2, column=1, pady=10,  sticky='ew')

        self.button2 = ctk.CTkButton(self.frame1, hover=False, text='    ', font=font)
        self.button2.grid(row=3, column=0, columnspan=3, pady=15, padx=20, sticky='nsew')

        self.frame2 = ctk.CTkFrame(self)
        self.frame2.pack_propagate(False)
        self.frame2.columnconfigure(0, weight=2, uniform='base4')
        self.frame2.columnconfigure(1, weight=1, uniform='base4')
        self.frame2.columnconfigure(2, weight=1, uniform='base4')
        self.frame2.columnconfigure(3, weight=1, uniform='base4')
        self.frame2.columnconfigure(4, weight=2, uniform='base4')
        self.frame2.rowconfigure(0, weight=1, uniform='base4')
        self.frame2.rowconfigure(1, weight=1, uniform='base4')
        self.frame2.rowconfigure(2, weight=1, uniform='base4')
        self.frame2.rowconfigure(3, weight=1, uniform='base4')
        self.frame2.grid(row=0, column=1, pady=20, padx=20, sticky='nsew')

        self.label2 = ctk.CTkLabel(self.frame2, text='Adószám/Adóazonosító', font=font)
        self.label2.grid(row=0, column=0, columnspan=5, padx=5, sticky='nsew')

        self.entry3 = ctk.CTkEntry(self.frame2, font=font, placeholder_text='Azonosító', height=50)
        self.entry3.grid(row=1, column=3, columnspan=2, padx=5, sticky='ew')

        self.combobox1 = ctk.CTkComboBox(self.frame2, values=['Cég', 'Magánszemély'], font=font, height=50)
        self.combobox1.grid(row=1, column=0, padx=5, sticky='ew')

        self.dateentry4 = DateEntry(self.frame2, selectmode='day', font=font, height=100, style='my.DateEntry',
                                date_pattern='yyyy.MM.dd', year=1982, month=6, day=16)
        self.dateentry4.configure(validate='none')
        x = self.dateentry4.winfo_rootx() + self.dateentry4.winfo_width() - self.dateentry4._top_cal.winfo_reqwidth()
        y = self.dateentry4.winfo_rooty() + self.dateentry4.winfo_height()
        self.dateentry4._top_cal.geometry('+%i+%i' % (x, y))
        self.dateentry4.grid(row=1, column=1, columnspan=2, padx=5, sticky='ew')

        self.button3 = ctk.CTkButton(self.frame2, text='Mutasd', command=button_func2, font=font)
        self.button3.grid(row=2, column=1, columnspan=2, pady=10, padx=10, sticky='ew')

        self.button4 = ctk.CTkButton(self.frame2, hover=False, text='    ', font=font)
        self.button4.grid(row=3, column=0, columnspan=5, pady=15, padx=20, sticky='nsew')

        self.frame3 = ctk.CTkFrame(self)
        self.frame3.pack_propagate(False)
        self.frame3.columnconfigure(0, weight=1, uniform='base4')
        self.frame3.columnconfigure(1, weight=1, uniform='base4')
        self.frame3.columnconfigure(2, weight=1, uniform='base4')

        self.frame3.rowconfigure(0, weight=1, uniform='base4')
        self.frame3.rowconfigure(1, weight=1, uniform='base4')
        self.frame3.rowconfigure(2, weight=1, uniform='base4')
        self.frame3.rowconfigure(3, weight=1, uniform='base4')
        self.frame3.grid(row=1, column=0, pady=20, padx=20, sticky='nsew')

        self.label3 = ctk.CTkLabel(self.frame3, text='Cím-pár', font=font)
        self.label3.grid(row=0, column=0, columnspan=3, padx=5, sticky='nsew')

        self.entry5 = ctk.CTkEntry(self.frame3, placeholder_text='Irányítószám', font=font, height=50)
        self.entry5.grid(row=1, column=0, padx=5, sticky='ew')

        self.entry6 = ctk.CTkEntry(self.frame3, placeholder_text='Település', font=font, height=50)
        self.entry6.grid(row=1, column=1, columnspan=2, padx=5, sticky='ew')

        self.button5 = ctk.CTkButton(self.frame3, text='Mutasd', command=button_func3, font=font)
        self.button5.grid(row=2, column=1, pady=10, padx=5, sticky='ew')

        self.button6 = ctk.CTkButton(self.frame3, hover=False, text='      ', font=font)
        self.button6.grid(row=3, column=0, columnspan=3, pady=15, padx=20, sticky='nsew')

        self.frame4 = ctk.CTkFrame(self)
        self.frame4.pack_propagate(False)
        self.frame4.columnconfigure(0, weight=1, uniform='base4')
        self.frame4.columnconfigure(1, weight=0, uniform='base4')
        self.frame4.columnconfigure(2, weight=1, uniform='base4')

        self.frame4.rowconfigure(0, weight=1, uniform='base4')
        self.frame4.rowconfigure(1, weight=1, uniform='base4')
        self.frame4.rowconfigure(2, weight=1, uniform='base4')
        self.frame4.rowconfigure(3, weight=1, uniform='base4')
        self.frame4.grid(row=1, column=1, pady=20, padx=20, sticky='nsew')

        self.label4 = ctk.CTkLabel(self.frame4, text='Települések közti távolság', font=font)
        self.label4.grid(row=0, column=0, columnspan=3, padx=5, sticky='nsew')

        self.entry7 = ctk.CTkEntry(self.frame4, font=font, height=50)
        self.entry7.grid(row=1, column=0, padx=5, sticky='ew')

        self.entry8 = ctk.CTkEntry(self.frame4, font=font, height=50)
        self.entry8.grid(row=1, column=2, padx=5, sticky='ew')

        self.button7 = ctk.CTkButton(self.frame4, text='Mutasd', command=button_func4, font=font)
        self.button7.grid(row=2, column=1, pady=10, padx=5, sticky='ew')

        self.button8 = ctk.CTkButton(self.frame4, hover=False, text='    ', font=font)
        self.button8.grid(row=3, column=0, columnspan=3, pady=15, padx=20, sticky='nsew')


class Test2Area(ctk.CTkFrame):
    def __init__(self, parent):
        super().__init__(master=parent)
        self.grid(row=0, column=1, sticky='nsew')
        font = ctk.CTkFont(family="Helvetica", size=20, weight='bold')

        self.columnconfigure(0, weight=2, uniform='base3')
        self.columnconfigure(1, weight=2, uniform='base3')
        self.rowconfigure(0, weight=2, uniform='base2')
        self.rowconfigure(1, weight=2, uniform='base2')

        engine, con = set_aut()

        def button_func1():
            value = get_moneyformatter(str(self.fentry1.get()), con)
            if value == 100:
                self.fbutton2 = ctk.CTkButton(self, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                              fg_color='red', font=font, text_color='Black',
                                              text=f'Nem számokat írtál be')
            elif value == '':
                self.fbutton2 = ctk.CTkButton(self, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                              fg_color='red', font=font, text_color='Black',
                                              text=f'Nem írtál be semmit')
            else:
                self.fbutton2 = ctk.CTkButton(self, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                              fg_color='green', font=font, text_color='White',
                                              text=f'{value}')
            self.fbutton2.grid(row=1, column=0, columnspan=2, padx=100, pady=100, sticky='nsew')

        def button_func2():
            value = get_genderchooser(str(self.fentry2.get()), con)
            if value == 100:
                self.fbutton2 = ctk.CTkButton(self, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                              fg_color='red', font=font, text_color='Black', text=f'Hibás formátum')
            elif value == 2:
                self.fbutton2 = ctk.CTkButton(self, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                              fg_color='pink', font=font, text_color='Black',
                                              text=f'{self.fentry2.get()} Nő')
            elif value == 1:
                self.fbutton2 = ctk.CTkButton(self, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                              fg_color='#3b2b7a', font=font, text_color='white',
                                              text=f'{self.fentry2.get()} Férfi')
            elif value is None:
                self.fbutton2 = ctk.CTkButton(self, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                              fg_color='red', font=font, text_color='Black',
                                              text=f'Nem létező nevet írtál be')
            else:
                self.fbutton2 = ctk.CTkButton(self, border_width=5, border_spacing=10, corner_radius=50, hover=False,
                                              fg_color='red', font=font, text_color='Black',
                                              text=f'{self.fentry2.get()} hiba')
            self.fbutton2.grid(row=1, column=0, columnspan=2, padx=100, pady=100, sticky='nsew')

        self.frame1 = ctk.CTkFrame(self)
        self.frame1.pack_propagate(False)
        self.frame1.rowconfigure(0, weight=1, uniform='base8')
        self.frame1.rowconfigure(1, weight=1, uniform='base8')
        self.frame1.rowconfigure(2, weight=1, uniform='base8')
        self.frame1.columnconfigure(0, weight=1, uniform='base8')

        self.frame2 = ctk.CTkFrame(self)
        self.frame2.pack_propagate(False)
        self.frame2.rowconfigure(0, weight=1, uniform='base8')
        self.frame2.rowconfigure(1, weight=1, uniform='base8')
        self.frame2.rowconfigure(2, weight=1, uniform='base8')
        self.frame2.columnconfigure(0, weight=1, uniform='base8')

        self.frame1.grid(row=0, column=0, pady=20, padx=20, sticky='nsew')

        self.flabel1 = ctk.CTkLabel(self.frame1, text='Szám szöveggé formázása', font=font)
        self.flabel1.grid(row=0, column=0, padx=5, sticky='nsew')
        self.fentry1 = ctk.CTkEntry(self.frame1, font=font, height=50)
        self.fentry1.grid(row=1, column=0, padx=5, sticky='ew')
        self.fbutton1 = ctk.CTkButton(self.frame1, text='Mutasd', command=button_func1, font=font)
        self.fbutton1.grid(row=2, column=0, pady=5, sticky='ew')

        self.frame2.grid(row=0, column=1, pady=20, padx=20, sticky='nsew')

        self.flabel2 = ctk.CTkLabel(self.frame2, text='Nem meghatározása keresztnévből', font=font)
        self.flabel2.grid(row=0, column=0, padx=5, sticky='nsew')
        self.fentry2 = ctk.CTkEntry(self.frame2, font=font, height=50)
        self.fentry2.grid(row=1, column=0, padx=5, sticky='ew')
        self.fbutton2 = ctk.CTkButton(self.frame2, text='Mutasd', command=button_func2, font=font)
        self.fbutton2.grid(row=2, column=0, pady=5, sticky='ew')
