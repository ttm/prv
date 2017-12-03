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
    classes = ["PRE" if "PRE-VERB" in i else i for i in classes]
    print(classes)
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
#     
# lines = []
# for class_ in words:
#     words_ = ' '.join(words[class_])
#     group = colors[class_]
#     lines.append('\nsyntax keyword '+'tokipona'+class_+' '+words_)
#     lines.append('highlight link '+'tokipona'+class_+' '+group)
# 
# coloring = '\n'.join(lines)
# header = '''" Vim syntax file
# " Language:	toki pona
# " Maintainer:	Renato Fabbri <fabbri@usp.br>
# " Last Change:	2016 Apr 30
# " Remark:	toki pona is a conlang, not a programming language
# 
# if exists("b:current_syntax")
#     finish
# endif
# 
# syntax clear
# syntax case ignore\n\n'''
# with open('../syntax/tokipona.vim','w') as f:
#     f.write(header+coloring)

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


tpwords = list(word_classes.keys())
tpwords_ = ''.join(tpwords)

vowels = 'aeiou'
consonants = 'jklmnpstw'
vowels_ = ''.join(v for v in tpwords_ if v in vowels)
consonants_ = ''.join(v for v in tpwords_ if v in consonants)

fracv =  [100*tpwords_.count(i)/len(tpwords_) for i in vowels]
fracv_ = [100*vowels_.count(i)/len(vowels_) for i in vowels]

fracc =  [100*tpwords_.count(i)/len(tpwords_) for i in consonants]
fracc_ = [100*consonants_.count(i)/len(consonants_) for i in consonants]
# overall, only vowels, only consonants, begin, end, middle

firstl = ''.join(i[0] for i in tpwords)
lastl = ''.join(i[-1] for i in tpwords)
midl = ''.join(i[1:-1] for i in tpwords if len(i)>2)
vowels__ = ''.join(v for v in firstl if v in vowels)
consonants__ = ''.join(v for v in firstl if v in consonants)

def statMe(token):
    vowels_ = ''.join(v for v in token if v in vowels)
    consonants_ = ''.join(v for v in token if v in consonants)

    fracv =  [100*token.count(i)/len(token) for i in vowels]
    fracv_ = [100*vowels_.count(i)/len(vowels_) for i in vowels]

    fracc =  [100*token.count(i)/len(token) for i in consonants]
    fracc_ = [100*consonants_.count(i)/len(consonants_) for i in consonants]

    data = [ fracv+fracc, fracv_+['-']*len(fracc_), ['-']*len(fracv_)+fracc_]
    return data

letter_sets = [tpwords_, firstl, lastl, midl]
all_data = []
for ls in letter_sets:
    data = statMe(ls)
    all_data += data

l0 = ['freq', 'v', 'c', 'freq\\_I', 'v', 'c', 'freq\\_L', 'v', 'c', 'freq\\_M', 'v', 'c']
l_ = [[i[j] for i in all_data] for j in range(14)]
ll = [l0]+l_
p.mediaRendering.tables.writeTex(
        p.mediaRendering.tables.encapsulateTable(
            p.mediaRendering.tables.makeTabular(
                ["letter"]+[i for i in vowels]+[i for i in consonants], 
                ll,
                True),
            """Frequency of letters in Toki Pona.
            freq, freq\\_I, freq\\_L and freq\\_M are
            the frequencies of the letters in any, initial, last and middle
            positions.
            The columns 'v' and 'c' that follow them are frequencies
            considering only vowels and consonants.
            The most frequent vowel is 'a' in any position,
            although it is more salient among words starting with a vowel
            and among the last letter of the words.
            For starting, ending and middle positions, the second most frequent
            vowel varies.
            Among the consonants, 'n' is the most frequent because it is
            the only consonant allowed in the last position and because
            almost 20\\% of the words end with 'n'.
            On the initial position, 's' is the most frequent consonant,
            while in middle position 'l' is the most frequent consonant.
            Many other conclusions can be drawn from this table and are
            useful e.g. for exploring sonorities in poems.""",
            'freqLet'),
        "../article/vowels.tex")
p.mediaRendering.tables.fontSize("../article/vowels.tex", write=1)
p.mediaRendering.tables.doubleLines("../article/vowels.tex",
        hlines=[], vlines=[], hlines_=[0,2,3,4,5,7,8,10,11,13,14,15],
        vlines_=[0,2,3,5,6,8,9,11,12,13])

##########################
# Syllables

