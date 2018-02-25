" nn : q:i
" nn q: :
nn <leader>z :cal ExtremeFolding()<CR>
nn <leader>R :cal PythonShowRun()<CR>

" Save and view text for current html file.
nn <Leader>H :update<Bar>cal ViewHtmlText(expand('%:p'))<CR>
" View text for visually selected url.
vn <Leader>h y:cal ViewHtmlText(@@)<CR>
nn <Leader>h :cal ViewHtmlText(@+)<CR>

nn <localleader>L :cal ToggleVerbose()<CR>

" Alt mappings ---------------------- {{{ ttm:alt-map
" Alt is a "command leader" for me
" Maybe change it to space
" and make folding with space space
nn A :Ai<CR>
nn a gT
ino a <ESC><C-W>:tabp<CR>l<C-W>:startinsert<CR>
cno a <ESC><C-W>:tabp<CR>l<c-w>:
tno a <C-W>:tabp<CR>

" see :h aaplug or :h aa-mappings or :h aa

nn b :exe 'Le ' . expand("%:h")<CR>:let t:prv_browserid = win_getid()<CR>25<C-W>\|
nn B :if exists("t:prv_browserid")ec 'a abanna'let t:prv_tempwinid = win_getid()cal win_gotoid(t:prv_browserid):q!if t:prv_tempwinid != t:prv_browseridcal win_gotoid(t:prv_tempwinid)enunl t:prv_browseridunl t:prv_tempwinidendif

" should put fold markers as comments, for now just VimL
noremap c mf?^fuA " {{{/^endfA " }}}`f 
ino c <ESC>?^fuA " {{{/^endfuA " }}}`fa
" for gigraphs
ino C <ESC>a
ino Ck k<BS>I

" nn d gT
" ino d <ESC><C-W>:tabp<CR>l<C-W>:startinsert<CR>
" cno d <ESC><C-W>:tabp<CR>l<c-w>:
" tno d <C-W>:tabp<CR>

nn d gt
tno d <C-W>:tabn<CR>
ino d <ESC><C->:tabn<CR>l<C-W>:startinsert<CR>
cno d <ESC><C-W>:tabn<CR>l<c-w>:
ino Dk k<BS>I

nmap <silent> D :set opfunc=PRVPutCharAround<CR>g@
vmap <silent> D :<C-U>call PRVPutCharAround(visualmode(), 1)<CR>

nn e :e<CR>
ino e <ESC>:e<CR>a
nn E <C-L>
ino E <ESC><C-L>:e<CR>a

" should run functions, for now just VimL
nn f mf?^fu<CR>V/^endf<CR>:@*<CR>`f
ino f <ESC>mf?^fu<CR>V/^endf<CR>:@*<CR>`fa

" find files
nn FF :Split echo globpath('/home/renato/repos/', "**/rdf*")
nn Ff :Split echo globpath(&rtp, "**/*")<Left><Left><Left>
" nn Ff :Split echo globpath(&rtp, '"**/' . expand("<cword>") . "*")
nn Fa :Split echo globpath(&rtp, "**/ttm*")<CR>
nn FA :Split echo globpath(&rtp, "**/pack/**")<CR>

nn Fs :lv /RegisterNote/ ~/.vim/pack/ttm/**
nn Fg :lv /\v/ ~/.vim/**<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

nn g :up<CR>:source %<CR>
ino g <ESC>:up<CR>:source %<CR>

nn h <C-W><C-H>
nn j <C-W><C-J>
nn k <C-W><C-K>
nn l <C-W><C-L>
ino h <ESC><C-W><C-H>a
ino j <ESC><C-W><C-J>a
ino l <ESC><C-W><C-L>a
tno h <ESC><C-W><C-H>
tno j <ESC><C-W><C-J>
tno k <ESC><C-W><C-K>
tno l <ESC><C-W><C-L>
cno h <ESC><C-W><C-H>:
cno j <ESC><C-W><C-J>:
cno k <ESC><C-W><C-K>:
cno l <ESC><C-W><C-L>:

nn L :cal CompileLatex()<CR>

ino o <ESC>

" put char around word and WORD
nn q :q<CR>
ino q <ESC>:q<CR>a

" Notes mappings
" nn N 
" ino N 
" cno N 
" tno N 

nn p :runtime! plugin/**/*.vim<CR>
ino p <ESC>:runtime! plugin/**/*.vim<CR>a
nn P :cal OpenPDF()<CR>

