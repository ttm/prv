import nltk as k, os
# from percolation.rdf import c

__doc__ = """Utilitiy variables and functions"""


vowels = 'aeiou'
vowels_ = 'AEIOU'
consonants = 'jklmnpstw'
invalid_syllables = 'ji','ti','wo','wu'

tpath = os.path.abspath(__file__).replace(os.path.basename(__file__), '')

with open(tpath + 'rules.txt','rb') as f:
    notes = f.read()

def printTextsAccents(text):
    '''Print toki pona text with accents in volgals of first syllabes'''
    tokens = k.wordpunct_tokenize(text)
    tokens_ = []
    for token in tokens:
        if token[0] in vowels:
            token = vowels_[vowels.index(token[0])]+token[1:]
        else:
            token = token[0]+vowels_[vowels.index(token[1])] + token[2:]
        tokens_ += [token]
    text_ = ' '.join(tokens_)
    print(text_)
    return text_


def representAccents(text):
    '''Exchange consonants such as k->g, p->b, t->d and s->z
    
    Note
    ----
    Not implemented
    
    '''
    pass


def consonantSyllables(consonant):
    '''Return all the syllables given the initial consonant.
    
    Notes
    -----
    TODO:
    Needs revision. lj is not prohibited, but should it be allowed?
    Send issues to discussion groups.
    '''
    global vowels_
    if consonant != 'j':
        vowels_ = vowels + 'j'
    syllables = [consonant+vowel for vowel in vowels_ if
            consonant+vowel not in invalid_syllables]
    syllables += [syllable + 'n' for syllable in syllables]
    return syllables


def allConsonantSyllables():
    '''Return all possible syllables given the rules.

    Notes
    -----
    TODO:
    send syllables list to discussion groups.

    '''
    # need to include the y. E.g. Enya, ijo.
    all_syllables = []
    for consonant in consonants:
        all_syllables += [consonantSyllables(consonant)]
    all_syllables_ = [syl for syls in all_syllables for syl in syls]
    return all_syllables_


def allTokiPonaPossibleWords(n=3):
    '''Returns all possible Toki Pona words with at most n syllables.

    Parameters
    ----------
    n : integer
        The maximum number of syllables in a word.

    Notes
    -----
    Syllables have the general form (C)V(N).
    I.e. each syllable has a consonant, a vowel and an optional n.
    First syllable of word can have no consonant, i.e. a
    word might start with a vowel.
    The other syllables must start with a consonant.

    '''
    n_ = 1
    words = allConsonantSyllables()
    while n_ < n:
        words_ = [word for word in words if len(word)/2 == n_]
        for word in words_:
            for syllable in allConsonantSyllables():
                if word[-1] == syllable [-1] == 'j':
                    continue
                word_ = word+syllable
                words += [word_]
        # c('finished words with {} syllables'.format(n_+1))
        n_ += 1
    words_ = words[:]
    for vowel in vowels:
        words += [vowel+word for word in words_ if
                len(word)/2 < n]
    words += [vowel for vowel in vowels]  # assuming one vowel words
    # c('finished words starting with vowels')

    return words

def allTokiPonaExistentWords():
    from . import makeStatistics as stats
    return stats

if __name__ == '__main__':
    print('vowels:', vowels)
    print('\n', 'consonants:', consonants)
    print('\n', 'invalid_syllables (4):', invalid_syllables)
    all_syllables = allConsonantSyllables()
    print('\n', 'valid syllables ({}):'.format(len(all_syllables)),
            all_syllables)
    all_possible_words = allTokiPonaPossibleWords()
    print('\n', 'all tokipona possible words with 3 syllables',
            '({})'.format(len(all_possible_words)),
            all_possible_words)
