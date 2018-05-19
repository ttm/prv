" {{{1 header
" put in header for a selfcomp wiki file
" see ./../syntax/wikirel.vim
cal ApplyCS(g:ccs.red1b_, 'c')
" {{{1 wiki template

hi link wComment Type
sy match wComment /\v\s{4}.*/

hi link wCount Error
sy match wCount /\v\d[\)\-]/

hi link wEnd CursorLineNr
sy match wEnd /\v^:::/ contains=wEnd2

hi link wEnd2 Visual
sy match wEnd /\v^:\zs::/ contained

hi link wHTTP WildMenu
sy match wHTTP /\vhttps{0,1}\:\/\/.*/

hi link wPath Error
sy match wPath /\v\.+\/[a-zA-Z0-9\/]{2,}/

hi link wSubsubtitle VisualNOS
sy match wSubsubtitle /\v\~\~\~.*\~\~\~/

hi link wSubtitle Visual
sy match wSubtitle /\v\~\~.*\~\~/

hi link wTag Error
sy match wTag /\v\:.*\:/
hi link wTag2 DiffChange
sy match wTag2 /\v \zs[ativos]{1,6}/
hi link wTag3 Constant
sy match wTag3 /\v r\+\+/
hi link wTag4 Type
sy match wTag4 /\v h\+\+/

hi link wTitle IncSearch
sy match wTitle /\v\~.*\~/


" {{{1 vim template
hi SpellBad guifg=white

hi LineNr guifg=red

