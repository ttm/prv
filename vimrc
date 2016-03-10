"" -, H, L, <space>, <cr>, and <bs> do things that you almost never need
"" from http://learnvimscriptthehardway.stevelosh.com/chapters/06.html
" set pp=/home/r/.vim
"" from https://danielmiessler.com/study/vim/?fb_ref=118ef0e03ab54c0d8197214328648a68-Hackernews
set nocompatible
filetype plugin indent on
syntax on
set encoding=utf-8
set scrolloff=3
set autoindent
set number
set wrap
set spell spelllang=en_us
set nospell
" set guifont=Menlo:h14
set wildmenu
vnoremap . :norm.<CR>
let maplocalleader = "\\\\"
let mapleader = "\\"

""""""""""""""""""""""""""""""
""        my favourites:
"" general strategy is to choose (WHAT) invalid commands
"" (e.g. operation1+operation2 or operation1+non-movement)
"" and commands that don't doo anything (e.g. up+down)
"" E.g. cl is the same as s
"" 'escape keys are lame'
"" good combinations giving already included movements
"" are also registered. Ideally, any of such movements
"" should perform something or echo 'Non used combination'.
"" I should make <nowait> option work for this to be really useful.

"" and to try to keep navigation inside keyboard. E.g.:
"" sdfghjkl toolkit ****
inoremap jj <ESC>
inoremap kk <CR><UP>
inoremap kj <ESC>kyypi
inoremap jk <ESC>jyyPi
" inoremap  fd <ESC>
" inoremap  df <ESC>
" inoremakjp kj
" nnoremap <nowait> jk o<ESC>
" nnoremap <nowait> kj O<ESC>

nnoremap <ESC> ge

nnoremap <leader>d :args ~/repos/percolation/**/*.py<CR>
nnoremap <leader>R :!python3 %<CR>
" nnoremap <leader>r :set shiftround!<CR>

nnoremap <leader>J :jumps<CR>
nnoremap <leader>j :s/=/ = /g<CR>
" nnoremap <leader>S :setlocal spell!<CR>

nnoremap <leader>s :mapclear<CR> :source $MYVIMRC<CR>
nnoremap <leader>S :source $MYVIMRC<CR>
nnoremap <localleader>s :e $MYVIMRC<CR>
nnoremap <localleader>S :vs $MYVIMRC<CR>
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
nnoremap <leader>q :q<CR>
nnoremap <leader>h :tabe<CR>:h 
vnoremap <leader>" <ESC>`>a"<ESC>`<i"<ESC>
vnoremap <leader>' <ESC>`>a'<ESC>`<i'<ESC>
nnoremap <localleader>' :s/"/'/g<CR>
inoremap <C-B> <ESC>viW~i
nnoremap <localleader>p ibanana<ESC>
nnoremap <localleader>t :args /home/r/repos/tokipona/**/*.py<CR>
nnoremap <localleader>S :vs $MYVIMRC<CR>
nnoremap gr gT
iabbrev clssa class
iabbrev clas class
iabbrev clss class
iabbrev edf def
iabbrev efd def
iabbrev remail renato.fabbri@gmail.com
iabbrev rwebsite http://openlinkedsocialdata.github.io
iabbrev rsignature --<CR> Renato Fabbri
iabbrev pimp from percolation.rdf import NS, po, a, c<CR>import percolation as P
iabbrev pimp2 import percolation as P<CR>import social as S<CR>import participation as Pa<CR>import gmane as G<CR>import music as M<CR>import visuals as V<CR>
iabbrev pmain if __name__ == "__main__":<CR>
set clipboard=unnamedplus
set relativenumber
set backspace=2
" use jk instead
inoremap <ESC> <nop>
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set visualbell           " don't beep
set nobackup
set noswapfile
set ruler
set list
set listchars=tab:>-,trail:.,extends:#,nbsp:*,eol:$
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" nnoremap <space> za
" let python_highlight_all=1
aug pythonaus
  au!
  au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab autoindent fileformat=unix
  au BufNewFile,BufRead *.py nnoremap <buffer> cd /\<def\><CR>
  au BufNewFile,BufRead *.py nnoremap <buffer> cD ?\<def\><CR> 
  au BufNewFile,BufRead *.py nnoremap <buffer> cc /\<class\><CR>
  au BufNewFile,BufRead *.py nnoremap <buffer> cC ?\<class\><CR>
  au FileType python :iabbrev <buffer> def def ():<CR>=<CR>return
  au FileType python :iabbrev <buffer> class class:<CR>__id = 0<CR>def __init__(self):<CR>__id_ = 0<CR><BS><CR>def ():<CR>return
aug END

" for walking through wrapped lines:
" nnoremap j gj
" nnoremap j gj
" nnoremap k gk

" Experimental mappings:
" autocmd BufWritePre *.py :normal gg=G
set autoread
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap iN( :<c-u>normal! F)vi(<cr>
onoremap in[ :<c-u>normal! f[vi[<cr>
onoremap iN[ :<c-u>normal! F]vi[<cr>
onoremap in{ :<c-u>normal! f{vi{<cr>
onoremap iN{ :<c-u>normal! F}vi{<cr>
" some initial snippets:
" :iabbrev <buffer> return NOPENOPENOPE

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
