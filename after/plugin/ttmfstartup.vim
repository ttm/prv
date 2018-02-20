call CommandColorSchemes()
call ApplyCS(g:ccs.yellow1, 'c')
" let g:mstartup2 = v:true
" let g:mstartup3 = v:true

set wildignore+=*.swp,*.swo,*.pyo,**/aux/undo/*,viminfo
packadd gruvbox
colo gruvbox
set bg=dark

let g:mstartup = v:true
