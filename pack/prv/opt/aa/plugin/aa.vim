" Vim plugin for periodic note-taking  {{{3
" Author: Renato Fabbri <renato.fabbri@gmail.com>
" Date: 2018 Fev 21 (when I wrote this header...)
" Installing:	:help aa-install 
" Usage:	:help aa
" Note: this plugin is part of the PRV framework,
"             check https://github.com/ttm/prv
" Goals: sharing of efforts, supporting distributed and asynchronous teamwork,
"     self-management, time management and automated documenting activities.
" Copyright: Public Domain

" Load Once: {{{3
if exists("g:loaded_aaplugin") && (exists("g:aa_not_hacking") || exists("g:prv_not_hacking_all"))
 fini
en
let g:loaded_aaplugin = "v0.02b"
let g:aa_dir = expand("<sfile>:p:h:h") . '/'
" let g:aa_default_leader = '<Space>'
" options:
" aux/ dir?
" aa_leader and aa_localleader
" say and saytime
" if !exists("g:loaded_prvplugin")
"   exe 'so ' . g:aa_dir . 'aux/prvdependence.vim'
" en

let g:aa_default_leader = ' a'

" MAPPINGS: {{{1
" -- g:aa_leader hack, part 1 of 2 {{{3
" let tleader = g:mapleader
" let tlocalleader = g:mapleader
let g:mapleader = ' a'
let g:maplocalleader = ' '
" -- for shouts {{{3
" shouting:
nn <leader>a :A<space>
nn <leader>A :exec "vs " . g:aa.paths.shouts<CR>Go<ESC>o<ESC>:.!date<CR>:put=g:aa.set.sep<CR>kki
" for accessing the aashouts.txt:
nn <leader>e :exec "e " . g:aa.paths.shouts<CR>G
nn <leader>v :exec "vs " . g:aa.paths.shouts<CR>G
nn <leader>t :exec "tabe " . g:aa.paths.shouts<CR>G
" for the time since last shout:
nn <leader>t :ec system('date')[:-2]<CR>
nn <leader><localleader>t :ec 'minutes since last shout: ' . ATimeSinceLastShout()<CR>
" -- for sessions {{{3
" starting a session:
nn <leader>s :Aa 15 8<space>
nn <leader>S :Aa 5 24<space>
nn <leader><localleader>s :Aa 30 4
" accessing aasessions.txt:
nn <leader>V :exec "vs " . g:aa.paths.sessions<CR>G
" for info on the session (time and left in the slot, іs session on): 
nn <leader>l :ec 'time left in slot: '.ATimeLeftInSlot()<CR>
nn <leader>L :ec 'time spent in slot: 'ATimeSpentInSlot()<CR>
nn <leader>o :ec 'AA session ongoing: '.AIsSessionOn()<CR>
" declare shout sent or request
nn <leader>r :cal ASessionRegisterShoutGiven()<CR>
nn <leader>R :cal ASessionRegisterShoutWanted()<CR>
nn <leader>u :cal AUpdateColorColumns()<CR>
" -- hacking {{{3
nn <leader>H :exec 'vs ' . g:aa.paths.aux<CR>
nn <leader>h :exec 'vs ' . g:aa.paths.aascript<CR>
nn <leader><localleader> :PRedir v ec g:aa
" this command does not find tags from other help files:
" nn <leader>H :exec 'vs ' . g:aa.paths.aadoc<CR>
" thus we use:
" NOT WORKING TTM :todo:
nn <leader>m :exe "vnew :map \<Space>a"<CR>:sort />A\zs/<CR>
" -- general {{{3
nn <leader>i :ec AInfo()<CR>
nn <leader> :ec AInfo()<CR>
nn <leader><localleader>i :cal AInit()<CR>
nn <leader>I :cal Ainit('force')<CR>
nn <leader>c :cal AClear()<CR>
nn <leader>C :cal AClear('force')<CR>

" COMMANDS: {{{3
com! -nargs=1 -complete=tag_listfiles A cal AShout(<q-args>)
" com! -nargs=1 -complete=customlist,AAutoComplete A call AShout(<q-args>)
com! -nargs=+ Aa cal AStartSession(<f-args>)
" the following are more easely accesses though :Ai
" FUNCTIONS: {{{1
" -- MAIN {{{2
fu! AShout(msg) " {{{3
  " each message should have the
  " date and time, the message,
  " and a final line separator
  cal AInit()
  let date = system("date")[:-2]

  let sep = g:aa.set.sep

  let mlines = [a:msg, l:date, l:sep]
  cal writefile(mlines, g:aa.paths.shouts, 'as')
  cal ASessionReceiveMsg()
  let g:aa.events.shouts_count += 1
  if g:aa.set.bot
    ec a:msg."\n-> ".BotTalk(a:msg)
    " ec "-> ".TPBotTalk(a:msg)
  el
    ec a:msg
  en
