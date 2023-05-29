from widgets import *
from menu import Menu
from configparser import ConfigParser


def connect_to_database(server, ln, pw, mode):
    set_aut()
    driver = '{ODBC Driver 17 for SQL Server}'
    if mode == '1':
        try:
            c_string = f"Driver={driver};Server={server};Database=master;NeedODBCTypesOnly=1;Trusted_Connection=yes;"
            pyodbc.connect(c_string, autocommit=True)
            windows_login(c_string, ln, pw)
            return 0
        except:
            return 2
    else:
        try:
            pyodbc.connect(f"Driver={driver};Server={server};Database=master;NeedODBCTypesOnly=1;UID={ln};PWD={pw}",
                           autocommit=True)
            return 0
        except:
            return 1


class App(ctk.CTk):
    def __init__(self):
        super().__init__()
        self.popup = None
        self.textbox = None
        self.menu = None
        self.main_area = None
        ctk.set_appearance_mode('dark')
        self.geometry('1200x600')
        self.title('Alfabot OFFLINE')
        self.minsize(800, 500)
        self.rowconfigure(0, weight=1)
        self.columnconfigure(0, weight=2, uniform='base')
        self.columnconfigure(1, weight=7, uniform='base')

        self.login_widget = LoginWidget(self, self.login)
        self.mainloop()

    def load_empty_func(self):
        self.main_area = EmptyArea(self)

    def load_client_search_func(self):
        self.main_area = ClientSearchArea(self)

    def load_contract_search_func(self):
        self.main_area = ContractSearchArea(self)

    def load_task_evhandler_func(self):
        self.main_area = TaskEvHandlerArea(self)

    def load_stat_monthlysales_func(self):
        self.main_area = StatMonthlySalesArea(self)

    def load_stat_partnerstat_func(self):
        self.main_area = StatPartnerStatArea(self)

    def load_test_func(self):
        self.main_area = TestArea(self)

    def load_test2_func(self):
        self.main_area = Test2Area(self)

    def login(self, servername, username, password, authentication):
        parser = ConfigParser()
        parser.read('config.ini')

        parser.set('Login', 'ServerName', servername)
        parser.set('Login', 'UserName', username)
        parser.set('Login', 'Password', password)
        parser.set('Login', 'Authentication', str(authentication))

        with open('config.ini', 'w') as configfile:
            parser.write(configfile)

        server = parser.get('Login', 'ServerName')
        uid = parser.get('Login', 'UserName')
        pwd = parser.get('Login', 'Password')
        aut_mode = parser.get('Login', 'Authentication')

        check = connect_to_database(server, uid, pwd, aut_mode)
        if check == 1:
            self.popup = ctk.CTkToplevel(self)
            self.popup.after(10, self.popup.lift)
            self.popup.geometry("%dx%d+%d+%d" % (880, 380, self.winfo_x() + 800 / 4, self.winfo_y() + 500 / 4))

            self.textbox = ctk.CTkTextbox(master=self.popup, width=1650, height=1200, corner_radius=0,
                                          font=ctk.CTkFont(family="Helvetica", size=20, weight='bold'))
            self.textbox.grid(row=0, column=0, sticky="nsew")
            self.textbox.insert("0.0",
                                """
                    Hibás adatok vagy adatbázis beállítások!
        
                 - A szerver nevét lekérdezheted a @@SERVERNAME parancs segitségével
        
                 - A felhasználónév és jelszó az általad létrehozott SQL login
        
                 - Ellenőrizd hogy sikeres volt-e a RESTORE és megvan-e a szükséges jogosultság
                    User Mapping->Alfabot, db_owner (SQLNCLI miatt szükséges)
                    
                 - Ellenőrizd az ODBC driver verzióját, vagy telepítsd:
                    https://go.microsoft.com/fwlink/?linkid=2223304
                """)
        elif check == 0:
            self.login_widget.grid_forget()

            self.menu = Menu(self, self.load_empty_func, self.load_client_search_func,
                             self.load_contract_search_func,
                             self.load_task_evhandler_func, self.load_stat_monthlysales_func,
                             self.load_stat_partnerstat_func, self.load_test_func, self.load_test2_func)
            self.main_area = MainArea(self)
        elif check == 2:
            self.popup = ctk.CTkToplevel(self)
            self.popup.after(10, self.popup.lift)
            self.popup.geometry("%dx%d+%d+%d" % (880, 380, self.winfo_x() + 800 / 4, self.winfo_y() + 500 / 4))

            self.textbox = ctk.CTkTextbox(master=self.popup, width=1650, height=1200, corner_radius=0,
                                          font=ctk.CTkFont(family="Helvetica", size=20, weight='bold'))
            self.textbox.grid(row=0, column=0, sticky="nsew")
            self.textbox.insert("0.0",
                                """
                                Valamiért nem sikerült a Windows autentikáció, próbáld meg 
                                sql login létrehozásával.
                                """)


App()