def firstSyllable(token):
    if len(token) <= 2:
        sy = token
        tk = ''
    elif token[0] in vowels:
        if token[1] == 'n':
            if token[2] in vowels:
                sy = token[0]
                tk = token[1:]
            else:
                sy = token[:2]
                tk = token[2:]
        else:
            sy = token[0]
            tk = token[1:]
    else:
        if token[2] == 'n':
            if len(token) == 3 or token[3] in consonants:
                sy = token[:3]
                tk = token[3:]
            else:
                sy = token[:2]
                tk = token[2:]
        else:
            sy = token[:2]
            tk = token[2:]
    return sy, tk

def getSyllables(token):
    tk = token
    syl = []
    while tk:
        sy, tk = firstSyllable(tk)
        syl.append(sy)
    return syl

syllables = [getSyllables(i) for i in tpwords]
syllables_ = [j for i in syllables for j in i]

syllables__ = list(set(syllables_))
syllables__.sort()
syllables__.sort(key=len)

syllables_0 = [i[0] for i in syllables]
syllables_1 = [i[-1] for i in syllables]
syllables_i = [i[1] for i in syllables if len(i) == 3]

def histSyl(syllables_):
    freq_syl = [(i, 100*syllables_.count(i)/len(syllables_), syllables_.count(i)) for i in syllables__]
    # aa = list(zip(syllables__, freq_syl))
    bb = sorted(freq_syl, key=lambda t: -t[1])
    return bb

syls = [syllables_, syllables_0, syllables_1, syllables_i]
hsyls = [histSyl(i) for i in syls]

lsyl = [len(i) for i in syllables]
hlsyl = [100*lsyl.count(i)/len(lsyl) for i in (1, 2, 3)]
hlsyl_ = [lsyl.count(i) for i in (1, 2, 3)]
hlsyl__ = [[w for w in tpwords if len(getSyllables(w)) == i] for i in (1, 2, 3)]
[i.sort() for i in hlsyl__]
[i.sort(key=len) for i in hlsyl__]

def v(syl):
    for i in syl:
        if i in 'aeiou':
            return i
fracv0_ = [v(i) for i in syllables_0]
fracv1_ = [v(i) for i in syllables_1]

def format_(syl):
    syl_ = '{} ({}, {:.2f}\\%)'.format(syl[0], syl[2], syl[1])
    return syl_
l0 = ['all', 'first', 'last', 'middle']
l_ = [[format_(i[j]) for i in hsyls] for j in range(10)]
ll = [l0]+l_

p.mediaRendering.tables.writeTex(
        p.mediaRendering.tables.encapsulateTable(
            p.mediaRendering.tables.makeTabular(
                ['rank']+[str(i+1) for i in range(10)], 
                ll,
                True),
            """Frequency of syllables in Toki Pona
            considering all 235 syllables of the 124 tokens,
            only the first or last syllables or only the middle
            syllable.
            In parenthesis are the count and percentage of the
            corresponding syllable. For more information and a
            complete list of syllables, see Section~\\ref{sec:stat}.
            """,
            'freqSyl'),
        "../article/syls.tex")

p.mediaRendering.tables.doubleLines("../article/syls.tex",
        hlines=[], vlines=[], hlines_=[0,2,3,4,5,6,7,8,9,10,11],
        vlines_=[0,2,3,4,5])
# length of words in characters


#############################
## words possible

syllables_possible = set()
for c in consonants:
    for v in vowels:
        syllables_possible.add(c+v)
        syllables_possible.add(c+v+'n')
forbiden = ['ji', 'wu', 'wo', 'ti', 'nn', 'nm']
for i in forbiden[:-2]:
    syllables_possible.remove(i)

syllables_start = set([i for i in vowels]) | set([i+'n' for i in vowels]) | syllables_possible

words1 = syllables_start
words2 = set()
for i in words1:
    for j in syllables_possible:
        words2.add(i+j)
words2_ = words2.copy()
for i in forbiden:
    for j in words2:
        if i in j:
            # it might have been removed because of another restriction
            if j in words2_:
                words2_.remove(j)

words3 = set()
for i in words2:
    for j in syllables_possible:
        words3.add(i+j)
words3_ = words3.copy()
for i in forbiden:
    for j in words3:
        if i in j:
            # it might have been removed because of another restriction
            if j in words3_:
                words3_.remove(j)
nwords = [len(i) for i in (words1, words2, words3)]
# words without a
# with most and less vowels
# largest in letters
# walk through levenshtein distance
# 
##########################################
# Possible sentences

def possibleSentences(n, v, o, p=[1], nparticles=1):
    p_ = 1
    for pp in p:
        p_ *= 5 * 110**pp

    delta = 110**n * 110**v * 110**o * p_ * 10^3
    return delta 

