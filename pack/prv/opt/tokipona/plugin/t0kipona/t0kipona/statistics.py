# import ezodf
import pandas as pd
import numpy as n
import os
tdir = os.path.dirname(os.path.abspath(__file__))

class TP:
    def __init__(self):
        self._initAuxVars()
        self._initDicts()
        self._loadDictionary()
        self._getClasses()
        self._analyseLemmas()
        self._posStats()

#     def _uniqueCombinations(self, comb_pos_):
#         comb_pos_ = comb_pos_[:]
#         for i in comb_pos_:
#             same_size = [j for j in comb_pos_ if (len(j) == len(i) and j != i)]
#             for comb in same_size:
#                 if sum([pos in i for pos in comb]) == len(i):
#                     comb_pos_.remove(i)
#                     return uniqueCombinations(comb_pos_)
#         return comb_pos_

    def _posStats(self):
        self.comb_pos=list(self.word_classes.values())
        self.comb_pos_=[]
        for i in self.comb_pos:
            if i not in self.comb_pos_:
                self.comb_pos_.append(i)
        # self.uniqueCombinations(comb_pos_)

        self.pos_comb = {}
        for comb in self.comb_pos_:
            c = str(comb)
            self.pos_comb[c] = []

        self.comb_pos__ = [set(i) for i in self.comb_pos_]
        for word in self.word_classes:
            comb = self.word_classes[word]
            c = set(comb)
            for cc in self.comb_pos_:
                if c == set(cc):
                    c_ = str(cc)
                    self.pos_comb[c_].append(word)


    def _analyseLemmas(self):
        self.word_classes = {}
        for row in self.table:
            # Better choose the class
            classes = [i for i in row[1].split() if i.isupper() and i not in ("I,","O!")]
            classes = ["PRE" if "PRE-VERB" in i else i for i in classes]
            # print(classes)
            if self.precedence=="first":
                class_ = classes[0]
            else:
                class__ = classes
                not_chosen = 1
                for pos in self.precedence:
                    if pos in class__ and not_chosen:
                        class_ = pos
                        self.class_count[pos] += 1
                        self.class_count_[pos] += 1
                        not_chosen = 0
                    elif pos in class__:
                        self.class_count[pos] += 1

            # print(row[0], class_, colors[class_])
            # all2.add(class_)
            words_ = row[0].split()
            if "PRE-VERB" in classes:
                classes[classes.index("PRE-VERB")] = "PRE"
            for word in words_:
                if word != 'or':
                    self.words[class_].add(word)
                    self.word_classes[word] = []
                    for aclass in classes:
                        self.words_all[aclass].add(word)
                        self.word_classes[word].append( aclass )
                else:
                    self.synonyms += 1
        for i in self.word_classes:
            if "PRE" in self.word_classes[i]:
                if "VERB" in self.word_classes[i]:
                    self.word_classes[i].remove("VERB")

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

class TPSynHigh(TP):
    """
    Syntax highlighting for Toki Pona in Vim

    Basic usage:
        sh = TPSynHigh()
        sh.mkSynHighFile()
    
    For different results, tweak sh.colors
    before executing sh.mkSynHighFile()

    """
    def __init__(self):
        TP.__init__(self)
        self._linkClassSyn()
        print(self.__doc__)

    def _linkClassSyn(self):
        self.colors = {'ADJECTIVE': 'Comment', 'NOUN': 'Constant',
                  'NUMBER': 'Identifier',
                  'PARTICLE': 'Statement', 'PRE': 'PreProc',
                  'PREPOSITION': 'Type', 'VERB': 'Special'}

    def mkSynHighFile(self):
        lines = []
        for class_ in self.words:
            words_ = ' '.join(self.words[class_])
            group = self.colors[class_]
            lines.append('\nsyntax keyword '+'tokipona'+class_+' '+words_)
            lines.append('highlight link '+'tokipona'+class_+' '+group)

        coloring = '\n'.join(lines)
        header = '''" Vim syntax file
" Language:	toki pona
" Maintainer:	Renato Fabbri <fabbri@usp.br>
" Last Change:	2016 Apr 30
" Remark:	toki pona is a conlang, not a programming language

if exists("b:current_syntax")
    finish
endif
let b:current_syntax = "tokipona"

syntax clear
syntax case ignore\n\n'''
        dpath = tdir.split("plugin")[0] + 'syntax/tokipona.vim'
        with open(dpath, 'w') as f:
            f.write(header+coloring)


class TPTabFig(TP):
    """
    TP tables and figures.

    Used by the TP article included in this framework.
    Basic usage:
        tf = TPTabFig()
        tf.mkAll()

    Check all tf.mk* methods for individual
    tabels and figuras.

    """
    def __init__(self):
        TP.__init__(self)
        print(self.__doc__)

