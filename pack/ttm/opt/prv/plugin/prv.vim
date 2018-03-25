" main file of the prv plugin for Vim {{{1
" Author: Renato Fabbri
" Date: 2018/Feb/25 (when I wrote this header)
" Copyright: Public domain
" Acknowledgments:
" vim_use email list (discussion forum)
" Cristina Ferreira de Oliveira (PhD, VICG/ICMC/USP),
" FAPESP (project 2017/05838-3)
" Ricardo Fabbri (PhD, IPRJ/UERJ)

" Load Once: {{{1
if exists("g:loaded_prvplugin") && (exists("g:prv_not_hacking") || exists("g:prv_not_hacking_all"))
 finish
endif
let g:loaded_prvplugin = "v0.01b"
let g:prv_dir = expand("<sfile>:p:h:h") . '/'
" {{{1 settings

fu! PRVInit() " {{{
" {{{2 variables
  cal PRVDefineSettings()
  cal PRVSetWiki()
" {{{2 mappings
  cal PRVDeclareLeader('prv')
  cal PRVMkMappings('ndlLa')
  cal PRVRestoreLeader('prv')
endf " }}}

" {{{1 commands
com! -nargs=+ -complete=command PRVRedir call PRVRedirMessage(<f-args>)
com! PRVbuf setlocal buftype=nofile noswapfile bufhidden=wipe nobuflisted ft=python
com! -nargs=+ PRVLeader cal PRVLeaderHelper(<f-args>)

" {{{1 functions
" for plugin-specific leader and localleader {{{2
fu! PRVLeaderHelper(...)
  if a:1 == 'd'
    cal PRVDeclareLeader(a:2)
  elsei a:1 == 'r'
    cal PRVRestoreLeader(a:2)
  en
  let g:asd = a:
endf
fu! PRVDeclareLeader(plug)
  cal assert_equal(type(a:plug), 1, 'only strings are accepted as arg to PRVDeclareLeader(plug)')
  let g:prv.leaders[a:plug] = [g:mapleader, g:maplocalleader]
  " exe 'let g:'.a:plug.'_keepleaders = [g:mapleader, g:maplocalleader]'
  if has_key(g:prvset.leaders, a:plug)
    let g:mapleader = g:prvset.leaders[a:plug][0]
    let g:maplocalleader = g:prvset.leaders[a:plug][1]
  en
endf
fu! PRVRestoreLeader(plug)
  let [g:mapleader, g:maplocalleader] = g:prv.leaders[a:plug]
endf

" insert one char {{{2
" TTM ensure working fine
fu! PRVInsertBeforeAfter(...)
  let a = nr2char(getchar())
  if len(a:000) == 0
    exe "norm i".a."\elli".a."\e"
  el
    exe "norm a".a."\ela".a."\e"
  en
endf
fu! PRVCircleChar(...)
  echo 'enter char to be input: '
  let a = nr2char(getchar())
  if len(a:000) > 0
    if a:1 == 'W'
      let w = 'W'
      let cmd = "norm vi".w."di".a."\<C-R>\"".a
    elsei a:1 == 'a'
      let w = input('enter your text item or movement command (e.g. a", i]): ')
      let cmd = "norm v".w."di".a."\<C-R>\"".a
    en
  el
    let w = 'w'
    let cmd = "norm vi".w."di".a."\<C-R>\"".a
  en
  if getline('.')[col('.')-2] == ' '
    norm h
  en
  exe cmd
  norm l
endf

fu! PRVMoveToWindow(to)
  ec a:to
  ec mode()
PRVMoveToWindow('l')
endf
fu! PRVMoveToTab(to)
  ec a:to
endf
" sessions {{{2 test TTM
fu! PRVSession(act)
  if !isdirectory(g:prv.paths.sessions)
    cal mkdir(g:prv.paths.sessions, 'p')
  en
  " to keep global variables that star with Uppercase and have at least one
  " lower case letter (only string and number are stored), and local settings:
  let sop = &sessionoptions
  se sessionoptions+=globals,localoptions,
  if a:act == 'l' " list
    ec '== Sessions currently saved in ' g:prv.paths.sessions.':'
    ec system("ls ".g:prv.paths.sessions)."\n"
  elsei a:act == 's' " save
    if !exists('g:prv.session')
      PRVSession('sa')
    en
    exe 'mksession! ' . g:prv.paths.sessions . g:prv.sesѕion
  elsei a:act == 'sa' " save new
    cal PRVSession('l')
    let g:prv.session = input("Enter NEW (prv/vim) session name to SAVE: ")
    cal PRVSession('s')
  elsei a:act == 'lo' " load
    cal PRVSession('l')
    let resp = input("loading session makes you loose all windows and tabs, ok? [y/N]: ")
    if l:resp == 'y'
      let g:prv.session = input("Enter session name to load: ")
      on
      tabo
      exe 'so ' . g:prv.paths.sessions . g:prv.session
    en
  elsei a:act == 'i' " insert
    cal PRVSession('l')
    let g:prv.session = input("Enter session name to insert: ")
    tabe
    exe 'so ' . g:prv.paths.sessions . g:prv.session
  en
  let &sessionoptions = l:sop
