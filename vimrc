" basic settings -------------------------------------------------------- {{{
" reworked for usage with Vim 8, True Colors (24 bits) and tmux
set nocompatible
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set viminfo=%,!,'1000,:1000,n~/.vim/viminfo
set tw=0
se noru
autocmd InsertEnter * set timeoutlen=200
autocmd InsertLeave * set timeoutlen=1000
let g:netrw_altv=1
let g:netrw_preview=1
set virtualedit=all
runtime! ftplugin/man.vim
set mouse=a
call pathogen#infect()
filetype plugin indent on
syntax enable
" syntax on
set encoding=utf-8
set scrolloff=3
set autoindent
set number
set showcmd
set wrap
set spell spelllang=en_us
set nospell
set wildmenu
set relativenumber
" same as :set backspace=indent,eol,start
set backspace=2
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set visualbell           " don't beep
" set nobackup
" set noswapfile
set listchars=tab:>-,trail:.,extends:#,nbsp:*,eol:$
" useful if * and + registers don't work properly
" set clipboard=unnamedplus
" set clipboard=unnamed
set hlsearch incsearch
set bg=dark
colorscheme gruvbox
let maplocalleader = "\\\\"
let mapleader = "\\"
augroup vimrcEx
  au!
  " restore-cursor, usr-05.txt
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
augroup END

nnoremap <leader>z :call ExtremeFolding()<CR>
function! ExtremeFolding()
  if &foldopen == 'all'
    set foldopen&
    set foldclose&
  else
    set foldopen=all
    set foldclose=all
  endif
endfunction
" statusline --- {{{
set laststatus=0                             " always show statusbar  
set statusline=%-5.3n\                     " buffer number  
set statusline+=%f\                          " filename   
set statusline+=%h%m%r%w                     " status flags  
set statusline+=\[%{strlen(&ft)?&ft:'none'}] " file type  
set statusline+=%=                           " right align remainder  
" uncomment to add time and date to statusline (disabled because using byobu)
" set statusline+=%{strftime(\"%l:%M:%S,\ %a\ %b\ %d,\ %Y,\ \ \ \ \ \ \")}
set statusline+=0x%-8B                       " character value  
set statusline+=%-14(%l/%L,%P,%c%V%)               " line, character  
" set statusline=%<%f%h%m%r%=%{strftime(\"%l:%M:%S\ \%p,\ %a\ %b\ %d,\ %Y\")}\ %{&ff}\ %l,%c%V\ %P
" }}}
" }}}

" filetype settings --- {{{
" Vimscript file settings ---------------------- {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker softtabstop=2 shiftwidth=2 expandtab
augroup END
" }}}

" Help file settings ---------------------- {{{
augroup filetype_help
  autocmd!
  autocmd FileType help setlocal iskeyword+=-,.,(,)
augroup END
" }}}

" Python file settings ---------------------- {{{
augroup pythonaus
" let python_highlight_all=1
  autocmd!
  " TTM removed tabstop=4
  autocmd BufNewFile,BufRead *.py set softtabstop=4 shiftwidth=4 textwidth=0 expandtab autoindent fileformat=unix
  autocmd BufNewFile,BufRead *.py nnoremap <buffer> cd /\<def\><CR>
  autocmd BufNewFile,BufRead *.py nnoremap <buffer> cD ?\<def\><CR> 
  autocmd BufNewFile,BufRead *.py nnoremap <buffer> cc /\<class\><CR>
  autocmd BufNewFile,BufRead *.py nnoremap <buffer> cC ?\<class\><CR>
