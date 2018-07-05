import string, random
import nltk as k
from t0kipona import TPWordnetPP, TPSynth

class TPBot:
    def __init__(self):
        self.wn = TPWordnetPP()
        self.s = TPSynth()

    def tpTalk(self, words=''):
        words_ = k.wordpunct_tokenize(words)
        words_ = [i for i in words_ if i not in string.punctuation]
        # find the synsets for each w in word_
        # find the tp words which have such synsets
        # choose a random word or the word that has more synsets in the wS
        ss = [set(k.wordnet.wordnet.synsets(w, lang='por')) for w in words_]
        [i.update(set(k.wordnet.wordnet.synsets(w))) for i, w in zip(ss, words_)]
        wnmask = dict(zip(words_, ss))
        tpw = []
        i = 0
        self.wordsss = {}
        for ss_ in ss:
            for ss__ in ss_:
                self.wordsss[ss__] = words_[i]
                if ss__ in self.wn.wnss:
                    tpw.append(self.wn.wnss[ss__])
            i += 1
        print(tpw)
        tpw_ = list(set(tpw))
        w_ = random.choice(tpw_)
        self.dd = locals()
        return self.s.createParagraph(1, [w_])
        # percorrer hiperonimos p achar os synsets do toki pona




