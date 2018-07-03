" Vim syntax file
" Language:	toki pona
" Maintainer:	Renato Fabbri <fabbri@usp.br>
" Last Change:	2016 Apr 30
" Remark:	toki pona is a conlang, not a programming language

if exists("b:current_syntax")
    finish
endif
let b:current_syntax = "tokipona"

syntax clear
syntax case ignore


syntax keyword tokiponaNUMBER 
highlight link tokiponaNUMBER Identifier

syntax keyword tokiponaVERB 
highlight link tokiponaVERB Special

syntax keyword tokiponaPARTICLE 
highlight link tokiponaPARTICLE Statement

syntax keyword tokiponaNOUN 
highlight link tokiponaNOUN Constant

syntax keyword tokiponaPRE 
highlight link tokiponaPRE PreProc

syntax keyword tokiponaADJECTIVE 
highlight link tokiponaADJECTIVE Comment

syntax keyword tokiponaPREPOSITION 
highlight link tokiponaPREPOSITION Type