import nltk as k
from percolation.rdf import c


vowels = 'aeiou'
vowels_ = 'AEIOU'
consonants = 'jklmnpstw'
invalid_syllables = 'ji','ti','wo','wu'

with file('rules.txt','rb') as f:
    notes = f.read()

def printTextsAccents():
    '''Print toki pona text with accents in volgals of first syllabes'''
    tokens = k.wordpunt_tokenize(text)
    for token in i:
        if token[0] in vowels:
            token = vowels_[vowels.index(token[0])]+token[1:]
        else:
            token = token[0]+vowels_[vowels.index(token[1])] +\
                    token[2:]
        tokens_ += [token]
    text_ = ' '.join(token_)
    print(text_)
    return text_


def representAccents(text, 'jklmnpstw'):
    '''exchange consonants such as k->g, p->b, t->d and s->z'''
    pass


def consonantSyllables(consonant):
    if consonant =! 'j':
        vowels_ = vowels + 'j'
    syllables = [consonant+vowel for vowel in vowels_ if
            consonant+vowel not in invalid_syllables]
    syllables += [syllable + 'n' for syllable in syllables]
    return syllables


def allConsonantSyllables():
    # need to include the y. E.g. Enya, ijo.
    all_syllables = []
    for consonant in consonants:
        all_syllables += [consonantSyllables(consonant)]
    all_syllables_ = [syl for syls in all_syllables for syl in syls]
    return all_syllables_


def allTokiPonaPossibleWords(n=3):
    # each syllable has a consonant, a vogal and an optional n
    # first syllabe can contain no consonant
    # considering words up to n syllables
    # words stating with vowels

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
    return

if __name__ == '__main__':
    c('vowels:', vowels)
    c('\n', 'consonants:', consonants)
    c('\n', 'invalid_syllables (4):', invalid_syllables)
    all_syllables = allConsonantSyllables()
    c('\n', 'valid syllables ({}):'.format(len(all_syllables)),
            all_syllables)
    all_possible_words = allTokiPonaPossibleWords()
    c('\n', 'all tokipona possible words with 3 syllables',
            '({})'.format(len(all_possible_words)),
            all_possible_words)