endf
fu! AStartSession(...) " {{{3
  " default duration = 15, ntimes = 8
  " message = 'Ding Dong Ding Dong'
  if AIsSessionOn()
    cal timer_stopall()
    let g:aa.events.session.shouts_expected = 0
    let g:aa.events.session.shouts_requested = 1
    let g:aa.events.session.nslots = 0
    ASessionReceiveMsg()
  en
  cal AInit()
  if a:0 > 0
    let dur = str2float(a:.1)
  el
    let dur = 15
  en
  if a:0 > 1
    let nslots = str2nr(a:.2)
  el
    let nslots = 15
  en
  let l:started = strftime("%c")
  let l:started_seconds = localtime()
  let g:aa.events.session = {'dur': l:dur, 'nslots': l:nslots, 'shouts_requested': 0, 'shouts_expected': 0, 'shouts_sent': 0, 'last_shout': {}, 'started': [l:started, l:started_seconds]}

  cal timer_start(float2nr(60.0*1000*l:dur), "AExpectMsg", {'repeat': l:nslots})
  cal AUpdateColorColumns()

  cal writefile(['', '', g:aa.set.ssep], g:aa.paths.shouts, 'as')
  cal writefile(['', '', 'started: '.system("date")[:-2],
                        \ 'dur: '.string(l:dur), 'slots: '.l:nslots],
               \ g:aa.paths.sessions, 'as')

  let g:rand = string(PRand())
  let g:aa.events.session.voices = [g:aa.set.voices[g:rand[2]], g:aa.set.voices[g:rand[3]]]
  cal AExpectMsg("notimerbind")
  let g:aa.events.session.on = 1
  if a:0 > 2
    let aamsg = join(a:000[2:], ' ')
    exe 'A '.l:aamsg
  en
endf
fu! AInit(...) " {{{3
  cal AInitVars()
endf
fu! AInfo() " {{{3
  let ml = AInfoLines()
  let ml2 = join(l:ml, "\n")
  retu l:ml2
endf " }}}
" -- UTILS {{{2
fu! AIsInitialized() " {{{3
  if exists("g:aa.events.on")
    retu 1
  el
    retu 0
  en
endf
fu! AIsSessionOn() " {{{3
  if exists("g:aa.events.session.on") && g:aa.events.session.on == 1
    retu 1
  el
    retu 0
  en
endf
fu! AClear(...) " {{{3
  if a:0 == 0
    let apass = input("are you sure you want to clear AA data? [y/N] ")
  el
    let apass = 'y'
  en
  if l:apass == 'y' || l:apass == 'Y'
    cal AUnInit()
  en
endf
fu! AUnInit() " {{{3
    if AIsInitialized()
      unl g:aa
    en
    cal timer_stopall()
    cal AUpdateColorColumns()
endf
fu! ATimeLeftInSlot() " {{{3
  let at = g:aa.events.session.dur*60 - (localtime() - g:aa.events.last_shout.request_seconds)
  retu ASecondsToTimestring(string(l:at))
endf
fu! ATimeSpentInSlot() " {{{3
  let at = localtime() - g:aa.events.last_shout.request_seconds
  retu ASecondsToTimestring(l:at)
endf
fu! ATimeSinceLastShout() " {{{3
  if !exists("g:aa.events.last_shout.sent_seconds")
    retu 'no shout has beed given since last AA startup'
  en
  let at = (localtime() - g:aa.events.last_shout.time[1])
  retu ASecondsToTimestring(l:at)
endf
fu! ASessionRegisterShoutGiven() " {{{3
  " let g:aa.cursession.shouts_requested += 1
  " let g:aa.cursession.shouts_expected -= 1
  cal AInit()
  cal ASessionReceiveMsg()
  let g:aa.events.shouts_count += 1
endf
fu! ATimeOfLastShout() " {{{3
  if exists("g:aa.events.last_shout.time")
    retu g:aa.events.last_shout.time[0]
  el
    retu 'no shout given yet'
  en
endf
fu! ASessionRegisterShoutWanted() " {{{3
  cal AExpectMsg('notimerbind')
