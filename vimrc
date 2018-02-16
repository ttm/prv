" basic settings -------------------------------------------------------- {{{
" reworked for usage with Vim 8, True Colors (24 bits) and tmux
set nocompatible
set termguicolors
" this file should be read out of the box, but I need to source it (bug??)
let mysyntaxfile = '~/.vim/syntax/mysyntaxfileTTM.vim'
py3 import random
se digraph
" :se t_Co should give 256, otherwise uncomment:
" se t_Co=256
" to enable true colors inside Byoby/Tmux
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set viminfo=%,!,'1000,:1000,n~/.vim/viminfo
set tw=0
se noru
" se autowrite does not work... using update again on mappings
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
so ~/.vim/aux/rfencript.vim

" same as :set backspace=indent,eol,start
set backspace=2
set history=10000         " remember more commands and search history
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
au Colorscheme * so ~/.vim/syntax/mysyntaxfileTTM.vim
" colorscheme gruvbox
colo blue
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

" Vimwiki file settings ---------------------- {{{
  autocmd BufNewFile,BufRead *.wiki set softtabstop=2 shiftwidth=2 textwidth=0 expandtab autoindent fileformat=unix
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
" Alt mappings ---------------------- {{{
" Alt is a "command leader" for me
" Maybe change it to space
" and make folding with space space
nnoremap a gT
inoremap a <ESC><C-W>:tabp<CR>l<C-W>:startinsert<CR>
cnoremap a <ESC><C-W>:tabp<CR>l<c-w>:
tnoremap a <C-W>:tabp<CR>

" should put fold markers as comments, for now just VimL
noremap c mf?^fuA " {{{/^endfu€kbA " }}}`f 
inoremap c <ESC>?^fuA " {{{/^endfu€kbA " }}}`fa

" nnoremap d gT
" inoremap d <ESC><C-W>:tabp<CR>l<C-W>:startinsert<CR>
" cnoremap d <ESC><C-W>:tabp<CR>l<c-w>:
" tnoremap d <C-W>:tabp<CR>

nnoremap d gt
tnoremap d <C-W>:tabn<CR>
inoremap d <ESC><C-W>:tabn<CR>l<C-W>:startinsert<CR>
cnoremap d <ESC><C-W>:tabn<CR>l<c-w>:

" should run functions, for now just VimL
nnoremap f mf?^fu^MV/^endf^M:@*^M`f
inoremap f <ESC>mf?^fu^MV/^endf^M:@*^M`fa

" find files
nnoremap FF :Split echo globpath('/home/renato/repos/', "**/percolation*/**")
nnoremap Ff :Split echo globpath(&rtp, "*/vimwiki.vim")

nnoremap g :w<CR>:source %<CR>
inoremap g <ESC>:w<CR>:source %<CR>

nnoremap h <C-W><C-H>
nnoremap j <C-W><C-J>
nnoremap k <C-W><C-K>
nnoremap l <C-W><C-L>
inoremap h <ESC><C-W><C-H>a
inoremap j <ESC><C-W><C-J>a
inoremap k <ESC><C-W><C-K>a
inoremap l <ESC><C-W><C-L>a
tnoremap h <ESC><C-W><C-H>
tnoremap j <ESC><C-W><C-J>
tnoremap k <ESC><C-W><C-K>
tnoremap l <ESC><C-W><C-L>
cnoremap h <ESC><C-W><C-H>:
cnoremap j <ESC><C-W><C-J>:
cnoremap k <ESC><C-W><C-K>:
cnoremap l <ESC><C-W><C-L>:

nnoremap L :call CompileLatex()<CR>

inoremap o <ESC>

nnoremap p :runtime! plugin/**/*.vim<CR>
inoremap p <ESC>:runtime! plugin/**/*.vim<CR>a
nnoremap P :call OpenPDF()<CR>

" should run the line or the selection, for now just VimL
nnoremap r Y:@"<CR>
inoremap r <ESC>Y:@"<CR>a

nnoremap s :w<CR>:source $MYVIMRC<CR>:runtime! plugin/**/*.vim<CR>
inoremap s <ESC>:w<CR>:source %<CR>a
nnoremap S :w<CR>:source $MYVIMRC<CR>
inoremap S <ESC>:w<CR>:source %<CR>l

nnoremap w :w<CR>
inoremap w <ESC>:w<CR>a
nnoremap q :q<CR>
inoremap q <ESC>:q<CR>a

iabbrev j <C-O>
                  
