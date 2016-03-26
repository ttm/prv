" basic settings -------------------------------------------------------- {{{
set virtualedit=all
colorscheme morning
runtime! ftplugin/man.vim
set nocompatible
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif
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
set ruler
set list
set listchars=tab:>-,trail:.,extends:#,nbsp:*,eol:$
" useful if * and + registers don't work properly
" set clipboard=unnamedplus
" set clipboard=unnamed
if $TMUX == ''
    set clipboard+=unnamedplus
endif
set hlsearch incsearch
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
set laststatus=2                             " always show statusbar  
set statusline=%-5.3n\                     " buffer number  
set statusline+=%f\                          " filename   
set statusline+=%h%m%r%w                     " status flags  
set statusline+=\[%{strlen(&ft)?&ft:'none'}] " file type  
set statusline+=%=                           " right align remainder  
set statusline+=0x%-8B                       " character value  
set statusline+=%-14(%l/%L,%P,%c%V%)               " line, character  
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
  autocmd BufNewFile,BufRead *.py set softtabstop=4 shiftwidth=4 textwidth=72 expandtab autoindent fileformat=unix
  autocmd BufNewFile,BufRead *.py nnoremap <buffer> cd /\<def\><CR>
  autocmd BufNewFile,BufRead *.py nnoremap <buffer> cD ?\<def\><CR> 
  autocmd BufNewFile,BufRead *.py nnoremap <buffer> cc /\<class\><CR>
  autocmd BufNewFile,BufRead *.py nnoremap <buffer> cC ?\<class\><CR>
  autocmd FileType python :iabbrev <buffer> def def ():<CR>=<CR>return<ESC>?()<CR>hxi
  autocmd FileType python :iabbrev <buffer> class class:<CR>__id = 0<CR>def __init__(self):<CR>__id_ = 0<CR><BS><CR>def ():<CR>return
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
            set verbosefile=~/.log/vim/verbose.log
            set verbose=15
        else
            set verbose=0
            set verbosefile=
        endif
    endfunction
    nnoremap <localleader>l :call ToggleVerbose()<CR>
    set verbosefile=~/.log/vim/verbose.log
    set verbose=15
    nnoremap <localleader>L :e~/.log/vim/verbose.log<CR>
" }}}

  " persistent undo, make /.vim/undo dir ----- {{{
    set undofile
    set undodir=$HOME/.vim/undo
    set undolevels=1000
    set undoreload=10000
  " }}}

  " quickfix toogle ----- {{{
    nnoremap <leader>i :call <SID>QuickfixToggle()<cr>
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
noremap <leader>x :execute getline('.')<CR>
noremap <leader>X :execute getline('.')
nnoremap <leader>r :redraw!<CR>
nnoremap <leader>d :args ~/repos/percolation/**/*.py<CR>
" nnoremap <leader>r :set shiftround!<CR>
nnoremap <leader>J :jumps<CR>
nnoremap <leader>j :s/=/ = /g<CR>
" nnoremap <leader>S :setlocal spell!<CR>
nnoremap <leader>s :mapclear<CR> :source $MYVIMRC<CR>
nnoremap <leader>S :source $MYVIMRC<CR>
nnoremap <leader>N :set relativenumber!<CR>
nnoremap <leader>n :set number!<CR>
nnoremap <leader>k :s/,/, /g<CR>
nnoremap <leader>b :Sex<CR><C-W>T
nnoremap <leader>t :vs.<CR><C-W>T
nnoremap <leader>B :Sex<CR>
nnoremap <leader>T :vs.<CR>
nnoremap <leader>l :ls<CR>
nnoremap <leader>L :set list!<CR>
" :bn to choose file n
nnoremap <leader>c :<C-F>
nnoremap <leader>p :reg<CR>
nnoremap <leader>" ea"<ESC>hbi"<ESC>lel<CR>
nnoremap <leader>w :w<CR>
nnoremap / /\v
nnoremap <leader>q :q<CR>
vnoremap <leader>" <ESC>`>a"<ESC>`<i"<ESC>
vnoremap <leader>' <ESC>`>a'<ESC>`<i'<ESC>
nnoremap <localleader>' :s/"/'/g<CR>
inoremap <C-B> <ESC>viW~i
" }}}

" localleader mappings ---------------------- {{{
nnoremap <localleader>p ibanana<ESC>
nnoremap <localleader>t :args /home/r/repos/tokipona/**/*.py<CR>
nnoremap <localleader>S :vs $MYVIMRC<CR>
nnoremap <localleader>b :execute 'rightbelow vs ' . bufname('#')<CR>
nnoremap <localleader>s :e $MYVIMRC<CR>
nnoremap <localleader>S :vs $MYVIMRC<CR>
nnoremap <localleader>w :match Error /\v[ ]+$/<CR>
nnoremap <localleader>W :match none<CR>
nnoremap <localleader>h :tabe<CR>:h 
nnoremap <localleader>H :set hlsearch!<CR>
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
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <space> za
inoremap jj <ESC>
inoremap kk <CR><UP>
inoremap kj <ESC>kyypi
inoremap jk <ESC>jyyPi
" inoremap  fd <ESC>
" inoremap  df <ESC>
" inoremakjp kj
" nnoremap <nowait> jk o<ESC>
" nnoremap <nowait> kj O<ESC>
" nnoremap <ESC> ge
nnoremap gr gT
" }}}

" experimental mappings ---------------------- {{{
" for walking through wrapped lines:
" nnoremap j gj
" nnoremap j gj
" nnoremap k gk

set autoread
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap iN( :<c-u>normal! F)vi(<cr>
onoremap in[ :<c-u>normal! f[vi[<cr>
onoremap iN[ :<c-u>normal! F]vi[<cr>
onoremap in{ :<c-u>normal! f{vi{<cr>
onoremap iN{ :<c-u>normal! F}vi{<cr>
" }}}
" }}}
set viminfo=%,!,'1000,:1000,n~/.vim/viminfo
