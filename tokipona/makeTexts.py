import pandas as pd
import numpy as n
import os
# from makeStatistics import getSyllables

vowels = 'aeiou'
consonants = 'jklmnpstw'

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

# use variables words and word_classes to synthesize texts
plain_words = list(word_classes.keys())

# functions repeated from makeStatistics, join them into a utils.py or similar
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

def createPhrase(nsy=0):
    """
    Create a Toki Pona phrase.

    Such phrase might be used as a noun or verb phrase,
    and as a subject, predicate, object or prepositional phrase.

    Parameters
    ----------
    nsy : integer
        The number of syllables of the phrase.
        If nsy=0, the phrase will have a random number of syllables

    Returns
    -------
    ph : string
        A phrase of words in Toki Pona.

    Notes
    -----
    If a word ends with a vowel and the next starts with a vowel,
    an elision occurs and such two syllables are regarded as one.

    References
    ----------
    .. [1] Fabbri, Renato, et al. "Basic concepts and tools for the Toki Pona minimalist language: Wordnet synsets; analysis, synthesis and syntax highlighting of texts." arXiv preprint arXiv:abs/XXX.XXXX (2017)

    """
    if nsy == 0:
        nsy = n.random.randint(1,11)
    nsy_ = 0
    phrase = ''
    while nsy_ < nsy:
        w = n.random.choice(plain_words)
        s = getSyllables(w)
        l = len(s)
        if nsy_+l > nsy:
            continue
        nsy_ += l
        phrase += w + ' '
    return phrase[:-1]