" }}}
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
" make the f mappings usable by using the paths correctly
nnoremap <leader>f :term ++hidden ++close pdflatex %
nnoremap <leader>F :term ++hidden ++open pdflatex %
nnoremap <leader>g :source %<CR>
nnoremap <leader>G :echo "BANANA"<CR>
nnoremap <leader>i :exec "normal i".nr2char(getchar())."\e"<CR>
nnoremap <leader>I :call InsertBeforeAfter()<CR>
nnoremap <leader>f :set hlsearch!<CR>
nnoremap <leader>j :s/=/ = /g<CR>
nnoremap <leader>J :jumps<CR>
nnoremap <leader>k :s/,/, /g<CR>
nnoremap <leader>l :ls<CR>:b 
nnoremap <leader>L :set list!<CR>
" :bn to choose file n
nnoremap <leader>n :set number!<CR>
nnoremap <leader>N :set relativenumber!<CR>
nnoremap <leader>p :reg<CR>
nnoremap <leader>P :vs /home/renato/vimwiki/blergh.wiki<CR>
nnoremap <leader>q :q<CR>
" next command is only to remember how to do stuff
nnoremap <leader>r ?^\n<CR>V/^\n<CR>:py3 exec(vim.eval("@*"))<CR>/W<CR>f'lvt'y:!aplay <C-R>"
"-> nnoremap <leader>R :call PythonShowRun()<CR>
nnoremap <leader>s :w<CR>:source $MYVIMRC<CR>
nnoremap <leader>S :w<CR>:let g:mmapclear=1<CR>:mapclear<CR> :source $MYVIMRC<CR>
nnoremap <leader>t :vs.<CR><C-W>T
nnoremap <leader>T :r !date +\%d/\%h/\%y,\ \%H:\%\M:\%S<CR>
nnoremap <leader>W :w<CR>
nnoremap <leader>x :execute getline('.')<CR>
nnoremap <leader>X :execute getline('.')

" Vimwiki
nnoremap <leader>wA :vs ~/vimwiki/achievements.wiki<CR>
nnoremap <leader>wT :vs ~/vimwiki/todo.wiki<CR>
nnoremap <leader>wD :vs ~/vimwiki/daily/tasks.wiki<CR>
nnoremap <leader>wW :vs ~/vimwiki/weekly/wtasks.wiki<CR>

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

set sessionoptions+=globals
function! SaveSession()
  if !exists("g:msession")
    call ListSessions()
    let g:msession = input("Enter session name: ")
  endif
  execute 'mksession! ~/.vim/sessions/' . g:msession
endfunction

function! SaveNewSession()
  call ListSessions()
  let g:msession = input("Enter session name: ")
  execute 'mksession! ~/.vim/sessions/' . g:msession
endfunction

function! LoadSession()
  call ListSessions()
  let g:msession = input("Enter session name: ")
  execute 'only'
  execute 'tabonly'
  execute 'so ~/.vim/sessions/' . g:msession
endfunction

