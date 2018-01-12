" s:tickerids.push( timer_start(400, TickColor(), {'repeat': 3}) )

fu! InitializeAA()
  if !get(keys(s:), 'shouts')
    let s:shouts = []
  endif
  if !get(keys(s:), 'timers')
    let s:timers = []
  endif
endfu

fu! Shout(msg)
  " verbose of settings, use statistics, new entries, and a custom message.
  call InitializeAA()
  call add( s:shouts, msg )
endfu

fu! ChgBG()
  hi Normal guibg=black
endfu

fu! SetTimer(duration, message, ntimes)
  " default duration = 15, ntimes = 8
  " message = 'Ding Dong Ding Dong'
  call timer_start(a:duration*1000, "ChgBG")
endfu

com -nargs=1 Question let g:banana='for you'
Question how do behave the function arguments? In all the cases of having bang or not, receiving range, etc
proj +maktaba
todo check glaive
note Maj.Min.Pat-(a,b,rc)XXXYYY pattern for software releases, as in https://semver.org/
cnote exists(), tempname()
todo look for chatter bot in vim
