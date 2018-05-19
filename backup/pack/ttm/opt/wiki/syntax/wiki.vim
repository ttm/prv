hi link wTitle Constant
sy match wTitle /\v\~.*\~/
hi link wSubtitle WarningMsg
sy match wSubtitle /\v\~\~.*\~\~/
hi link wSubsubtitle Comment
sy match wSubsubtitle /\v\~\~\~.*\~\~\~/

hi link wPath Error
sy match wPath /\v\.\/\f{3,}/
hi link wEnd LineNr
sy match wEnd /\v^:::/

hi link wCount DiffChange
sy match wCount /\v\d{1,3}[\)\-]/

hi link wHTTP WildMenu
sy match wHTTP /\vhttps{0,1}\:\/\/.*/

hi link wArrow IncSearch
sy match wArrow /[↪↣↝↬↺⇶]/

hi link wComment DiffText
sy match wComment /\v\s{6}.*/

hi LineNr guifg=red
hi SpellBad guifg=white
