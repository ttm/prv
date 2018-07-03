#####
# this is just a hack to reload the module files when they change
import sys
keys=tuple(sys.modules.keys())
for key in keys:
    if "t0kipona" in key:
        del sys.modules[key]
import t0kipona as t
#####

#######
# to synthesize TP text
s = t.TPSynth()
# use s.createPhrase(), s.createSentence(), s.createParagraph() and
# s.createPoem()

#######
# to use the preliminary TP wordnets
w = t.TPWordnet()
# use w.wordnet, w.wordnet_ and w.wordnet__, each with less synsets

#######
# to make the syntax highlighting file:
sh = t.TPSynHigh()
sh.mkSynHighFile()  # this creates the Vim syntax highlighting

#######
# this is the most complete object with data on Toki Pona (TP),
# including statistics, although other classes have other data.
tf = t.TPTabFig()
tf.mkAll()  # this renders all the figures and tables of the TP article

#######
# also, check the functions and variables in
# t.utils

# Ter Jul  3 19:59:02 -03 2018
