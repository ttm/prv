" ttm final startup for PRV
hi Terminal guibg=lightgrey guifg=blue
call CommandColorSchemes()
call ApplyCS(g:ccs.yellow1, 'c')

let g:mstartup = v:true

set wildignore+=*.swp,*.swo,*.pyo,**/aux/undo/*,viminfo
packadd gruvbox
colo gruvbox
set bg=dark

cal ApplyCS(g:ccs["passivepink1"],"color")



