" nnoremap : q:i
" nnoremap q: :
nnoremap <leader>z :call ExtremeFolding()<CR>
nnoremap <leader>R :call PythonShowRun()<CR>

" Save and view text for current html file.
nnoremap <Leader>H :update<Bar>call ViewHtmlText(expand('%:p'))<CR>
" View text for visually selected url.
vnoremap <Leader>h y:call ViewHtmlText(@@)<CR>
nnoremap <Leader>h :call ViewHtmlText(@+)<CR>

nnoremap <localleader>L :call ToggleVerbose()<CR>

" Alt mappings ---------------------- {{{ ttm:alt-map
" Alt is a "command leader" for me
" Maybe change it to space
" and make folding with space space
nnoremap A :Ai<CR>
nnoremap a gT
inoremap a <ESC><C-W>:tabp<CR>l<C-W>:startinsert<CR>
cnoremap a <ESC><C-W>:tabp<CR>l<c-w>:
tnoremap a <C-W>:tabp<CR>

" see :h aaplug or :h aa-mappings or :h aa

nnoremap b :exec '15Le ' . expand("%:h")<CR>:let t:exp_set_ttm = 1<CR>
nnoremap B :if exists("t:exp_set_ttm")<CR>exec "normal 9\<C-W>h:q"<CR>unlet! t:exp_set_ttm<CR>endif
nnoremap B :if exists("t:exp_set_ttm")<CR>unlet! t:exp_set_ttm<CR>endif

" should put fold markers as comments, for now just VimL
noremap c mf?^fuA " {{{/^endfA " }}}`f 
inoremap c <ESC>?^fuA " {{{/^endfuA " }}}`fa
" for gigraphs
inoremap C <ESC>a
inoremap Ck k<BS>I

" nnoremap d gT
" inoremap d <ESC><C-W>:tabp<CR>l<C-W>:startinsert<CR>
" cnoremap d <ESC><C-W>:tabp<CR>l<c-w>:
" tnoremap d <C-W>:tabp<CR>

nnoremap d gt
tnoremap d <C-W>:tabn<CR>
inoremap d <ESC><C-W>:tabn<CR>l<C-W>:startinsert<CR>
cnoremap d <ESC><C-W>:tabn<CR>l<c-w>:
inoremap Dk k<BS>I

nnoremap e :e<CR>
inoremap e <ESC>:e<CR>a
nnoremap E <C-L>
inoremap E <ESC><C-L>:e<CR>a

" should run functions, for now just VimL
nnoremap f mf?^fu<CR>V/^endf<CR>:@*<CR>`f
inoremap f <ESC>mf?^fu<CR>V/^endf<CR>:@*<CR>`fa

" find files
nnoremap FF :Split echo globpath('/home/renato/repos/', "**/rdf*")
nnoremap Ff :Split echo globpath(&rtp, "**/*")<Left><Left><Left>
" nnoremap Ff :Split echo globpath(&rtp, '"**/' . expand("<cword>") . "*")
nnoremap Fa :Split echo globpath(&rtp, "**/ttm*")<CR>
nnoremap FA :Split echo globpath(&rtp, "**/pack/**")<CR>

nnoremap Fs :lvim /RegisterNote/ ~/.vim/pack/ttm/**
nnoremap Fg :lvim /\v/ ~/.vim/**<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

nnoremap g :up<CR>:source %<CR>
inoremap g <ESC>:up<CR>:source %<CR>

nnoremap h <C-W><C-H>
nnoremap j <C-W><C-J>
nnoremap k <C-W><C-K>
nnoremap l <C-W><C-L>
inoremap h <ESC><C-W><C-H>a
inoremap j <ESC><C-W><C-J>a
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

" put char around word and WORD
nnoremap q :q<CR>
inoremap q <ESC>:q<CR>a

" Notes mappings
" nnoremap N 
" inoremap N 
" cnoremap N 
" tnoremap N 

nnoremap p :runtime! plugin/**/*.vim<CR>
inoremap p <ESC>:runtime! plugin/**/*.vim<CR>a
nnoremap P :call OpenPDF()<CR>

" should run the line or the selection, for now just VimL
nnoremap r Y:@"<CR>
inoremap r <ESC>Y:@"<CR>a

nnoremap s :up<CR>:source $MYVIMRC<CR>:runtime! plugin/**/*.vim<CR>
inoremap s <ESC>:up<CR>:source %<CR>a
nnoremap S :up<CR>:source $MYVIMRC<CR>
inoremap S <ESC>:up<CR>:source %<CR>l

nnoremap U :call PushPRV("Auto updating PRV")

