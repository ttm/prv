" s:tickerids.push( timer_start(400, TickColor(), {'repeat': 3}) )

"  See things in mappings, put this in commands
command! -nargs=+ -complete=command A call AAShout(<q-args>)
command! -nargs=+ -complete=command S call AAStartSession(<f-args>)
command! -nargs=+ -complete=command AATest call AATestCommandToFunctionArgs(<f-args>)

fu! AAClear() " {{{
  au! aaPlug
  unlet g:aa
  unlet g:AA_dict
endfu " }}}
fu! AAShout(msg) " {{{
  " each message should have the
  " date and time, the message,
  " and a final line separator
  let date = system("date")[:-2]

  let sep = g:aa.separator

  let mlines = [a:msg, l:date, l:sep]
  call writefile(mlines, g:aa.paths.shouts, 'as')
  call AASessionReceiveMsg()
endfu " }}}
fu! AAStartSession(...) " {{{
  " default duration = 15, ntimes = 8
  " message = 'Ding Dong Ding Dong'
  if 1 " !exists("g:aa.initialized")
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

  " let g:aa.cursession = {'dur': l:dur, 'slots': l:nslots, 'slots_requested': 0, 'msgs_expected': 0, 'msgs_sent': 0}
  let g:aa.cursession = {'dur': l:dur, 'slots': l:nslots, 'slots_requested': 0, 'msgs_expected': 0, 'msgs_sent': 0}
  ec "ok"
  call timer_start(float2nr(60*1000*l:dur), "ExpectMsg", {'repeat': l:nslots})
  let g:aa.session_on = 1
  " BufEnter		after entering a buffer
  call AAPutCC()
  let g:aa.events.session_started = strftime("%c")
endfu " }}}
fu! AAInitialize() " {{{
  call AAInitVars()
  if !exists('g:aa.timers')
    let g:aa.timers = []
  endif
  let g:aa.initialized = 1
endfu " }}}
fu! AAInitVars() " {{{
  let g:aa = {}
  let g:AA_dict = g:aa
  let g:aa.note = 'AA stuff should be kept in files. Keep this dictionary minimal.'
  let g:aa.say = 1
  let g:aa.saytime = 1
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

  let g:aa.separator = '----- QWEEWQPOIIOPTYUUTYREWWRE AA separator -----'

  let g:aa.msgs = {}

  let g:aa.voices = ['croak', 'f1', 'f2', 'f3', 'f4', 'f5', 'klatt', 'klatt2', 'klatt3', 'klatt4', 'm1', 'm2', 'm3', 'm4', 'm5', 'm6', 'm7', 'whisper', 'whisperf']
endfu " }}}
fu! ExpectMsg(timer) " {{{
  let g:aa.cursession.slots_requested += 1
  let g:aa.cursession.msgs_expected += 1
  call AAPutCC()
  let g:aa.msgs.pmessage = 'A.A.: 1 shout expected. Total of ' . g:aa.cursession.msgs_expected . ' shouts expected.'
  " let g:aa.msgs.pmessage = g:aa.cursession.msgs_expected
  if g:aa.say == 1
    cal AASay(g:aa.msgs.pmessage)
  endif
  if g:aa.saytime == 1
    cal AASay(strftime("%T"))
    " cal AASay(strftime("%H:%M"))
  endif
  let g:aa.events.last_shout_seconds = localtime()
  let g:aa.events.last_shout_time = strftime("%c")
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
  if exists("g:aa.session_on") && g:aa.cursession.msgs_expected > 0
    let g:aa.cursession.msgs_expected -= 1
    call AAPutCC()
    if (g:aa.cursession.slots == g:aa.cursession.slots_requested) && (g:aa.cursession.msgs_expected == 0)
      unlet g:aa.session_on
    endif
  endif
  call AAPutCC()
endfu " }}}
fu! AASinceLastShout() " {{{
  ec (localtime() - g:aa.events.last_shout_seconds)/60
endfu " }}}
fu! AAPutCC() " {{{
  if g:aa.cursession.msgs_expected <= 0
    setg colorcolumn=
  else
    let ref = 20
    exec 'setg colorcolumn=' . ref
    for i in range(g:aa.cursession.msgs_expected - 1)
      let g:aa.cccommand_ = 'setg colorcolumn+=' . (ref + (i+1)*2)
      exec g:aa.cccommand_
    endfor
  endif
  set colorcolumn<
  let g:aa.cccommand = 'setg colorcolumn=' . &colorcolumn
  call UpdateColorColumns()
endfu " }}}
fu! UpdateColorColumns() " {{{
  tabdo windo exec g:aa.cccommand | windo set colorcolumn<          
endfu " }}}
fu! AATestCommandToFunctionArgs(...) " {{{
  let g:mfargs = a:
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
