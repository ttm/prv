" cal ApplyCS(g:ccs.red5, 'c')
" cal ApplyCS(g:ccs.green1, 'c')
" cal ApplyCS(g:ccs.green2, 'c')
" cal ApplyCS(g:ccs.blue1, 'c')
" cal ApplyCS(g:ccs.blue2, 'c')
" cal ApplyCS(g:ccs.red1b, 'c')
" cal ApplyCS(g:ccs.red1c, 'c')

let g:reldir = expand("<sfile>:p:h:h") . '/'
let g:auxfile = g:reldir . 'aux/wikisyn.vim'
exe 'so '.g:auxfile

cal ApplyCS(g:ccs.red1c_, 'c')

" exu1
" _notes
" passivepink1
" green1
" green2
" red1
" red2
" red3
" red4
" red5
" blue1
" blue2
" red1b
" red1c
colo desert

hi SpellBad guifg=white

hi link wTitle StatusLineTerm
sy match wTitle /\v\~.*\~/
hi link wSubsubtitle VisualNOS
sy match wSubsubtitle /\v\~\~\~.*\~\~\~/

hi link wPath Error
sy match wPath /\v\.\/\f{3,}/
hi link wEnd CursorLineNr
sy match wEnd /\v^:::/




hi link wTag Error
sy match tag /\v\:.*\:/
hi link wTag2 DiffChange
sy match wTag2 /\v \zs[ativos]{1,6}/
hi link wTag3 Constant
sy match wTag3 /\v r\+\+/
hi link wTag4 Type
sy match wTag4 /\v h\+\+/

hi link wHTTP WildMenu
sy match wHTTP /\vhttp.\:\/\/.*/

hi link wCount Error
sy match wCount /\v\d\)/

" hi Normal guibg=#551111
cal ApplyCS(g:ccs.yellow1, 'c')
hi wSubtitle guibg=darkgreen guifg=lightred
sy match wSubtitle /\v\~\~.*\~\~/
