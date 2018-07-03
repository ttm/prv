# import ezodf
from .corpus import TPCorpus

class TPWordnet(TPCorpus):
    """
    Toki Pona (hacky) wordnet.

    After initialization, the most important attributes are three
    dictionaries relating Toki Pona words to Princeton Wordnet:
        wordnet, relates each word to all synsets with the same lemma
        wordnet_, prepositions are excluded
        wordnet__, only synsets of the same morphosyntactic class as
            in the official Toki Pona dictionary

    TODO
    ----
    - make a better mask to Wordnet, as made in NLTK for Portuguese.
    - remove/enhance relarions yield by compound terms
        (e.g. 'have information on')
    """

    def __init__(self):
        TPCorpus.__init__(self)
        self._mkDataStr()
        self._init()

    def _mkDataStr(self):
        self.words = {}
        for row in self.table:
            all_pos = row[1].split("\n")
            lemma_pos = []
            for pos in all_pos:
                class_ = [i for i in pos.split() if i.isupper() and i not in ("I,","O!")][0]
                en_words = [i for i in pos.replace(" or ", ' ').split() if i.islower() or i in ("I,","O!")]
                for enw in en_words:
                    if enw in ('to','a','of','and','in','take','on','form','at','for'):
                        continue
                    w = enw.replace(";", "").replace(',', '').replace('(', '').replace(')', '').replace('?', '')
                    lemma_pos.append( (w, class_) )

            words_ = row[0].split()
            if 'or' in words_:
                words_.remove("or")
            for w in words_:
                self.words[w] = lemma_pos

    def _init(self):
        import nltk as k
        self.pos = {'NOUN': 'n',
                'VERB': 'v',
                'PRE-VERB': 'v', # pre-verbs are also verbs
                'ADJECTIVE': 'asr', # adjectives are also adverbs and satellite adjectives
                'NUMBER': 'asr' # numbers are qualifiers
                }

        self.wordnet = {}
        self.wordnet_ = {}
        self.wordnet__ = {}
        for word in self.words:
            self.wordnet[word] = set()
            self.wordnet_[word] = set()
            self.wordnet__[word] = set()
        for word in self.words:
            # if word in ('li', 'e', 'la', 'pi'):
            #     continue
            synsets = []
            synsets_ = []
            synsets__ = []
            for enw in self.words[word]:
                class_ = enw[1]
                if class_ in ('PARTICLE'):
                    continue
                w = enw[0]
                ss_ = k.wordnet.wordnet.synsets(w)
                if class_ in ('PREPOSITION'):
                    synsets += ss_
                    continue
                c = self.pos[class_]
                synsets += ss_
                synsets_ += ss_

                ss = k.wordnet.wordnet.synsets(w, pos=c)
                synsets__ += ss
            self.wordnet[word].update(synsets)
            self.wordnet_[word].update(synsets_)
            self.wordnet__[word].update(synsets__)

        synsets = []
        synsets_ = []
        synsets__ = []
        for word in self.wordnet:
            ss = self.wordnet[word]
            synsets += ss
            ss_ = self.wordnet_[word]
            synsets_ += ss_
            ss__ = self.wordnet__[word]
            synsets__ += ss__

        self.synsets = set(synsets)
        self.synsets_ = set(synsets_)
        self.synsets__ = set(synsets__)

        # TODO:
        # total number of synsets
        # total number of synsets counting neighbors
