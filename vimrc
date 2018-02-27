" My minimal vimrc (elaborate functionalities are in pavk/ttm/opt/prv/) {{{1
" Author: Renato Fabbri (renato.fabbri@gmail.com)
" Notes: Plugins are placed inside pack/ttm/opt/ and loaded with :pa
" This is a very minimal vimrc, see PRV Vim plugin (Private) for 
" utilities (mappigns, commands, functions, etc) in general
" Date: 2018/Fev/25 (when I wrote this header)

" {{{1 default Vim
se nocp
let maplocalleader = '\'
let mapleader = '\\'
se sts=2 sw=2 tw=0 et ai
se hi=10000  " remember more commands and search history
se wig=*.swp,*.bak,*.pyc,*.class
se vb           " don't beep
se tgst
" asserts python3 is loaded:
py3 import random
se mouse=a
filet plugin indent on
sy enable
se spell spelllang=en_us
se showcmd

let g:netrw_altv=1
let g:netrw_preview=1

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
" to enable true colors inside Byoby/Tmux, leave this lines
" let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
" let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" PRV {{{1
let g:prv_vimrc_dir = expand("<sfile>:h") . '/'

let g:prvset = {'leaders': {}}
" [leader, localleader, auxleader]
let g:prvset.leaders.prv = ['\', '', ' ']
let g:prvset.leaders.aa = ['A', ' ']
let g:prvset.leaders.realcolors = ['R', ' ']
let g:prvset.leaders.tokipona = ['T', " "]
" use <CR> for commands that have little to do with Vimwiki

" PRV also deals with Vimwiki, so \w is taken

" Notes{{{1
" this file should be read out of the box, but I need to source it (bug??) TTM
" let mysyntaxfile = '~/.vim/syntax/mysyntaxfileTTM.vim'

" Deprecated:   ------- {{{1
" se virtualedit=all
" cal pathogen#infect()

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

" make function in prv that sources the opt/after tree.
" " allow recursive TTM
