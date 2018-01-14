" s:tickerids.push( timer_start(400, TickColor(), {'repeat': 3}) )

fu! InitializeAA() " {{{
  if !get(keys(s:), 'shouts')
    let s:shouts = []
  endif
  if !get(keys(s:), 'timers')
    let s:timers = []
  endif
endfu " }}}

fu! Shout(msg) " {{{
  " verbose of settings, use statistics, new entries, and a custom message.
  call InitializeAA()
  call add( s:shouts, msg )
endfu " }}}

fu! PutCC() " {{{
  if g:msgs_expected <= 0
    call RemCC()
    return
  endif
  let ref = 40
  exec 'setl colorcolumn=' . ref
  for i in range(g:msgs_expected-1)
    let com = 'setl colorcolumn+=' . (ref + (i+1)*2)
    echom com
    exec com
  endfor
endfu " }}}

fu! RemCC() " {{{
  set colorcolumn=
  setg colorcolumn=
  setl colorcolumn=
  let g:msgs_expected = 0
endfu " }}}

fu! ReceiveMsg(shout) " {{{
  exec 'Aa ' . a:shout
  let g:msgs_expected -= 1
  call PutCC()
endfu " }}}

fu! ExpectMsg(timer) " {{{
  let g:msgs_expected += 1
  call PutCC()
  let g:aa_pmessage = 'AA: 1 shout expected. Total of ' . g:msgs_expected . ' :AA'
  echom g:aa_pmessage
  " Make sound"
endfu " }}}

fu! SetTimer(duration, ntimes) " {{{
  " default duration = 15, ntimes = 8
  " message = 'Ding Dong Ding Dong'
  let g:msgs_expected = 0
  call timer_start(float2nr(1000*a:duration), "ExpectMsg", {'repeat': a:ntimes})
endfu " }}}

" timer_start(400, TickColor(), {'repeat': 3}) )
"
" com -nargs=1 Question let g:banana='for you'
Question how do behave the function arguments? In all the cases of having bang or not, receiving range, etc
Todo check glaive
Note Maj.Min.Pat-(a,b,rc)XXXYYY pattern for software releases, as in https://semver.org/
Cnote exists(), tempname()
Todo look for chatter bot in vim
