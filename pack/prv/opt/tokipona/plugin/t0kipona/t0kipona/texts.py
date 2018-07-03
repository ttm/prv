from . import statistics
import numpy as n
np = n

class TPSynth(statistics.TPTextBasic):
    def __init__(self):
        statistics.TPTextBasic.__init__(self)
        self._declareWords()

    def _declareWords(self):
        self.plain_words = list(self.word_classes.keys())
        self.prepositions = list(self.words['PREPOSITION'])
        forbiden = ['li', 'e', 'la', 'pi', 'a', 'o', 'anu', 'en', 'seme', 'mu', 'kepeken', 'lon', 'tan']
        for f in forbiden:
            self.plain_words.remove(f)
        self.words_nsy = [
                [i for i in self.plain_words if len(self._getSyllables(i)) == 1],
                [i for i in self.plain_words if len(self._getSyllables(i)) == 2],
                [i for i in self.plain_words if len(self._getSyllables(i)) == 3]
                ]

    def _countSyllables(self, token):
        t = token.split(' ')
        nsy = 0
        vowel = 0
        for i in t:
            nsy += len(self._getSyllables(i))
            if i[0] in self.vowels and vowel:
                nsy -= 1
            if i[-1] in self.vowels:
                vowel = 1
            else:
                vowel = 0
        return nsy

    def createPhrase(self, nsy=0, nwords=0, vowel=False):
        """
        Create a Toki Pona phrase.

        Such phrase might be used as a noun or verb phrase,
        and as a subject, predicate, object or prepositional phrase.

        Parameters
        ----------
        nsy : integer
            The number of syllables of the phrase.
            If nsy=0, the phrase will have a random number of syllables
        nwords : integer
            The number of words in the phrase.
            If nwords != 0, nsy is ignored.
        vowel : boolean

        Returns
        -------
        ph : string
            A phrase in Toki Pona.

        See Also
        --------
        createSentence : creates a sentence in Toki Pona.

        Notes
        -----
        If a word ends with a vowel and the next starts with a vowel,
        an elision occurs and such two syllables are regarded as one.

        References
        ----------
        .. [1] Fabbri, Renato, "Basic concepts and tools for the Toki Pona minimalist language: Wordnet synsets; analysis, synthesis and syntax highlighting of texts." arXiv preprint arXiv:abs/XXX.XXXX (2017)

        """
        phrase = ''
        if nwords:
            for i in range(nwords):
                w = n.random.choice(self.plain_words)
                phrase += w + ' '
        else:
            if nsy == 0:
                nsy = n.random.randint(1,7)
            nsy_ = 0
            while nsy_ < nsy:
                w = n.random.choice(self.plain_words)
                s = self._getSyllables(w)
                l = len(s)
                if w[0] in self.vowels and vowel:  # elision
                    l -= 1
                if nsy_+l > nsy:
                    continue
                nsy_ += l
                phrase += w + ' '
                if w[-1] in self.vowels:
                    vowel = 1
                else:
                    vowel = 0
        p = phrase[:-1]
        p_ = p.split()
        nsy_ = sum([len(self._getSyllables(i)) for i in p_])
        if len(p_) > 2 and nsy_ > 4:
            if n.random.random() < .2:  # use pi in 1/5 of sentences
                print('\n', p, self._countSyllables(p))
                where = n.random.randint(len(p_)-2)
                p_.insert(where+1, 'pi')
                if p_[where+2][0] not in self.vowels or (p_[where+2][0] in self.vowels and p_[where][-1] in self.vowels):
                    # choose a words with two or three syllables
                    # and make them one syllable shorter
                    p__ = ' '.join(p_)
                    while self._countSyllables(p__) != self._countSyllables(p):
                        sy__ = n.array([len(self._getSyllables(i)) for i in p_])
                        if n.all(sy__ == 1):
                            if self._countSyllables(' '.join(p_)) < nsy:
                                where_ = n.random.randint(len(p_))
                                p_.insert(where_, n.random.choice(self.plain_words))
                            elif self._countSyllables(' '.join(p_)) > nsy:
                                chosen = n.random.randint(0, len(p_))
                                while p_[chosen] == 'pi':
                                    chosen = n.random.randint(0, len(p_))
                                p_.pop(chosen)
                        else:
                            ok = (sy__ > 1).nonzero()[0]
                            chosen = n.random.choice(ok)
                            size = sy__[chosen]
                            w = n.random.choice(self.words_nsy[size-2])
                            p_[chosen] = w
                            p__ = ' '.join(p_)
                print(' '.join(p_), self._countSyllables(' '.join(p_)))
        pp = ' '.join(p_)

        return pp

    def createSentence(self, n=0, v=0, o=0, p=0,prep=True):
        """
        Create a Toki Pona sentence.

        Such phrase will always have a subject, predicate
        and object. Preposition is optional.

        If any of n, v, o, p is 0, it will be replaced by a random
        value in [1,4].

        Parameters
        ----------
        n : integer
            The number of words in the subject phrase.
        v : integer
            The number of words in the predicate phrase.
        o : integer
            The number of words in the object phrase.
        p : integer
            The number of words in the prepositional phrase.
        prep : boolean
            If True, the sentence will have a prepositional phrase,
            else it will not have a prepositional phrase.

        Returns
        -------
        se : string
            A sentence in Toki Pona.

        See Also
        --------
        createPhrase : creates a phrase in Toki Pona.

        Notes
        -----
        See createPhrase to understand how the phrases are created.

        References
        ----------
        .. [1] Fabbri, Renato, "Basic concepts and tools for the Toki Pona minimalist language: Wordnet synsets; analysis, synthesis and syntax highlighting of texts." arXiv preprint arXiv:abs/XXX.XXXX (2017)

        """
        sentence = ''
        if not n:
            n = np.random.randint(1, 5)
        if not v:
            v = np.random.randint(1, 5)
        if not o:
            o = np.random.randint(1, 5)
        sentence += self.createPhrase(nwords=n) + ' '
        if sentence[:-1] not in ('mi', 'sina'):
            sentence += 'li '
        sentence += self.createPhrase(nwords=v) + ' e '
        sentence += self.createPhrase(nwords=o)
        if prep:
            if not p:
                p = np.random.randint(1, 5)
            sentence += ' ' + np.random.choice(self.prepositions) + ' ' + self.createPhrase(nwords=p)
        return sentence

    def createPoem(self, nsyl=10, lstan=4, nstan=6, rhyme=True):
        """
        Create a Toki Pona poem.

        Parameters
        ----------
        nsy : integer
            The number of syllables of the verses.
            If nsy=0, the verses will have a random number of syllables
        lstan : integer
            The number of verses in an stanza.
            lstan is always considered to be 4,
            other values for lstan are not implemented.
        nstan : integer
            The number of stanzas.


        Returns
        -------
        poem : string
            The resulting poem.

        References
        ----------
        .. [1] Fabbri, Renato, "Basic concepts and tools for the Toki Pona minimalist language: Wordnet synsets; analysis, synthesis and syntax highlighting of texts." arXiv preprint arXiv:abs/XXX.XXXX (2017)

        """
        if nsyl < 5:
            return 'nsyl must be >= 5'
        # more then one sentence section per verse
        stanzas = []
        for i in range(nstan):
            stanza = ''
            for j in (0, 1):
                nsyl0 = nsyl1 = nsyl//2
                if nsyl%2 == 0:
                    nsyl1 -= 1
                s = self.createPhrase(nsyl0)
                v = self.createPhrase(nsyl1, vowel=True)
                o = self.createPhrase(nsyl1, vowel=True)
                p = n.random.choice(self.prepositions)
                while len(self._getSyllables(p)) >= nsyl1:
                    p = n.random.choice(self.prepositions)
                if o[-1] in self.vowels and p[0] in self.vowels:
                    elision = 1
                else:
                    elision = 0
                nsyl_ = nsyl - (nsyl1 + 1) - len(self._getSyllables(p)) + elision
                p_ = self.createPhrase(nsyl_, vowel=p[-1] in self.vowels)
                stanza += s + ' li ' + v
                stanza += '\ne ' + o + (' %s %s\n' % (p, p_))
            stanzas.append(stanza[:-1])
        poem = "\n\n".join(stanzas)
        return poem

    def createParagraph(self, nsentences=0, words=[]):
        """
        Synthesizes a paragraph in Toki Pona.

        Might not have all words if nsentences < len(words).
        Discards Toki Pona words not recognized.

        """
        ww = []
        for w in words:
            w_ = w.lower()
            if w_ in self.plain_words:
                ww.append(w_)
        words = ww
        if not nsentences:
            nsentences = n.random.randint(3,10)
        sentences = []
        ri = n.random.randint
        for i in range(nsentences):
            sentences.append(self.createSentence(ri(1,4),ri(1,4),ri(1,4),ri(1,4),prep=n.random.randint(0,2)))

        w = set()
        s1 = []
        s2 = []
        for s in sentences:
            have_word = 0
            for ww in words:
                if ww in s:
                    w.add(ww)
                    have_word = 1
            if have_word:
                s1.append(s)
            else:
                s2.append(s)
        w2 = set(words)
        w_ = w2.difference(w)
        while s2 and w_:
            ss = self.createSentence(prep=n.random.randint(0,2))
            w__ = w_.copy()
            for w in w__:
                if w in ss:
                    s1.append(ss)
                    s2.pop()
                    w_.remove(w)
        paragraph = ". ".join(s1+s2)
        return paragraph
