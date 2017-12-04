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
prepositions = list(words['PREPOSITION'])

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

forbiden = ['li', 'e', 'la', 'pi', 'a', 'o', 'anu', 'en', 'seme', 'mu', 'kepeken', 'lon', 'tan']
for f in forbiden:
    plain_words.remove(f)

def createPhrase(nsy=0, nwords=0, vowel=False):
    """
    Create a Toki Pona phrase.

    Such phrase might be used as a noun or verb phrase,
    and as a subject, predicate, object or prepositional phrase.

    Parameters
    ----------
    nsy : integer
        The number of syllables of the phrase.
        If nsy=0, the phrase will have a random number of syllables
    nwords : integer
        The number of words in the phrase.
        If nwords != 0, nsy is ignored.
    vowel : boolean

    Returns
    -------
    ph : string
        A phrase in Toki Pona.

    See Also
    --------
    createSentence : creates a sentence in Toki Pona.

    Notes
    -----
    If a word ends with a vowel and the next starts with a vowel,
    an elision occurs and such two syllables are regarded as one.

    References
    ----------
    .. [1] Fabbri, Renato, "Basic concepts and tools for the Toki Pona minimalist language: Wordnet synsets; analysis, synthesis and syntax highlighting of texts." arXiv preprint arXiv:abs/XXX.XXXX (2017)

    """
    phrase = ''
    if nwords:
        for i in range(nwords):
            w = n.random.choice(plain_words)
            phrase += w + ' '
    else:
        if nsy == 0:
            nsy = n.random.randint(1,11)
        nsy_ = 0
        while nsy_ < nsy:
            w = n.random.choice(plain_words)
            s = getSyllables(w)
            l = len(s)
            if w[0] in vowels and vowel:  # elision
                l -= 1
            if nsy_+l > nsy:
                continue
            nsy_ += l
            phrase += w + ' '
            if w[-1] in vowels:
                vowel = 1
            else:
                vowel = 0
    return phrase[:-1]


def createSentence(n=0, v=0, o=0, p=0,prep=True):
    """
    Create a Toki Pona sentence.

    Such phrase will always have a subject, predicate
    and object. Preposition is optional.

    If any of n, v, o, p is 0, it will be replaced by a random
    value in [1,4].

    Parameters
    ----------
    n : integer
        The number of words in the subject phrase.
    v : integer
        The number of words in the predicate phrase.
    o : integer
        The number of words in the object phrase.
    p : integer
        The number of words in the prepositional phrase.
    prep : boolean
        If True, the sentence will have a prepositional phrase,
        else it will not have a prepositional phrase.

    Returns
    -------
    se : string
        A sentence in Toki Pona.

    See Also
    --------
    createPhrase : creates a phrase in Toki Pona.

    Notes
    -----
    See createPhrase to understand how the phrases are created.

    References
    ----------
    .. [1] Fabbri, Renato, "Basic concepts and tools for the Toki Pona minimalist language: Wordnet synsets; analysis, synthesis and syntax highlighting of texts." arXiv preprint arXiv:abs/XXX.XXXX (2017)

    """
    sentence = ''
    if not n:
        n = n.random.randint(1, 5)
    if not v:
        v = n.random.randint(1, 5)
    if not o:
        o = n.random.randint(1, 5)
    sentence += createPhrase(nwords=n) + ' '
    if sentence[:-1] not in ('mi', 'sina'):
        sentence += 'li '
    sentence += createPhrase(nwords=v) + ' e '
    sentence += createPhrase(nwords=o)
    if prep:
        if not p:
            p = n.random.randint(1, 5)
        sentence += ' ' + createPhrase(nwords=p)
    return sentence

def createPoem(nsyl=10, lstan=4, nstan=6, rhyme=True):
    """
    Create a Toki Pona poem.

    Parameters
    ----------
    nsy : integer
        The number of syllables of the verses.
        If nsy=0, the verses will have a random number of syllables
    lstan : integer
        The number of verses in an stanza.
        lstan is always considered to be 4,
        other values for lstan are not implemented.
    nstan : integer
        The number of stanzas.


    Returns
    -------
    poem : string
        The resulting poem.

    References
    ----------
    .. [1] Fabbri, Renato, "Basic concepts and tools for the Toki Pona minimalist language: Wordnet synsets; analysis, synthesis and syntax highlighting of texts." arXiv preprint arXiv:abs/XXX.XXXX (2017)

    """
    if nsyl < 5:
        return 'nsyl must be >= 5'
    # more then one sentence section per verse
    stanzas = []
    for i in range(nstan):
        stanza = ''
        for j in (0, 1):
            nsyl0 = nsyl1 = nsyl//2
            if nsyl%2 == 0:
                nsyl1 -= 1
            s = createPhrase(nsyl0)
            v = createPhrase(nsyl1, vowel=True)
            o = createPhrase(nsyl1, vowel=True)
            p = n.random.choice(prepositions)
            while len(getSyllables(p)) >= nsyl1:
                p = n.random.choice(prepositions)
            if o[-1] in vowels and p[0] in vowels:
                elision = 1
            else:
                elision = 0
            nsyl_ = nsyl - (nsyl1 + 1) - len(getSyllables(p)) + elision
            p_ = createPhrase(nsyl_, vowel=p[-1] in vowels)
            stanza += s + ' li ' + v
            stanza += '\ne ' + o + (' %s %s\n' % (p, p_))
        stanzas.append(stanza[:-1])
    poem = "\n\n".join(stanzas)
    return poem




