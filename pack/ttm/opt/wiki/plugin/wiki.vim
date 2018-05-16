" main file of the wiki plugin for Vim {{{3
" Author: Renato Fabbri
" Date: 2018/Feb/25 (when I wrote this header)
" Copyright: Public domain
" Acknowledgments:
" vim_use email list (discussion forum)
" Cristina Ferreira de Oliveira (PhD, VICG/ICMC/USP),
" FAPESP (project 2017/05838-3)
" Ricardo Fabbri (PhD, IPRJ/UERJ)

" Load Once: {{{3
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
" {{{1 html
fu! WHTMLok() " {{{3
  TOhtml
  %s/\v\.\/(\f+)/\<a href\=\"\.\/\1\.html\"\>\1\<\/a\>/g
  %s/\v\<body /\<body class\=\"center\" /g 
  %s/\v\<\/style\>/.center { margin: auto; width: 60%; border: 3px solid #73AD21; padding: 10px; }\r\<\/style\>/g
  w
  exe '!google-chrome ' . expand("%")
  " %s$\vIntro\-Next$\<a href\=\"\.\/data\/FernandoGularte\/Intro-Next\.mp3\"\>Intro-Next\<\/a\>$g
  " %s$\vSecond$\<a href\=\"\.\/data\/FernandoGularte\/Second\.mp3\"\>Second\<\/a\>$g
  " %s$\vDr Jekyll$\<a href\=\"\.\/data\/FernandoGularte\/Dr\.Jekyll\.mp3\"\>Dr Jekyll\<\/a\>$g
endf

" {{{1 notes
" {{{3 notes
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

" {{{3 Vimwiki, deprecated, notes
" cal g:PRVVWFileNMapping("<leader>wA", "achievements.wiki")
" cal g:PRVVWFileNMapping("<leader>wT", "todo.wiki")
" cal g:PRVVWFileNMapping("<leader>wD", "daily/tasks.wiki")
" cal g:PRVVWFileNMapping("<leader>wW", "weekly/wtasks.wiki")
" cal g:PRVVWFileNMapping("<leader>wN", "blergh.wiki<CR>gg")
" {{{1 last commands
cal WikiInit()
" vim:foldlevel=2:
