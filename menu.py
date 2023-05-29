from panels import *


class Menu(ctk.CTkTabview):
    def __init__(self, parent, load_empty_func,
                 load_client_search_func, load_contract_search_func, load_task_evhandler_func,
                 load_stat_monthlysales_func, load_stat_partnerstat_func, load_test_func, load_test2_func):
        super().__init__(master=parent)
        self.grid(row=0, column=0, sticky='nsew')
        self.configure(width=220, height=200)
        self.configure()

        self.add('Ügyfelek')
        self.add('Feladatok')
        self.add('Kimutatás')
        self.add('Teszt')

        ClientFrame(self.tab('Ügyfelek'), load_empty_func, load_client_search_func, load_contract_search_func)
        TaskFrame(self.tab('Feladatok'), load_empty_func, load_task_evhandler_func)
        RiportFrame(self.tab('Kimutatás'), load_empty_func, load_stat_monthlysales_func, load_stat_partnerstat_func)
        TestFrame(self.tab('Teszt'), load_empty_func, load_test_func, load_test2_func)


class ClientFrame(ctk.CTkFrame):
    def __init__(self, parent, load_empty_func, load_client_search_func, load_contract_search_func):
        super().__init__(master=parent, fg_color='transparent')
        self.pack(expand=True, fill='both')

        ClientButton(self, load_client_search_func=load_client_search_func,
                     load_contract_search_func=load_contract_search_func,
                     load_empty_func=load_empty_func,
                     b_text=['Keresés', 'Új felvitel', 'Módosítás', 'Törlés', 'Szerződés adatai'])


class TaskFrame(ctk.CTkFrame):
    def __init__(self, parent, load_empty_func, load_task_evhandler_func):
        super().__init__(master=parent, fg_color='transparent')
        self.pack(expand=True, fill='both')

        TaskButton(self, load_task_evhandler_func=load_task_evhandler_func,
                   load_empty_func=load_empty_func,
                   b_text=['Feladataim', 'Közelgő események'])


class RiportFrame(ctk.CTkFrame):
    def __init__(self, parent, load_empty_func, load_stat_monthlysales_func, load_stat_partnerstat_func):
        super().__init__(master=parent, fg_color='transparent')
        self.pack(expand=True, fill='both')

        RiportButton(self,
                     load_empty_func=load_empty_func,
                     load_stat_monthlysales_func=load_stat_monthlysales_func,
                     load_stat_partnerstat_func=load_stat_partnerstat_func,
                     b_text=['Üzletkötők teljesítménye', 'Állományom statisztikája'])


class TestFrame(ctk.CTkFrame):
    def __init__(self, parent, load_empty_func, load_test_func, load_test2_func):
        super().__init__(master=parent, fg_color='transparent')
        self.pack(expand=True, fill='both')

        TestButton(self,
                   load_empty_func=load_empty_func,
                   load_test_func=load_test_func,
                   load_test2_func=load_test2_func,
                   b_text=['Validáció', 'Formázás-Ell.', 'teszt', 'Adatbázis létehozása',
                           'DEMO adatok generálása', 'Google API'])
