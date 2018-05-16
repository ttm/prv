let g:reldir = expand("<sfile>:p:h:h") . '/'
let g:auxfile = g:reldir . 'aux/wikisyn.vim'
exe 'so '.g:auxfile

" cal ApplyCS(g:ccs.exu1, 'c')
" cal ApplyCS(g:ccs.red1b, 'c')
cal ApplyCS(g:ccs.red1b_, 'c')
hi link wComment VisualNOS
sy match wComment /\v\s{6}.*/

hi link wCount DiffChange
sy match wCount /\v\d{1,3}[\)\-]/

hi link wEnd CursorLineNr
sy match wEnd /\v^:::/

hi link wHTTP WildMenu
sy match wHTTP /\vhttps{0,1}\:\/\/.*/

hi link wSubsubtitle VisualNOS
sy match wSubsubtitle /\v\~\~\~.*\~\~\~/

hi link wSubtitle Visual
sy match wSubtitle /\v\~\~.*\~\~/

hi link wTitle IncSearch
sy match wTitle /\v\~.*\~/

hi SpellBad guifg=white
