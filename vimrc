" My minimal vimrc (elaborate functionalities are in pavk/ttm/opt/prv/) {{{1
" Author: Renato Fabbri (renato.fabbri@gmail.com)
" Notes: Plugins are placed inside pack/ttm/opt/ and loaded with :pa
" This is a very minimal vimrc, see PRV Vim plugin (Private) for 
" utilities (mappigns, commands, functions, etc) in general
" Date: 2018/Fev/25 (when I wrote this header)

" {{{1 default Vim
se nocp
se sts=2 sw=2 tw=0 bs=2 et ai nu rnu
se so=9999
se so=3
se sj=-80
se hi=10000  " remember more commands and search history
se wig=*.swp,*.bak,*.pyc,*.class
se vb           " don't beep
se tgst
" asserts python3 is loaded:
py3 import random
se mouse=a
filet plugin indent on
sy enable
se spell spl=en_us
se nospell
se nohls
se showcmd

let g:netrw_altv=1
let g:netrw_preview=1

let mapleader = '\'
let maplocalleader = '\\'

" statusline --- {{{2
se hl -=sn,Sn
se hl +=Sn,sn
se hl +=sc
se stl =__
se stl +=%{('\ \ ')}
se stl +=%l-%L,%c\ (%P)
se stl +=%2*\ %{'ft='.&ft.'/'.&ff}\ %h%m%r%w%*
se stl +=%1*%f\ %*
se stl +=[\%02.2B/\%03.3b]\ 
hi User1 guifg=yellow
hi User2 guifg=blue
hi User3 guifg=red
" comment to add time and date to statusline:
" se stl +=%3*\ \ %{strftime(\"%l:%M:%S,\ %d/%b/%Y\ (%a)\")}%*

" {{{2 Terminal color: set to termguicolors and deal with tmux.
" OBS: gVim users might skip this part. 
" :se t_Co should give 256, otherwise uncomment:
" se t_Co=256
se tgc
" to enable true colors inside Byoby/Tmux, leave this lines:
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" wiki, calendar, email {{{1
let g:calendar_google_calendar = 1
let g:calendar_google_task = 1
let g:calendar_cache_directory = expand('~/.vim/pack/ttm/opt/prv/aux/calendarCache.vim')

" PRV {{{1
let g:prv_vimrc_dir = expand("<sfile>:h") . '/'

let g:prvset = {'leaders': {}}
" [leader, localleader, auxleader]
let g:prvset.leaders.prv = ['\', '', ' ']
let g:prvset.leaders.aa = ['A', '']
let g:prvset.leaders.realcolors = ['R', ' ']
let g:prvset.leaders.tokipona = ['T', " "]
let g:prvset.leaders.wiki = ['W', " "]
" use <CR> for commands that have little to do with Vimwiki

let g:vimwiki_list = [{'path': '~/.vim/pack/ttm/opt/wiki/aux/wiki/', 'auto_toc': 0, 'auto_tags': 1}]

" PRV also deals with Vimwiki, so \w is taken
" \X is also reserved for a nice restart
" make a PRVReinitializeAll()? TTM TODO
nn \Xx :so $MYVIMRC<CR>
nn \Xp :cal PRVInit()<CR>
" aa init has another meaning
" TODO TTM
nn \Xt :cal TPInit()<CR>
nn \Xc :cal RCInit()<CR>
nn \Xa :exe 'so '.g:aa.paths.aascript<CR>
fu! PRVReinitializeAll() " {{{2
  if exists("g:loaded_prvplugin")
    exe 'so '.g:prv_dir.'plugin/prv.vim' 
    cal PRVInit()
  en
  if exists("g:loaded_aaplugin")
    exe 'so '.g:aa_dir.'plugin/aa.vim' 
    " AAInit() will clear sessions and etc. Settings
    " are already rerun when sourcing script
  en
  if exists("g:loaded_realcolorsplugin")
    " TODO TTM
  en
  if exists("g:loaded_tokiponaplugin")
    " TODO TTM
  en
endf " }}}
fu! Undoline() " {{{  --- make mapping for this fu! TTM
  let pos = getpos(".")
  let current = getline(pos[1])
  let chg = changenr()
  wh changenr() > 0 && current ==# getline(pos[1])
    sil exe 'u'
  endw
  let old = getline(pos[1])

  wh changenr() < chg
    sil exe 'redo'
  endw
  " undo if we jumped over a gap
  if changenr() > chg
    sil exe 'u'
  en
  cal setpos('.', pos)
  if old ==# current
    ec 'no change found'
  el
    cal setline(pos[1], old)
  en
endf " }}}
" Aux / Temp {{{1
nn mn /^=====<CR>zt<C-E>
nn mp ?^=====<CR>nzt<C-E>
nn mo /http<CR>:exe '!google-chrome '.expand("<cfile>")<CR><CR>
nn mi ml:g/\s\{3,}\S.*/normal >><CR>`l
nn mI ml:g/\s\{3,}\S.*/normal <<<CR>`l
2match Constant /\v.*http.*/
match Special /\v\~.*\~/


" Notes{{{1
" this file should be read out of the box, but I need to source it (bug??) TTM
" let mysyntaxfile = '~/.vim/syntax/mysyntaxfileTTM.vim'

" Deprecated:   ------- {{{1
" se virtualedit=all

" set encoding=utf-8
" set scrolloff=3
" set number
" set showcmd
" set wrap
" set nospell
" set wildmenu
" set relativenumber
" so ~/.vim/aux/rfencript.vim
" set listchars=tab:>-,trail:.,extends:#,nbsp:*,eol:$
" }}}

":Todo make function in prv that sources the opt/after tree.
" " allow recursive TTM