endf

" visual functions {{{2
fu! ShowImg()
  exe "normal! viWy"
  sil exec '!eog -f ' getreg('0')
  exe 'colorscheme gruvbox'
endf

fu! PRVNtabs()
  sil PRVRedir v tabs
  redir => avar
  sil %s/^Tab p//gn
  redi END
  q
  let ntabs = split(l:avar, ' ')[0][1:]
  retu l:ntabs
endf
fu! PRVRedirMessage(...) " get output of command in window {{{2
  redi => avar
  sil exe join(a:000[1:])
  redi END
  if empty(avar)
    echoe "no output"
  el
    exe a:1 == 't' ? "tabe" : ( a:1 == 'v' ? "vne" : 'new' )
    PRVbuf
    pu = string(avar)
  en
  let g:asd = [l:, a:]
endf

" latex related {{{2
fu! OpenPDF()
  let l:tfname = expand("%:r") . '.pdf'
  let l:tcmd = 'evince ' . l:tfname
  if !filereadable(l:tfname)
    let @x = ':call add( g:pdfjobs, job_start(["/bin/bash", "-c", "' . l:tcmd . '" ]))'
    ec 'command to open PDF in @x register, PDF not found'
  el
    cal add( g:.prv.jobs, job_start(["/bin/bash", "-c", l:tcmd]))
  en
endf
fu! CompileLatex(...) " test TTM
  " TTM: handle jobs and terminal more appropriately.
  " Most importantly:
  "   1. a terminal window should only pop if there are errors (pdf not
  "   created)
  "   2. the lists of kobs and terminals should have a window of their status.
  "   3. they should be reused whenever possible
  "   4. a visual cue (one the command line or status or tabs bars) of their
  "   number and status.
  let mode = ((len(a:000) > 0 ) && a:1 == 'h' ) ? 'hide' : 'show'
  let tfname = expand("%")
  let tdname = expand("%:h")
  let tcmd = 'pdflatex -output-directory=' . l:tdname . '/ ' . l:tfname
  if mode == 'hide'
    " let ajob = job_start(["/bin/bash", "-c", l:tcmd])
    let ajob = job_start([l:tcmd])
    cal add(prv.jobs, ajob)
  el
    let aterm = term_start(tcmd, {'hidden': 1, 'term_finish': 'open',
          \'term_opencmd': "\<C-W>:ec 'finished compiling latex (or trying to). Command: '".tcmd})
    cal add(prv.terms, aterm)
  en
endf

fu! PRVViewHtmlText(url) " WWW navigation {{{2
  if !empty(a:url)
    new
    PRVBuf
    exe 'r !elinks ' . a:url . ' -dump -dump-width ' . winwidth(0)
    1d
  en
endf

fu! PRVToggleVerbose() " {{{2
  " TTM make mapping
  if !&verbose
    se verbosefile = g:prv_verbose_file
    se verbose = 15
    vs ~/.vim/aux/verbose.log
    setl autoread
  el
    se verbose = 0
    se verbosefile=
  en
endf

fu! PRVVWFileNMappingDEPRECATED(mapping, fpath) " mapping utilities {{{2
  let path = g:vimwiki_list[0].path.a:fpath
  let cmd = ' :vs '.l:path
  let cmd2 = 'nn '.a:mapping.l:cmd
  exe l:tcmd2
endf
let g:PRVVWFileNMapping = {keys, fpath -> execute('nn '.keys.' :vs '.g:prv.paths.vimwiki.fpath.'<CR>')}
fu! RotateRegisters() " registers {{{2
  " find where it is used and assert it is doing what is expected
  " also try to make similar mechanisms for other registers,
  " maybe use a dict of lists (one list for the history
  " of each type of register)
  let @h=@j
  let @j=@k
  let @k=@l
  let @l=@.
endf

