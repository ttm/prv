" Vim syntax file
" Language:     toki pona
" Maintainer:   Renato Fabbri <renato.fabbri@gmail.com>
" Last Change:  2018 Fev 11
" URL:          https://github.com/ttm/tokipona
" Remark:       toki pona is a conlang, not a programming language

if exists("b:current_syntax")
    finish
endif

" define here so loaded files might test for it (unlet at the end)
if !exists("main_syntax")
  let main_syntax = 'tokipona'
endif

syntax clear
syntax case ignore


syntax keyword tokiponaADJECTIVE taso mute sewi pu sin ante kule sike loje pona ike suli ken laso tawa pimeja ala jelo sama anpa jaki moli ale musi lete pilin wan ali wawa seli pini ni nasa lili weka pakala lape suwi namako wile walo kama awen
highlight link tokiponaADJECTIVE Comment

syntax keyword tokiponaNUMBER ali tu ale luka wan
highlight link tokiponaNUMBER Identifier

syntax keyword tokiponaNOUN kala mute pan ilo lipu sewi sina telo kasi ko lawa tomo sike akesi lupa mani nanpa soweli noka ma insa tenpo kulupu luka poki suno mi uta selo poka len kiwen ale linja palisa mun ona kili nasin kon pilin esun ali mama kute sijelo meli nena jan supa lukin nimi pipi waso oko sitelen sinpin monsi ijo mije
highlight link tokiponaNOUN Constant

syntax keyword tokiponaVERB jo lukin pali kalama sona unpa open alasa lawa oko olin pana utala kute moku toki
highlight link tokiponaVERB Special

syntax keyword tokiponaPARTICLE taso mu o a e kin anu en li pi la seme nanpa
highlight link tokiponaPARTICLE Statement

syntax keyword tokiponaPREPOSITION tawa kepeken sama tan lon
highlight link tokiponaPREPOSITION Type

syntax keyword tokiponaPRE lukin sona oko wile kama awen ken
highlight link tokiponaPRE PreProc

syntax match tokiponaComment /#.*$/
highlight link tokiponaComment StatusLine

let b:current_syntax = "tokipona"
if main_syntax == 'tokipona'
  unlet main_syntax
endif