function! InsertSession()
  call ListSessions()
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
inoremap <C-J> <ESC><C-W><C-J>:startinsert<CR>
inoremap <C-K> <ESC><C-W><C-K>:startinsert<CR>
inoremap <C-L> <ESC><C-W><C-L>:startinsert<CR>
inoremap <C-H> <ESC><C-W><C-H>:startinsert<CR>
tnoremap <C-J> <C-W><C-J>
tnoremap <C-K> <C-W><C-K>
tnoremap <C-L> <C-W><C-L>
tnoremap <C-H> <C-W><C-H>
nnoremap <space><space> za
" inoremap jj <ESC>:up<CR>
" inoremap jj <ESC>:up<CR>
inoremap <C-[> <ESC>:up<CR>
" inoremap kk <CR><UP>
" inoremap kj <ESC>kyypi
" inoremap jk <ESC>jyyPi
" inoremap  fd <ESC>
" inoremap  df <ESC>
" inoremakjp kj
" nnoremap <nowait> jk o<ESC>
" nnoremap <nowait> kj O<ESC>
" nnoremap <ESC> ge
fu! PreservInsert(isin, isterm)
  if isterm != 0
    if isin
    endif
  endif
  let g:in_prv_insert = a:isin
endfu

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

" autocommands --- {{{
function! RotateRegisters()
  let @h=@j
  let @j=@k
  let @k=@l
  let @l=@.
endfunction
au InsertLeave * call RotateRegisters()

autocmd CmdwinEnter * map <buffer> <C-D> <CR>q:
autocmd CmdwinEnter * map <buffer> <C-E> <CR> input("")q:

" }}}

let @f = 'mf?^fu^MV/^endf^M:@*^M`f'
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
" :h pi_getscript.txt pi_vimball.txt
" highlight SpellBad
" highlight Normal
" highlight SpellBad term=reverse ctermbg=9 gui=undercurl guisp=Red guifg=red guibg=darkBlue
" highlight Normal ctermfg=11 ctermbg=4 guifg=lightyellow guibg=Blue
" autocommand for saving and compiling tex file when exiting insert mode.
" au InsertLeave * :!pdflatex %<CR><CR>
" ensure the autocommands are loaded only once or removed before being added again.

" :runtime syntax/hitest.vim
" :so $VIMRUNTIME/syntax/hitest.vim 

" :exec getline('.')
" Y:@"


" Highlighting notes   ------------------   {{{
"
" :echo synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
" should give you the highlighting group you need to change
" to change the colors of the char in cursor position.
" hi <name_of_group><CR> 
" will output the settings, which can be changed by appending to the same command
" highlight, syntax and colorcheme
"
" 
" found in:
" http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
" map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '>
" trans<'
" \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
" \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
" }}}
"
" Spell bad and other groups are bot being shown
"
" Make a mapping for saving current highlighting settings. Just redir
"
" :redir @a
" :set all
" :redir END
" }}}

function! TabMessage(cmd) " {{{
  " use like :TabMessage highlight
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    " use "new" instead of "tabnew" below if you prefer split windows instead of tabs
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
  endif
endfunction " }}}
command! -nargs=+ -complete=command Tab call TabMessage(<q-args>)

function! OutputSplitWindow(...) " {{{
  " this function output the result of the Ex command into a split scratch buffer
  let cmd = join(a:000, ' ')
  let temp_reg = @"
  redir @"
  silent! execute cmd
  redir END
  let output = copy(@")
  let @" = temp_reg
  if empty(output)
    echoerr "no output"
  else
    new
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
    put! =output
  endif
endfunction " }}}
command! -nargs=+ -complete=command Split call OutputSplitWindow(<f-args>)

function! HiFile() " {{{
  " run to hightlight the buffer with the highlight output
  " e.g. after :Split sy or :Split hi
    let i = 1
    while i <= line("$")
        if strlen(getline(i)) > 0 && len(split(getline(i))) > 2
            let w = split(getline(i))[0]
            exe "syn match " . w . " /\\(" . w . "\\s\\+\\)\\@<=xxx/"
        endif
        let i += 1
    endwhile
endfunction " }}}

" https://en.wikipedia.org/wiki/Blood_red and http://rgb.to/color/2845/blood-red
"
""""""""""""""""""""""""""""
" End of vimrc, last commands
se verbose=2
let g:vimscript_vars = s:
" au BufEnter,BufRead,BufNewFile,BufFilePre,BufFilePost,BufWinEnter,BufNew,BufReadPost,BufReadCmd,Colorscheme * so ~/.vim/syntax/mysyntaxfileTTM.vim
" au BufEnter,BufRead,BufNewFile,BufFilePre,BufFilePost,BufWinEnter,BufNew,BufReadPost,BufReadCmd,Colorscheme * so ~/.vim/syntax/mysyntaxfileTTM.vim
" au! Syntax * so ~/.vim/syntax/mysyntaxfileTTM.vim
" gq gw
" recovering mappings from plugins...
if exists("g:mmapclear")
  unlet! g:mmapclear
  unlet! g:loaded_vimwiki
  so /home/renato/.vim/pack/plugins/start/vimwiki/plugin/vimwiki.vim
  " Shout put all plugins here I assume...
  " or find a way to source them all again
endif
" Solve the navigation issue. True C-HJKL in all?
" Problem: move i_<C-K> to another combination.
" It helps ut to enter :dig.
" Solution: se digraph
" Note: <C-L> does not seem to work in insert or command modes.
" In Normal mode it does: redraw! Using zz zt zb for now.
" Ok! make it available in all modes.
"
" What about next/previous tab? Any good C- command?
" Alfanumeric are used to type by insert, command and terminal job modes
"

" Navigate hjkl in insert/command and terminal job modes with <C-UIOP>?
"
" To make new commands:
" zp zq zu zy z(B I J K P Q S T U Y Z) z(any punctuation except: +-=.^, e.g.
" ,/;'[]\`)
" Z(any not Z or Q)
"
" g(2-7,9) g(A,B,C,G,K,L,M,O,S,X,Z,Y,W) g(b,c,l,y,w)
" not g(~,@,_,^,],?,;,<,,,,+,*,',`,$,#): g(.,/,:,",[,\,=)

" CTRL, i_(I,M,Q,S), puncts not ([,],\ CN CG,^,_)
" misterious i_(B,F,
" normal: (Q,S,M,N,P,I), puncts not (],^,)
" c_(H,I,J,K,M,O,Q,S), puncts not ([,],^,_,\ CN CG e
"
" (F is in lowecases, gm after gn, g<punctuations> are scattered)
" Is there a command to know the mappings being used by the Vim installation
" or one has to browser :h index  ?
"
" Best key combination for mappings: g and z. Ctrl
" Alt and <C-\> are not used and are thus secure to use
" (ahtough Alt often conflicts with system shortcurts).
" Commands which we find useless.
"
" use r? to ro13 enconde! No cypher needed, or install a cypher
"title caps	:s/\v<(.)(\w*)/\u\1\L\2/g

" about Bram video of effective text editing (2005)
" gf opens links
" [I shows all the matches of the keyword under cursor
" :cfile ??
" ctags, exuberant-ctags, cscope
"
" https://youtu.be/p6K4iIMlouI?t=1h51s Bram advocates terminal vim (although
" he used both in the presentation)
"
" ~50m: he calls for help in the todo list.
"
" send article to vim list, mentioning the recent revision and add of the
" results section.
"
" 1h integration of Vim to cloud resources, e.g. for google autocomplete
"
" license: handmade by Bram in the initial years of Vim,
" and is GPL compatible (Richard Stallman reviwed the license himself).
" https://youtu.be/p6K4iIMlouI?t=1h6m31s
"
" You, the author, can change the license whenever you want, so don't worry
" about sharing scripts. I usually put "Public Domain" somewhere in the
" repository, because it is fairily unambiguous and open.
" Sometimes I use GPL, LGPL, MIT and CC-variants for reasons usually very
" unimportant and shallow.
"
" Charityware rightfully received some emphasis, by Moolinaar, on the same video.
" Vim donations go to Uganda, to educate kids, mostly orphans, though a
" project which Mollinaar knows by going there.
"
" Bram does not use tabs. but understands its usefulness and advocates its use
" e.g. in gVim to avoid opening multiple gVim instances.
" But states that if 
"
" TODO: look for terminals in sessions, post on vim list.
"       add about '1-9 which are cross buffers, yes, but go to last 1-9
"       positions where you left Vim.
"
" cat /dev/urandom in Terminal-Job mode breaks Vim
" another drawback is that if the terminal history is too big,
" e.g. if you are compiling latex often for a day, or running many verbose
" Python code in ipython, it slows down all" of Vim.
"
" vim notetaking tips: https://www.youtube.com/watch?v=wh_WGWii7UE&t=934s
" change \L char
" get the vimgrep command to vimwiki at ~10m
" learn pandoc to convert vimwiki MD files to Latex.
" learn how to write articles there. Write the color scheme for SH
" article on vimwiki
"
" Vim 25 years video (2016)
" see :h viminfo
"
" Bram uses Vim script not VimL
" Blowfish encription, 
" persistend undo branches and advocation it
"
" my binary is 11M (without GUI, but huge and with Python2 and 3, termguicolors,
" terminal, in his presentation it is 2.4MB.
"
" :TODO add :options command to article
"
" jobs 50m
"
" 52m30 "look at the log while you are doing something else"
" (while talking about job and using (job_start)
"
" Channels (e.g. for daemons) uses json
" testing with assert_equal
" timers (timer_start)
" realcolors in a package not a plugin?
" is timers just jobs that are repeated from time to time?
" partials to bind dictionaries and arguments to functions
" lambda functions
" closure
" finishes by talking about these vim 8.0 release, and says 8.1 is next..
"
" TODO: mentions Bram's videos on documentation and historical note.
"       add about channels, jobs and timers in the terminal job mode
"       use of directives in Vim, e.g. " :vim aoidjasoidj aosjd
"           How to make a file with independent syntax highlighting with these
"           directives
"       see how Vimwiki hides link [[]] and _ _ to highlight
"       A Vim plugin is one script. If you have multiple scripts, you have a
"       pack
"       Add notes on version8.txt and last commits in vim/vim repo
"       Is the diff of pack and plugin/<dir> just :packadd?
"
"       change tokipona and realcolors to pack/ttm/start/(tokipona,
"       realcolors)
"           this way, syntax/tokipona.vim will be correctly inside
"           pack/ttm/start/tokipona/syntax/tokipona.vim
"           and the rest in:
"           pack/ttm/start/tokipona/syntax/tokipona.vim and 
"
"       Make realcolors initialized at startup and make :col0[rscheme] to
"       realcolors colors
"       Write help files for tokipona and realcolors
"           :h  add-local-help (usr_05)
"
"       add about plugin being only one file: :h plugin:
"         "A plugin is nothing more than a Vim script file that is loaded automatically when Vim starts."
"
"       use :load-plugins
"       read :h todo and h: develop
"       
"       put realcolors colorschemes in colors/xxx.vim.
"       
"       check notes on colors in :h todo

"       add about :mk and :mkv

"       check the :h trojan-horse for making the Vim evolutionary
"       inteligence and optimization algorithms

"       clear the pipeline: function -> command -> mapping.
"           when is command needed? when is it convenient for a mapping?

"       <SID> only for commands and and s: everywhere else. Why? check :h usr_41 
map Q gq

"       normal command reads all the followin chars as the sequence of keys.
"       execute command expects a string, e.g. starting by " and ending with "
"       e.g. :normal iYouBoy ;; :execute "normal iYouboy"
"       when does a command expect a string and when does it reads argument as string?

"       learn :h getscript   ??
"       
"       understand what happends when ftplugin and ftdetect are inside plugin/
"       as made with tokipona plugin

" :finish s
" use <unique> on the mappings

" maybe allow CRF in multi fyletype... e.g. setfiletype html.php ... :h filetype

" put instruction to copy the files into pack, clone into 

" add :helptags command to a plugin file in both realcolors and tokipona

" make note about after/ dir not being recursive (e.g. .vim/after/after is not add to runtimpath

" make correct differentiation between plugin, ftplugin, ftdetect, after, syntax, pack, pack/start, pack/opt, bundle?...

" state the uses for Cundle, Pathogen, Vimball and other means, GLP (GLV?)

" describe paths search for in each dir of &runtimepath, include e.g. ftdetect and others which are not in :h runtimepath

" mention the brief discussion in :h map-which-keys about which keys
" to map

" a thorough consideration of the possibilities for mappings would
" include statistics of the languages and text styles intended.

" open pdf of the tex file using a job, bash and evince

" use abbreviations for insert mode.. e.g. fj triggers function that
" allows for one normal command and goes back to insert mode

" <C-> mappings remove the hand from the middle of the keyboard.
" <A-> has the same problem.
" <Space> is ok for normal mode, but used a lot in command, terminal
" and insert modes.
" a mapping might suffice to use the same commands as in normal mode:
" FJ anf JF fj jf maybe...
" shift also removes hand from the middle of the keyboard.
" maybe <letter>u us uppercase, uu is u and uuu is U.
" enter also removes the hand from the middle of the
" keyboard, so maybe fh for enter

" or make a mapping to enable and disable the shortcuts with fj,
" j, space, abbrev or any other convenience.  

" space mmakes sense for normal mode, suggesting that each command 
" be thought as a word (in the editing language, ideally, in thought
" of editing thought language).

" make a plugin to tackle the subject, turning on and off
" the mappings to use keyboard with hands in the middle,
" respecting the desing of the keyboard for writting.
" (study typing techniques?)


if !exists("pdfjobs")
  let g:pdfjobs = []
endif

fu! OpenPDF() " {{{
  let l:tfname = expand("%:r") . '.pdf'
  let l:tcmd = 'evince ' . l:tfname
  if !filereadable(l:tfname)
    let @x = ':call add( g:pdfjobs, job_start(["/bin/bash", "-c", "' . l:tcmd . '" ]))'
    echo 'command to open PDF in @x register'
  else
    call add( g:pdfjobs, job_start(["/bin/bash", "-c", l:tcmd]))
  endif
endfu " }}}

fu! CompileLatex() " {{{
  let l:tfname = expand("%")
  let l:tdname = expand("%:h")
  let l:tcmd = 'pdflatex -output-directory=' . l:tdname . '/ ' . l:tfname
  call job_start(["/bin/bash", "-c", l:tcmd])
endfu " }}}

