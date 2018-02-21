" Load Once: {{{1
if exists("g:loaded_aaplugin") && (exists("g:aa_not_hacking") || exists("g:prv_not_hacking_all"))
 finish
endif
let g:loaded_aaplugin = "v0.01b"

" Vim plugin for time management and automated documenting activities
" Author: Renato Fabbri <renato.fabbri@gmail.com>
" Date: 2018 Fev 21 (when I wrote this header...)
" Installing:	:help aa-install 
" Usage:	:help aaplug         
" Notes: * This plugin is part of the PRV framework, check https://github.com/ttm/prv
"        * check and hack also after/plugin/aastartup.vim
" Goals: sharing of efforts, supporting distributed and asynchronous teamwork,
" self-management.
" Copyright: Public Domain

" Load Once: {{{1
if exists("g:loaded_aaplugin") && (exists("g:aa_not_hacking") || exists("g:prv_not_hacking_all"))
 finish
endif
let g:loaded_aaplugin = "v0.01b"

" MAPPINGS: {{{1
" -- for shouts {{{2
nnoremap Aa :A 
nnoremap AA :exec "vs " . g:aa.paths.shouts<CR>Go<ESC>o<ESC>:.!date<CR>:put =g:aa.separator<CR>kki

nnoremap Av :exec "vs " . g:aa.paths.shouts<CR>
nnoremap Ao :exec "e " . g:aa.paths.shouts<CR>
nnoremap At :exec "tabe " . g:aa.paths.shouts<CR>

nnoremap AA :As<CR>

" -- for sessions {{{2
nnoremap As :S 15 8
nnoremap AS :S 15 8<CR>
nnoremap At :At<CR>
nnoremap AT :AT<CR>
nnoremap AO :Ao<CR>
" -- general {{{2
nnoremap Ai :Ai<CR>
nnoremap AI :AI<CR>
nnoremap Ar :new<CR>:put =string(g:aa)<CR>:PRVbuff<CR>

" COMMANDS: {{{1
" -- MAIN: {{{2
command! -nargs=1 A call AAShout(<q-args>)
command! -nargs=+ S call AAStartSession(<f-args>)
command! Ai ec AAInfo()
command! AI call AAInitialize()
" -- UTILS: {{{2
command! Ao ec 'AA session on: '.AAIsSessionOn()
command! Ac call AAClear()
command! At ec AATimeLeftInSlot()
command! AT ec AATimeSpentInSlot()
command! As ec 'minutes since last shout: ' . AATimeSinceLastShout()

command! -nargs=+ AATest call AATestCommandToFunctionArgs(<f-args>)
command! PRVbuff setlocal buftype=nofile noswapfile bufhidden=wipe nobuflisted ft=python

" FUNCTIONS: {{{1
" -- MAIN {{{2
fu! AAShout(msg) " {{{
  " each message should have the
  " date and time, the message,
  " and a final line separator
  if 1 " !exists("g:aa.initialized")
    call AAInitialize()
  endif
  let date = system("date")[:-2]

  let sep = g:aa.separator

  let mlines = [a:msg, l:date, l:sep]
  call writefile(mlines, g:aa.paths.shouts, 'as')
  call AASessionReceiveMsg()
endfu " }}}
fu! AAStartSession(...) " {{{
  " default duration = 15, ntimes = 8
  " message = 'Ding Dong Ding Dong'
  if !AAIsInitialized()
    call AAInitialize()
  endif
  if a:.0 > 0
    let dur = a:.1
  else
    let dur = 15
  endif
  if a:.0 > 1
    let nslots = a:.2
  else
    let nslots = 15
  endif

  let g:aa.cursession = {'dur': l:dur, 'slots': l:nslots, 'messages_requested': 0, 'shouts_expected': 0, 'shouts_sent': 0, 'last_shout': {}}
  ec "ok"
  call timer_start(float2nr(60*1000*l:dur), "AAExpectMsg", {'repeat': l:nslots})
  let g:aa.session_on = 1
  " BufEnter		after entering a buffer
  call AAPutCC()
  " put two empty lines before session
  call writefile(['', ''], g:aa.paths.shouts, 'as')
  call writefile(['', '', 'started: '.system("date")[:-2],
                        \ 'dur: '.l:dur, 'slots: '.l:nslots],
               \ g:aa.paths.sessions, 'as')
  let g:aa.events.session_started = strftime("%c")
