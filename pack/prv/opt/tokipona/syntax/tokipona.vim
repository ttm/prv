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


syntax keyword tokiponaPARTICLE e kin nanpa pi taso anu seme li la o en mu a
highlight link tokiponaPARTICLE Statement

syntax keyword tokiponaPREPOSITION sama tawa tan lon kepeken
highlight link tokiponaPREPOSITION Type

syntax keyword tokiponaNUMBER luka ale wan ali tu
highlight link tokiponaNUMBER Identifier

syntax keyword tokiponaADJECTIVE lape tawa walo taso moli pu anpa ken sike loje ale laso ali jaki musi kule lili weka awen pini pakala sewi lete pimeja namako wile wawa mute kama wan ala pona sin ante pilin sama ike ni suli suwi seli jelo nasa
highlight link tokiponaADJECTIVE Comment

syntax keyword tokiponaPRE lukin oko wile sona awen ken kama
highlight link tokiponaPRE PreProc

syntax keyword tokiponaVERB moku unpa lukin olin oko alasa open lawa sona utala jo pali kute kalama toki pana
highlight link tokiponaVERB Special

syntax keyword tokiponaNOUN mi sina lukin nanpa ma lawa mama meli sinpin sike kala nasin akesi waso ale ali tenpo luka lipu uta lupa telo kili sewi kute kon selo mute pipi ijo kasi kulupu mani esun nena suno pan mun poka tomo sitelen soweli nimi sijelo supa oko monsi poki linja kiwen ona noka pilin len ko mije palisa jan ilo insa
highlight link tokiponaNOUN Constant

syntax match tokiponaComment /#.*$/
highlight link tokiponaComment StatusLine

let b:current_syntax = "tokipona"
if main_syntax == 'tokipona'
  unlet main_syntax
endif