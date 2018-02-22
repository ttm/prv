" ttm final startup for PRV
hi Terminal guibg=lightgrey guifg=blue
call CommandColorSchemes()
call ApplyCS(g:ccs.yellow1, 'c')

let g:mstartup = v:true

set wildignore+=*.swp,*.swo,*.pyo,**/aux/undo/*,viminfo
" in pack/plugins/opt/
packadd gruvbox
" in pack/ttm/opt/
packadd realcolors
packadd prv
packadd aa
colo gruvbox
set bg=dark

cal ApplyCS(g:ccs["passivepink1"],"color")
hi SpellBad cterm=undercurl



