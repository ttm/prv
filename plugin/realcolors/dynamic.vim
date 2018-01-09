function! InitializeDynamics()
  " to keep track of the tickers___:
  cal timer_stopall()
  let s:tickerids = []
endf
function! TickColor(timer)
  let s:anum = 0
  let s:tick = 1
  " default:
  " change some of the colors (of text and bg)
  " at the window in some patterns
  while s:tick == 1
    echo "banana =" s:anum
    let s:anum += 1
  endwhile
endfunc

function! StartTick()
  s:tickerids.push( timer_start(400, TickColor(), {'repeat': 3}) )
endfunction


""""""""""""""""""" {{{ Minimal Patterner
func! MyHandler(timer)
  echo 'Handler called' s:i
  let s:i += 1
endfunc
func! MyTimer(repeat, period)
  let s:i = 0
  let timer = timer_start(a:period, 'MyHandler',
        \ {'repeat': a:repeat})
  call add(s:timers, timer)
endfu
" }}}

"""""""""""" Don't Know {{{
" make a rhythm on numbers by updating a variable with list
" of numbers or patterns
"
" one calls the other to repeat n times.
" displacement/offset might be performed with repeat=1, period=silence)
" pattern(offset=2000, repeat=4, period=500)
func! MyHandler2(offset, timer, makeoffset)
  echo 'Handler called' s:counters
  if a:makeoffset == 1
    call MyHandler2(a:offset, 1, )
  let s:counters[i] += 1
endfunc

func! MyTimer2(offset, repeat, period)
  let timer = timer_start(a:period, 'MyHandler2',
        \ {'repeat': a:repeat, 'offset': a:offset, 'makeOffset': 1})
  call add(s:timers, timer)
endfu
" let s:pattern = s:MyTimer2
" }}}

""""""""""""""""""" {{{ Z-Patterner
fu! StandardPattern()
  let s:counters[s:ncounters] += s:ncounters
  let s:ncounters = (s:ncounters + 1) % len(s:counters)
endf

fu! BypassPattern()
  " for silence
  let foo = 'bar'
endf

fu! Pattern1(value)
  let s:counters[a:value] += a:value
endf

fu! WavePattern()
  call Voice(100, 20, 'std')
  call Voice(1, 1000, 'silence')
  call Voice(100, 20, 'std')
endf

function! Wobble(nlines)
  " Make curent line and next ones wobble
  let i = 0
  let mstart = system("echo $RANDOM")
  while i < nlines
    exec line('.')+i . 'center' 30+(i*1+mstart)%80
    let i += 1
  endwhile
endfunc

fu! PWobble()
  " let timer = timer_start(500, 'Wobble')
  " let timer = timer_start(500, 'Wobble',
  "      			\ {'repeat': a:repeat})
  call Voice(3, 200, 'Wobble(5)')
endf

fu! OverallPattern()
  call Voice(-1, 2000, 'PWobble')
endf


fu! MyHandler3(timerID)
  " a:timer is the number of repeats.
  " the duration is set by MyTimer3(timer=a:timer, duration=XXX)
  let foo = copy(s:counters)
  if !has_key(s:patterns, a:timerID)
    " call StandardPattern()
    cal BypassPattern()
  el
    exe s:patterns[a:timerID]
  en
  " let rand = system("echo $RANDOM")%len(s:counters)
  " echo [rand, len(s:counters)]
  " let s:counters[rand] += rand
  let bar = [s:ncounters, len(s:counters)]
  " echo bar 'Handler called' foo
  "     \ '\nHandler finished' s:counters ' ' a:timer
  ec bar 'Handler called' foo
      \ '\nHandler finished' s:counters ' ' a:timerID
endf

func! MyTimer3(repeats, duration, value)
  " timer is number of subsequent timer onsets
  " duration is period in ms
  " value is simpy not being used
  let timerID_ = timer_start(a:duration, 'MyHandler3',
        \ {'repeat': a:repeats})
  echo timerID_
  let s:patterns[timerID_] = "call Pattern1(". a:value .")"
  call add(s:timers, timerID_)
endfu
" let s:pattern = s:MyTimer3
"
"
" }}}

""""""""""""""""""" {{{ Z-Patterner2
fu! SporkVoice(timerID)
  " a:timer is the number of repeats.
  " the duration is set by MyTimer3(timer=a:timer, duration=XXX)
  let foo = copy(s:counters)
  if !has_key(s:patterns, a:timerID)
    " call StandardPattern()
    cal BypassPattern()
  el
    exe s:patterns[a:timerID]
  en
  " let rand = system("echo $RANDOM")%len(s:counters)
  " echo [rand, len(s:counters)]
  " let s:counters[rand] += rand
  let bar = [s:ncounters, len(s:counters)]
  " echo bar 'Handler called' foo
  "     \ '\nHandler finished' s:counters ' ' a:timer
  ec bar 'Handler called' foo
      \ '\nHandler finished' s:counters ' ' a:timerID
endf

fu! Voice(repeats, duration, patternID)
  " timer is number of subsequent timer onsets
  " duration is period in ms
  " value is simpy not being used
  let timerID_ = timer_start(a:duration, 'SporkVoice',
        \ {'repeat': a:repeats})
  echo timerID_
  if type(a:patternID) == 0
    let s:patterns[timerID_] = "call Pattern1(". a:value .")"
  elsei has_key(s:mpatterns, a:patternID)
    let s:patterns[timerID_] = s:mpatterns[a:patternID]
  else
    let s:patterns[timerID_] = 'call' a:patternID
  en
  call add(s:timers, timerID_)
endfu
" let s:pattern = s:MyTimer3
"
"
" }}}

