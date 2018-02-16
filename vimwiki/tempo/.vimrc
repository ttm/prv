version 6.0
if &cp | set nocp | endif
tnoremap  
nnoremap  
let s:cpo_save=&cpo
set cpo&vim
tnoremap <NL> <NL>
nnoremap <NL> <NL>
tnoremap  
nnoremap  
tnoremap  
nnoremap  
noremap g :w:source %
noremap S :w:source $MYVIMRC
noremap s :w:source $MYVIMRC:runtime! plugin/**/*.vim
noremap p :runtime! plugin/**/*.vim
noremap q :q
noremap w :w
tnoremap d :tabn
tnoremap a :tabp
nnoremap d gt
nnoremap a gT
nnoremap h 
nnoremap l 
nnoremap k 
nnoremap j <NL>
noremap R :colo gruvbox
noremap r :colo blue
noremap g2 :call GetColors(2)
noremap g1 :call GetColors(1)
noremap g0 :call GetColors(0)
noremap gg :call GetColors(0)
noremap g :call GetColors(0)
noremap a :call GetAll()
noremap b :call MkBlack()
noremap w3 :call MakeColorsWindow(3)
noremap w2 :call MakeColorsWindow(2)
noremap w1 :call MakeColorsWindow(1)
noremap w0 :call MakeColorsWindow(0)
noremap ww :call MakeColorsWindow(3)
noremap w :call MakeColorsWindow(3)
noremap W :call StandardColorsOrig()
noremap s :echo SynStack()
noremap c :call ChgColor()
noremap i :call InitializeColors()
noremap I :w:runtime **/*.vim:call InitializeColors()
nnoremap   za
vnoremap . :norm .
nmap <silent> \w\y <Plug>VimwikiMakeYesterdayDiaryNote
nmap <silent> \w\t <Plug>VimwikiTabMakeDiaryNote
nmap <silent> \w\w <Plug>VimwikiMakeDiaryNote
nmap <silent> \w\i <Plug>VimwikiDiaryGenerateLinks
nmap <silent> \wi <Plug>VimwikiDiaryIndex
nmap <silent> \ws <Plug>VimwikiUISelect
nmap <silent> \wt <Plug>VimwikiTabIndex
nmap <silent> \ww <Plug>VimwikiIndex
map \wf mX:sp ~/.vim/plugin/prv/fortunes.txtggd/^--/Gp:wq'XGAp`X
nnoremap \Cb :call VCB_MainChatLoop()
map \hlt <Plug>HiLinkTrace
nnoremap \\W :match none
nnoremap \\w :match Error /\v[ ]+$/
nnoremap \\T :call ToggleTabLine()
nnoremap \\t :args /home/r/repos/tokipona/**/*.py
nnoremap \\S :tabe $MYVIMRC
nnoremap \\s :e $MYVIMRC
nnoremap \\p :setlocal spell!
nnoremap \\l :set invhlsearch | set hlsearch?
nnoremap \\k :se keymap=accents
nnoremap \\i :call ShowImg()
nnoremap \\h :call Help()
nnoremap \\g :call ChangeBackground()
nnoremap \\B :call ToggleStatusbar()
nnoremap \\b :execute 'rightbelow vs ' . bufname('#')
nnoremap \\c :set cursorline! cursorcolumn!
nnoremap \\' :s/"/'/g
nnoremap \wT :vs ~/vimwiki/todo.wiki
nnoremap \wA :vs ~/vimwiki/achievements.wiki
nnoremap \X :execute getline('.')
nnoremap \x :execute getline('.')
nnoremap \W :w
nnoremap \T :r !date +\%d/\%h/\%y,\ \%H:\%\M:\%S
nnoremap \t :vs.T
nnoremap \S :w:let g:mmapclear=1:mapclear :source $MYVIMRC
nnoremap \s :w:source $MYVIMRC
nnoremap \r ?^\nV/^\n:py3 exec(vim.eval("@*"))/Wf'lvt'y:!aplay "
nnoremap \q :q
nnoremap \P :vs /home/renato/vimwiki/blergh.wiki
nnoremap \p :reg
nnoremap \N :set relativenumber!
nnoremap \n :set number!
nnoremap \L :set list!
nnoremap \l :ls:b 
nnoremap \k :s/,/, /g
nnoremap \J :jumps
nnoremap \j :s/=/ = /g
nnoremap \I :call InsertBeforeAfter()
nnoremap \i :exec "normal i".nr2char(getchar())."\e"
nnoremap \G :echo "BANANA"
nnoremap \g :source %
nnoremap \F :term ++hidden ++open pdflatex %
nnoremap \f :set hlsearch!
nnoremap \E :call InsertSession()
nnoremap \e :call LoadSession()
nnoremap \D :call SaveNewSession()
nnoremap \d :call SaveSession()
nnoremap \C :call ListSessions()
nnoremap \c :
nnoremap \B :Sex
nnoremap \b :SexT
nnoremap \A :call InsertAfterAfter()
nnoremap \a :exec "normal li".nr2char(getchar())."\e"
vnoremap \' `>a'`<i'
vnoremap \" `>a"`<i"
nnoremap \" ea"hbi"lel
nnoremap \\L :call ToggleVerbose()
nnoremap \h :call ViewHtmlText(@+)
vnoremap \h y:call ViewHtmlText(@@)
nnoremap \H :update|call ViewHtmlText(expand('%:p'))
nnoremap \R :call PythonShowRun()
nnoremap \z :call ExtremeFolding()
vnoremap _g y:exe "grep /" . escape(@", '\\/') . "/ *.py"
vmap gx <Plug>NetrwBrowseXVis
nmap gx <Plug>NetrwBrowseX
onoremap iN{ :normal! F}vi{
onoremap in{ :normal! f{vi{
onoremap iN[ :normal! F]vi[
onoremap in[ :normal! f[vi[
onoremap iN( :normal! F)vi(
onoremap in( :normal! f(vi(
vnoremap <silent> <Plug>NetrwBrowseXVis :call netrw#BrowseXVis()
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())
inoremap  viW~i
inoremap  :startinsert
inoremap <NL> <NL>:startinsert
inoremap  :startinsert
inoremap  :startinsert
cnoremap d :tabnl:
cnoremap a :tabpl:
inoremap d :tabnl:startinsert
inoremap a :tabpl:startinsert
inoremap  :up
inoremap s 
iabbr pmain if __name__ == "__main__":
iabbr pimp_ import percolation as Pimport social as Simport participation as Paimport gmane as Gimport music as Mimport visuals as V
iabbr pimp from percolation.rdf import NS, po, a, cimport percolation as P
iabbr rsignature -- Renato Fabbri
iabbr rwebsite http://openlinkedsocialdata.github.io
iabbr remail renato.fabbri@gmail.com
iabbr efd def
iabbr edf def
iabbr clss class
iabbr clas class
iabbr clssa class
let &cpo=s:cpo_save
unlet s:cpo_save
set autoindent
set backspace=2
set cryptmethod=blowfish2
set digraph
set expandtab
set fileencodings=ucs-bom,utf-8,default,latin1
set helplang=en
set history=10000
set hlsearch
set incsearch
set laststatus=0
set listchars=tab:>-,trail:.,extends:#,nbsp:*,eol:$
set mouse=a
set pyxversion=3
set runtimepath=~/.vim,~/.vim/pack/plugins/start/vimwiki,~/.vim/bundle/gruvbox,/usr/local/share/vim/vimfiles,/usr/local/share/vim/vim80,/usr/local/share/vim/vimfiles/after,~/.vim/after
set scrolloff=3
set sessionoptions=blank,buffers,curdir,folds,help,options,tabpages,winsize,globals
set shiftwidth=2
set showcmd
set softtabstop=2
set spelllang=en_us
set statusline=%-5.3n\ %f\ %h%m%r%w[%{strlen(&ft)?&ft:'none'}]%=0x%-8B%-14(%l/%L,%P,%c%V%)
set tabstop=2
set termguicolors
set textwidth=70
set undodir=~/.vim/undo
set undofile
set verbose=2
set verbosefile=~/.vim/verbose.log
set viminfo=%,!,'1000,:1000,n~/.vim/viminfo
set virtualedit=all
set visualbell
set wildignore=*.swp,*.bak,*.pyc,*.class
set wildmenu
" vim: set ft=vim :
