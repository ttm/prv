if !exists("g:pdfjobs")
  let g:pdfjobs = []
endif

fu! ExtremeFolding() " {{{1
  if &nctionfoldopen == 'all'
    set foldopen&
    set foldclose&
  else
    set foldopen=all
    set foldclose=all
  endif
endfu

fu! PythonShowRun() " {{{1
  " Move this function to +PRV? TTM
  let pout = system("python3 " . bufname("%") . " 2>&1")
  " Open a new split and set it up.
  vsplit __Python_output__
  normal! ggdG
  setlocal buftype=nofile
  " Insert the bytecode.
  call append(0, split(pout, '\v\n'))
endfu

fu! ViewHtmlText(url) " WWW navigation {{{1
  if !empty(a:url)
    new
    setlocal buftype=nofile bufhidden=hide noswapfile
    let g:ttmurl=a:url
    execute 'r !elinks ' . a:url . ' -dump -dump-width ' . winwidth(0)
    1d
  endif
endfu

fu! ToggleVerbose() " {{{1
    if !&verbose
        set verbosefile=~/.vim/aux/verbose.log
        set verbose=15
        vs ~/.vim/aux/verbose.log
        setlocal autoread
    else
        set verbose=0
        set verbosefile=
    endif
endfu

fu! VWFileNMapping(mapping, fpath) " {{{1
  let tpath = g:vimwiki_list[0].path . a:fpath
  let tcmd = ' :vs ' . tpath
  let tcmd2 = 'nnoremap ' . a:mapping . l:tcmd . '<CR>'
  exec l:tcmd2
endfu

" insert one char {{{1
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

" sessions {{{1
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

" visual functions {{{1
function! ShowImg()
  exec "normal! viWy"
  silent exec '!eog -f ' getreg('0')
  exec 'colorscheme gruvbox'
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

fu! TabMessage(cmd) " {{{1
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
endfu

fu! SplitMessage(...) " {{{1
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
endfu

fu! HiFile() " {{{1
  " Does a bad job... But the idea is good, enhance it! TTM
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
endfu

fu! OpenPDF() " {{{1
  let l:tfname = expand("%:r") . '.pdf'
  let l:tcmd = 'evince ' . l:tfname
  if !filereadable(l:tfname)
    let @x = ':call add( g:pdfjobs, job_start(["/bin/bash", "-c", "' . l:tcmd . '" ]))'
    echo 'command to open PDF in @x register'
  else
    call add( g:pdfjobs, job_start(["/bin/bash", "-c", l:tcmd]))
  endif
endfu

fu! CompileLatex() " {{{1
  let l:tfname = expand("%")
  let l:tdname = expand("%:h")
  let l:tcmd = 'pdflatex -output-directory=' . l:tdname . '/ ' . l:tfname
  call job_start(["/bin/bash", "-c", l:tcmd])
endfu

fu! RotateRegisters() " {{{1
  let @h=@j
  let @j=@k
  let @k=@l
  let @l=@.
endfu

fu! PushPRV(amsg) " {{{1
  " encrypt all vimwiki messages
  " add -f vimwiki
  " commit -am '
  " decrypt all msgs
endfu

