if exists("b:current_syntax")
    finish
endif

syntax keyword structureKeyword li e pi
highlight link structureKeyword Keyword

syntax keyword prepositionWords lon tan tawa kepeken
highlight link prepositionWords Function

syntax match textComment "\v#.*$"
highlight link textComment Comment

syntax region externalString start=/\v"/ skip=/\v\\./ end=/\v"/
syntax region externalString start=/\v'/ skip=/\v\\./ end=/\v'/
highlight link externalString String

syntax match punctuationString "\v\="
syntax match punctuationString "\v\:"
syntax match punctuationString "\v\;"
syntax match punctuationString "\v\,"
syntax match punctuationString "\v\."
syntax match punctuationString "\v\*"
syntax match punctuationString "\v/"
syntax match punctuationString "\v\+"
syntax match punctuationString "\v-"
syntax match punctuationString "\v\?"
syntax match punctuationString "\v\!"
syntax match punctuationString "\v\*\="
syntax match punctuationString "\v/\="
syntax match punctuationString "\v\+\="
syntax match punctuationString "\v-\="

highlight link punctuationString Operator

syntax match numericDigits "\v\d"
highlight link numericDigits Number

let b:current_syntax = "tokipona"
