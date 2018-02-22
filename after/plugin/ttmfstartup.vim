" ----------------------- Adding packages {{{1
" in pack/plugins/opt/
packadd gruvbox
" in pack/ttm/opt/
packadd realcolors
packadd prv
packadd aa

" ------------------------ ttm final startup {{{1
hi Terminal guibg=lightgrey guifg=blue
call CommandColorSchemes()
call ApplyCS(g:ccs.yellow1, 'c')

let g:mstartup = v:true

set wildignore+=*.swp,*.swo,*.pyo,**/aux/undo/*,viminfo
colo gruvbox
set bg=dark

cal ApplyCS(g:ccs["passivepink1"],"color")
hi SpellBad cterm=undercurl
se path-=~/.vim/pack/ttm/opt/
se path+=~/.vim/pack/ttm/opt/
se path+=~/.vim/aux/vimwiki/

se suffixesadd+=.wiki
se suffixesadd+=.vim
se suffixesadd+=.py
se suffixesadd+=.txt