" should run the line or the selection, for now just VimL
nn r Y:@"<CR>
ino r <ESC>Y:@"<CR>a

nn s :up<CR>:source $MYVIMRC<CR>:runtime! plugin/**/*.vim<CR>
ino s <ESC>:up<CR>:source %<CR>a
nn S :up<CR>:source $MYVIMRC<CR>
ino S <ESC>:up<CR>:source %<CR>l

nn U :cal PushPRV("Auto updating PRV")

nn x :up<CR>
ino x <ESC>:up<CR>
ino 3 <ESC>:up<CR>
ino [ <ESC>:up<CR>

nn W :w<CR>
ino W <ESC>:w<CR>a
nn w :up<CR>
ino w <ESC>:up<CR>a
" substitue all these mappings by one e+surroundings.
" E might be previous words, or WORD. TTM
nn " ea"<ESC>hbi"<ESC>lel
nn ' ea'<ESC>hbi'<ESC>lel
ino " <ESC>hhea"<ESC>hbi"<ESC>lelli
ino ' <ESC>hhea'<ESC>hbi'<ESC>lelli
cno " ea"<ESC>hbi"<ESC>lel<CR>
cno ' ea'<ESC>hbi'<ESC>lel<CR>
tno " ea"<ESC>hbi"<ESC>lel<CR>
tno ' ea'<ESC>hbi'<ESC>lel<CR>
" }}}
" space mappings ---------------------- {{{
" normal mode mappings
" (migrate leader mappings to here)
nn <Space>a :exec "normal li".nr2char(getchar())."\e"<CR>
nn <Space>A  :cal InsertAfterAfter()<CR>
nn <Space>f  :cal system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>
" -- for exceptional commands {{{2
nn <Space>ea :exec "e " . split(&runtimepath,',')[0] . "/after/plugin/ttmmappings.vim"<CR>/\v[^\]\^]ttm:alt-map\|^ttm:alt-map<CR>
nn <Space>eA :exec "e " . split(globpath(&rtp, "plugin/ttmmappings.vim"), "\n")[0]<CR>:lvim $\v[^\]\^]ttm:alt-map\|^ttm:alt-map$ ~/.vim/**
nn <Space>eb :Split ec getbufinfo()
nn <Space>ec :cal CircleChar('foo')<CR>
nn <Space>eC :cal CircleChar('W')<CR>
" nn <Space>eC 
nn <Space>e<Space>c :put ='\" '.string(keys(ccs))<CR>:put ='cal ApplyCS(g:ccs[\"green1\"],\"color\")'<CR>
nn <Space>ee :exec "e " . split(globpath(&rtp, "plugin/ttmmappings.vim"), "\n")[0]<CR>/ttm:exc-com<CR>
nn <Space>e<Space>F :sf **/aa|    " press tab after
" nn <Space>ea :exec "e " . split(globpath(&rtp, "plugin/ttmmappings.vim*"), "\n")[0]<CR>:lvim $\v[^\]]ttm:alt-map$ ~/.vim/**<CR>
nn <Space>ei :help aa<CR>
nn <Space>eI :help aa<CR>`t

nn <Space>ef :exec "e " . split(&runtimepath,',')[0] . "/after/plugin/ttmfstartup.vim"<CR>G
nn <Space>e<Space>f :Split filter // oldfiles<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
nn <Space>e<Space>f :Split filter // oldfiles<S-Left><S-Left><Right>
nn <Space>eF GoCopyright: Public Domain.  vim:modifiable:noreadonly:tw=0:ts=8:ft=help.vimwiki:suffixesadd+=.txt:norl:softtabstop=4:shiftwidth=4:textwidth=0:expandtab:<ESC><C-O>

nn <Space>et :tselect /aa<CR>
nn <Space>eT :tselect /

" how to do this TTM |aa-todo|
" nn <Space>eh :map \\<Space><CR>


nn <Space>ep :Split exec "normal \<C-G>"<CR>xf"Dh

" leader mappings ---------------------- {{{1
" should be removed in order to avoid conflict with plugins
nn <leader>b :Sex<CR><C-W>T
nn <leader>B :Sex<CR>

nn <leader>C :cal ListSessions()<CR>
" nn <leader>d :args ~/repos/percolation/**/*.py<CR>
nn <leader>d :cal SaveSession()<CR>
nn <leader>D :cal SaveNewSession()<CR>
" assert latest is saved as a user practice
nn <leader>e :cal LoadSession()<CR>
nn <leader>E :cal InsertSession()<CR>

" make the f mappings usable by using the paths correctly
nn <leader>f :term ++hidden ++close pdflatex %
nn <leader>F :term ++hidden ++open pdflatex %
nn <leader>i :exec "normal i".nr2char(getchar())."\e"<CR>
nn <leader>I :cal InsertBeforeAfter()<CR>

nn <leader>j :s/=/ = /g<CR>
nn <leader>J :jumps<CR>
nn <leader>k :s/,/, /g<CR>
nn <leader>l :ls<CR>:b 
nn <leader>L :set list!<CR>
" :bn to choose file n
nn <leader>n :set number!<CR>
nn <leader>N :set relativenumber!<CR>
nn <leader>p :reg<CR>

nn <leader>q :q<CR>
" next command is only to remember how to do stuff
nn <leader>r ?^\n<CR>V/^\n<CR>:py3 exec(vim.eval("@*"))<CR>/W<CR>f'lvt'y:!aplay <C-R>"
nn <leader>s :up<CR>:source $MYVIMRC<CR>
nn <leader>S :up<CR>:let g:mmapclear=1<CR>:mapclear<CR> :source $MYVIMRC<CR>
nn <leader>t :vs.<CR><C-W>T
nn <leader>T :r !date +\%d/\%h/\%y,\ \%H:\%\M:\%S<CR>
nn <leader>W :up<CR>
nn <leader>x :execute getline('.')<CR>
nn <leader>X :execute getline('.')

" Vimwiki
cal VWFileNMapping("<leader>wA", "achievements.wiki")
cal VWFileNMapping("<leader>wT", "todo.wiki")
cal VWFileNMapping("<leader>wD", "daily/tasks.wiki")
cal VWFileNMapping("<leader>wW", "weekly/wtasks.wiki")
cal VWFileNMapping("<leader>wN", "blergh.wiki<CR>gg")

" }}}
" localleader mappings ---------------------- {{{1
nn <localleader>' :s/"/'/g<CR>
nn <localleader>c :set cursorline! cursorcolumn!<CR>
nn <localleader>b :execute 'rightbelow vs ' . bufname('#')<CR>
nn <localleader>B :cal ToggleStatusbar()<CR>
nn <localleader>g :cal ChangeBackground()<CR>
" nn <localleader>h :tabe<CR>:h 
nn <localleader>i :cal ShowImg()<CR>
" keymap=
nn <localleader>k :se keymap=accents<CR>
nn <localleader>l :set invhlsearch \| set hlsearch?<CR>
"-> nn <localleader>L <CR>
nn <localleader>p :setlocal spell!<CR>
nn <localleader>s :e $MYVIMRC<CR>
nn <localleader>S :tabe $MYVIMRC<CR>
nn <localleader>t :args /home/r/repos/tokipona/**/*.py<CR>
nn <localleader>T :cal ToggleTabLine()<CR>
nn <localleader>w :match Error /\v[ ]+$/<CR>
nn <localleader>W :match none<CR>
" }}}
" command line commands {{{1
cno <C-J> <S-Left>
cno <C-K> <S-Right>

" }}}

