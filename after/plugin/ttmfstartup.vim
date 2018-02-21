" ttm final startup for PRV
call CommandColorSchemes()
call ApplyCS(g:ccs.yellow1, 'c')

let g:mstartup = v:true

set wildignore+=*.swp,*.swo,*.pyo,**/aux/undo/*,viminfo
packadd gruvbox
colo gruvbox
set bg=dark

cal ApplyCS(g:ccs['green2'],'color')

