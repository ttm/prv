from .texts import TPTextBasic, tdir
import numpy as n
np = n

class TPSynth(TPTextBasic):
    def __init__(self):
        TPTextBasic.__init__(self)
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


class TPTabFig(TPTextBasic):
    """
    TP tables, figures and statistcs about the vocabulary.

    Used by the TP article included in this framework.
    Basic usage:
        tf = TPTabFig()
        tf.mkAll()

    Check all tf.mk* methods for individual
    tabels and figures.

    TODO
    ----
    - separate the procedures which calculate the statistics
    into separate methods, e.g. with:
        self.extend(locals())
        return locals()
    appended and the procedure substituted e.g. by:
        locals().extend(self.vowelStats())
    """

    def __init__(self):
        TPTextBasic.__init__(self)
        print(self.__doc__)

    def mkPosTable(self):
        from collections import OrderedDict
        pos_ = OrderedDict(sorted(self.class_count_.items(), key=lambda t: -t[1]))
        pos = OrderedDict(sorted(self.class_count.items(), key=lambda t: -t[1]))

        import percolation as p
        labels=list(pos.keys())
        fpath = tdir.split("plugin")[0] + 'aux/article/acm/pos.tex'
        p.mediaRendering.tables.writeTex(
                p.mediaRendering.tables.encapsulateTable(
                    p.mediaRendering.tables.makeTabular(
                        ["POS"]+labels+["total"], 
                        [["All", "Chosen"]] + list(zip(pos.values(), pos_.values())) + [[sum(pos.values()),120]]),
                    """"POS tags incident and chosen as preferential e.g. in text synthesis.
                    The official dictionary often relates tokens
                    to more than one POS tag.
                    For the text highlighting Plugin, for example,
                    a token has to have an established tag to have
                    a defined color.
                    On the Chosen column, the tokens were regarded only once
                    by choosing the first occurrence of """+str(self.precedence)+" in the official dictionary."),
                fpath)
        p.mediaRendering.tables.doubleLines(fpath,
                hlines=[], vlines=[], hlines_=[0,2,3,4,5,6,7,9],
                vlines_=[0,2,3])

    def mkLetters(self):
        tpwords = self.tpwords
        tpwords_ = ''.join(tpwords)

        vowels = self.vowels
        consonants = self.consonants
        vowels_ = ''.join(v for v in tpwords_ if v in vowels)
        consonants_ = ''.join(v for v in tpwords_ if v in consonants)

        fracv =  [100*tpwords_.count(i)/len(tpwords_) for i in vowels]
        fracv_ = [100*vowels_.count(i)/len(vowels_) for i in vowels]

        fracc =  [100*tpwords_.count(i)/len(tpwords_) for i in consonants]
        fracc_ = [100*consonants_.count(i)/len(consonants_) for i in consonants]
        # overall, only vowels, only consonants, begin, end, middle

        firstl = ''.join(i[0] for i in tpwords)
        lastl = ''.join(i[-1] for i in tpwords)
        midl = ''.join(i[1:-1] for i in tpwords if len(i)>2)
        vowels__ = ''.join(v for v in firstl if v in vowels)
        consonants__ = ''.join(v for v in firstl if v in consonants)

        def statMe(token):
            vowels_ = ''.join(v for v in token if v in vowels)
            consonants_ = ''.join(v for v in token if v in consonants)

            fracv =  [100*token.count(i)/len(token) for i in vowels]
            fracv_ = [100*vowels_.count(i)/len(vowels_) for i in vowels]

            fracc =  [100*token.count(i)/len(token) for i in consonants]
            fracc_ = [100*consonants_.count(i)/len(consonants_) for i in consonants]

            data = [ fracv+fracc, fracv_+['-']*len(fracc_), ['-']*len(fracv_)+fracc_]
            return data

        letter_sets = [tpwords_, firstl, lastl, midl]
        all_data = []
        for ls in letter_sets:
            data = statMe(ls)
            all_data += data

        l0 = ['freq', 'v', 'c', 'freq\\_I', 'v', 'c', 'freq\\_L', 'v', 'c', 'freq\\_M', 'v', 'c']
        l_ = [[i[j] for i in all_data] for j in range(14)]
        ll = [l0]+l_
        import percolation as p
        fpath = tdir.split("plugin")[0] + 'aux/article/acm/vowels.tex'
        p.mediaRendering.tables.writeTex(
                p.mediaRendering.tables.encapsulateTable(
                    p.mediaRendering.tables.makeTabular(
                        ["letter"]+[i for i in vowels]+[i for i in consonants], 
                        ll,
                        True),
                    """Frequency of letters in Toki Pona. Columns
                    freq, freq\\_I, freq\\_L and freq\\_M are
                    the frequencies of the letters in any, initial, last and middle
                    positions.
                    The columns 'v' and 'c' that follow them are frequencies
                    considering only vowels and consonants.
                    The most frequent vowel is 'a' in any position,
                    although it is more salient among words starting with a vowel
                    and among the last letter of the words.
                    For starting, ending and middle positions, the second most frequent
                    vowel varies.
                    Among the consonants, 'n' is the most frequent because it is
                    the only consonant allowed in the last position and because
                    almost 20\\% of the words end with 'n'.
                    On the initial position, 's' is the most frequent consonant,
                    while in middle position 'l' is the most frequent consonant.
                    Many other conclusions may be drawn from this table and are
                    useful e.g. for exploring sonorities in poems.""",
                    'freqLet'),
                fpath)
        p.mediaRendering.tables.fontSize(fpath, write=1)
        p.mediaRendering.tables.doubleLines(fpath,
                hlines=[], vlines=[], hlines_=[0,2,3,4,5,7,8,10,11,13,14,15],
                vlines_=[0,2,3,5,6,8,9,11,12,13])

    def mkSyllables(self):

        syllables = [self._getSyllables(i) for i in self.tpwords]
        syllables_ = [j for i in syllables for j in i]

        syllables__ = list(set(syllables_))
        syllables__.sort()
        syllables__.sort(key=len)
        self.syllables__ = syllables__

        syllables_0 = [i[0] for i in syllables]
        syllables_1 = [i[-1] for i in syllables]
        syllables_i = [i[1] for i in syllables if len(i) == 3]

        syls = [syllables_, syllables_0, syllables_1, syllables_i]
        hsyls = [self._histSyl(i) for i in syls]

        lsyl = [len(i) for i in syllables]
        self.hsyl = hlsyl = [100*lsyl.count(i)/len(lsyl) for i in (1, 2, 3)]
        hlsyl_ = [lsyl.count(i) for i in (1, 2, 3)]
        self.hsyl__ = hlsyl__ = [[w for w in self.tpwords if len(self._getSyllables(w)) == i] for i in (1, 2, 3)]
        [i.sort() for i in hlsyl__]
        [i.sort(key=len) for i in hlsyl__]

        fracv0_ = [self._v(i) for i in syllables_0]
        fracv1_ = [self._v(i) for i in syllables_1]
        l0 = ['all', 'first', 'last', 'middle']
        l_ = [[self._aformat(i[j]) for i in hsyls] for j in range(10)]
        ll = [l0]+l_

        import percolation as p
        fpath = tdir.split("plugin")[0] + 'aux/article/acm/syls.tex'
        p.mediaRendering.tables.writeTex(
                p.mediaRendering.tables.encapsulateTable(
                    p.mediaRendering.tables.makeTabular(
                        ['rank']+[str(i+1) for i in range(10)], 
                        ll,
                        True),
                    """Frequency of syllables in Toki Pona
                    considering all 235 syllables of the 124 tokens,
                    only the first or last syllables or only the middle
                    syllables.
                    In parenthesis are the count and percentage of the
                    corresponding syllable. For more information and a
                    complete list of syllables, see Section~\\ref{sec:stat}.
                    """,
                    'tab:freqSyl'),
                fpath)

        p.mediaRendering.tables.doubleLines(fpath,
                hlines=[], vlines=[], hlines_=[0,2,3,4,5,6,7,8,9,10,11],
                vlines_=[0,2,3,4,5])

    def _aformat(self, syl):
        syl_ = '{} ({}, {:.2f}\\%)'.format(syl[0], syl[2], syl[1])
        return syl_

    def _histSyl(self, syllables_):
        freq_syl = [(i, 100*syllables_.count(i)/len(syllables_), syllables_.count(i)) for i in self.syllables__]
        # aa = list(zip(syllables__, freq_syl))
        bb = sorted(freq_syl, key=lambda t: -t[1])
        return bb

    def _v(self, syl):
        for i in syl:
            if i in 'aeiou':
                return i


    def mkPossibleSentences(n, v, o, p=[1], nparticles=1):
        p_ = 1
        for pp in p:
            p_ *= 5 * 110**pp

        delta = 110**n * 110**v * 110**o * p_ * 10^3
        return delta 

    def mkPossibleWords(self):
        syllables_possible = set()
        for c in self.consonants:
            for v in vowels:
                syllables_possible.add(c+v)
                syllables_possible.add(c+v+'n')
        forbiden = ['ji', 'wu', 'wo', 'ti', 'nn', 'nm']
        for i in forbiden[:-2]:
            syllables_possible.remove(i)

        syllables_start = set([i for i in vowels]) | set([i+'n' for i in vowels]) | syllables_possible

        words1 = syllables_start
        words2 = set()
        for i in words1:
            for j in syllables_possible:
                words2.add(i+j)
        words2_ = words2.copy()
        for i in forbiden:
            for j in words2:
                if i in j:
                    # it might have been removed because of another restriction
                    if j in words2_:
                        words2_.remove(j)

        words3 = set()
        for i in words2:
            for j in syllables_possible:
                words3.add(i+j)
        words3_ = words3.copy()
        for i in forbiden:
            for j in words3:
                if i in j:
                    # it might have been removed because of another restriction
                    if j in words3_:
                        words3_.remove(j)
        nwords = [len(i) for i in (words1, words2, words3)]
        return nwords

    def mkAll(self):
        self.mkPosTable()
        self.mkSyllables()
        self.mkLetters()

