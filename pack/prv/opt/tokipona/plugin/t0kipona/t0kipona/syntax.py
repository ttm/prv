from .corpus import TP

class TPSynHigh(TP):
    """
    Syntax highlighting for Toki Pona in Vim

    Basic usage:
        sh = TPSynHigh()
        sh.mkSynHighFile()
    
    For different results, tweak sh.colors
    before executing sh.mkSynHighFile()

    """
    def __init__(self):
        TP.__init__(self)
        self._linkClassSyn()
        print(self.__doc__)

    def _linkClassSyn(self):
        self.colors = {'ADJECTIVE': 'Comment', 'NOUN': 'Constant',
                  'NUMBER': 'Identifier',
                  'PARTICLE': 'Statement', 'PRE': 'PreProc',
                  'PREPOSITION': 'Type', 'VERB': 'Special'}

    def mkSynHighFile(self):
        lines = []
        for class_ in self.words:
            words_ = ' '.join(self.words[class_])
            group = self.colors[class_]
            lines.append('\nsyntax keyword '+'tokipona'+class_+' '+words_)
            lines.append('highlight link '+'tokipona'+class_+' '+group)

        coloring = '\n'.join(lines)
        header = '''" Vim syntax file
" Language:	toki pona
" Maintainer:	Renato Fabbri <fabbri@usp.br>
" Last Change:	2016 Apr 30
" Remark:	toki pona is a conlang, not a programming language

if exists("b:current_syntax")
    finish
endif
let b:current_syntax = "tokipona"

syntax clear
syntax case ignore\n\n'''
        dpath = tdir.split("plugin")[0] + 'syntax/tokipona.vim'
        with open(dpath, 'w') as f:
            f.write(header+coloring)

