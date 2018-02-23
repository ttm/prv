" ----------------------- Adding packages {{{1
" in pack/plugins/opt/
packadd gruvbox
" in pack/ttm/opt/
packadd realcolors
packadd prv
packadd aa
packadd vimwiki
" because of a bug or Vim's ways, the after/ in a opt/ pack/
" are not loaded at startup. (afterwards it is, probably because
" they are on the runtimepath.
" yields error:
" runtime! after/plugin/*.vim

" ------------------------ ttm final startup {{{1
hi Terminal guibg=lightgrey guifg=blue
" colo gruvbox
" set bg=dark
cal CommandColorSchemes()
" cal ApplyCS(g:ccs["passivepink1"],"color")
" cal ApplyCS(g:ccs.yellow1, 'c')
cal ApplyCS(g:ccs.green2, 'c')

let g:mstartup = v:true

set wildignore+=*.swp,*.swo,*.pyo,**/aux/undo/*,viminfo

hi SpellBad cterm=undercurl
se path-=~/.vim/pack/ttm/opt/
se path+=~/.vim/pack/ttm/opt/
se path+=~/.vim/aux/vimwiki/

se suffixesadd+=.wiki
se suffixesadd+=.vim
se suffixesadd+=.py
se suffixesadd+=.txt
