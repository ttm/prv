if !exists("g:pdfjobs")
  let g:pdfjobs = []
endif
" for plugin-specific leader and localleader {{{1
fu! PRVDeclareLeader(plug)
  cal assert_equal(type(a:plug), 1, 'only strings are accepted as arg to PRVDeclareLeader(plug)')
  let g:prv_keepleaders = [g:mapleader, g:maplocalleader]
  if exists('g:'.a:plug.'_leader')
    exe 'let mapleader = g:'.a:plug.'_leader'
  el
    exe 'let mapleader = g:'.a:plug.'_default_leader'
    exe 'let g:'.a:plug.'_leader = g:'.a:plug.'_default_leader'
  en
  if exists("g:aa_localleader")
    exe 'let maplocalleader = g:'.a:plug.'_localleader'
  el
    exe 'let maplocalleader = g:'.a:plug.'_default_localleader'
    exe 'let g:'.a:plug.'_localleader = g:'.a:plug.'_default_localleader'
  en
endf
fu! PRVRestoreLeader(plug)
  let [mapleader, maplocalleader] = g:prv_keepleaders
endf

" insert one char {{{1
fu! InsertBeforeAfter()
  let a = nr2char(getchar())
  exe "norm i".a."\e"
  exe "norm lli".a."\e"
endf
fu! InsertAfterAfter()
  let a = nr2char(getchar())
  exe "norm a".a."\e"
  exe "norm lla".a."\e"
endf
fu! CircleChar(...)
  let a = nr2char(getchar())
  let w = 'w'
  if a:1 == 'W'
    let w = 'W'
  en
  let cmd = "norm vi".l:w."di".l:a."\<C-R>\"".l:a
  let g:asd = l:cmd
  if getline('.')[col('.')-1] == ' '
    norm h
  en
  exe l:cmd
  norm l
endf

" sessions {{{1
if !isdirectory(g:prv_sessions_dir)
  cal mkdir(g:prv_sessions_dir, 'p')
en
fu! SaveSession()
  if !exists("g:msession")
    cal ListSessions()
    let g:msession = input("Enter session name: ")
  en
  exe 'mksession! ' . g:prv_sessions_dir . g:msession
endf
fu! SaveNewSession()
  cal ListSessions()
  let g:msession = input("Enter session name: ")
  exe 'mksession!' g:prv_sessions_dir . g:msession
endf
fu! LoadSession()
  cal ListSessions()
  let g:msession = input("Enter session name: ")
  exe 'only'
  exe 'tabonly'
  exe 'so ' . g:prv_sessions_dir . g:msession
endf
fu! InsertSession()
  cal ListSessions()
  exe 'tabe'
  let g:msession = input("Enter session name: ")
  exe 'so ' . g:prv_sessions_dir . g:msession
endf
fu! ListSessions()
  exe '!ls ' . g:prv_sessions_dir
endf

" visual functions {{{1
fu! ShowImg()
  exe "normal! viWy"
  sil exec '!eog -f ' getreg('0')
  exe 'colorscheme gruvbox'
endf
fu! ChangeBackground()
  if &bg == 'dark'
    se bg=light
  el
    se bg=dark
  en
endf
fu! ToggleStatusbar()
  if &ls == 2
    se ls=0
  el
    se ls=2
  en
endf
fu! ToggleTabLine()
  if &showtabline == 2
    se showtabline=0
  el
    se showtabline=2
  en
endf

" get window with output of command using redir {{{1
fu! TabMessage(cmd)
  redi => message
  ex a:cmd
  redi END
  if empty(l:message)
    echoe "no output"
  el
    tabnew
    PRVbuff
    p = message
  en
endf
fu! SplitMessage(cmd)
  redi => avar
  exe a:cmd
  redi END
  if empty(output)
    echoe "no output"
  el
    vne
    PRVbuff
    p = avar
  en
endf

" latex related {{{1
fu! OpenPDF()
  let l:tfname = expand("%:r") . '.pdf'
  let l:tcmd = 'evince ' . l:tfname
  if !filereadable(l:tfname)
    let @x = ':call add( g:pdfjobs, job_start(["/bin/bash", "-c", "' . l:tcmd . '" ]))'
    ec 'command to open PDF in @x register, pdf not found'
  el
    cal add( g:pdfjobs, job_start(["/bin/bash", "-c", l:tcmd]))
  en
endf
fu! CompileLatex()
  let l:tfname = expand("%")
  let l:tdname = expand("%:h")
  let l:tcmd = 'pdflatex -output-directory=' . l:tdname . '/ ' . l:tfname
  cal job_start(["/bin/bash", "-c", l:tcmd])
endf

fu! ExtremeFolding() " {{{1
  " make mapping TTM
  if &foldopen == 'all'
    se foldopen&
    se foldclose&
  el
    se foldopen=all
    se foldclose=all
  en
endf

fu! ViewHtmlText(url) " WWW navigation {{{1
  if !empty(a:url)
    new
    setl buftype=nofile bufhidden=hide noswapfile
    let g:ttmurl=a:url
    exe 'r !elinks ' . a:url . ' -dump -dump-width ' . winwidth(0)
    1d
  en
endf

fu! ToggleVerbose() " {{{1
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

fu! VWFileNMapping(mapping, fpath) " {{{1
  let path = g:vimwiki_list[0].path.a:fpath
  let cmd = ' :vs '.l:path
  let cmd2 = 'nn '.a:mapping.l:cmd
  exe l:tcmd2
endf

fu! RotateRegisters() " {{{1
  " find where it is used and assert it is doing what is expected
  " also try to make similar mechanisms for other registers,
  " maybe use a dict of lists (one list for the history
  " of each type of register)
  let @h=@j
  let @j=@k
  let @k=@l
  let @l=@.
endf

fu! DecryptVimwiki() " {{{1
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
fu! PythonShowRun() " {{{1
  " Test TTM
  let pout = system("python3 " . bufname("%") . " 2>&1")
  " Open a new split and set it up.
  vs __Python_output__
  norm! ggdG
  setl buftype=nofile
  " Insert the bytecode.
  0a split(pout, '\v\n')
endf

