# Text syntax highlighting, analysis and synthesis for the Toki Pona Language

For the syntax highlighting, one should copy the
ftdetect/, ftplugin/ and syntax/ directories to ~/.vim/plugin/tokipona/
or
  $ git clone https://github.com/ttm/tokipona ~/.vim/plugin/
You might need to copy the syntax/tokipona.vim file to
~/.vim/syntax/.

If you change the syntax file,
a file with highlighted text (in Toki Pona)
will have the highlighting updated upon
reload (:e<CR> in Vim).
For more information in using the plugin,
see the [article on article/ directory](https://github.com/ttm/tokipona/raw/master/article/article.pdf).

text 
Vim syntax highlighting for the toki pona constructed language
Maintainer:	Renato Fabbri <fabbri@usp.br>
License:	This file is placed in the public domain.

You might want to place files in this directory inside
e.g. .vim/plugins/tokipona/

And syntax/tokipona.vim inside .vim/syntax/

ToDo:
* Make a Vimball with the files tructure of this
plugins because it needs files inside plugin/ and syntax/
directories.

Artigo de Toki Pona
* Procurar nas anotacoes (rascunhao, ttm)
* O que Toki Pona é: definição,
histórico, estado da arte, grupos do fb telegram
* Minha explicação da linguagem: li e la pi

No pi, word word word:
word <- (qualifies 1) word <- (qualifies 2)  word

One pi, word pi word word
word <- (qualifies 2) [ word <- (qualifies 1)  word ]

Two pi: word pi word word word pi word word
word <-5 word 3 word 2 word <-4 word 1  word
or:
word <-5 word 2 word 1 word <-4 word 3  word

You can mix the number of words in each noun term separated by pi
and maybe extend it to the prepositions.

Make considerations about the official book
in contrast with the way I summarize the language.

==========
Most usual letters, in the beginning and end,
and sequences of letters.
Distribution of word sizes,
smallest and largest words.
Maybe scrape toki-pona sites
and see the distribution of the
words.

==========
Syntax highlighting,
automated construction of sentences.
Acknowledge the hacks already available (e.g. translation of names)
and the spreadsheet with all the resources.




