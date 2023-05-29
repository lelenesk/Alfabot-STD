from widgets import *


class Panel(ctk.CTkFrame):
    def __init__(self, parent):
        super().__init__(master=parent, fg_color='#4a4a4a')
        self.pack(fill='x', pady=4, ipady=8)


class ClientButton(Panel):
    def __init__(self, parent, b_text, load_client_search_func, load_contract_search_func, load_empty_func):
        super().__init__(parent=parent)
        self.pack(fill='x', pady=4, ipady=8)
        font = ctk.CTkFont(family="Helvetica", size=20, weight='bold')

        self.load_client_search_func = load_client_search_func
        self.load_contract_search_func = load_contract_search_func
        self.load_empty_func = load_empty_func

        ctk.CTkButton(self, command=self.load_client_search_func, text=b_text[0], font=font).pack(pady=4, ipady=8)
        ctk.CTkButton(self, command=self.load_empty_func, text=b_text[1], font=font).pack(pady=4, ipady=8)
        ctk.CTkButton(self, command=self.load_empty_func, text=b_text[2], font=font).pack(pady=4, ipady=8)
        ctk.CTkButton(self, command=self.load_empty_func, text=b_text[3], font=font).pack(pady=4, ipady=8)
        ctk.CTkButton(self, command=self.load_contract_search_func, text=b_text[4], font=font).pack(pady=4, ipady=8)


class TaskButton(Panel):
    def __init__(self, parent, b_text, load_task_evhandler_func, load_empty_func):
        super().__init__(parent=parent)
        font = ctk.CTkFont(family="Helvetica", size=20, weight='bold')

        self.pack(fill='x', pady=4, ipady=8)
        self.load_task_evhandler_func = load_task_evhandler_func
        self.load_empty_func = load_empty_func

        ctk.CTkButton(self, command=self.load_empty_func, text=b_text[0], font=font).pack(pady=4, ipady=8)
        ctk.CTkButton(self, command=self.load_task_evhandler_func, text=b_text[1], font=font).pack(pady=4, ipady=8)


class RiportButton(Panel):
    def __init__(self, parent, b_text, load_empty_func, load_stat_monthlysales_func, load_stat_partnerstat_func):
        super().__init__(parent=parent)
        font = ctk.CTkFont(family="Helvetica", size=20, weight='bold')

        self.pack(fill='x', pady=4, ipady=8)
        self.load_empty_func = load_empty_func
        self.load_stat_monthlysales_func = load_stat_monthlysales_func
        self.load_stat_partnerstat_func = load_stat_partnerstat_func

        ctk.CTkButton(self, command=self.load_stat_monthlysales_func, text=b_text[0], font=font).pack(pady=4, ipady=8)
        ctk.CTkButton(self, command=self.load_stat_partnerstat_func, text=b_text[1], font=font).pack(pady=4, ipady=8)


class TestButton(Panel):
    def __init__(self, parent, b_text, load_empty_func, load_test_func,  load_test2_func):
        super().__init__(parent=parent)
        font = ctk.CTkFont(family="Helvetica", size=20, weight='bold')

        self.pack(fill='x', pady=4, ipady=8)
        self.load_empty_func = load_empty_func
        self.load_test_func = load_test_func
        self.load_test2_func = load_test2_func

        ctk.CTkButton(self, command=self.load_test_func, text=b_text[0], font=font).pack(pady=4, ipady=8)
        ctk.CTkButton(self, command=self.load_test2_func, text=b_text[1], font=font).pack(pady=4, ipady=8)
        ctk.CTkButton(self, command=self.load_empty_func, text=b_text[2], font=font).pack(pady=4, ipady=8)
        ctk.CTkButton(self, command=self.load_empty_func, text=b_text[3], font=font).pack(pady=4, ipady=8)
        ctk.CTkButton(self, command=self.load_empty_func, text=b_text[4], font=font).pack(pady=4, ipady=8)
        ctk.CTkButton(self, command=self.load_empty_func, text=b_text[5], font=font).pack(pady=4, ipady=8)


