" {{{1 header
" put in header for a selfcomp wiki file
" see ./../syntax/wikirel.vim
cal ApplyCS(g:ccs.red1b_, 'c')
" {{{1 wiki template

hi link wComment VisualNOS
sy match wComment /\v\s{6}.*/

hi link wCount Error
sy match wCount /\v\d[\)\-]/

hi link wEnd CursorLineNr
sy match wEnd /\v^:::/

hi link wHTTP WildMenu
sy match wHTTP /\vhttps{0,1}\:\/\/.*/

hi link wPath Error
sy match wPath /\v\.\/\f{3,}/

hi link wSubsubtitle VisualNOS
sy match wSubsubtitle /\v\~\~\~.*\~\~\~/

hi link wSubtitle Visual
sy match wSubtitle /\v\~\~.*\~\~/

hi link wTitle IncSearch
sy match wTitle /\v\~.*\~/

" {{{1 vim template
hi SpellBad guifg=white

hi LineNr guifg=red

