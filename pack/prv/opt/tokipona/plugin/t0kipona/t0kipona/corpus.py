import os
tdir = os.path.dirname(os.path.abspath(__file__))
import pandas as pd, numpy as n

class TPCorpus:
    def __init__(self):
        self._initAuxVars()
        self._initDicts()
        self._loadDictionary()
        self._getClasses()

    def _loadDictionary(self):
        dpath = tdir.split("plugin")[0] + 'aux/dictionary.xlsx'
        # os.system('unoconv -f xlsx -o ../data/dictionary.xlsx ../data/dictionary.ods ')
        xl_file = pd.ExcelFile(dpath)
        dfs = {sheet_name: xl_file.parse(sheet_name)
               for sheet_name in xl_file.sheet_names}
        df = dfs['Sheet1']
        self.table = n.vstack((df.keys(), df.values))

    def _getClasses(self):
        self.classes = set()
        for row in self.table:
            classes = " ".join(i for i in row[1].split() if i.isupper())
            # print(row[0], classes)
            self.classes.add(classes)

    def _changePrecedence(self):
        if self.precedence == 'first':
            self.precedence = ['PRE', 'VERB', 'PREPOSITION', 'PARTICLE', 'ADJECTIVE', 'NOUN', 'NUMBER']
        else:
            self.precedence = 'first'

    def _initAuxVars(self):
        self.precedence = ['PRE', 'VERB', 'PREPOSITION', 'PARTICLE', 'ADJECTIVE', 'NOUN', 'NUMBER']
        self.synonyms = 0

    def _initDicts(self):
        self.words = {}
        for class_ in self.precedence:
            self.words[class_] = set()
        self.words_all = self.words.copy()

        self.class_count = dict.fromkeys(self.precedence, 0)
        self.class_count_ = dict.fromkeys(self.precedence, 0)


