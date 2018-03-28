import os, types
import nltk as k
from collections import Counter
def markovTalk(self):
    bi = self.ngrams[0][2]['1john']
    tri = self.ngrams[0][3]['1john']
    # choose a random bigram or trigram
    # choose a word to begin sentence
    # concatenate bi/tri until the phrase is complete
    print([0][:50])
def ngram(text, n):
    c = Counter(k.ngrams(text,n))
    aa = sorted(c.items(), key = lambda ngram: -ngram[1])
    return aa
class Corpus:
    def __init__(self, path, cid):
        # open files in path
        self.id = cid
        if os.path.isdir(path):
            fnames = os.listdir(path)
            self.texts = [open(fn, 'r').read() for fn in fnames]
            self.text = " ".join(self.texts)
        else:
            self.text = open(path, 'r').read()
            self.texts = [self.text]
        self.text_ = k.wordpunct_tokenize(self.text)
        self.texts_ = [k.wordpunct_tokenize(t) for t in self.texts]
class Bot:
    """
    The conversational agent.

    Notes
    -----
    Also called a: particle, soul, being, agent, alien, person.
    
    """
    def __init__(self, bid):
        self.id = bid
        self.visited_realities = []
class Population:
    """
    A collection of Bots.

    Notes
    -----
    Such bots might be universes or generalized beings,
    i.e. souls.

    """
    pass
class Reality:
    """
    A collection of ways by which Bots interact with Corpus and other Bots.

    Notes
    -----

    """
    def __init__(self, rid):
        self.id = rid
        self.perform = []  # for methods implied by reality when world performs
    pass
class MarkovReality(Reality):
    def __init__(self, rid, ngrams=(2,3)):
        Reality.__init__(self, rid)
        self.ngrams = ngrams
        self.ngrams_ = {}  # for ngram statistics
        self.perform.append(self.trainBots)
    def trainBots(self, world):
        for ng in self.ngrams:
            self.makeNgrams(ng, world)
        for pop in world.populations:
            for bot in world.populations[pop]:
                if 'ngrams' not in dir(bot):
                    bot.ngrams = []
                bot.ngrams.append(self.ngrams_)
                bot.visited_realities.append('markov' + '-'.join([str(i) for i in self.ngrams]))
                bot.visited_realities.append(self.id)
                self.addTalkAbility(bot)
    def addTalkAbility(self, bot):
        bot.markovTalk = types.MethodType(markovTalk, bot)
    def makeNgrams(self, n, world):
        self.ngrams_[n] = {}
        for c in world.corpus:
            c_ = world.corpus[c]
            self.ngrams_[n][c] = [ngram(c_.text_, n)]
            self.vocab[c] = [list(set(c_.text_))]
            if len(c_.texts) > 1:
                for t in c_.texts_:
                    self.ngrams_[n][c].append(ngram(t, n))
class World:
    """
    A binding of Reality, Population, and Corpus.

    Notes
    -----
    Might elaborate Reality, specially through biological, geological,
    atmospheric metaphors.

    """
    def __init__(self, wid, reality):
        self.populations = {}
        self.corpus = {}
        self.reality = reality
        self.id = wid
    def addCorpus(self, corpus):
        self.corpus[corpus.id] = corpus
    def addBot(self, bot, population=0):
        if population not in self.populations:
            self.populations[population] = []
        self.populations[population].append(bot)
    def perform(self):
        self.considerReality()
        self.iterate()
    def considerReality(self):
        # perform methods requested by reality
        for method in self.reality.perform:
            method(self)
    def iterate(self):
        """To be overwritten in iterative worlds"""
        pass
class Universe:
    """
    A collection of worlds sharing the same reality

    Notes
    -----
    Ideally, iteration occurs in a Universe or a World.

    """
    pass
if __name__ == '__main__':
    c = Corpus("/home/renato/repos/joyce/corpus/1john.txt", '1john')
    r = MarkovReality('reality1')
    w = World('world1', r)
    w.addCorpus(c)
    b = Bot('Srila')
    w.addBot(b)
    w.perform()
