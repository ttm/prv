## Python utilities for the Toki Pona minimalist conlang

This package contains routines to:
- analyze the official Toki Pona vocabulary
- synthesize phrases. sentences, paragraphs, short stories and poems in Toki Pona
- the achievement of (very preliminary) Toki Pona wordnets
- synthesize Vim syntax files for the Toki Pona language

Such facilities are implemented in accordance with the [Toki Pona article],
of which the Latex and PDF files are in the article/ directory
of this repository (ttm/tokipona)

### Syntax highlighting
This repository also holds a [Toki Pona Vim plugin].

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

##### Screen shots of the syntax highlighting (in Vim)

[one text in imgur]

[another with various texts in another color scheme]

[one HTML rendering of a buffer or window]


### Usage example of the Python package


```python
### Basic usage
import tokipona as t

### the main functionalities are:

# 1 - make a syntax highlighting file for Vim

# 2 - analyze the official Toki Pona vocabulary

# 3 - obtain (very preliminary) Toki Pona wordnet synsets

# 4 - synthesize texts in Toki Pona

```


### TODO:
For now:
- check issues in this repository
- check the vim.org page for the [Toki Pona Vim plugin].

### Further notes
This Python package is intended to help in answering these (types of) questions:
- What are the most usual letters, in the beginning and end,and sequences of letters?
- What is the distribution of word sizes, smallest and largest words?
- What is the basic statistics obtained if one scrapes toki pona sites?

### Most important links

[Toki Pona article]: https://arxiv.org/abs/1712.09359
[Toki Pona Vim plugin]: https://vim.sourceforge.io/scripts/script.php?script_id=5656
