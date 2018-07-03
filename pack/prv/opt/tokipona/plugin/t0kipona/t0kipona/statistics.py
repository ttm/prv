# import ezodf
from .corpus import TPCorpus
# from .synth import TPTabFig
import os
tdir = os.path.dirname(os.path.abspath(__file__))


class TPStats(TPCorpus):
    """
    very preliminary countings and data structures for statistics.

    counting of lemma relations to POS (part-of-speech) tags.

    """
    def __init__(self):
        TPCorpus.__init__(self)
        self._analyseLemmas()
        self._posStats()

    def _posStats(self):
        self.comb_pos=list(self.word_classes.values())
        self.comb_pos_=[]
        for i in self.comb_pos:
            if i not in self.comb_pos_:
                self.comb_pos_.append(i)
        # self.uniqueCombinations(comb_pos_)

        self.pos_comb = {}
        for comb in self.comb_pos_:
            c = str(comb)
            self.pos_comb[c] = []

        self.comb_pos__ = [set(i) for i in self.comb_pos_]
        for word in self.word_classes:
            comb = self.word_classes[word]
            c = set(comb)
            for cc in self.comb_pos_:
                if c == set(cc):
                    c_ = str(cc)
                    self.pos_comb[c_].append(word)

    def _analyseLemmas(self):
        self.word_classes = {}
        for row in self.table:
            # Better choose the class
            classes = [i for i in row[1].split() if i.isupper() and i not in ("I,","O!")]
            classes = ["PRE" if "PRE-VERB" in i else i for i in classes]
            # print(classes)
            if self.precedence=="first":
                class_ = classes[0]
            else:
                class__ = classes
                not_chosen = 1
                for pos in self.precedence:
                    if pos in class__ and not_chosen:
                        class_ = pos
                        self.class_count[pos] += 1
                        self.class_count_[pos] += 1
                        not_chosen = 0
                    elif pos in class__:
                        self.class_count[pos] += 1

            # print(row[0], class_, colors[class_])
            # all2.add(class_)
            words_ = row[0].split()
            if "PRE-VERB" in classes:
                classes[classes.index("PRE-VERB")] = "PRE"
            for word in words_:
                if word != 'or':
                    self.words[class_].add(word)
                    self.word_classes[word] = []
                    for aclass in classes:
                        self.words_all[aclass].add(word)
                        self.word_classes[word].append( aclass )
                else:
                    self.synonyms += 1
        for i in self.word_classes:
            if "PRE" in self.word_classes[i]:
                if "VERB" in self.word_classes[i]:
                    self.word_classes[i].remove("VERB")
