import os, types, random
import nltk as k, networkx as x
from collections import Counter

# There are two networks: one of the bigrams,
# and one of the trigrams.
# They have the same vocabulary.
# They are both weighted digraphs,
# but the trigrams graph is a multigraph.
# These structures are best represented
# as networkx digraphs and multigraphs.

# big = x.DiGraph()
# for b in bi:
#     big[b[0]][b[1]] = bi[b]


def markovTalk(self, word=''):
    bi = self.ngrams[0][2]['1john']
    tri = self.ngrams[0][3]['1john']
    # choose a random bigram or trigram
    # choose a word to begin sentence
    # concatenate bi/tri until the phrase is complete
    vocabs = list(self.vocab[0].keys())
    if not word:
        for v in vocabs:
            word = random.choice(self.vocab[0][v][0])
    # print(self.ngrams[0][2]['1john'][0]['and'], word)
    dg = self.ngrams[0][2]['1john'][0]
    s1 = word
    for i in range(10):
        w_ = random.choice(list(dg[word].keys()))
        s1 += ' ' + w_
        word = w_
    print(s1)

def ngram(text, n):
    c = Counter(k.ngrams(text,n))
    aa = sorted(c.items(), key = lambda ngram: -ngram[1])
    if n == 2:
        d = x.DiGraph()
        d.add_nodes_from(text)
        for ng in aa:
            # d[ng[0][0]][ng[0][1]]['weight'] = ng[1]
            d.add_edge(ng[0][0], ng[0][1], weight = ng[1])
        return d
    return aa
class Corpus:
    def __init__(self, path, cid):
        # open files in path
        self.id = cid
        self.text = open(path, 'r').read()
        self.text_ = k.wordpunct_tokenize(self.text)
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
                if 'vocab' not in dir(bot):
                    bot.vocab = []
                bot.ngrams.append(self.ngrams_)
                bot.vocab.append(self.vocab)
                bot.visited_realities.append('markov' + '-'.join([str(i) for i in self.ngrams]))
                bot.visited_realities.append(self.id)
                self.addTalkAbility(bot)
    def addTalkAbility(self, bot):
        bot.markovTalk = types.MethodType(markovTalk, bot)
    def makeNgrams(self, n, world):
        self.ngrams_[n] = {}
        self.vocab = {}
        for c in world.corpus:
            c_ = world.corpus[c]
            self.ngrams_[n][c] = [ngram(c_.text_, n)]
            self.vocab[c] = [list(set(c_.text_))]

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
    # c = Corpus("/home/renato/repos/joyce/corpus/1john.txt", '1john')
    c = Corpus("../corpus/butlerPreciado2.txt", '1john')
    r = MarkovReality('reality1')
    w = World('world1', r)
    w.addCorpus(c)
    b = Bot('Srila')
    w.addBot(b)
    w.perform()