"  autocmd FileType python :iabbrev <buffer> def def ():<CR>=<CR>return<ESC>?()<CR>hxi
"  autocmd FileType python :iabbrev <buffer> class class:<CR>__id = 0<CR>def __init__(self):<CR>__id_ = 0<CR><BS><CR>def ():<CR>return
  nnoremap <leader>R :call PythonShowRun()<CR>
  " validade this (from usr_05.txt):
  vnoremap _g y:exe "grep /" . escape(@", '\\/') . "/ *.py"<CR>
augroup END

function! PythonShowRun()
  let pout = system("python3 " . bufname("%") . " 2>&1")

  " Open a new split and set it up.
  vsplit __Python_output__
  normal! ggdG
  setlocal buftype=nofile

  " Insert the bytecode.
  call append(0, split(pout, '\v\n'))
endfunction
" }}}
" }}}

" hacks ------------------------------------ {{{
  " WWW navigation ------------------------------------ {{{
    function! ViewHtmlText(url)
      if !empty(a:url)
        new
        setlocal buftype=nofile bufhidden=hide noswapfile
        let g:ttmurl=a:url
        execute 'r !elinks ' . a:url . ' -dump -dump-width ' . winwidth(0)
        1d
      endif
    endfunction
    " Save and view text for current html file.
    nnoremap <Leader>H :update<Bar>call ViewHtmlText(expand('%:p'))<CR>
    " View text for visually selected url.
    vnoremap <Leader>h y:call ViewHtmlText(@@)<CR>
    nnoremap <Leader>h :call ViewHtmlText(@+)<CR>
    " View text for URL from clipboard.
    " On Linux, use @* for current selection or @+ for text in clipboard.
  " }}}

  " verbose vim usage for hacking ------------------------------------ {{{
    "  had to add "set nocp" to use "ToggleVerbose()" function when run in root
    "  because of &verbose
    function! ToggleVerbose()
        if !&verbose
            set verbosefile=~/.vim/verbose.log
            set verbose=15
            :vs ~/.vim/verbose.log
            :setlocal autoread
            else
                set verbose=0
                set verbosefile=
        endif
    endfunction
    " nnoremap <localleader>l :call ToggleVerbose()<CR>
    set verbosefile=~/.vim/verbose.log
    set verbose=0
    nnoremap <localleader>L :call ToggleVerbose()<CR>
" }}}

  " persistent undo, make /.vim/undo dir ----- {{{
    set undofile
    set undodir=$HOME/.vim/undo
    set undolevels=1000
    set undoreload=10000
  " }}}

  " quickfix toogle ----- {{{
    " nnoremap <leader>i :call <SID>QuickfixToggle()<cr>
    let g:quickfix_is_open = 0
    function! s:QuickfixToggle()
      if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
        execute g:quickfix_return_to_window . "wincmd w"
      else
        let g:quickfix_return_to_window = winnr()
        copen
        let g:quickfix_is_open = 1
      endif
    endfunction
  " }}}
" }}}

" notes for movements and usage : ------------------------------------------------- {{{
"" the general strategy is to choose invalid commands
"" (e.g. operation1+operation2 or operation1+non-movement)
"" and commands that don't doo anything (e.g. up+down)
"" E.g. cl is the same as s
"" 'escape keys are lame'
"" good combinations giving movements already in better combinations
"" are also registered. Ideally, any of such movements
"" should perform something or echo 'Non used combination'.
"" I should make <nowait> option work for this to be really useful.
"" and to try to keep navigation inside keyboard. E.g.:
"" sdfghjkl toolkit ****
" -->  H, L, <space>, <cr>, and <bs> do things that you almost never need
" --> show buffers of clipboard and search
" :echo @" . @/
"""" put in .bashrc:
" alias v='vim3 --servername mvimserver --remote-tab-silent'
" }}}

" mappings and abbrevs --- {{{
" leader mappings ---------------------- {{{
nnoremap <leader>" ea"<ESC>hbi"<ESC>lel<CR>
vnoremap <leader>" <ESC>`>a"<ESC>`<i"<ESC>
vnoremap <leader>' <ESC>`>a'<ESC>`<i'<ESC>
nnoremap <leader>a :exec "normal li".nr2char(getchar())."\e"<CR>
nnoremap <leader>A  :call InsertAfterAfter()<CR>
nnoremap <leader>b :Sex<CR><C-W>T
nnoremap <leader>B :Sex<CR>
nnoremap <leader>c :<C-F>
nnoremap <leader>C :call ListSessions()<CR>
" nnoremap <leader>d :args ~/repos/percolation/**/*.py<CR>
nnoremap <leader>d :call SaveSession()<CR>
nnoremap <leader>D :call SaveNewSession()<CR>
" assert latest is saved as a user practice
nnoremap <leader>e :call LoadSession()<CR>
nnoremap <leader>E :call InsertSession()<CR>
" nnoremap <leader>r :set shiftround!<CR>
nnoremap <leader>i :exec "normal i".nr2char(getchar())."\e"<CR>
nnoremap <leader>I :call InsertBeforeAfter()<CR>
nnoremap <leader>f :set hlsearch!<CR>
nnoremap <leader>j :s/=/ = /g<CR>
nnoremap <leader>J :jumps<CR>
nnoremap <leader>k :s/,/, /g<CR>
nnoremap <leader>l :ls<CR>
nnoremap <leader>L :set list!<CR>
" :bn to choose file n
nnoremap <leader>n :set number!<CR>
nnoremap <leader>N :set relativenumber!<CR>
nnoremap <leader>p :reg<CR>
nnoremap <leader>P :vs ~/.vim/notes.md<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>r :redraw!<CR>
"-> nnoremap <leader>R :call PythonShowRun()<CR>
nnoremap <leader>s :mapclear<CR> :source $MYVIMRC<CR>
nnoremap <leader>S :source $MYVIMRC<CR>
nnoremap <leader>t :vs.<CR><C-W>T
nnoremap <leader>T :vs.<CR>
nnoremap <leader>w :w<CR>
noremap <leader>x :execute getline('.')<CR>
noremap <leader>X :execute getline('.')
"-> nnoremap <leader>z :call ExtremeFolding()<CR>
function! InsertBeforeAfter()
  let a = nr2char(getchar())
  :exec "normal i".a."\e"
  :exec "normal lli".a."\e"
endfunction
function! InsertAfterAfter()
  let a = nr2char(getchar())
  :exec "normal a".a."\e"
  :exec "normal lla".a."\e"
endfunction

function! SaveSession()
  if !exists("g:msession")
    :call ListSessions()
    let g:msession = input("Enter session name: ")
  endif
  execute 'mksession! ~/.vim/sessions/' . g:msession
endfunction

function! SaveNewSession()
  :call ListSessions()
  let g:msession = input("Enter session name: ")
  execute 'mksession! ~/.vim/sessions/' . g:msession
endfunction

function! LoadSession()
  :call ListSessions()
  let g:msession = input("Enter session name: ")
  execute 'only'
  execute 'tabonly'
  execute 'so ~/.vim/sessions/' . g:msession
endfunction

function! InsertSession()
  :call ListSessions()
  execute 'tabe'
  let g:msession = input("Enter session name: ")
  execute 'so ~/.vim/sessions/' . g:msession
endfunction

function! ListSessions()
  execute '!ls ~/.vim/sessions/'
endfunction
" }}}

" localleader mappings ---------------------- {{{
hi CursorLine   cterm=NONE ctermbg=235
hi CursorColumn cterm=NONE ctermbg=235

nnoremap <localleader>' :s/"/'/g<CR>
nnoremap <localleader>c :set cursorline! cursorcolumn!<CR>
nnoremap <localleader>b :execute 'rightbelow vs ' . bufname('#')<CR>
nnoremap <localleader>B :call ToggleStatusbar()<CR>
nnoremap <localleader>g :call ChangeBackground()<CR>
" nnoremap <localleader>h :tabe<CR>:h 
nnoremap <localleader>h :call Help()<CR>
nnoremap <localleader>i :call ShowImg()<CR>
" keymap=
nnoremap <localleader>k :se keymap=accents<CR>
nnoremap <localleader>l :set invhlsearch \| set hlsearch?<CR>
"-> nnoremap <localleader>L <CR>
nnoremap <localleader>p :setlocal spell!<CR>
nnoremap <localleader>s :e $MYVIMRC<CR>
nnoremap <localleader>S :tabe $MYVIMRC<CR>
nnoremap <localleader>t :args /home/r/repos/tokipona/**/*.py<CR>
nnoremap <localleader>T :call ToggleTabLine()<CR>
nnoremap <localleader>w :match Error /\v[ ]+$/<CR>
nnoremap <localleader>W :match none<CR>
function! ShowImg()
  exec "normal! viWy"
  silent exec '!eog -f ' getreg('0')
  exec 'colorscheme gruvbox'
endfunction
function! Help()
  let token = input('what? ')
  :tabe
  exec ':h ' . token
  execute "normal! \<C-W>\<C-J>"
  :q
endfunction
function! ChangeBackground()
  if &bg == 'dark'
    set bg=light
  else
    set bg=dark
  endif


endfunction
function! ToggleStatusbar()
  if &ls == 2
    set ls=0
  else
    set ls=2
  endif
endfunction
function! ToggleTabLine()
  if &showtabline == 2
    set showtabline=0
  else
    set showtabline=2
  endif
endfunction
" l and L are used for verbose

" }}}

" abbrev ---------------------- {{{
iabbrev clssa class
iabbrev clas class
iabbrev clss class
iabbrev edf def
iabbrev efd def
iabbrev remail renato.fabbri@gmail.com
iabbrev rwebsite http://openlinkedsocialdata.github.io
iabbrev rsignature --<CR> Renato Fabbri
iabbrev pimp from percolation.rdf import NS, po, a, c<CR>import percolation as P
iabbrev pimp_ import percolation as P<CR>import social as S<CR>import participation as Pa<CR>import gmane as G<CR>import music as M<CR>import visuals as V<CR>
iabbrev pmain if __name__ == "__main__":<CR>
" }}}

" other mappings ---------------------- {{{
vnoremap . :norm .<CR>
" nnoremap ; :
" nnoremap : ;
inoremap <C-B> <ESC>viW~i
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
tnoremap <C-J> <C-W><C-J>
tnoremap <C-K> <C-W><C-K>
tnoremap <C-L> <C-W><C-L>
tnoremap <C-H> <C-W><C-H>
nnoremap <space> za
inoremap jj <ESC>
" inoremap kk <CR><UP>
" inoremap kj <ESC>kyypi
" inoremap jk <ESC>jyyPi
" inoremap  fd <ESC>
" inoremap  df <ESC>
" inoremakjp kj
" nnoremap <nowait> jk o<ESC>
" nnoremap <nowait> kj O<ESC>
" nnoremap <ESC> ge
nnoremap gr gT
tnoremap gr <C-W>:tabp<CR>
tnoremap gt <C-W>:tabn<CR>

" }}}

" experimental mappings ---------------------- {{{
" for walking through wrapped lines:
" nnoremap j gj
" nnoremap j gj
" nnoremap k gk

" set autoread
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap iN( :<c-u>normal! F)vi(<cr>
onoremap in[ :<c-u>normal! f[vi[<cr>
onoremap iN[ :<c-u>normal! F]vi[<cr>
onoremap in{ :<c-u>normal! f{vi{<cr>
onoremap iN{ :<c-u>normal! F}vi{<cr>
" }}}
" }}}

" Useful commands which I might need to recall:
" C-A, C-X to add and subtract from number
" check on usage of bracket commands in Python
" start using tags seriously (and find that video from Bram)
" i_C-R to paste register
" i_C-NP to next-previous word completion
" i_C-UTY
" C-W_orR
" Review the '`commands
" g#*<DIjks
" zgGwWv
