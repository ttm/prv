" Vim plugin for time management and automated documenting activities {{{3
" Author: Renato Fabbri <renato.fabbri@gmail.com>
" Date: 2018 Fev 21 (when I wrote this header...)
" Installing:	:help aa-install 
" Usage:	:help aaplug         
" Notes: * This plugin is part of the PRV framework, check https://github.com/ttm/prv
"        * check and hack also after/plugin/aastartup.vim
" Goals: sharing of efforts, supporting distributed and asynchronous teamwork,
" self-management.
" Copyright: Public Domain

" Load Once: {{{3
if exists("g:loaded_aaplugin") && (exists("g:aa_not_hacking") || exists("g:prv_not_hacking_all"))
 fini
en
let g:loaded_aaplugin = "v0.01b"
let g:aa_dir = expand("<sfile>:p:h:h") . '/'
" let g:aa_default_leader = '<Space>'
" options:
" aux/ dir?
" aa_leader and aa_localleader
" say and saytime
if !exists("g:loaded_prvplugin")
  exe 'so ' . g:aa_dir . 'aux/prvdependence.vim'
en

let g:aa_default_leader = 'A'
let g:aa_default_localleader = ''

" MAPPINGS: {{{1
" -- g:aa_leader hack, part 1 of 2 {{{3
PRVLeader d aa
" -- for shouts {{{3
" shouting:
nn <leader>a :A 
nn <leader>A :exec "vs " . g:aa.paths.shouts<CR>Go<ESC>o<ESC>:.!date<CR>:put =g:aa.separator<CR>kki
" for accessing the aashouts.txt:
nn <leader>e :exec "e " . g:aa.paths.shouts<CR>
nn <leader>v :exec "vs " . g:aa.paths.shouts<CR>G
nn <leader>t :exec "tabe " . g:aa.paths.shouts<CR>
" for the time since last shout:
nn <leader><localleader>t :As<CR>
nn <leader>T :ec system('date')[:-2]<CR>
" -- for sessions {{{3
" starting a session:
nn <leader>s :S 15 8
nn <leader>S :S 5 3
nn <leader><localleader>S :S 15 8 starting session (dummy message from aa plugin)<CR>
" accessing aasessions.txt:
nn <leader>V :exec "vs " . g:aa.paths.sessions<CR>G
" for info on the session (time and left in the slot, іs session on): 
nn <leader>l :At<CR>
nn <leader>L :AT<CR>
nn <leader>o :Ao<CR>
" declare shout sent or request
nn <leader><localleader>r :Ar<CR>
nn <leader><localleader>R :AR<CR>
nn <leader>u :Au<CR>:ec 'color columns updated'<CR>
" -- hacking {{{3
nn <leader>h :exec 'vs ' . g:aa.paths.aux<CR>
nn <leader>H :help aa<CR>`"
nn <leader><localleader>H :exec 'vs ' . g:aa.paths.aascript<CR>
nn <leader><localleader>h :exec 'vs ' . g:aa.paths.aaiscript<CR>
" this command does not find tags from other help files:
" nn <leader>H :exec 'vs ' . g:aa.paths.aadoc<CR>
" thus we use:
nn <leader>m :exe 'PRVRedir v :map '.g:prv.leaders.aa[0]<CR>:sort />A\zs/<CR>
" -- general {{{3
nn <leader>c :Ac<CR>
nn <leader>C :Ac y<CR>
nn <leader>i :Ai<CR>
nn <leader> :Ai<CR>
nn <leader><localleader>I :AI<CR>
nn <leader>r :PRVRedir v ec g:aa

" -- g:aa_leader hack, part 2 of 2 {{{3
PRVLeader r aa

" COMMANDS: {{{1
" -- MAIN: {{{3
com! -nargs=1 -complete=tag_listfiles A call AAShout(<q-args>)
" com! -nargs=1 -complete=customlist,AAAutoComplete A call AAShout(<q-args>)
com! -nargs=+ S call AAStartSession(<f-args>)
com! -nargs=* Ac call AAClear(<q-ar4jgs>)
com! Ai ec AAInfo()
com! AI call AAInit()
" -- UTILS: {{{3
com! Ar cal AASessionRegisterShoutGiven()
com! AR cal AASessionRegisterShoutWanted()
" the following are more easely accesses though :Ai
com! At ec 'time left in slot: '.AATimeLeftInSlot()
com! AT ec 'time spent in slot: 'AATimeSpentInSlot()
com! As ec 'minutes since last shout: ' . AATimeSinceLastShout()
com! Ao ec 'AA session ongoing: '.AAIsSessionOn()
com! Au cal AAUpdateColorColumns()
" FUNCTIONS: {{{1
" -- MAIN {{{2
fu! AAShout(msg) " {{{3
  " each message should have the
  " date and time, the message,
  " and a final line separator
  if !AAIsInitialized()
    cal AAInit()
  en
  let date = system("date")[:-2]

  let sep = g:aa.separator

  let mlines = [a:msg, l:date, l:sep]
  cal writefile(mlines, g:aa.paths.shouts, 'as')
  cal AASessionReceiveMsg()
  let g:aa.events.shouts_count += 1
  ec a:msg.' || '.BotTalk(a:msg)
endf
fu! AAStartSession(...) " {{{3
  " default duration = 15, ntimes = 8
  " message = 'Ding Dong Ding Dong'
  if !AAIsInitialized()
    cal AAInit()
  en
  if a:.0 > 0
    let dur = str2float(a:.1)
  el
    let dur = 15
  en
  if a:.0 > 1
    let nslots = str2nr(a:.2)
  el
    let nslots = 15
  en
  let g:aa.cursession = {'dur': l:dur, 'nslots': l:nslots, 'shouts_requested': 0, 'shouts_expected': 0, 'shouts_sent': 0, 'last_shout': {}, 'note': 'see g:aa.events'}
  ec "ok"
  cal timer_start(float2nr(60.0*1000*l:dur), "AAExpectMsg", {'repeat': l:nslots})
  let g:aa.session_on = 1
  " BufEnter		after entering a buffer
  cal AAUpdateColorColumns()
  " put two empty lines and a session separator
  cal writefile(['', '', g:aa.session_separator], g:aa.paths.shouts, 'as')
  cal writefile(['', '', 'started: '.system("date")[:-2],
                        \ 'dur: '.string(l:dur), 'slots: '.l:nslots],
               \ g:aa.paths.sessions, 'as')
  let g:aa.events.session_started = strftime("%c")
  let g:aa.events.session_started_seconds = localtime()
  cal AAExpectMsg("foo")
  if a:.0 > 2
    let aamsg = join(a:.000[2:], ' ')
    exe 'A '.l:aamsg
  en
endf
fu! AAInit() " {{{3
  cal AAInitVars()
  if !exists('g:aa.timers')
    let g:aa.timers = []
  en
  let g:aa.initialized = 1
endf
fu! AAInfo() " {{{3
  let ml = AAInfoLines()
  let ml2 = join(l:ml, "\n")
  retu l:ml2
endf " }}}
" -- UTILS {{{2
fu! AAIsInitialized() " {{{3
  if exists("g:aa.initialized")
    retu 1
  el
    retu 0
  en
endf
fu! AAIsSessionOn() " {{{3
  if exists("g:aa.session_on")
    retu 1
  el
    retu 0
  en
endf
fu! AAClear(...) " {{{3
  let g:acaa = a:
  if a:.1 == ''
    let apass = input("are you sure you want to clear AA data? [y/N] ")
  el
    let apass = 'y'
  en
  if l:apass == 'y' || l:apass == 'Y'
    " au! aaPlug
    if exists("g:aa")
      unl g:aa
      unl g:AA_dict
    en
    cal timer_stopall()
    cal AAUpdateColorColumns()
  en
endf
fu! AATimeLeftInSlot() " {{{3
  let at = g:aa.cursession.dur*60 - (localtime() - g:aa.events.last_shout.request_seconds)
  retu AASecondsToTimestring(string(l:at))
endf
fu! AATimeSpentInSlot() " {{{3
  let at = localtime() - g:aa.events.last_shout.request_seconds
  retu AASecondsToTimestring(l:at)
endf
fu! AATimeSinceLastShout() " {{{3
  if !exists("g:aa.events.last_shout.sent_seconds")
    retu 'no shout has beed given since last AA startup'
  en
  let at = (localtime() - g:aa.events.last_shout.sent_seconds)
  retu AASecondsToTimestring(l:at)
endf
fu! AASessionRegisterShoutGiven() " {{{3
  " let g:aa.cursession.shouts_requested += 1
  " let g:aa.cursession.shouts_expected -= 1
  if !AAIsInitialized()
    cal AAInit()
  en
  cal AASessionReceiveMsg()
  let g:aa.events.shouts_count += 1
endf
fu! AATimeOfLastShout() " {{{3
  if exists("g:aa.events.last_shout.time")
    retu g:aa.events.last_shout.time
  el
    retu 'no shout given yet'
  en
endf
fu! AASessionRegisterShoutWanted() " {{{3
  cal AAExpectMsg('foobar')
endf
" -- AUX {{{2
fu! AAInfoLines() " {{{3
  let mlines = ['== Info about AA ==']
  if !AAIsInitialized()
    cal add(l:mlines, 'AA has not been initialized... Initialing.')
    cal AAInit()
    cal add(l:mlines, 'AA initialized ok.')
  en
  cal add(l:mlines, '')
  cal add(l:mlines, 'initialized: '.g:aa.initialized)
  cal add(l:mlines, 'initialized time: '.g:aa.events.aa_initialized)
  cal add(l:mlines, 'time since initialized: '.AASecondsToTimestring(localtime() - g:aa.events.aa_initialized_seconds))
  cal add(l:mlines, '| using voices: '.string(g:aa.voices))
  cal add(l:mlines, '| using voice to say time: '.g:aa.saytime)
  cal add(l:mlines, 'user: '.g:aa.user)
  cal add(l:mlines, 'paths: '.string(g:aa.paths))

  cal add(l:mlines, '')
  cal add(l:mlines, 'shouts sent since init: '.g:aa.events.shouts_count)
  cal add(l:mlines, 'time since last shout: '.AATimeSinceLastShout())
  cal add(l:mlines, 'last shout in: '.AATimeOfLastShout())
  cal add(l:mlines, '| shouts in current shouts.txt: '. AACountShoutsInFile())

  cal add(l:mlines, '')
  cal add(l:mlines, 'session on: '.AAIsSessionOn())
  if AAIsSessionOn()
    cal add(l:mlines, 'time left in current slot: '.AATimeLeftInSlot())
    cal add(l:mlines, 'time spent in current slot: '.AATimeSpentInSlot())
    cal add(l:mlines, 'slots finished: '.(g:aa.cursession.shouts_requested-1))
    cal add(l:mlines, '|| shouts expected: '.g:aa.cursession.shouts_expected)
    cal add(l:mlines, '|| shouts requested: '.g:aa.cursession.shouts_requested)
    
    let l:sextra = g:aa.cursession.shouts_sent - g:aa.cursession.shouts_requested
    let astr = '   (' . l:sextra . ' extra)'
    cal add(l:mlines, '|| shouts sent: '.g:aa.cursession.shouts_sent .l:astr)
    cal add(l:mlines, '|| minimum number of shouts in whole session: '.(g:aa.cursession.nslots+1))
    cal add(l:mlines, 'slot duration in minutes: '.string(g:aa.cursession.dur))
    cal add(l:mlines, 'number of slots: '.g:aa.cursession.nslots)
    cal add(l:mlines, '| total duration: '.AASecondsToTimestring(g:aa.cursession.nslots*60*float2nr(g:aa.cursession.dur)))
    cal add(l:mlines, '| session started at: '.(g:aa.events.session_started))
    let at = localtime() - g:aa.events.session_started_seconds
    cal add(l:mlines, '| in session for: '.AASecondsToTimestring(l:at))
  el
    cal add(l:mlines, '(start AA session to have more stats)')
  en
  cal add(l:mlines, '')
  cal add(l:mlines, 'more info in :h aa, the files in the paths above, and the script files.')
  retu l:mlines
endf
fu! AARunInAllWindows(acmd) " {{{3
  let wi = win_getid()
  tabd windo exec a:acmd
  cal win_gotoid(l:wi)
endf " }}}
fu! AAUpdateColorColumns() " {{{
  if !exists("g:aa.cursession") || g:aa.cursession.shouts_expected <= 0
    setg colorcolumn=
    se colorcolumn<
    let acommand = 'setg colorcolumn='.&colorcolumn.' | set colorcolumn<'
    cal AARunInAllWindows(l:acommand)
  el
    let ref = 20
    exe 'setg colorcolumn=' . ref
    for i in range(g:aa.cursession.shouts_expected - 1)
      let g:aa.cccommand_ = 'setg colorcolumn+=' . (ref + (i+1)*2)
      exe g:aa.cccommand_
    endfo
    se colorcolumn<
    let g:aa.cccommand = 'setg colorcolumn='.&colorcolumn.' | set colorcolumn<'
    " tabdo windo exec g:aa.cccommand | windo set colorcolumn<
    cal AARunInAllWindows(g:aa.cccommand)
  en
endf
fu! AAInitVars() " {{{3
  let g:aa = {}
  let g:AA_dict = g:aa
  let g:aa.note = 'AA stuff should be kept in files. Keep this dictionary minimal.'
  " let g:aa.say = 0
  " let g:aa.saytime = 0
  let g:aa.say = 1
  let g:aa.saytime = 1
  let g:aa.paths = {}
  let g:aa.paths.aa_dir = g:aa_dir
  let g:aa.paths.aux = g:aa.paths.aa_dir . 'aux/'
  if !isdirectory(g:aa.paths.aux)
    let mkd = input("make directory " . g:aa.paths.aux . " ? (y/N)")
    if l:mkd == 'y' || l:mkd == 'Y'
      cal mkdir(g:aa.paths.aux, 'p')
    en
  en
  " mkdir if necessary
  let g:aa.paths.shouts = g:aa.paths.aux . 'aashouts.txt'
  let g:aa.paths.sessions = g:aa.paths.aux . 'aasessions.txt'
  let g:aa.paths.aascript = g:aa.paths.aa_dir . 'plugin/aa.vim'
  let g:aa.paths.aaiscript = g:aa.paths.aa_dir . 'after/plugin/aastartup.vim'
  let g:aa.paths.aadoc = g:aa.paths.aa_dir . 'doc/aa.txt'
  if exists("g:aa_user")
    let g:aa.user = aa_user
  el
    let g:aa.user = 'anon-' . system("echo $RANDOM$RANDOM$RANDOM")
  en

  let g:aa.events = {}
  let g:aa.events.aa_initialized = strftime("%c")
  let g:aa.events.aa_initialized_seconds =localtime()
  let g:aa.events.last_shout = {}
  let g:aa.events.shouts_count = 0

  " let g:aa.separator = '----- QWEEWQPOIIOPTYUUTYREWWRE AA separator -----'
  let g:aa.separator = '-----'
  let g:aa.session_separator = '$$$$$'

  let g:aa.msgs = {}

  let g:aa.voices = ['croak', 'f1', 'f2', 'f3', 'f4', 'f5', 'klatt', 'klatt2', 'klatt3', 'klatt4', 'm1', 'm2', 'm3', 'm4', 'm5', 'm6', 'm7', 'whisper', 'whisperf']
endf
fu! AASecondsToTimestring(secs) " {{{3
  let g:coisa = a:secs
  if type(a:secs) ==  1
    let s = str2float(a:secs)
  elsei type(a:secs) == 0
    let s = 1.0*a:secs
  en
  cal assert_equal(type(l:s), 5)
  let hr = float2nr(l:s/(60*60))
  let min = float2nr(l:s/60 - l:hr*60)
  let sec = float2nr(l:s - l:min * 60 - l:hr*60*60)
  if hr > 0
    let durline = l:hr.'h'.l:min.'m'.l:sec.'s'
  el
    let durline = l:min.'m'.l:sec.'s'
  en
  retu l:durline
endf
fu! AAExpectMsg(timer) " {{{3
  let g:aa.cursession.shouts_requested += 1
  let g:aa.cursession.shouts_expected += 1
  cal AAUpdateColorColumns()
  let pmsg = []
  if g:aa.say == 1
    cal add(l:pmsg, 'A.A.: finished slot: ' . (g:aa.cursession.shouts_requested-1)
          \ . 'of ' . g:aa.cursession.nslots)
    cal add(l:pmsg, 'A.A.: 1 more shout expected. Total of ' . g:aa.cursession.shouts_expected)
    if g:aa.saytime == 1
      cal add(l:pmsg, 'A.A.: current time and day is: ' . strftime("%T, %B, %d"))
    en
    cal AASay(l:pmsg)
  en
  let g:aa.events.last_shout.request_time = strftime("%c")
  let g:aa.events.last_shout.request_seconds = localtime()
  " Make sound"
endf " }}}
fu! AASay(phrases) " {{{3
  let voices = []
  for i in a:phrases
    cal add(l:voices, AAMkVoice() . ' "' . i . '"')
  endfo
  let ef = g:aa.paths.aux . 'tempespeak'
  cal writefile(l:voices, l:ef)
  cal system('chmod +x ' . l:ef)
  cal job_start(l:ef)
  cal system('rm '.l:ef)
endf
fu! AAMkVoice() " {{{3
    let voice = g:aa.voices[reltime()[1]%len(g:aa.voices)]
    let epk = 'espeak -v' . l:voice
  retu l:epk
endf
fu! AASessionReceiveMsg() " {{{3
  if exists("g:aa.session_on") && g:aa.cursession.shouts_expected > 0
    let g:aa.cursession.shouts_expected -= 1
    let g:aa.cursession.shouts_sent += 1
    cal AAUpdateColorColumns()
    if (g:aa.cursession.nslots + 1 == g:aa.cursession.shouts_requested) && (g:aa.cursession.shouts_expected == 0)
      unl g:aa.session_on
      cal writefile([g:aa.session_separator, '', ''], g:aa.paths.shouts, 'as')
      cal writefile(['ended: '.system("date")[:-2], '', ''], g:aa.paths.sessions, 'as')
    en
  en
  let g:aa.events.last_shout.time = strftime("%c")
  let g:aa.events.last_shout.sent_seconds = localtime()
endf
fu! AACountShoutsInFile() " {{{3
  " count ^-----
  " readfile depois count
  let g:taafile = readfile(g:aa.paths.shouts)
  let g:aashoutcount = count(g:taafile, "-----")
  return g:aashoutcount
endf
fu! AAAutoComplete(ArgLead, CmdLine, CursorPos) " {{{3
  " blend funtion, buffer names, augroup, color, command, dir, file, file-In_path, event, help, highlight, history, mapping, messages, option, packadd, syntax, tag, tag_listfiles, var
  let g:asd = a:
endf
" -------- notes {{{3
" Todo check glaive
" Cnote exists(), tempname()
" Todo look for chatter bot in vim
" -- final commands and file settings {{{3
if !AAIsInitialized()
  cal AAInit()
en
" vim:foldlevel=2:
