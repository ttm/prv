" Vim syntax file
" Language:	toki pona
" Maintainer:	Renato Fabbri <fabbri@usp.br>
" Last Change:	2016 Apr 30
" Remark:	toki pona is a conlang, not a programming language

 if exists("b:current_syntax")
    finish
endif

syntax clear
syntax case ignore
syntax keyword tokiponaStructure li e pi la
highlight link tokiponaStructure Keyword

syntax keyword tokiponaPrepositions lon tan tawa kepeken
highlight link tokiponaPrepositions Function

syntax match tokiponaComment "\v#.*$"
highlight link tokiponaComment Comment

syntax region tokiponaExternal start=/\v"/ skip=/\v\\./ end=/\v"/
syntax region tokiponaExternal start=/\v'/ skip=/\v\\./ end=/\v'/
highlight link tokiponaExternal String

syntax match tokiponaPunctuation "\v\="
syntax match tokiponaPunctuation "\v\:"
syntax match tokiponaPunctuation "\v\;"
syntax match tokiponaPunctuation "\v\,"
syntax match tokiponaPunctuation "\v\."
syntax match tokiponaPunctuation "\v\*"
syntax match tokiponaPunctuation "\v/"
syntax match tokiponaPunctuation "\v\+"
syntax match tokiponaPunctuation "\v-"
syntax match tokiponaPunctuation "\v\?"
syntax match tokiponaPunctuation "\v\!"
syntax match tokiponaPunctuation "\v\*\="
syntax match tokiponaPunctuation "\v/\="
syntax match tokiponaPunctuation "\v\+\="
syntax match tokiponaPunctuation "\v-\="

highlight link tokiponaPunctuation Operator

syntax match tokiponaNumber "\v\d"
syntax keyword tokiponaNumber wan tu luke
highlight link tokiponaNumber Number

let b:current_syntax = "tokipona"
