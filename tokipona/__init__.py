from . import utils
def stats():
    from . import makeStatistics as stats
    return stats
def synthesis():
    from . import makeTexts as synthesis
    return synthesis
def syntax():
    from . import makeVimSyntax as syntax
    return syntax
def wordnet():
    from . import makeWordnet as wordnet
    return wordnet
# del makeStatistics, makeTexts, makeVimSyntax, makeWordnet

__doc__ = """The main modules of this tokipona package are:
- stats: for statistics of the official vocabulary.
- synthesis: for synthesizing phrases, sentences, paragraphs, short narratives and poems.
- syntax: to tweak and synthesize the Vim syntax file for Toki Pona.
- wordnet: for thea achievement and usage of (very preliminary) Toki Pona wordnets.
- utils: utilities for considering the space of all possible syllables and words given the Toki Pona rules"""
