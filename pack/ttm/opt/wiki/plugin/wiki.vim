" main file of the wiki plugin for Vim {{{1
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

" syntax:
" if .wiki, ~.*~ is heading marker, Constant
" if :.*: tag to be parsed (into anything, make a dictionary)
" ./ ../ etc are paths, to be linked in the resulting HTML file
" the HTML that results from :TOhtml are parsed to fit a central
" window, with margins.
"
" highlighting:
" :: ~~ ./ are highlighted when .wiki is the extension

" hi wTitle guifg=red

" hi link wTitle Constant
" hi link wSubtitle Boolean
" hi link wSubsububtitle Comment
" hi link wPath Error
" sy match wTitle /\v\~.*\~/
" sy match wSubitle /\v\~\~.*\~\~/
" sy match wSubsubitle /\v\~\~\~.*\~\~\~/
" sy match wPath /\v\..*/
" 
" hi link wTitle Constant
" hi link wSubtitle WarningMsg
" hi link wSubsubtitle Comment
" hi link wPath Error
" sy match wTitle /\v\~.*\~/
" sy match wSubtitle /\v\~\~.*\~\~/
" sy match wSubsubtitle /\v\~\~\~.*\~\~\~/
" sy match wPath /\v\.\f{3,}/
" 
" fu! WCenterHTML()
"   norm /<\/style>
"   let @" = '.center { margin: auto; width: 60%; border: 3px solid #73AD21; padding: 10px; }'
"   norm p
" endf
" 
" find \v\<\/style\>
" paste before (P):
" .center {
"     margin: auto;
"     width: 60%;
"     border: 3px solid #73AD21;
"     padding: 10px;
" }
" find '\v\<body '
" walk e, paste ' class="center"'
" 
" save. centering finished.
" 
" linking to other files:
" 
" find \.\/
" let tlink = expand("<cfile>")
" let tlink .='.wiki.html'
" paste '<a href="'.tlink.'">'
" move t<
" paste </a>




cal WikiInit()
" {{{5 Vimwiki, deprecated, notes
" cal g:PRVVWFileNMapping("<leader>wA", "achievements.wiki")
" cal g:PRVVWFileNMapping("<leader>wT", "todo.wiki")
" cal g:PRVVWFileNMapping("<leader>wD", "daily/tasks.wiki")
" cal g:PRVVWFileNMapping("<leader>wW", "weekly/wtasks.wiki")
" cal g:PRVVWFileNMapping("<leader>wN", "blergh.wiki<CR>gg")
