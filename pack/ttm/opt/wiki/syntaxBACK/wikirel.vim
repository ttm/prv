let g:reldir = expand("<sfile>:p:h:h") . '/'
let g:auxfile = g:reldir . 'aux/wikisyn.vim'
exe 'so '.g:auxfile


colo blue
hi Normal guibg=lightgreen guifg=darkred

hi link wArrow IncSearch
sy match wArrow /[↪↣↝↬↺⇶]/

" hi link wComment VisualNOS
hi link wComment DiffText
sy match wComment /\v\s{6}.*/

hi link wEnd LineNr
sy match wEnd /\v^:::/

hi link wPath Cursor
" hi link wSubsubtitle DiffChange
hi wSubsubtitle guibg=darkgreen guifg=white
sy match wSubsubtitle /\v\~\~\~.*\~\~\~/
sy match wPath /\v\.\/\f{3,}/
hi link wSubtitle WarningMsg
sy match wSubtitle /\v\~\~.*\~\~/
hi link wTitle TabLineFill
sy match wTitle /\v\~.*\~/

hi LineNr guifg=red

hi SpellBad guifg=white
