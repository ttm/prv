" ----------------------- Adding packages {{{1
" in pack/plugins/opt/
" packadd gruvbox
" " in pack/ttm/opt/
" packadd prv
" cal PRVInit()
packadd realcolors
packadd aa
" packadd vimwiki
" packadd tokipona

" ------------------------ ttm final startup {{{1
" hi Terminal guibg=lightgrey guifg=blue
cal CommandColorSchemes()
" colo blue
cal ApplyCS(g:ccs.green2, 'c')
