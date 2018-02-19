" s:tickerids.push( timer_start(400, TickColor(), {'repeat': 3}) )

"  See things in mappings, put this in 
command! -nargs=+ -complete=command A call AAShout(<q-args>)

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
  let g:aa.paths = {}
  let g:aa.paths.path = g:prv_dir . 'aux/aa/'
  let g:aa.paths.shouts = g:aa.paths.path . 'aashouts.txt'
  let g:aa.paths.sessions = g:aa.paths.path . 'aasessions.txt'
  if exists("g:aa_user")
    let g:aa.user = aa_user
  else
    let g:aa.user = 'anon-' . system("echo $RANDOM$RANDOM$RANDOM")
  endif

  let g:aa.events = {}
  let g:aa.events.aa_started = strftime("%c")

  let g:aa.separator = '----- QWEEWQPOIIOPTYUUTYREWWRE AA separator -----'
endfu " }}}

fu! AAShout(msg) " {{{
  " each message should have the
  " date and time, the message,
  " and a final line separator
  let date = system("date")[:-2]

  let sep = g:aa.separator

  let mlines = [a:msg, l:date, l:sep]
  call writefile(mlines, g:aa_file, 'as')
  call AASessionReceiveMsg()
endfu " }}}

fu! AASinceLastShout() " {{{
  ec (localtime() - g:aa_last_sent_sec)/60
endfu " }}}

fu! AAStartSession(duration, ntimes) " {{{p
  " default duration = 15, ntimes = 8
  " message = 'Ding Dong Ding Dong'
  let g:aa.cursession = {'dur': a:duration, 'slots': ntimes, 'slots_requested': 0, 'msgs_expected': 0, 'msgs_sent': 0}
  call timer_start(float2nr(1000*a:duration), "ExpectMsg", {'repeat': a:ntimes})
  let g:aa.session_on = 1
endfu " }}}
fu! ExpectMsg(timer) " {{{
  let g:aa.cursession.slots_requested += 1
  let g:aa.cursession.msgs_expected += 1
  call PutCC()
  let g:aa.msgs.pmessage = 'A.A.: 1 shout expected. Total of ' . g:aa.cursession.msgs_expected . ' shouts expected.'
  call system('espeak "' . g:aa.msgs.pmessage . '"')
  if g:aa_saytime == 1
    call system('espeak"' . strftime("%T") . '"')
  endif
  let g:aa_last_sent_sec = localtime()
  let g:aa_last_sent_time = strftime()
  " Make sound"
endfu " }}}

fu! AAPutCC() " {{{
  if g:msgs_expected <= 0
    setg colorcolumn=
    return
  endif
  let ref = 20
  exec 'setg colorcolumn=' . ref
  for i in range(g:msgs_expected-1)
    let com = 'setg colorcolumn+=' . (ref + (i+1)*2)
    exec com
  endfor
endfu " }}}

fu! AASessionReceiveMsg() " {{{
  if exists("g:aa.session_on") && g:aa.cursession.msgs_expected > 0
    let g:aa.cursession.msgs_expected -= 1
    call AAPutCC()
    if (aa.cursession.slots == aa.cursession.slots_requested) && (aa.cursession.msgs_expected == 0)
      unlet g:aa.session_on
    endif
  endif
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
