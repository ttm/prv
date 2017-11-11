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
words_all = words.copy()

synonyms = 0
precedence = 'first'
precedence = ['PRE', 'VERB', 'PREPOSITION', 'PARTICLE', 'ADJECTIVE', 'NOUN', 'NUMBER']
allp = list(colors.keys())
precedence += [i for i in allp if i not in precedence]

class_count = colors.copy()
for i in class_count: class_count[i] = 0
class_count_ = colors.copy()
for i in class_count_: class_count_[i] = 0

word_classes = {}
for row in table:
    # Better choose the class
    classes = [i for i in row[1].split() if i.isupper() and i not in ("I,","O!")]
    if precedence=="first":
        class_ = classes[0]
    else:
        class__ = classes
        not_chosen = 1
        for pos in precedence:
            if pos in class__ and not_chosen:
                class_ = pos
                class_count[pos] += 1
                class_count_[pos] += 1
                not_chosen = 0
            elif pos in class__:
                class_count[pos] += 1

    print(row[0], class_, colors[class_])
    all2.add(class_)
    words_ = row[0].split()
    if "PRE-VERB" in classes:
        classes[classes.index("PRE-VERB")] = "PRE"
    for word in words_:
        if word != 'or':
            words[class_].add(word)
            word_classes[word] = []
            for aclass in classes:
                words_all[aclass].add(word)
                word_classes[word].append( aclass )
        else:
            synonyms += 1
for i in word_classes:
    if "PRE" in word_classes[i]:
        if "VERB" in word_classes[i]:
            word_classes[i].remove("VERB")

comb_pos=list(word_classes.values())
comb_pos_=[]
for i in comb_pos:
    if i not in comb_pos_:
        comb_pos_.append(i)
def uniqueCombinations(comb_pos_):
    comb_pos_ = comb_pos_[:]
    for i in comb_pos_:
        same_size = [j for j in comb_pos_ if (len(j) == len(i) and j != i)]
        for comb in same_size:
            if sum([pos in i for pos in comb]) == len(i):
                comb_pos_.remove(i)
                return uniqueCombinations(comb_pos_)
    return comb_pos_
uniqueCombinations(comb_pos_)

pos_comp = {}
for comb in comb_pos_:
    c = str(comb)
    pos_comp[c] = []

comb_pos__ = [set(i) for i in comb_pos_]
for word in word_classes:
    comb = word_classes[word]
    c = set(comb)
    for cc in comb_pos_:
        if c == set(cc):
            c_ = str(cc)
            pos_comp[c_].append(word)


# class_count and class_count_ has?
# The number of the 120 different words (no synonyms)
# that are classified in a POS by the dictionary (18
# and by the system.
# words and words_all has the set of tokens related to each tag,
# words is for highlighting,
# words_all has all the tokens associated to each tag as
# in the official dictionary
# words use 124 tokens (4 syonyms, 120 meanings or synsets).
# class_count and words dictionaries have the POS tags as keys:
# dict[tag] = set or count



# 
    
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

# class_count has the number of occurrences of each pos tag.
# each of them in the chosen form and in any of the classifications
# on the official dictionary.

from collections import OrderedDict
pos_ = OrderedDict(sorted(class_count_.items(), key=lambda t: -t[1]))
pos = OrderedDict(sorted(class_count.items(), key=lambda t: -t[1]))

import percolation as p
labels=list(pos.keys())
p.mediaRendering.tables.writeTex(
        p.mediaRendering.tables.encapsulateTable(
            p.mediaRendering.tables.makeTabular(
                ["POS"]+labels+["total"], 
                [["All", "Chosen"]] + list(zip(pos.values(), pos_.values())) + [[sum(pos.values()),120]]),
            """"POS tags incident and chosen.
            The official dictionary often relates tokens
            to more than one POS tag.
            For the text highlighting Plugin, for example,
            a token has to have an established tag to have
            a defined color.
            On the Chosen column, the tokens were regarded only once
            by choosing the first classification in the dictionary in """+str(precedence)+"."),
        "../article/pos.tex")


