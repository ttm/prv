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


class SimplestCorpus:
    """Only one text"""
    def __init__(self, path, cid):
        # open files in path
        self.id = cid
        self.text = open(path, 'r').read()
        self.text_ = k.wordpunct_tokenize(self.text)
class SimplestBot:
    """
    The conversational agent.

    Notes
    -----
    Also called a: particle, soul, being, agent, alien, person.
    
    """
    def __init__(self, bid):
        self.id = bid
    def addVisitedReality(self, reality):
        self.reality = reality
    def addDataAttr(self, data, attrname='data'):
        self.__dict__[attrname] = data
    def addMethodAttr(self, method, attrname='method'):
        self.__dict__[attrname] = types.MethodType(method, self)

class SimplestPopulation:
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
    The methods of child realities might consider ot not the World and the
    Bot.

    """
    def __init__(self, rid):
        self.id = rid
    def touchBots(self):
        """to be overritten by child classes.
        
        Describes a procedure to be executed when a bot *experiences*
        a reality. Whis routine is called by World.perform() before
        calling World.reality.iterateBots().

        Although not be strict,
        this routine is dedicated to giving Bots new abilities,
        in the form of data and methods attributes,
        while self.iterateBots() enhances them."""
        pass
    def iterateBots(self):
        """to be overritten by child classes.
        
        Describes a procedure to be executed when a bot *resides* in
        a reality. Whis routine is called by World.perform() after
        calling World.reality.touchBots().

        Although not strict,
        this routine is dedicated to enhancing abilities of Bots,
        that are instantiated in the form of data and methods attributes
        by touchBots()."""
        pass
class SimplestMarkovReality(Reality):
    """Only uses bigrams, only has one talk method."""
    def __init__(self, rid):
        Reality.__init__(self, rid)
    def touchBots(self, world):
        self.makeBigrams(world.corpus.text_)
        for bot in world.population:
            if 'ngrams' not in dir(bot):
                bot.ngrams = []
            if 'vocab' not in dir(bot):
                bot.vocab = []
            bot.addDataAttr(self.ngrams_, 'ngrams')
            bot.addDataAttr(world.corpus.text_, 'vocab')
            bot.addVisitedReality(self.id)
            self.addTalkAbility(bot)
    def addTalkAbility(self, bot):
        bot.markovTalk = types.MethodType(SimplestMarkovReality.markovTalk, bot)
        bot.sentlength = 0
    def makeBigrams(self, text):
        c = Counter(k.ngrams(text,2))
        aa = sorted(c.items(), key = lambda ngram: -ngram[1])
        d = x.DiGraph()
        d.add_nodes_from(text)
        for ng in aa:
            d.add_edge(ng[0][0], ng[0][1], weight = ng[1])
        self.ngrams_ = d
    def markovTalk(self, words='', length=10):
        bi = self.ngrams
        # choose a random bigram or trigram
        # choose a word to begin sentence
        # concatenate bi/tri until the phrase is complete
        words_ = words.split(' ')
        if len(words_) > 0:
            word = random.choice(words_)
            while word not in self.vocab:
                words_.remove(word)
                if len(words_) > 0:
                    word = random.choice(words_)
                else:
                    word = ''
                    break
        if not word:
            word = random.choice(self.vocab)
        # print(self.ngrams[0][2]['1john'][0]['and'], word)
        dg = self.ngrams
        s1 = word
        if self.sentlength > 0:
            length = self.sentlength
        for i in range(length):
            w_ = random.choice(list(dg[word].keys()))
            s1 += ' ' + w_
            word = w_
        return s1


class SimplestWorld:
    """Only one ability (talk), one population and one corpus
    
    Notes
    -----
    Other talk methods:
        choose only the X most used words/bigrams.
        give preference for a sequence of words
            ['rice', 'arm']
            will start with rice if possible
            and use arm as soon as the second
            token of the bigram is available.
        return terms and collocations in corpus 
        regulate punctuation and/or stopwords
        relate to synonymy and other Wordnet relations
        give preference to vowels, consonants, syllables, wordsize, etc.
        return text as poem with x syllables, words, verses, etc
        make sentences that respect POS standard structures.
        return sentence and all words replaced by hypo and hypernyms, when possible.

    other corpus possibilites:
        more then one corpus, what are the possibilites?
            multicorpus is multilanguage is multiculture worlds?
            multipopulation worlds are 
        remove punctuation and/or stopwords
        process with POS tagging to use in Talk
        make standard mythological, scientific (complex networks) and etc corpus
        trigrams/quadrigrams etc might be encoded in the bigrams network:
            edges have arbitrary attributes, which might be:
              g.nodes[x][y][z] = ntrigrams(x,y,z)
            is there a better way? write networkx community

    other population structures:
        more then one population:
            multi-population is multi-specie or multi-race worlds?
            do they interact?
            will they be just a sequence of sequence/sets of bots?
        a population might be a sequence or an unordered set.
        the population might have different, random attributes.

    other perform routines:
        iteration evolve population of bots:
            by natural selection
            by enhancing their abilities without natural selection
            any alternative to a fitness value?
        see |fzf|, use fuzzy logic to iterate/operate among Bots

    """
    def __init__(self, wid, reality):
        self.population = []
        self.reality = reality
        self.id = wid
    def addCorpus(self, corpus):
        self.corpus = corpus
    def addBot(self, bot):
        self.population.append(bot)
    def perform(self):
        self.considerReality()
        self.iterate()
    def considerReality(self):
        self.reality.touchBots(self)
        # anything else specific of this world
    def iterate(self):
        self.reality.iterateBots()
        # anything else specific of this world

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
        self.reality.touchBots(self)
    def iterate(self):
        """To be overwritten in iterative worlds"""
        self.reality.iterateBots()

class Universe:
    """
    A collection of worlds sharing the same reality

    Notes
    -----
    Ideally, iteration occurs in a Universe or a World.

    """
    pass

def baselineBotFromText(textf, botname='b0t', realityname='r1',
        worldname='w1', corpusname='c1'):
    r = SimplestMarkovReality(realityname)
    w = SimplestWorld(worldname, r)
    c = SimplestCorpus(textf, corpusname)
    w.addCorpus(c)
    b = SimplestBot(botname)
    w.addBot(b)
    w.perform()
    return b

if __name__ == '__main__':
    b = baselineBotFromText("/home/renato/.vim/pack/ttm/opt/aa/aux/aashouts.txt",
            'Srila')
    # r = SimplestMarkovReality('reality1')
    # w = SimplestWorld('world1', r)
    # # c = Corpus("/home/renato/repos/joyce/corpus/1john.txt", '1john')
    # # c = SimplestCorpus("../corpus/butlerPreciado2.txt", '1john')
    # c = SimplestCorpus("/home/renato/.vim/pack/ttm/opt/aa/aux/aashouts.txt", 'shouts')
    # w.addCorpus(c)
    # b = SimplestBot('Srila')
    # w.addBot(b)
    # w.perform()
    # b.markovTalk()
