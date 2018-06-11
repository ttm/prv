# recursive neural networks
# for word prediction

import numpy as n, scipy as s
from scipy import special as ss

# rnn has N inputs, which are the last X words.

# each word is indexed alphabetically
# (tokenize, set, sort, index of word is used as input to rnn)

# the input which is zero is the word to be predicted.
# the output is thus only one word.

# many of the inputs might be zero,
# case in which the outputs should yield the necessary
# word

words = ['oi', 'gato', 'bonito', 'do', 'pai']
words_ = ['fala', 'beleza', 'fruta', 'que', 'belo']
w = words + words_

def lfun(xvec):
    return 2*ss.expit(xvec) - 1

class NN:
    def __init__(self, X=5, Y=1, Z=4):
        # instantiate X, Y and Z
        self.w = weights = n.random.random((X, Z))
        pass
    def run(self, inp=[0]*5):
        res1 = lfun(self.w[:, 0] *inp)
        res2 = lfun(self.w[:, 1] *res1)
        res3 = lfun(self.w[:, 2] *res2)
        res4 = n.sum(self.w[:, 3] *res3)
        return res4