endfu " }}}
fu! AAInitialize() " {{{
  call AAInitVars()
  if !exists('g:aa.timers')
    let g:aa.timers = []
  endif
  let g:aa.initialized = 1
endfu " }}}
fu! AAInfo() " {{{
  let ml = AAInfoLines()
  let ml2 = join(l:ml, "\n")
  retu l:ml2
endfu " }}}
" -- UTILS {{{2
fu! AAIsInitialized() " {{{
  if exists("g:aa.initialized")
    return 1
  else
    return 0
  endif
endfu " }}}
fu! AAIsSessionOn() " {{{
  if exists("g:aa.session_on")
    return 1
  else
    return 0
  endif
endfu " }}}
fu! AAClear() " {{{
  let apass = input("are you sure you want to clear AA data? [y/N] ")
  if l:apass == 'y' || l:pass == 'Y'
    au! aaPlug
    unlet g:aa
    unlet g:AA_dict
  endif
endfu " }}}
fu! AATimeLeftInSlot() " {{{
  retu g:aa.cursession.dur -  (localtime() - g:aa.events.last_shout.request_seconds)/60
endfu " }}}
fu! AATimeSpentInSlot() " {{{
  retu (localtime() - g:aa.events.last_shout.request_seconds)/60
endfu " }}}
fu! AATimeSinceLastShout() " {{{
  if !exists("g:aa.events.last_shout.sent_seconds")
    retu 'no shout has beed given since last AA startup'
  en
  retu string((localtime() - g:aa.events.last_shout.sent_seconds)/60.0)
endfu " }}}
fu! AATestCommandToFunctionArgs(...) " {{{
  let g:mfargs = a:
endfu " }}}
" }}}
" -- AUX {{{2
fu! AAInfoLines() " {{{
  let mlines = ['== Info about AA ==']
  if !AAIsInitialized()
    cal add(l:mlines, 'AA has not been initialized... Initialing.')
    cal AAInitialize()
    cal add(l:mlines, 'AA initialized ok.')
  en
  cal add(l:mlines, '')
  cal add(l:mlines, 'initialized: '.g:aa.initialized)
  cal add(l:mlines, 'initialized time: '.g:aa.events.aa_initialized)
  cal add(l:mlines, 'using voices: '.string(g:aa.voices))
  cal add(l:mlines, 'using voice to say time: '.g:aa.saytime)
  cal add(l:mlines, 'user: '.g:aa.user)
  cal add(l:mlines, 'paths: '.string(g:aa.paths))
  cal add(l:mlines, '')
  cal add(l:mlines, 'session on: '.AAIsSessionOn())
  if AAIsSessionOn()
    cal add(l:mlines, 'slot duration in minutes: '.g:cursession.dur)
    cal add(l:mlines, 'number of slots: '.g:cursession.nslots)
    cal add(l:mlines, 'shouts requested / slots finished: '.g:cursession.msgs_requested)
    cal add(l:mlines, 'shouts expected: '.g:cursession.shouts_expected)
    cal add(l:mlines, 'shouts sent: '.g:cursession.shouts_sent)
  else
    cal add(l:mlines, '(start AA session to have more stats)')
  endif
  cal add(l:mlines, '')
  cal add(l:mlines, 'more info in :h aaplug.txt, the files in the paths above, and the script files.')
  retu l:mlines
endf " }}}
fu! AAPutCC() " {{{
  if g:aa.cursession.shouts_expected <= 0
    setg colorcolumn=
  else
    let ref = 20
    exec 'setg colorcolumn=' . ref
    for i in range(g:aa.cursession.shouts_expected - 1)
      let g:aa.cccommand_ = 'setg colorcolumn+=' . (ref + (i+1)*2)
      exec g:aa.cccommand_
    endfor
  endif
  set colorcolumn<
  let g:aa.cccommand = 'setg colorcolumn=' . &colorcolumn
  tabdo windo exec g:aa.cccommand | windo set colorcolumn<          
