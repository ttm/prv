hi link wTitle Constant
hi link wSubtitle WarningMsg
hi link wSubsubtitle Comment
hi link wPath Error
hi link wEnd LineNr

sy match wTitle /\v\~.*\~/
sy match wSubtitle /\v\~\~.*\~\~/
sy match wSubsubtitle /\v\~\~\~.*\~\~\~/
sy match wPath /\v\.\/\f{3,}/

sy match wEnd /\v^:::/

