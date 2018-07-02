## Python and Vim utilities for the Toki Pona minimalist conlang
(
This README.md document is well formatted in:
https://github.com/ttm/tokipona
)

This repository holds both:
- the tokipona Python package (with tools to deal with Toki Pona); and
- the tokipona Vim plugin (mainly with syntax file and some advanced capabilities for coloring

They might be used and installed independently,
although:
- the Python package, among other things, synthesizes the Vim syntax files;
- the Vim plugin, among other things, is proposed to also bring the
  tokipona Python package into the Vim editor.

### notes for arXiv submission

  $ cd article/acm/

comment tipa package loading.
Swap line on pronunciation.

  $ zip -r arxiv.zip sample-acmlarge.tex sample-acmlarge.bbl samplebody-journals.tex pos.tex syls.tex vowels.tex acmart.cls ACM-Reference-Format.bst figs/

upload arxiv.zip.


### Table of Contents
Items / Sections / Headers:
  * [Overall description and installation](#overall-description-and-installation)
    + [Of the tokipona Python package](#of-the-tokipona-python-package)
  * [Usage example of the Python package](#usage-example-of-the-python-package)
    + [Of the tokipona Vim plugin](#of-the-tokipona-vim-plugin)
      - [Screenshots of the syntax highlighting (in Vim)](#screenshots-of-the-syntax-highlighting--in-vim-)
  * [deployment](#deployment)
    + [of Python package to PyPI](#of-python-package-to-pypi)
    + [of the Vim plugin to vim.org](#of-the-vim-plugin-to-vimorg)
  * [TODO:](#todo-)
  * [Further notes](#further-notes)
  * [Most important links](#most-important-links)

### Overall description and installation
For the Python package and the Vim plugin.

#### Of the tokipona Python package
This package contains routines to:
- analyze the official Toki Pona vocabulary
- synthesize phrases. sentences, paragraphs, short stories and poems in Toki Pona
- the achievement of (very preliminary) Toki Pona wordnets
- synthesize Vim syntax files for the Toki Pona language
- maybe something more

Such facilities are implemented in accordance with the [Toki Pona article],
of which the Latex and PDF files are in the article/ directory
of this repository (ttm/tokipona).

Install with:

    $ pip install tokipona
or

    $ python setup.py tokipona

For customization ease, hacking and debugging, clone the repository and install with 'pip3 install -e':

    $ git clone https://github.com/ttm/tokipona.git
    $ pip3 install -e <path_to_repo>

This install method is especially useful when reloading the modified module in subsequent runs.

### Usage example of the Python package


```python
# to import changes made in local package files,
# e.g. if installed with pip3 install -e ~/repos/tokipona/
import sys
keys=tuple(sys.modules.keys())
for key in keys:
    if "tokipona" in key:
        del sys.modules[key]

### Basic usage
import tokipona as t

### the main functionalities are:

# 1 - make a syntax highlighting file for Vim
sh = t.syntax()

# 2 - analyze the official Toki Pona vocabulary
st = t.stats()

# 3 - obtain (very preliminary) Toki Pona wordnet synsets
wn = t.wordnet()

# 4 - synthesize texts in Toki Pona
sy = t.synthesis()

print( sy.createParagraph() )
print( sy.createPhrase() )
print( sy.createPoem() )
print( sy.createSentence() )

# sh, st, wn, sy have objects related to each of the
# functions as further described in this README.

# 5 - further routines and variables in utils:
v, c = t.utils.vowels, t.utils.consonants
str_ = "TP vowels are: {}; TP consonants are: {}".format(v, c)
print(str_)

possible_words = t.utils.allTokiPonaPossibleWords(n=2)
print("all possible words with two syllables given the TP rules are {}".format(possible_words))

##############################################
### check files in tokipona/
# for many other functionalities and convenient variables.

# Tweak at will.
##############################################

```


#### Of the tokipona Vim plugin
To avoid redundancy upkeep, please visit
the [Toki Pona Vim plugin] page for an overview of the
implemented facilities.

To install it by hand, one might copy:
- the plugin/ directory to ~/.vim/plugin/
- the syntax/ directory to ~/.vim/syntax/

or clone the repository to a directory in your :echo &runtimepath.
For example:

  $ git clone https://github.com/ttm/tokipona ~/.vim/

If you change the syntax file,
a file with highlighted text (in Toki Pona)
will have the highlighting updated upon
reload (:e<CR> in Vim).
For more information in using the plugin,
see the vim.org page for the [Toki Pona Vim plugin].

Also, check the [Toki Pona article] because it is a carefully built
document that contextualizes and describes the routines available
in this repository.

##### Screenshots of the syntax highlighting (in Vim)

A simple text:
![Toki Pona text highlighted in Vim](https://imgur.com/xTLGVjE.jpg)

Some texts with another color scheme:
![Some Toki Pona texts highlighted in Vim](https://imgur.com/6OGc5bT.jpg)

And yet in another color scheme:
![Some Toki Pona texts highlighted in Vim (in a dfferent color scheme)](https://imgur.com/fj4hQkt.jpg)

And an HTML export (through :TOhtml Vim command)
of the syntax coloring:
![And an HTML export (through :TOhtml Vim command) of the syntax coloring:](https://imgur.com/v7a3hME.jpg)

### deployment

#### of Python package to PyPI
This package іs delivered by running:
  $ python3 setup.py sdist
  $ python3 setup.py bdist\_wheel
  $ twine upload dist/

Maybe use "python setup.py sdist upload -r pypi" ?

#### of the Vim plugin to vim.org
For making the Vimball for sharing this plugins and derivatives,
check the instructions in file ./tokiponaVimballInfo.txt

### TODO:
For now:
- check issues in this repository
- check the vim.org page for the [Toki Pona Vim plugin].

### Further notes
This Python package is intended to help in answering these (types of) questions:
- What are the most usual letters, in the beginning and end,and sequences of letters?
- What is the distribution of word sizes, smallest and largest words?
- What is the basic statistics obtained if one scrapes toki pona sites?

#### Acknowledgements
This work is sponsored by FAPESP (project 2017/05838-3) in a project lead by 
Profa. Dra. Maria Cristina Ferreira de Oliveira at VICG/ICMC/USP, São Carlos, Brazil.

### Most important links

[Toki Pona article]: https://arxiv.org/abs/1712.09359
[Toki Pona Vim plugin]: https://vim.sourceforge.io/scripts/script.php?script_id=5656
