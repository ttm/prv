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


syntax keyword tokiponaADJECTIVE anpa nasa jaki ale pu namako pimeja ala taso moli musi laso ike lape suli pakala walo sewi pilin weka wile seli pona awen wan ken mute sike sin kule pini kama suwi ali jelo loje ante ni lete sama lili tawa wawa
highlight link tokiponaADJECTIVE Comment

syntax keyword tokiponaPRE oko ken lukin wile kama sona awen
highlight link tokiponaPRE PreProc

syntax keyword tokiponaNUMBER ale wan ali luka tu
highlight link tokiponaNUMBER Identifier

syntax keyword tokiponaPREPOSITION tan kepeken sama lon tawa
highlight link tokiponaPREPOSITION Type

syntax keyword tokiponaPARTICLE pi nanpa en kin seme li a la o mu anu e taso
highlight link tokiponaPARTICLE Statement

syntax keyword tokiponaVERB open pana lawa kalama oko olin toki lukin moku pali unpa jo utala alasa sona kute
highlight link tokiponaVERB Special

syntax keyword tokiponaNOUN kon uta poki ale nena ona selo esun poka len kiwen mun telo sitelen palisa meli nimi mi ko sina kili sewi linja pilin akesi nanpa noka waso kute suno sijelo lawa monsi lipu mute sike tomo kala pipi ilo kulupu insa ali mije tenpo pan ijo luka oko mama nasin ma sinpin lukin kasi jan soweli mani supa lupa
highlight link tokiponaNOUN Constant