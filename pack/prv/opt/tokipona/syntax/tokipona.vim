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


syntax keyword tokiponaNUMBER tu wan ali ale luka
highlight link tokiponaNUMBER Identifier

syntax keyword tokiponaADJECTIVE pilin ale lili pu namako pimeja ni jelo loje sewi suwi seli wawa mute awen kama sin ante ala lete moli ken pakala taso pona walo ali ike weka wan suli nasa sama sike tawa anpa musi pini laso jaki kule lape
highlight link tokiponaADJECTIVE Comment

syntax keyword tokiponaPARTICLE nanpa e li a kin la anu mu o en pi taso seme
highlight link tokiponaPARTICLE Statement

syntax keyword tokiponaPRE sona lukin kama oko wile ken awen
highlight link tokiponaPRE PreProc

syntax keyword tokiponaNOUN mije pilin ale kute lukin noka suno kala insa sina tomo kiwen ijo ma telo waso sewi ilo soweli uta sijelo lipu kon mani ko monsi mute nasin pan tenpo supa kili poki linja pipi mi kulupu lawa sitelen ona ali nanpa jan nimi lupa selo oko akesi poka mama palisa sinpin nena len luka meli mun sike kasi esun
highlight link tokiponaNOUN Constant

syntax keyword tokiponaPREPOSITION kepeken lon sama tawa tan
highlight link tokiponaPREPOSITION Type

syntax keyword tokiponaVERB olin sona kute lukin utala oko alasa lawa unpa pana pali kalama open moku jo toki
highlight link tokiponaVERB Special