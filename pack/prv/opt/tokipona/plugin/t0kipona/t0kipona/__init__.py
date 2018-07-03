from .corpus import TPCorpus
from .texts import TPTextBasic
from .statistics import TPStats
from .synth import TPSynth, TPTabFig
from .syntax import TPSynHigh

from . import utils

__doc__ = """The main modules of this tokipona package are:
- stats: for statistics of the official vocabulary.
- synthesis: for synthesizing phrases, sentences, paragraphs, short narratives and poems.
- syntax: to tweak and synthesize the Vim syntax file for Toki Pona.
- wordnet: for thea achievement and usage of (very preliminary) Toki Pona wordnets.
- utils: utilities for considering the space of all possible syllables and words given the Toki Pona rules"""
