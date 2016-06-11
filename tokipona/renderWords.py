# import ezodf
import pandas as pd
import numpy as n
import os
# from ODSReader import *

# ods = ezodf.newdoc(doctype='ods',filename='../data/dictionary.ods')

# ezodf.config.set_table_expand_strategy('all')

# spreadsheet = ezodf.opendoc('../data/dictionary.ods')


os.system('unoconv -f xlsx -o ../data/dictionary.xlsx ../data/dictionary.ods ')
xl_file = pd.ExcelFile('../data/dictionary.xlsx')
dfs = {sheet_name: xl_file.parse(sheet_name)
       for sheet_name in xl_file.sheet_names}
df = dfs['Sheet1']
table = n.vstack((df.keys(), df.values))

all = set()
for row in table:
    classes = " ".join(i for i in row[1].split() if i.isupper())
    print(row[0], classes)
    all.add(classes)
all2 = set()

colors = {'ADJECTIVE': 'Comment', 'NOUN': 'Constant', 'NUMBER': 'Identifier',
          'PARTICLE': 'Statement', 'PRE': 'PreProc',
          'PREPOSITION': 'Type', 'VERB': 'Special'}
words = {}
for color in colors:
    words[color] = set()

for row in table:
    class_ = [i for i in row[1].split() if i.isupper()][0]
    print(row[0], class_, colors[class_])
    all2.add(class_)
    words_ = row[0].split()
    for word in words_:
        if word != 'or':
            words[class_].add(word)
lines = []
for class_ in words:
    words_ = ' '.join(words[class_])
    group = colors[class_]
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

syntax clear
syntax case ignore\n\n'''
with open('../syntax/tokipona.vim','w') as f:
    f.write(header+coloring)
