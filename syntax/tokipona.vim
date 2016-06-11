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


syntax keyword tokiponaPREPOSITION lon tawa kepeken tan
highlight link tokiponaPREPOSITION Type

syntax keyword tokiponaVERB utala unpa pali sona kalama moku jo alasa open toki pana olin
highlight link tokiponaVERB Special

syntax keyword tokiponaPRE ken wile
highlight link tokiponaPRE PreProc

syntax keyword tokiponaPARTICLE e en taso anu kin la li pi seme o a mu nanpa
highlight link tokiponaPARTICLE Statement

syntax keyword tokiponaADJECTIVE ni seli ike walo ante loje lili weka namako ali anpa jelo moli pimeja pakala suli mute pini suwi awen sama kule lape nasa pona wawa sin kama musi ale pu ala lete laso jaki wan
highlight link tokiponaADJECTIVE Comment

syntax keyword tokiponaNUMBER tu
highlight link tokiponaNUMBER Identifier

syntax keyword tokiponaNOUN ma selo nimi esun noka sina ona mun lipu sitelen soweli kala mi sijelo jan meli pan mije pipi lukin akesi kulupu poki sike supa ko lupa sinpin len monsi kili insa kute telo kon kasi sewi nasin waso palisa nena luka linja kiwen lawa uta oko tenpo poka mama mani pilin suno tomo ilo ijo
highlight link tokiponaNOUN Constant