fu! DecryptVimwiki() " encryption {{{2
  " encrypt all vimwiki messages
  " add -f vimwiki
  " commit -am '
  " decrypt all msgs
  let g:tcmd = 'vs ' . g:prv_dir . 'aux/vimwiki/'
  exe g:tcmd
  " normal /^" =====.*\n[^"]\<CR>
  sil g|=.*\n.[^ ]
  norm j
  let l:tlinen = line('.')
  let l:visdirs = 0
  let g:cmls = []
  let g:visited = []
  wh 1
    let tline = getline('.')
    ec l:tlinen tline
    if l:tline != "../" && l:tline != "./"
      ec 'not ..'
      let fname = expand("<cfile>:p")
      if index(g:visited, fname) >= 0
        " file or dir already visited..
        let l:alinen = line('.')
        norm j
        if l:alinen == line('.')
          norm -
          let g:visdirs -= 1
        el
          let l:tlinen = line('.')
          con
        en
      en
      sil exec "normal \<CR>"
      " silent exec "normal gf"
      if &ft == 'vimwiki'
        "ec 'found vimwiki'
        " call input('1 Press any key to continue')
        e
        " call input('3 Press any key to continue')
        setl key=
        " call input('4 Press any key to continue')
        exe "normal :w\<CR>"
        cal add(g:cmls, getcmdline())
        " cal input('5 Press any key to continue')
        " exe "normal :w!\<CR>\<C-^>"
        exe "normal \<C-^>"
        " cal input('6 Press any key to continue')
      elsei &ft != 'netrw'
        "ec 'found spurious'
        exe "normal \<C-^>"
      el
        "ec "entered a directory"
        sil g|=.*\n.[^ ]
        norm j
        let l:tlinen = line('.')
        con
      en
      cal add(g:visited, l:fname)
    el
      ec "yes .."
      "ec 'dir half count'
      let l:visdirs += 0.5
    en
    norm j
    if line('.') == l:tlinen
      if exists("l:entdict")
        let banana=6
      el
        "ec 'got to the same line. Up a dir'
        let stuck = 1
        wh stuck
          norm -
          let l:visdirs -= 1
          if l:visdirs < 0.9
            break
          en
          let l:alinen = line('.')
          norm j
          if l:alinen == line('.')
            " got up a dir to the bottom of the list
            " will loop again
          el
            let stuck = 0
          en
        endw
      en
    en
    let l:tlinen = line('.')
  endw
endf
fu! PythonShowRun() " python {{{2
  " Test TTM
  let pout = system("python3 " . bufname("%") . " 2>&1")
  new
  PRVbuf
  pu = pout
endf

fu! PRVMkVimball(plug, version) " Vimball {{{2
  " Load this function by visually selecting it, then
  " :@*
  " Then run it while in this buffer with:
  " :call PRVMkVimball(plug), where plug is 'prv', 'aa', 'rc', 'tp'
  " to create the vimball
  exe 'e ' g:prv.paths.plugin_files
  if a:plug =~# 'aa'
    exe '2,8MkVimball! aa'.a:version
    ec 'Vimball for the aa plugin has been written at current directory'
  en
  if a:plug =~# 'prv'
    exe '12,23MkVimball! prv'.a:version
    echo 'Vimball for the prv plugin has been written at current directory'
  en
  if a:plug =~# 'rc'
    exe '2,8MkVimball! realcolors'.a:version
    echo 'Vimball for the realcolors plugin has been written at current directory'
  en
  if a:plug =~# 'tp'
    exe '2,8MkVimball! tokipona'.a:version
    echo 'Vimball for the tokipona plugin has been written at current directory'
  en
  normal <C-^>
endf

fu! PRVTerminalMove(direction)
    exe "normal \<C-W>".a:direction
    if exists('g:prv.isinsert')
      if mode() == 'n'
        unl g:prv.isinsert
        normal l
        startinsert
        ec input(mode())
      en
    en
    " tno <C-L> <C-W><C-L><C-W>:exe exists('g:prv.isinsert') ? 'startinsert' : ''<CR><C-O>:exe mode()=='t' ? '' : (exists('g:prv.isinsert') ? 'unl g:prv.isinsert' : '')<CR>
endf

" {{{2 init funcs (init, restart, unload all vars/mappings/commands etc etc)
fu! PRVMkMappings(str) " {{{3
  " str might have the sequences d,n,
  if a:str =~# 'n' " {{{4 mappings in navigation with default keys (C-W navigation)
    " window navigation {{{5
    " normal mode
    nn <C-H> <C-W><C-H>
    nn <C-J> <C-W><C-J>
    nn <C-K> <C-W><C-K>
    nn <C-L> <C-W><C-L>
    " insert mode
    ino <silent> <C-H> <C-[><C-W><C-H><C-W>:exe mode()=='t' ? 'let g:prv.isinsert = 1' : "normal l"<CR><C-W>:star<CR>
    ino <silent> <C-J> <C-[><C-W><C-J><C-W>:exe mode()=='t' ? 'let g:prv.isinsert = 1' : "normal l"<CR><C-W>:star<CR>
    ino <silent> <C-K> <C-[><C-W><C-K><C-W>:exe mode()=='t' ? 'let g:prv.isinsert = 1' : "normal l"<CR><C-W>:star<CR>
    ino <silent> <C-L> <C-[><C-W><C-L><C-W>:exe mode()=='t' ? 'let g:prv.isinsert = 1' : "normal l"<CR><C-W>:star<CR>
    " command-line mode
    cno <C-H> <C-E>'<C-B>let tempprv='<CR><C-W><C-H><C-W>:<C-R>=tempprv<CR>
    cno <C-J> <C-E>'<C-B>let tempprv='<CR><C-W><C-J><C-W>:<C-R>=tempprv<CR>
    cno <C-K> <C-E>'<C-B>let tempprv='<CR><C-W><C-K><C-W>:<C-R>=tempprv<CR>
    cno <C-L> <C-E>'<C-B>let tempprv='<CR><C-W><C-L><C-W>:<C-R>=tempprv<CR>
    " terminal-job mode
    " tno <C-H> <C-W><C-H><C-W>:exe exists('g:prv.isinsert') ? 'startinsert' : ''<CR><C-O>:exe mode()=='t' ? '' : (exists('g:prv.isinsert') ? 'unl g:prv.isinsert' : '')<CR>
    " tno <C-J> <C-W><C-J><C-W>:exe exists('g:prv.isinsert') ? 'startinsert' : ''<CR><C-O>:exe mode()=='t' ? '' : (exists('g:prv.isinsert') ? 'unl g:prv.isinsert' : '')<CR>
    " tno <C-K> <C-W><C-K><C-W>:exe exists('g:prv.isinsert') ? 'startinsert' : ''<CR><C-O>:exe mode()=='t' ? '' : (exists('g:prv.isinsert') ? 'unl g:prv.isinsert' : '')<CR>
    " tno <C-L> <C-W><C-L><C-W>:exe exists('g:prv.isinsert') ? 'startinsert' : ''<CR><C-O>:exe mode()=='t' ? '' : (exists('g:prv.isinsert') ? 'unl g:prv.isinsert' : '')<CR>
    tno <silent> <C-H> <C-W>:cal PRVTerminalMove('h')<CR>
    tno <silent> <C-J> <C-W>:cal PRVTerminalMove('j')<CR>
    tno <silent> <C-K> <C-W>:cal PRVTerminalMove('k')<CR>
    tno <silent> <C-L> <C-W>:cal PRVTerminalMove('l')<CR>
    " tab navigation {{{5
    " no <C-N> :PRVMoveToTab('T')
    " no <C-P> :PRVMoveToTab('t')
    " no! <C-N> PRVMoveToTab('T')
    " no! <C-P> PRVMoveToTab('t')
    " nn <C-J> <C-W><C-J>
    " nn <C-K> <C-W><C-K>
    " nn <C-L> <C-W><C-L>
    " nn <C-H> <C-W><C-H>
    " ino <C-H> PRVMoveToWindow('h', 'i')
    " ino <C-J> PRVMoveToWindow('j', 'i')
    " ino <C-K> PRVMoveToWindow('k', 'i')
    " ino <C-L> PRVMoveToWindow('l', 'i')
    " tno <C-J> <C-W><C-J>
    " tno <C-K> <C-W><C-K>
    " tno <C-L> <C-W><C-L>
    " tno <C-H> <C-W><C-H>
    " cno <C-J> <C-W><C-J>
    " cno <C-K> <C-W><C-K>
    " cno <C-L> <C-W><C-L>
    " cno <C-H> <C-W><C-H>
    " vn <C-J> <C-W><C-J>
    " vn <C-K> <C-W><C-K>
    " vn <C-L> <C-W><C-L>
    " vn <C-H> <C-W><C-H>
    " nn <C-J> <C-W><C-J>
    " nn <C-K> <C-W><C-K>
    " nn <C-L> <C-W><C-L>
    " nn <C-H> <C-W><C-H>
    " nn <C-N> gT
    " nn <C-P> gt
    " ino <C-J> PRVMoveToWindow('l')<ESC><C-W><C-J>a
    " ino <C-K> <ESC><C-W><C-K>a
    " ino <C-L> <ESC><C-W><C-L>a
    " ino <C-H> <ESC><C-W><C-H>a
    " tno <C-J> <C-W><C-J>
    " tno <C-K> <C-W><C-K>
    " tno <C-L> <C-W><C-L>
    " tno <C-H> <C-W><C-H>
    " cno <C-J> <C-W><C-J>
    " cno <C-K> <C-W><C-K>
    " cno <C-L> <C-W><C-L>
    " cno <C-H> <C-W><C-H>
    " vn <C-J> <C-W><C-J>
    " vn <C-K> <C-W><C-K>
    " vn <C-L> <C-W><C-L>
    " vn <C-H> <C-W><C-H>
  en
  if a:str =~# 'd' " {{{4 mappings with the default keys 
    " normal
    " insert
    ino <C-B> <ESC>viW~i
    " visual, Why: TTM
    vn . :norm .<CR>
    " command-line
    cno <C-J> <S-Left>
    cno <C-K> <S-Right>
    " terminal
    tno <C-Y> <C-A>vim --servername $VIM_SERVERNAME --remote
    tno <C-S-Y> vim --servername $VIM_SERVERNAME --remote 
    " tno <C-I> clear<CR>
    " tno <C-K> <C-W>:normal w<CR>
    " tno <C-J> <C-W>:normal b<CR>
  en
  if a:str =~# 'l' " {{{4 leader
    " {{{5 execute lines
    nn <leader>x :execute getline('.')<CR>
    vn <leader>x :@@<CR>
    " {{{5 command shoutcuts, toogles, numbers, hl, spell, quit etc
    nn <leader>q :q<CR>
    nn <leader>z :w<CR>
    nn <leader><leader>p :setl spell!<CR>
    nn <leader><leader>l :se hlsearch!
    nn <leader>n :set number!<CR>
    nn <leader>N :set relativenumber!<CR>
    nn <leader>L :set list!<CR>
    nn <leader>a :w<CR>
    nn <leader>l :ls<CR>:b
    nn <leader>J :jumps<CR>
    nn <leader>p :reg<CR>
    nn <silent> <leader>t :let &ls = (&ls == 1) ? (len(tabpagebuflist()) > 1 ? 0 : 2) : 2*(((&ls + 2) % 4)/2)<CR>
    nn <silent> <leader>T :let &stal = (&stal == 1) ? (PRVNtabs() > 1 ? 0 : 2) : 2*(((&stal + 2) % 4)/2)<CR>
    nn <leader>g :let &bg = &bg == 'dark' ? 'light' : 'dark'<CR>
    nn <leader>k :let &k'seymap = &keymap ==# 'accents' ? '' : 'accents'<CR>
    nn <leader>c :set cursorline! cursorcolumn!<CR>
    " {{{5 vimrc
    nn <leader>s :e $MYVIMRC<CR>
    nn <leader>S :tabe $MYVIMRC<CR>
    " {{{5 insert one char TODO: accept range?
    nn <silent> <leader>i :ec 'enter char to be input: ' \| exe "norm i".nr2char(getchar())."\e"<CR>
    nn <silent> <leader>a :ec 'enter char to be appended: ' \| exe "norm a".nr2char(getchar())."\e"<CR>
    nn <silent> <leader>I :ec 'enter char to be input around cur char: ' \| cal PRVInsertBeforeAfter()<CR>
    nn <silent> <leader>A :ec 'enter char to be appended around cur char: ' \| :cal PRVInsertBeforeAfter('a')<CR>
    nn <silent> <leader>r :cal PRVCircleChar()<CR>
    nn <silent> <leader>R :cal PRVCircleChar('W')<CR>
    nn <silent> <leader>u :cal PRVCircleChar('a')<CR>
    " {{{5 filesystem navigation
    nn <leader>b :Sex<CR><C-W>T
    nn <leader>B :Vex<CR>
    " {{{5 Vimwiki
    cal g:PRVVWFileNMapping("<leader>wA", "achievements.wiki")
    cal g:PRVVWFileNMapping("<leader>wT", "todo.wiki")
    cal g:PRVVWFileNMapping("<leader>wD", "daily/tasks.wiki")
    cal g:PRVVWFileNMapping("<leader>wW", "weekly/wtasks.wiki")
    cal g:PRVVWFileNMapping("<leader>wN", "blergh.wiki<CR>gg")
    " {{{5 latex
    " make the f mappings usable by using the paths correctly TTM
    nn <leader>f :cal PRVCompileLatex()
    nn <leader><leader>f :cal PRVOpenPDF()
    nn <leader>F :cal PRVCompileLatex('s')
    " {{{5 session (m)aintain (test TTM)
    nn <leader>ml :cal PRVSession('l')<CR>
    nn <leader>ms :cal PRVSession('s')<CR>
    nn <leader>mS :cal PRVSession('sa')<CR>
    nn <leader>mL :cal PRVSession('lo')<CR>
    nn <leader>mi :cal PRVSession('i')<CR>
    " {{{5 formatting helpers
    nn <leader>j :s/=/ = /g<CR>
    nn <leader>, :s/,/, /g<CR>
    nn <leader>' :s/"/'/g<CR>
    nn <leader>" :s/'/"/g<CR>
    nn <leader>. :s/ \. /\./g<CR>
    " {{{5 HTML navigation 
    " view text for visually selected url:
    vn <Leader>h y:cal PRVViewHtmlText(@@)<CR>
    nn <Leader>h :cal PRVViewHtmlText(@+)<CR>
    " Save and view text for current html file:
    nn <Leader>H :up<Bar>cal PRVViewHtmlText(expand('%:p'))<CR>
    " {{{5 Python
    nn <leader>P :cal PythonShowRun()<CR>
    " {{{5 helpers (redir, images, slides, etc)
    nn <leader>v PRVRedir s <C-R>:<CR>
    nn <leader>v PRVRedir t <C-R>:<CR>
    nn <leader><leader>i :cal ShowImg()<CR>
  en
  if a:str =~# 'L' " {{{4 localleader
    " interface navigation {{{5
    nn <localleader>a gT
    ino <localleader>a <ESC><C-W>:tabp<CR>l<C-W>:startinsert<CR>
    cno <localleader>a <ESC><C-W>:tabp<CR>l<c-w>:
    tno <localleader>a <C-W>:tabp<CR>

    " see |aa-mappings|
    nn <localleader>b :exe 'Le ' . expand("%:h")<CR>:let t:prv_browserid = win_getid()<CR>25<C-W>\|
    nn <localleader>B :if exists("t:prv_browserid")ec 'a abanna'let t:prv_tempwinid = win_getid()cal win_gotoid(t:prv_browserid):q!if t:prv_tempwinid != t:prv_browseridcal win_gotoid(t:prv_tempwinid)enunl t:prv_browseridunl t:prv_tempwinidendif
    "
    " should put fold markers as comments, for now just VimL
    noremap <localleader>c mf?^fuA " {{{<localleader>/^endfA " }}}<localleader>`f 
    ino <localleader>c <ESC>?^fuA " {{{<localleader>/^endfuA " }}}<localleader>`fa
    " for gigraphs
    ino <localleader>C <ESC>a
    ino <localleader>Ck k<BS>I
    "
    " nn <localleader>d gT
    " ino <localleader>d <ESC><C-W>:tabp<CR>l<C-W>:startinsert<CR>
    " cno <localleader>d <ESC><C-W>:tabp<CR>l<c-w>:
    " tno <localleader>d <C-W>:tabp<CR>
    "
    nn <localleader>d gt
    tno <localleader>d <C-W>:tabn<CR>
    ino <localleader>d <ESC>:tabn<CR>l<C-W>:startinsert<CR>
    cno <localleader>d <ESC><C-W>:tabn<CR>l<c-w>:
    ino <localleader>Dk k<BS>I
    "
    nmap <silent> <localleader>D :set opfunc=PRVPutCharAround<CR>g@
    vmap <silent> <localleader>D :<C-U>call PRVPutCharAround(visualmode(), 1)<CR>
    "
    nn <localleader>e :e<CR>
    ino <localleader>e <ESC>:e<CR>a
    nn <localleader>E <C-L>
    ino <localleader>E <ESC><C-L>:e<CR>a
    "
    " should run functions, for now just VimL
    nn <localleader>f mf?^fu<CR>V/^endf<CR>:@*<CR>`f
    ino <localleader>f <ESC>mf?^fu<CR>V/^endf<CR>:@*<CR>`fa
    "
    " find files
    nn <localleader>FF :Split echo globpath('/home/renato/repos/', "**/rdf*")
    nn <localleader>Ff :Split echo globpath(&rtp, "**/*")<Left><Left><Left>
    " nn <localleader>Ff :Split echo globpath(&rtp, '"**/' . expand("<cword>") . "*")
    nn <localleader>Fa :Split echo globpath(&rtp, "**/ttm*")<CR>
    nn <localleader>FA :Split echo globpath(&rtp, "**/pack/**")<CR>
    "
    nn <localleader>Fs :lv /RegisterNote/ ~/.vim/pack/ttm/**
    nn <localleader>Fg :lv /\v/ ~/.vim/**<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
    "
    nn <localleader>g :up<CR>:source %<CR>
    ino <localleader>g <ESC>:up<CR>:source %<CR>
    "
    nn <localleader>h <C-W><C-H>
    nn <localleader>j <C-W><C-J>
    nn <localleader>k <C-W><C-K>
    nn <localleader>l <C-W><C-L>
    ino <localleader>h <ESC><C-W><C-H>a
    ino <localleader>j <ESC><C-W><C-J>a
    ino <localleader>l <ESC><C-W><C-L>a
    tno <localleader>h <ESC><C-W><C-H>
    tno <localleader>j <ESC><C-W><C-J>
    tno <localleader>k <ESC><C-W><C-K>
    tno <localleader>l <ESC><C-W><C-L>
    cno <localleader>h <ESC><C-W><C-H>:
    cno <localleader>j <ESC><C-W><C-J>:
    cno <localleader>k <ESC><C-W><C-K>:
    cno <localleader>l <ESC><C-W><C-L>:
    "
    ino <localleader>o <ESC>
    "
    " put char around word and WORD
    nn <localleader>q :q<CR>
    ino <localleader>q <ESC>:q<CR>a
    "
    " Notes mappings
    " nn <localleader>N 
    " ino <localleader>N 
    " cno <localleader>N 
    " tno <localleader>N 
    "
    nn <localleader>p :runtime! plugin/**/*.vim<CR>
    ino <localleader>p <ESC>:runtime! plugin/**/*.vim<CR>a
    "
    " should run the line or the selection, for now just VimL
    nn <localleader>r Y:@"<CR>
    ino <localleader>r <ESC>Y:@"<CR>a
    "
    nn <localleader>s :up<CR>:source $MYVIMRC<CR>:runtime! plugin/**/*.vim<CR>
    ino <localleader>s <ESC>:up<CR>:source %<CR>a
    nn <localleader>S :up<CR>:source $MYVIMRC<CR>
    ino <localleader>S <ESC>:up<CR>:source %<CR>l
    "
    nn <localleader>U :cal PushPRV("Auto updating PRV")
    "
    nn <localleader>x :up<CR>
    ino <localleader>x <ESC>:up<CR>
    ino <localleader>3 <ESC>:up<CR>
    ino <localleader>[ <ESC>:up<CR>
    "
    nn <localleader>W :w<CR>
    ino <localleader>W <ESC>:w<CR>a
    nn <localleader>w :up<CR>
    ino <localleader>w <ESC>:up<CR>a
    " substitue all these mappings by one <localleader>e+surroundings.
    " <localleader>E might be previous words, or WORD. TTM
    nn <localleader>" ea"<ESC>hbi"<ESC>lel
    nn <localleader>' ea'<ESC>hbi'<ESC>lel
    ino <localleader>" <ESC>hhea"<ESC>hbi"<ESC>lelli
    ino <localleader>' <ESC>hhea'<ESC>hbi'<ESC>lelli
    cno <localleader>" ea"<ESC>hbi"<ESC>lel<CR>
    cno <localleader>' ea'<ESC>hbi'<ESC>lel<CR>
    tno <localleader>" ea"<ESC>hbi"<ESC>lel<CR>
    tno <localleader>' ea'<ESC>hbi'<ESC>lel<CR>
  en

  if a:str =~# 'a' " {{{4 auxleader
    let l:foo = g:mapleader
    let g:mapleader = g:prvset.leaders.prv[2]
    nn <leader>a :exec "normal li".nr2char(getchar())."\e"<CR>
    nn <leader>A  :cal InsertAfterAfter()<CR>
    nn <leader>f  :cal system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>
    " -- for exceptional commands {{{5
    nn <leader>ea :exec "e " . split(&runtimepath,',')[0] . "/after/plugin/prv.vim"<CR>/\v[^\]\^]ttm:alt-map\|^ttm:alt-map<CR>
    nn <leader>ec :cal PRVCircleChar()<CR>
    nn <leader>eC :cal PRVCircleChar('W')<CR>
    " nn <leader>eC 
    nn <leader>e<leader>c :put ='\" '.string(keys(ccs))<CR>:put ='cal ApplyCS(g:ccs[\"green1\"],\"color\")'<CR>
    nn <leader>ee :exec "e " . split(globpath(&rtp, "plugin/prv.vim"), "\n")[0]<CR>/ttm:exc-com<CR>
    nn <leader>e<leader>F :sf **/aa|    " press tab after
    " nn <leader>ea :exec "e " . split(globpath(&rtp, "plugin/ttmmappings.vim*"), "\n")[0]<CR>:lvim $\v[^\]]ttm:alt-map$ ~/.vim/**<CR>
    nn <leader>ei :help aa<CR>
    nn <leader>eI :help aa<CR>`t
    "
    nn <leader>ef :exec "e " . split(&runtimepath,',')[0] . "/after/plugin/ttmfstartup.vim"<CR>G
    nn <leader>e<leader>f :Split filter // oldfiles<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
    nn <leader>e<leader>f :Split filter // oldfiles<S-Left><S-Left><Right>
    nn <leader>eF GoCopyright: Public Domain.  vim:modifiable:noreadonly:tw=0:ts=8:ft=help.vimwiki:suffixesadd+=.txt:norl:softtabstop=4:shiftwidth=4:textwidth=0:expandtab:<ESC><C-O>
    "
    nn <leader>et :tselect /aa<CR>
    nn <leader>eT :tselect /
    "
    " how to do this TTM |aa-todo|
    " nn <leader>eh :map \\<leader><CR>
    "
    nn <leader>ep :PRVRedir v exec "normal g\<C-G>"<CR>xf"Dh
    nn <leader>eP :PRVRedir t exec "normal g\<C-G>"<CR>xf"Dh
    nn <leader>e<leader>p :PRVRedir n exec "normal g\<C-G>"<CR>xf"Dh
    let g:mapleader = l:foo
  en
endf

fu! PRVSetWiki() " {{{3 bare Vim wiki, findind files
  exe 'se path+='.g:prv_dir.'aux/vimwiki/'
  se sua +=.wiki
  se sua +=.vim
  se sua +=.py
  se sua +=.txt
  " to avoid getting unwanted files when finding files
  se wildignore+=*.swp,*.swo,*.pyo,**/aux/undo/*,viminfo
endf
fu! PRVDefineSettings() " {{{3 basic variables/settings
  let g:prv = {}
  let g:prv.paths = {}
  let g:prv.leaders = {}
  if !exists("g:prvset") " for user settings
    let g:prvset = {'leaders' : {}}
  en
  let g:prv.paths.path = g:prv_dir
  let A = {arg -> g:prv.paths.path . arg}
  let g:prv.paths.verbose_file = A('aux/prvverbose.log')
  let g:prv.paths.vimwiki = A('aux/vimwiki/')
  if !isdirectory(g:prv.paths.vimwiki)
    cal mkdir(g:prv.paths.vimwiki, 'p')
  en
  if !exists("g:pdfjobs")
    let g:prv.jobs = []
    let g:prv.terms = []
  en
  let g:prv.session = v:none
  " {{{4 Persistence see |prv-persistence|:
  let g:prv.paths.sessions = A('aux/prvsessions/')
  " state is maintained upon exit and enter vim because of viminfo not empty:
  if !exists("g:prv_noviminfo")
    exe "se viminfo=%,!,/1000,<1000,'1000,:1000,@1000,n".g:prv_dir."aux/prvviminfo"
  en
  " autosave the undo file in the known dir:
  se udf
  let g:prv.paths.undo = A('aux/undo')
  if !isdirectory(g:prv.paths.undo)
    cal mkdir(g:prv.paths.undo, 'p')
  en
  exe 'se undodir='.g:prv.paths.undo
  " TTM what is this for:
  let g:prv.paths.plugin_files = A('aux/pluginFiles.txt')
endf
" make status lines for filetypes: aashouts.txt, aasessions.txt, prv.vim? (number of :map commands, etc)
" Vim already makes such parsing to a small extent, for syntax highlighting, so... TTM

" make mapping to set title to a tab. TTM

" make routines to parsing any file and registering the AA TTM notes (cop and lop?)


" {{{2 aux funcs (time, random numbers, etc)
let g:Curmili = {-> system("date +%s%N | cut -b1-13")[:-2]}

" {{{1 autocommands
" restore-cursor, usr-05.txt
aug prvgeneric
  au!
  au BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
  if !has('gui_running') " because of tgc not using gui= attr in :hi
    au Colorscheme * runtime ~/.vim/aux/underlineSpellBad.vim
  en
  au CmdwinEnter * map <buffer> <C-D> <CR>q:
  au VimLeavePre *  call QuitNetrw() " really needed? Useful when? TTM
aug END

aug prvfttweaks
  au!
  au FileType vim setl fdm=marker sts=2 sw=2 et
  au FileType help setl iskeyword+=-,.,(,)
  au Filetype python setl sts=4 sw=4 tw=0 et ai ff=unix
aug END

fu! QuitNetrw() " is this really needed? TTM {{{2
  for i in range(1, bufnr($))
    if buflisted(i)
      if getbufvar(i, '&filetype') == "netrw"
        sil exe 'bwipeout ' . i
      en
    en
  endfo
endf

" {{{1 digraphs
" ♔ ☘ ☠ ☥ ☨ ☪ ☮ ☯ 
dig kI 9812
dig kT 9752
dig kS 9760
dig kA 9765
dig kC 9768
dig kM 9770
dig kP 9774
dig kE 9775
" Other 0U ☻ 
" a₁,₂
" asodija sdoi ja # 
" trigrams
" better to enter them as C-V?
" select the digraphs related to math (relations, operations, greek
" letters, etc) TTM. Are any of them not defined in Vim by Default?
" what are the missing notatios in utf8? indexes (x_{i,j})will not be ok in
" mono fonts beyond single digit indexes.
"
" ☲ (0,0,1) ☶ (0,0,1)

" {{{1 Notes and further stuff
" for mapping of letters in insert mode {{{ 
" (test with <Space> to replicate normal commands)
" au InsertEnter * set timeoutlen=200
" au InsertLeave * set timeoutlen=1000
" }}}

cal PRVInit()
