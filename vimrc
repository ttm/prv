" My minimal vimrc, Sáb Mai 19 00:12:54 -03 2018 {{{1
" Author: Renato Fabbri (renato.fabbri@gmail.com)
" Notes: Plugins are placed inside pack/prv/opt/ and loaded with :pa
" This is a very minimal vimrc, check the rest of the file tree

" {{{1 default Vim
se nocp
se sts=2 sw=2 tw=0 bs=2 et ai nu rnu
se so=2
" se sj=-80
se hi=10000  " remember more commands and search history
se wig=*.swp,*.bak,*.pyc,*.class
se vb           " don't beep
se tgst
" asserts python3 is loaded:
py3 import random
se mouse=a
filet plugin indent on
sy enable
se spelllang=en_us
se nospell
se nohls
se showcmd
" to enable true color and tab navigation inside Byoby/Tmux
if !empty($TMUX)
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  nn <ESC>[6;5~ gt
  nn <ESC>[5;5~ gT
endif
se tgc

se backup
se backupdir=~/.vim/aux/backupdir//
se dir=~/.vim/aux/swapdir//

" {{{1 PRV 
let g:aa_user = 'rfabbri'
let g:prv = {'leaders': {}, 'paths': {}}
" add items to this list to find out the order in which files are sourced

let g:prv.order = ['vimrc']

let g:prv.paths.vim = expand("<sfile>:h") . '/'
let g:prv.leaders.default = ['', "<space>", "<cr>", "<tab>", "<bs>", '_', '\']
let g:prv.leaders.other = ["<c-h>", "<c-j>", "<c-k>"]

" created with $ xmodmap -pke > aux/PXmodmap
" when the keyboard is loaded (with or without dead keys)
" and swapping colon with semicolon
" can I leave only the chars needed to swap? e.g. only ; with :?
" i should make this through the system.

pa aa
pa wiki
pa c0lor
pa bot
pa tokipona
pa prv
let aa.set.bot = 0

" nn <silent> <space>p; :cal system('xmodmap '.g:prv.paths.vim . ('aux/PXmodmap' ))<cr>
" nn <silent> <space>p: :cal system('xmodmap '.g:prv.paths.vim . ('aux/PXmodmap2'))<cr>

" {{{1 final commands
colo blue

" {{{1 syntastic

" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
" pa syntastic
" " se statusline+=%#warningmsg#
" " se statusline+=%{SyntasticStatuslineFlag()}
" " se statusline+=%*
" " g:syntastic_python_checkers = ['flake8', 'python3']
" let g:syntastic_python_flake8_args = '--ignore=E712,E402'
" 
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0

" {{{1 notes
" space, enter, backspace, tab, are keys not really used
" _ and ^ both go to same place
" <c-> commands, e.g. <c-w> commands
" reduntant commands that cannot be used: n_<c-p>
" g and z combinations that are not used
" <a-> commands, which in the terminal is <esc-> here and:
"      might be used as expected in normal mode
"      should be considered in insert mode

" :A ha uma transicao de fase quando se escreve mais fluente e tem os comandos
" nos dedos. Nao vale mais a pena sair dos standards do Vim.
" :todo: write to vim_use about sticking to standards, no plugins

" :A fumegando mapping p trocar : por ;.
