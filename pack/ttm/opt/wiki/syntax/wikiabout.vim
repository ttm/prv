hi Normal guibg=white guifg=black

hi link wTitle DiffText
hi link wSubtitle WarningMsg
hi link wSubsubtitle Comment
hi link wPath Error
hi link wEnd LineNr

sy match wTitle /\v\~.*\~/
sy match wSubtitle /\v\~\~.*\~\~/
sy match wSubsubtitle /\v\~\~\~.*\~\~\~/
sy match wPath /\v\.\/\f{3,}/

sy match wEnd /\v^:::/
hi LineNr guifg=red
