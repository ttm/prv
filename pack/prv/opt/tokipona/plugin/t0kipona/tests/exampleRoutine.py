# to import changes made in local package files,
# e.g. if installed with pip3 install -e ~/repos/tokipona/
import sys
keys=tuple(sys.modules.keys())
for key in keys:
    if "tokipona" in key:
        del sys.modules[key]

### Basic usage
import tokipona as t

### the main functionalities are:

# 1 - make a syntax highlighting file for Vim
sh = t.syntax()

# 2 - analyze the official Toki Pona vocabulary
st = t.stats()

# 3 - obtain (very preliminary) Toki Pona wordnet synsets
wn = t.wordnet()

# 4 - synthesize texts in Toki Pona
sy = t.synthesis()

print( sy.createParagraph() )
print( sy.createPhrase() )
print( sy.createPoem() )
print( sy.createSentence() )

# sh, st, wn, sy have objects related to each of the
# functions as further described in this README.

# 5 - further routines and variables in utils:
v, c = t.utils.vowels, t.utils.consonants
str_ = "TP vowels are: {}; TP consonants are: {}".format(v, c)
print(str_)

possible_words = t.utils.allTokiPonaPossibleWords(n=2)
print("all possible words with two syllables given the TP rules are {}".format(possible_words))

##############################################
### check files in tokipona/
# for many other functionalities and convenient variables.

# Tweak at will.
##############################################

