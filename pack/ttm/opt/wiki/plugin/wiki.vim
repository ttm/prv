" main file of the prv plugin for Vim {{{1
" Author: Renato Fabbri
" Date: 2018/Feb/25 (when I wrote this header)
" Copyright: Public domain
" Acknowledgments:
" vim_use email list (discussion forum)
" Cristina Ferreira de Oliveira (PhD, VICG/ICMC/USP),
" FAPESP (project 2017/05838-3)
" Ricardo Fabbri (PhD, IPRJ/UERJ)

" Load Once: {{{1
if exists("g:loaded_wikiplugin") && (exists("g:wiki_not_hacking") || exists("g:wiki_not_hacking_all"))
 finish
endif
let g:loaded_wikiplugin = "v0.01b"
let g:wiki_dir = expand("<sfile>:p:h:h") . '/'
" {{{1 settings
fu! WikiInit() " {{{3 bare Vim wiki, finding files
  exe 'se path+='.g:wiki_dir.'aux/wiki/'
  exe 'se tags+='.g:wiki_dir.'aux/wiki/**/.tags'
  se sua +=.wiki
  se sua +=.vim
  se sua +=.py
  se sua +=.txt
  se sua +=.md
  " to avoid getting unwanted files when finding files
  se wildignore+=*.swp,*.swo,*.pyo,**/aux/undo/*,viminfo
  cal WikiMkMappings()
endf

fu! WikiMkMappings()
  nn Wu :exe '!ctags-exuberant -f '.g:wiki_dir.'aux/wiki/.tags '.g:wiki_dir.'aux/wiki/**/*'<CR> 
endf

cal WikiInit()