endf
" -- AUX {{{2
fu! AInfoLines() " {{{3
  let mlines = ['~~ Info about (AA) Algorithmic Autoregulation ~~']
  cal AInit()
  cal add(l:mlines, '')
  cal add(l:mlines, 'initialized: '.g:aa.events.on)
  cal add(l:mlines, 'initialized time: '.g:aa.events.started[0])
  cal add(l:mlines, 'time since initialized: '.ASecondsToTimestring(localtime() - g:aa.events.started[1]))
  cal add(l:mlines, '| using speech: '.string(g:aa.set.say))
  cal add(l:mlines, '| using speech to say time: '.g:aa.set.saytime)
  cal add(l:mlines, 'user: '.g:aa.set.user)
  cal add(l:mlines, "\npaths: ".string(g:aa.paths))

  cal add(l:mlines, '')
  cal add(l:mlines, 'shouts sent since init: '.g:aa.events.shouts_count)
  cal add(l:mlines, 'time since last shout: '.ATimeSinceLastShout())
  cal add(l:mlines, 'last shout in: '.ATimeOfLastShout())
  cal add(l:mlines, '| shouts in current shouts.txt: '. ACountShoutsInFile())

  cal add(l:mlines, '')
  cal add(l:mlines, 'session on: '.AIsSessionOn())
  if AIsSessionOn()
    cal add(l:mlines, 'time left in current slot: '.ATimeLeftInSlot())
    cal add(l:mlines, 'time spent in current slot: '.ATimeSpentInSlot())
    cal add(l:mlines, 'slots finished: '.(g:aa.events.session.shouts_requested-1))
    cal add(l:mlines, '|| shouts expected: '.g:aa.events.session.shouts_expected)
    cal add(l:mlines, '|| shouts requested: '.g:aa.events.session.shouts_requested)
    
    let l:sextra = g:aa.events.session.shouts_sent - g:aa.events.session.shouts_requested
    let astr = '   (' . l:sextra . ' extra)'
    cal add(l:mlines, '|| shouts sent: '.g:aa.events.session.shouts_sent .l:astr)
    cal add(l:mlines, '|| minimum number of shouts in whole session: '.(g:aa.events.session.nslots+1))
    cal add(l:mlines, 'slot duration in minutes: '.string(g:aa.events.session.dur))
    cal add(l:mlines, 'number of slots: '.g:aa.events.session.nslots)
    cal add(l:mlines, '| total duration: '.ASecondsToTimestring(g:aa.events.session.nslots*60*float2nr(g:aa.events.session.dur)))
    cal add(l:mlines, '| session started at: '.(g:aa.events.session.started[0]))
    let at = localtime() - g:aa.events.session.started[1]
    cal add(l:mlines, '| in session for: '.ASecondsToTimestring(l:at))
  el
    cal add(l:mlines, '(start AA session to have more stats)')
  en
  cal add(l:mlines, '')
  cal add(l:mlines, 'more info in :h aa, the files in the paths above, and the script files.')
  retu l:mlines
endf
fu! ARunInAllWindows(acmd) " {{{3
  let wi = win_getid()
  tabd windo exec a:acmd
  cal win_gotoid(l:wi)
endf " }}}
fu! AUpdateColorColumns() " {{{
  if !exists("g:aa.events.session") || g:aa.events.session.shouts_expected <= 0
    setg colorcolumn=
    se colorcolumn<
    let acommand = 'setg colorcolumn='.&colorcolumn.' | set colorcolumn<'
    cal ARunInAllWindows(l:acommand)
  el
    let ref = 20
    exe 'setg colorcolumn=' . ref
    for i in range(g:aa.events.session.shouts_expected - 1)
      let g:aa.cccommand_ = 'setg colorcolumn+=' . (ref + (i+1)*2)
      exe g:aa.cccommand_
    endfo
    se colorcolumn<
    let g:aa.cccommand = 'setg colorcolumn='.&colorcolumn.' | set colorcolumn<'
    " tabdo windo exec g:aa.cccommand | windo set colorcolumn<
    cal ARunInAllWindows(g:aa.cccommand)
  en
endf
fu! AInitVars(...) " {{{3
  if a:0 > 0 || !exists('g:aa')
    let g:aa = { 'set': {'say': 2, 'saytime': 0, 'bot': 0},
          \'timers': [], 'paths': {}, 'events': {} }
    let g:aa.note = 'AA stuff should be kept in files. Keep this dictionary minimal.'

    let g:aa.set.sep = '-----'
    let g:aa.set.ssep = '$$$$$'
    let g:aa.set.voices = ['croak', 'f1', 'f2', 'f3', 'f4', 'f5', 'klatt', 'klatt2', 'klatt3', 'klatt4', 'm1', 'm2', 'm3', 'm4', 'm5', 'm6', 'm7', 'whisper', 'whisperf']
    if exists("g:aa_user")
      let g:aa.set.user = g:aa_user
    el
      let g:aa.set.user = 'anon-' . system("echo $RANDOM$RANDOM$RANDOM")
    en

    let g:aa.paths.aa_dir = g:aa_dir
    let g:aa.paths.aux = g:aa.paths.aa_dir . 'aux/'
    let g:aa.paths.shouts = g:aa.paths.aux . 'aashouts'
    cal system('touch '.g:aa.paths.shouts)
    let g:aa.paths.sessions = g:aa.paths.aux . 'aasessions'
    cal system('touch '.g:aa.paths.sessions)
    let g:aa.paths.aascript = g:aa.paths.aa_dir . 'plugin/aa.vim'
    let g:aa.paths.aadoc = g:aa.paths.aa_dir . 'doc/aa.txt'
    if !isdirectory(g:aa.paths.aux)
      let mkd = input("make directory " . g:aa.paths.aux . " ? (y/N)")
      if l:mkd ==? 'y'
        cal mkdir(g:aa.paths.aux, 'p')
      en
    en

    let g:aa.events.shouts_count = 0
    let g:aa.events.last_shout = {}
    let g:aa.events.started = [strftime("%c"), localtime()]
    let g:aa.events.on = 1
  en
