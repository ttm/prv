# import ezodf
import pandas as pd
import numpy as n
import os

class TP:
    def __init__(self):
        os.system('unoconv -f xlsx -o ../data/dictionary.xlsx ../data/dictionary.ods ')
        xl_file = pd.ExcelFile('../data/dictionary.xlsx')
        dfs = {sheet_name: xl_file.parse(sheet_name)
               for sheet_name in xl_file.sheet_names}
        df = dfs['Sheet1']
        table = n.vstack((df.keys(), df.values))
        self.me = locals()

