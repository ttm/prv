# import ezodf
import pandas as pd
import numpy as n
import os

# to make tp wn, I need to know, for each word,
# the English lemmas and pos of each lemma.
# words[word] = [(lemma1, pos1), (lemma2, pos2),...]

os.system('unoconv -f xlsx -o ../data/dictionary.xlsx ../data/dictionary.ods ')
xl_file = pd.ExcelFile('../data/dictionary.xlsx')
dfs = {sheet_name: xl_file.parse(sheet_name)
       for sheet_name in xl_file.sheet_names}
df = dfs['Sheet1']
table = n.vstack((df.keys(), df.values))

words = {}

for row in table:
    all_pos = row[1].split("\n")
    lemma_pos = []
    for pos in all_pos:
        class_ = [i for i in pos.split() if i.isupper() and i not in ("I,","O!")][0]
        en_words = [i for i in pos.replace(" or ", ' ').split() if i.islower() or i in ("I,","O!")]
        for enw in en_words:
            w = enw.replace(";", "").replace(',', '')
            lemma_pos.append( (w, class_) )

    words_ = row[0].split()
    if 'or' in words_:
        words_.remove("or")
    for w in words_:
        words[w] = lemma_pos

pos = {'NOUN': 'n',
        'VERB': 'v',
        'PRE-VERB': 'v', # pre-verbs are also verbs
        'ADJECTIVE': 'asr', # adjectives are also adverbs and satellite adjectives
        'NUMBER': 'asr'
        }

import nltk as k
tp_wordnet = {}
tp_wordnet_ = {}
tp_wordnet__ = {}
for word in words:
    # if word in ('li', 'e', 'la', 'pi'):
    #     continue
    synsets = []
    synsets_ = []
    synsets__ = []
    for enw in words[word]:
        class_ = enw[1]
        if class_ in ('PREPOSITION'):
            w = enw[0]
            ss__ = k.wordnet.wordnet.synsets(w)
            synsets__ += ss__
        if class_ in ('PARTICLE', 'PREPOSITION'):
            continue
        w = enw[0]
        c = pos[class_]
        ss = k.wordnet.wordnet.synsets(w, pos=c)
        synsets += ss
        ss_ = k.wordnet.wordnet.synsets(w)
        synsets_ += ss_
        synsets__ += ss_
    tp_wordnet[word] = synsets
    tp_wordnet_[word] = synsets_
    tp_wordnet__[word] = synsets__

synsets = []
synsets_ = []
synsets__ = []
for word in tp_wordnet:
    ss = tp_wordnet[word]
    synsets += ss
    ss_ = tp_wordnet_[word]
    synsets_ += ss_
    ss__ = tp_wordnet__[word]
    synsets__ += ss__

synsets = set(synsets)
synsets_ = set(synsets_)
synsets__ = set(synsets__)

# total number of synsets
# total number of synsets counting neighbors
