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
