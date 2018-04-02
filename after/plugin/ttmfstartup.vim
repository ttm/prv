" ----------------------- Adding packages {{{1
" in pack/plugins/opt/
" packadd gruvbox
" " in pack/ttm/opt/
pa prv
pa realcolors
pa aa
pa vimwiki
" pa tokipona

" ------------------------ ttm final startup {{{1
" hi Terminal guibg=lightgrey guifg=blue
cal CommandColorSchemes()
" colo blue
cal ApplyCS(g:ccs.green2, 'c')
cal ApplyCS(g:ccs.red4, 'c')
cal ApplyCS(g:ccs.yellow1, 'c')
" ['exu1', '_notes', 'yellow1', 'redblackl', 'passivepink1', 'green1', 'green2', 'red1', 'red2', 'red3', 'red4', 'red5', 'blue1', 'blue2', 'red1b', 'red1c']
"