nnoremap x :up<CR>
inoremap x <ESC>:up<CR>
inoremap 3 <ESC>:up<CR>
inoremap [ <ESC>:up<CR>

nnoremap W :w<CR>
inoremap W <ESC>:w<CR>a
nnoremap w :up<CR>
inoremap w <ESC>:up<CR>a
" substitue all these mappings by one e+surroundings.
" E might be previous words, or WORD. TTM
nnoremap " ea"<ESC>hbi"<ESC>lel
nnoremap ' ea'<ESC>hbi'<ESC>lel
inoremap " <ESC>hhea"<ESC>hbi"<ESC>lelli
inoremap ' <ESC>hhea'<ESC>hbi'<ESC>lelli
cnoremap " ea"<ESC>hbi"<ESC>lel<CR>
cnoremap ' ea'<ESC>hbi'<ESC>lel<CR>
tnoremap " ea"<ESC>hbi"<ESC>lel<CR>
tnoremap ' ea'<ESC>hbi'<ESC>lel<CR>
" }}}
" space mappings ---------------------- {{{
" normal mode mappings
" (migrate leader mappings to here)
nnoremap <Space>a :exec "normal li".nr2char(getchar())."\e"<CR>
nnoremap <Space>A  :call InsertAfterAfter()<CR>
" -- for exceptional commands {{{2
nnoremap <Space>ea :exec "e " . split(&runtimepath,',')[0] . "/after/plugin/ttmmappings.vim"<CR>/\v[^\]\^]ttm:alt-map\|^ttm:alt-map<CR>
nnoremap <Space>eA :exec "e " . split(globpath(&rtp, "plugin/ttmmappings.vim"), "\n")[0]<CR>:lvim $\v[^\]\^]ttm:alt-map\|^ttm:alt-map$ ~/.vim/**
nnoremap <Space>eb :Split ec getbufinfo()
nnoremap <Space>ec :cal CircleChar('foo')<CR>
nnoremap <Space>eC :cal CircleChar('W')<CR>
" nnoremap <Space>eC 
nnoremap <Space>e<Space>c :put ='\" '.string(keys(ccs))<CR>:put ='cal ApplyCS(g:ccs[\"green1\"],\"color\")'<CR>
nnoremap <Space>ee :exec "e " . split(globpath(&rtp, "plugin/ttmmappings.vim"), "\n")[0]<CR>/ttm:exc-com<CR>
nnoremap <Space>e<Space>F :sf **/aa|    " press tab after
" nnoremap <Space>ea :exec "e " . split(globpath(&rtp, "plugin/ttmmappings.vim*"), "\n")[0]<CR>:lvim $\v[^\]]ttm:alt-map$ ~/.vim/**<CR>
nnoremap <Space>ei :help aa<CR>
nnoremap <Space>eI :help aa<CR>`t

nnoremap <Space>ef :exec "e " . split(&runtimepath,',')[0] . "/after/plugin/ttmfstartup.vim"<CR>G
nnoremap <Space>e<Space>f :Split filter // oldfiles<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
nnoremap <Space>e<Space>f :Split filter // oldfiles<S-Left><S-Left><Right>
nnoremap <Space>eF GoCopyright: Public Domain.  vim:modifiable:noreadonly:tw=0:ts=8:ft=help.vimwiki:suffixesadd+=.txt:norl:softtabstop=4:shiftwidth=4:textwidth=0:expandtab:<ESC><C-O>

nnoremap <Space>et :tselect /aa<CR>
nnoremap <Space>eT :tselect /

" how to do this TTM |aa-todo|
" nnoremap <Space>eh :map \\<Space><CR>


nnoremap <Space>ep :Split exec "normal \<C-G>"<CR>xf"Dh

" leader mappings ---------------------- {{{1
" should be removed in order to avoid conflict with plugins
nnoremap <leader>b :Sex<CR><C-W>T
nnoremap <leader>B :Sex<CR>

nnoremap <leader>C :call ListSessions()<CR>
" nnoremap <leader>d :args ~/repos/percolation/**/*.py<CR>
nnoremap <leader>d :call SaveSession()<CR>
nnoremap <leader>D :call SaveNewSession()<CR>
" assert latest is saved as a user practice
nnoremap <leader>e :call LoadSession()<CR>
nnoremap <leader>E :call InsertSession()<CR>

" make the f mappings usable by using the paths correctly
nnoremap <leader>f :term ++hidden ++close pdflatex %
nnoremap <leader>F :term ++hidden ++open pdflatex %
nnoremap <leader>i :exec "normal i".nr2char(getchar())."\e"<CR>
nnoremap <leader>I :call InsertBeforeAfter()<CR>

nnoremap <leader>j :s/=/ = /g<CR>
nnoremap <leader>J :jumps<CR>
nnoremap <leader>k :s/,/, /g<CR>
nnoremap <leader>l :ls<CR>:b 
nnoremap <leader>L :set list!<CR>
" :bn to choose file n
nnoremap <leader>n :set number!<CR>
nnoremap <leader>N :set relativenumber!<CR>
nnoremap <leader>p :reg<CR>

nnoremap <leader>q :q<CR>
" next command is only to remember how to do stuff
nnoremap <leader>r ?^\n<CR>V/^\n<CR>:py3 exec(vim.eval("@*"))<CR>/W<CR>f'lvt'y:!aplay <C-R>"
nnoremap <leader>s :up<CR>:source $MYVIMRC<CR>
nnoremap <leader>S :up<CR>:let g:mmapclear=1<CR>:mapclear<CR> :source $MYVIMRC<CR>
nnoremap <leader>t :vs.<CR><C-W>T
nnoremap <leader>T :r !date +\%d/\%h/\%y,\ \%H:\%\M:\%S<CR>
nnoremap <leader>W :up<CR>
nnoremap <leader>x :execute getline('.')<CR>
nnoremap <leader>X :execute getline('.')

" Vimwiki
call VWFileNMapping("<leader>wA", "achievements.wiki")
call VWFileNMapping("<leader>wT", "todo.wiki")
call VWFileNMapping("<leader>wD", "daily/tasks.wiki")
call VWFileNMapping("<leader>wW", "weekly/wtasks.wiki")
call VWFileNMapping("<leader>wN", "blergh.wiki<CR>gg")

" }}}
" localleader mappings ---------------------- {{{1
nnoremap <localleader>' :s/"/'/g<CR>
nnoremap <localleader>c :set cursorline! cursorcolumn!<CR>
nnoremap <localleader>b :execute 'rightbelow vs ' . bufname('#')<CR>
nnoremap <localleader>B :call ToggleStatusbar()<CR>
nnoremap <localleader>g :call ChangeBackground()<CR>
" nnoremap <localleader>h :tabe<CR>:h 
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
" }}}
" command line commands {{{1
cnoremap <C-J> <S-Left>
cnoremap <C-K> <S-Right>

" }}}

