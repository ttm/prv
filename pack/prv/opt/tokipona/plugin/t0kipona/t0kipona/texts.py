from . import statistics
# from .synth import TPTabFig
from .statistics import TPStats

class TPTextBasic(TPStats):
    def __init__(self):
        TP.__init__(self)
        self.tpwords = list(self.word_classes.keys())
        self.vowels = 'aeiou'
        self.consonants = 'jklmnpstw'

    def _firstSyllable(self, token):
        if len(token) <= 2:
            sy = token
            tk = ''
        elif token[0] in self.vowels:
            if token[1] == 'n':
                if token[2] in self.vowels:
                    sy = token[0]
                    tk = token[1:]
                else:
                    sy = token[:2]
                    tk = token[2:]
            else:
                sy = token[0]
                tk = token[1:]
        else:
            if token[2] == 'n':
                if len(token) == 3 or token[3] in self.consonants:
                    sy = token[:3]
                    tk = token[3:]
                else:
                    sy = token[:2]
                    tk = token[2:]
            else:
                sy = token[:2]
                tk = token[2:]
        return sy, tk

    def _getSyllables(self, token):
        tk = token
        syl = []
        while tk:
            sy, tk = self._firstSyllable(tk)
            syl.append(sy)
        return syl

