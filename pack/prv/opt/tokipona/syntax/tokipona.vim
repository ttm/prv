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


syntax keyword tokiponaNOUN oko ali lupa selo sijelo tomo nena kute mi mute poka sike suno ilo kulupu lawa nanpa sinpin lipu len linja mama ijo ona lukin mije telo waso sina mun meli kili kala nimi jan tenpo kiwen pipi ma ale palisa uta luka mani sewi monsi pan sitelen nasin esun pilin poki akesi kon supa noka soweli insa kasi ko
highlight link tokiponaNOUN Constant

syntax keyword tokiponaVERB oko open toki moku alasa unpa lukin kute pana sona olin pali lawa jo kalama utala
highlight link tokiponaVERB Special

syntax keyword tokiponaPREPOSITION tan sama tawa lon kepeken
highlight link tokiponaPREPOSITION Type

syntax keyword tokiponaPRE oko wile lukin sona kama awen ken
highlight link tokiponaPRE PreProc

syntax keyword tokiponaPARTICLE li la nanpa anu mu pi e o taso kin en seme a
highlight link tokiponaPARTICLE Statement

syntax keyword tokiponaADJECTIVE ali sin ike ni pini kule mute pu awen sike lili namako nasa walo anpa tawa suli ken loje sama pimeja ale wawa jaki lete wan sewi lape ante laso pilin moli pona ala jelo weka pakala kama seli taso suwi musi
highlight link tokiponaADJECTIVE Comment

syntax keyword tokiponaNUMBER tu ali ale wan luka
highlight link tokiponaNUMBER Identifier