endfu " }}}
fu! AAInitVars() " {{{
  let g:aa = {}
  let g:AA_dict = g:aa
  let g:aa.note = 'AA stuff should be kept in files. Keep this dictionary minimal.'
  " let g:aa.say = 1
  " let g:aa.saytime = 1
  let g:aa.say = 0
  let g:aa.saytime = 0
  let g:aa.paths = {}
  let g:aa.paths.path = g:prv_dir . 'aux/aa/'
  if !isdirectory(g:aa.paths.path)
    let mkd = input("make directory " . g:aa.paths.path . " ? (y/N)")
    if (l:mkd == 'y' || l:mkd == 'Y') && 
      call mkdir(g:aa.paths.path, 'p')
    endif
  endif
  " mkdir if necessary
  let g:aa.paths.shouts = g:aa.paths.path . 'aashouts.txt'
  let g:aa.paths.sessions = g:aa.paths.path . 'aasessions.txt'
  if exists("g:aa_user")
    let g:aa.user = aa_user
  else
    let g:aa.user = 'anon-' . system("echo $RANDOM$RANDOM$RANDOM")
  endif

  let g:aa.events = {}
  let g:aa.events.aa_initialized = strftime("%c")
  let g:aa.events.last_shout = {}

  let g:aa.separator = '----- QWEEWQPOIIOPTYUUTYREWWRE AA separator -----'

  let g:aa.msgs = {}

  let g:aa.voices = ['croak', 'f1', 'f2', 'f3', 'f4', 'f5', 'klatt', 'klatt2', 'klatt3', 'klatt4', 'm1', 'm2', 'm3', 'm4', 'm5', 'm6', 'm7', 'whisper', 'whisperf']
endfu " }}}
fu! AAExpectMsg(timer) " {{{
  let g:aa.cursession.messages_requested += 1
  let g:aa.cursession.shouts_expected += 1
  call AAPutCC()
  let g:aa.msgs.pmessage = 'A.A.: 1 shout expected. Total of ' . g:aa.cursession.shouts_expected . ' shouts expected.'
  if g:aa.say == 1
    cal AASay(g:aa.msgs.pmessage)
  endif
  if g:aa.saytime == 1
    cal AASay(strftime("%T"))
    " cal AASay(strftime("%H:%M"))
  endif
  let g:aa.events.last_shout.request_seconds = localtime()
  let g:aa.events.last_shout.request_time = strftime("%c")
  " Make sound"
endfu " }}}
fu! AASay(aphrase) " {{{
  call system(AAMkVoice() . ' "' . a:aphrase . '"')
endfu " }}}
fu! AAMkVoice() " {{{
    let voice = g:aa.voices[reltime()[1]%len(g:aa.voices)]
    let epk = 'espeak -v' . l:voice
  return l:epk
endfu " }}}
fu! AASessionReceiveMsg() " {{{
  if exists("g:aa.session_on") && g:aa.cursession.shouts_expected > 0
    let g:aa.cursession.shouts_expected -= 1
    call AAPutCC()
    if (g:aa.cursession.slots == g:aa.cursession.shouts_requested) && (g:aa.cursession.shouts_expected == 0)
      unlet g:aa.session_on
      call writefile(['', ''], g:aa.paths.shouts, 'as')
      call writefile(['ended: '.system("date")[:-2], '', ''], g:aa.paths.sessions, 'as')
    endif
  endif
  let g:aa.events.last_shout.sent_seconds = localtime()
  let g:aa.events.last_shout.time = strftime("%c")
endfu " }}}
" -------- notes {{{
" timer_start(400, TickColor(), {'repeat': 3}) )
"
" com -nargs=1 Question let g:banana='for you'
" Question how do behave the function arguments? In all the cases of having bang or not, receiving range, etc
" Todo check glaive
" Note Maj.Min.Pat-(a,b,rc)XXXYYY pattern for software releases, as in https://semver.org/
" Cnote exists(), tempname()
" Todo look for chatter bot in vim
" }}}
" }}}