endf
fu! ASecondsToTimestring(secs) " {{{3
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
    " let durline = l:hr.'h'.l:min.'m'.l:sec.'s'
    let durline = printf("%02dh%02dm%02ds", l:hr, l:min, l:sec)
  el
    let durline = printf("%02dm%02ds", l:min, l:sec)
  en
  retu l:durline
endf
fu! AExpectMsg(timer) " {{{3
  let g:aa.events.session.shouts_requested += 1
  let g:aa.events.session.shouts_expected += 1
  cal AUpdateColorColumns()
  cal ASay()
  let g:aa.events.last_shout.request_time = strftime("%c")
  let g:aa.events.last_shout.request_seconds = localtime()
endf " }}}
fu! ASay() " {{{3
  if g:aa.set.say == 1
    let pmsg = []
    cal add(l:pmsg, 'A.A.: finished slot: ' . (g:aa.events.session.shouts_requested-1)
          \ . 'of ' . g:aa.events.session.nslots)
    cal add(l:pmsg, 'A.A.: ' . g:aa.events.session.shouts_expected . ' shouts expected')
    if g:aa.set.saytime == 1
      cal add(l:pmsg, 'A.A.: current time and day is: ' . strftime("%T, %B, %d"))
    en
    let voices = []
    for i in l:pmsg
      cal add(l:voices, AMkVoice() . ' "' . i . '"')
    endfo
    let ef = g:aa.paths.aux . 'tempespeak'
    cal writefile(l:voices, l:ef)
    cal system('chmod +x ' . l:ef)
    cal job_start(l:ef)
    cal system('rm '.l:ef)
  elsei g:aa.set.say == 2
    let pmsg = []
    cal add(l:pmsg, (g:aa.events.session.shouts_requested-1)
          \ . 'of ' . g:aa.events.session.nslots)
    if g:aa.set.saytime == 1
      cal add(l:pmsg, 'A.A.: current time and day is: ' . strftime("%T, %B, %d"))
    en
    let voices = []
    for i in l:pmsg
      cal add(l:voices, AMkVoice() . ' "' . i . '"')
    endfo
    let ef = g:aa.paths.aux . 'tempespeak'
    cal writefile(l:voices, l:ef)
    cal system('chmod +x ' . l:ef)
    cal job_start(l:ef)
    cal system('rm '.l:ef)
  en
endf
fu! AMkVoice() " {{{3
    let voice = g:aa.events.session.voices[reltime()[1]%len(g:aa.events.session.voices)]
    let epk = 'espeak -a 50 -v' . l:voice
  retu l:epk
endf
fu! ASessionReceiveMsg() " {{{3
  if AIsSessionOn() && g:aa.events.session.shouts_expected > 0
    let g:aa.events.session.shouts_expected -= 1
    let g:aa.events.session.shouts_sent += 1
    cal AUpdateColorColumns()
    if (g:aa.events.session.nslots + 1 == g:aa.events.session.shouts_requested) && (g:aa.events.session.shouts_expected == 0)
      let g:aa.events.session.on = 0
      cal writefile([g:aa.set.ssep, '', ''], g:aa.paths.shouts, 'as')
      cal writefile(['ended: '.system("date")[:-2], '', ''], g:aa.paths.sessions, 'as')
    en
  en
  let g:aa.events.last_shout.time = [strftime("%c"), localtime()]
endf
fu! ACountShoutsInFile() " {{{3
  " count ^-----
  " readfile depois count
  let g:taafile = readfile(g:aa.paths.shouts)
  let g:aashoutcount = count(g:taafile, "-----")
  return g:aashoutcount
endf
fu! AAutoComplete(ArgLead, CmdLine, CursorPos) " {{{3
  " blend funtion, buffer names, augroup, color, command, dir, file, file-In_path, event, help, highlight, history, mapping, messages, option, packadd, syntax, tag, tag_listfiles, var
  let g:asd = a:
endf
" -------- notes {{{3
" Todo check glaive
" Cnote exists(), tempname()
" Todo look for chatter bot in vim
" -- final commands and file settings {{{3
cal AInit()
" vim:foldlevel=2:foldmethod=marker:
