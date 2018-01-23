" ->prv: template autocomplete
com! -complete=custom,ListUsers -nargs=1 Finger !finger <args>
fun! ListUsers(A,L,P)
    return system("cut -d: -f1 /etc/passwd")
endfun

fu! Start() " {{{
  " Run to start using notes
  call ResetAll()
  call StartNotes()
  " Use the functions defined by g:note_classes
  " remove items with e.g. :unlet todos['todo00004']
endfu " }}}

call Start()
" select a block of code an write  to run it
let @r = ":@*\<CR>"
" when inside a function, look for function limits and run it
let @f = "mf?^fu\<CR>V/^endf\<CR>:@*\<CR>`f"
" run current line (Not working!)
let @l = "Y:@\"\<CR>"

Todo understand double quotes for defining strings
Todo make prv vars persistent

fu! StartNotes() " {{{
  " Or recover them from somewhere (load from txt files?)
  let g:user = 'hybrid'
  let g:note_classes = ['note', 'todo', 'cnote', 'idea', 'aa', 'synonym', 'curproj', 'description', 'question', 'music']
  for c in g:note_classes
    let c_ = toupper(c[0]) . c[1:]
    echo c_ c
    exec 'com! -nargs=1' c_ 'call RegisterNote("<args>","' . c . '")'
  endfor
  let g:last_noteid = v:none
endfu " }}}

fu! RegisterNote(msg, nname) " {{{
  " Register notes, ideas, todos, cnotes, etc.
  " msg is the note and nname is the class of the note
  " (todo, note, idea, etc)
  echo a:nname a:msg
  if a:msg == 'reset-itself'
    unlet g:[a:nname . 's']
    unlet g:[a:nname . 's_']
    unlet g:[a:nname . '_counter']
    return
  endif
  if !has_key(g:, a:nname . 's')
    let g:[a:nname . 's'] = {}
    let g:[a:nname . 's_'] = []
    let g:[a:nname . '_counter'] = 0
  endif
  let ndict = {}
  let ndict['datetime'] = strftime("%c")
  let ndict['user'] = g:user
  let ndict['msg'] = a:msg
  let ndict['last'] = g:last_noteid
  " let context = []
  " for c in g:note_classes
  "   if has_key(g:, c . 's_')
  "     call add(context, g:[c . 's_'][-1])
  "   endif
  " endfor

  let noteid = printf("%05d", g:[a:nname . '_counter'])
  let g:[a:nname . '_counter'] += 1

  let g:last_noteid = a:nname . noteid
  let g:[a:nname . 's'][noteid] = ndict
  call add(g:[a:nname . 's_'], noteid)
endfu " }}}

fu! ResetAll() " {{{
  if !exists('g:note_classes')
    return
  endif
  for c in g:note_classes
    if has_key(g:, c . 's')
      unlet g:[c . 's']
    endif
    if has_key(g:, c . 's_')
      unlet g:[c . 's_']
    endif
    if has_key(g:, c . '_counter')
      unlet! g:[c . '_counter']
    endif
    let c_ = toupper(c[0]) . c[1:]
    exec 'delcom' c_
  endfor
  unlet g:note_classes
endfu " }}}

fu! AllNotes() " {{{
  let fstring = ''
  for c in g:note_classes
    if has_key(g:, c . 's')
      let fstring .= "------> " . c . "s:" . "\n"
      let n = c . 's'
      for note in g:[c . 's_']
        let fstring .= g:[n][note] . ' || before:' . string(g:[n][note . '_last']) . "\n"
        echo type(g:[n][note .  '_datetime'] )
        echo type(g:[n][note . '_user'])
        let fstring .= g:[n][note .  '_datetime'] . ' ' . g:[n][note . '_user'] . "\n\n"
      endfor
      let fstring .= "==========\n"
    endif
  endfor
  let g:fstring = fstring
  vs foo
  setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
  put! =fstring
endfu " }}}
let g:prv_vimpath = expand('%:p:h')
fu! DumpNotes() " {{{
  " write them to data/<name>.prv
  " just source them to read
  for c in g:note_classes
    if has_key(g:, c . 's')
      " unlet g:[]
      " write g:[c . 's'] to data/c . 's.prv'
      let tline = "let g:" . c . 's = ' . string(g:[c . 's'])
      let tfile = g:prv_vimpath . '/data/' . c . 's.prv'
      call writefile([tline], tfile, 'as')
    endif
  endfor
endfu " }}}

fu! DownNotes() " {{{
  py3 import pymongo
  py3 client = pymongo.MongoClient("mongodb://labmacambira:macambira00@ds153577.mlab.com:53577/prv")
  " py3 notes = client.aaserver.shouts.find({}, {"_id": 0}).sort([(u'_id', -1), ])
  py3 notes = client.prv.notes.find({}, {"_id": 0}).sort([(u'_id', -1), ])
  let g:ad = {}
  py3 d = vim.bindeval('g:ad')
  py3 d['all'] = notes
endfu " }}}

fu! UpNotes() " {{{
  " write them to the cloud.
  " For now a mongodb
  py3 import pymongo
  py3 client = pymongo.MongoClient("mongodb://labmacambira:macambira00@ds153577.mlab.com:53577/prv")
  for c in g:note_classes
    if has_key(g:, c . 's')
      " unlet g:[]
      " write g:[c . 's'] to data/c . 's.prv'
      " client.prv.notes.insert({"time":now,"nick":nick,"shout":shout})
      py3 dd = {'note_class' : vim.eval("c . 's'")}
      for kk in keys(g:[c . 's'])
        let aval = g:[c . 's'][kk]
        py3 dd[vim.eval('kk')] = vim.eval('aval')
      endfor
      " py3 client.prv.notes.insert({"note_class": vim.eval("c . 's'"), "note": vim.bindeval('g:[c . "s"]')})
      " translate the dict to RDF?
      " Or send each note through SparQL?
      py3 client.prv.notes.insert(dd)
          
      " let tline = "let g:" . c . 's = ' . string(g:[c . 's'])
      " let tfile = g:prv_vimpath . '/data/' . c . 's.prv'
      " call writefile([tline], tfile, 'as')
    endif
  endfor
endfu " }}}

fu! LoadNotes() " {{{
  " Just read the last line of each existing file in ./data/*
  " that match a name in g:color_classes or whatnot
  " for now that is it.
  for c in g:note_classes
    let tfile = g:prv_vimpath . '/data/' . c . 's.prv'
    if filereadable(tfile)
      echo tfile
      let g:tline = readfile(tfile, '', -1)
      let g:c = c
      exec substitute(g:tline[0], c, c . 'ABAB', '')
    endif
  endfor
endfu " }}}

"""""" Notes {{{
Note musical instrument to play with hands like the hand 


" com! -nargs=2
Note :setl for the buffer (or window?) :doautoall for non-local all-the-buffers. Sometimes the command is by standard local (set) or global (au).

Note make permanent notes (as wanted by ric/v1z)  by using dataworld or datahub
Note as in l1255 /usr/local/share/vim/vim80/doc/map.txt, 

Synonym vimL, vimScript
Cnote let @a = printf('l%s %s', line('.'), expand('%'))
Cnote let aa = readfile( expand('%')) | pu =aa[19:25]

Note debugging vim: scriptease, google vroom (neovim), vader, vspec, :h debug-scripts, Decho

Note colors of orixas
Todo integrate dictionary and synonyms into vim http://www.thesaurus.com/browse/synonym

Description remove accents
Cnote s/[[=a=]]/a/g|s/[[=e=]]/e/g|s/[[=i=]]/i/g|s/[[=o=]]/o/g|s/[[=u=]]/u/g

Todo learn bash decently and make some gadgets / models to help with prv

Curproj AI
Todo make the todo function which takes note of anything written.
Todo look at :h getline()

Todo the key with which an entry is registered is then used to make further notes (date, username, file in which it was found, etc)

Todo make the basic functions

Question how to deal with funcref

Question how to make vim, python and rdf variables and settings persistent?

Todo make the function to source any vim, python or rdf file and deal with the pragmas, load vars to correct namespace, run silently or open term when

Todo make possible to take notes as above but as comments


Note vim might interact with python in various ways
Note python might be called as a filter :<,>!python3
Note python might be called through vim python functions
Note python might be called to run only one or inside a current ipython instance
Todo deal with the last three notes doing custom functions and commands
Todo make syntax files for prv files in order e.g. for them to recognize that anything in front of note, todo, idea, etc is a string, a constant
Todo recover the cri ideas as a way to better integrate system and files to rdf
" }}}


""""""""""""""" Enhance these: {{{
" 
" commands: ac[complish]
" rus[h], par[se], ad[minister],
fu! SourceSelection()
  let ext =  expand("%:e")
  "normal y:@"<CR>
  if ext == 'vim'
    normal :@*<CR>
  elseif ext == 'py'
    normal :python3 @*<CR>
  endif
endfu

fu! FindVar(varname, v, g, s, l, w, b)
  let g:findthem = 'yes'
endfu


let aa = 'test'
let aa2 = 'test2'
let aa23 = 'test3'

let found = FindVar('aa', v:, g:, s:, v:none , w:, b:)  " :l
" }}}


fu! PersistVars() " {{{
  let g:ALL = g:
  let g:Allasdpoi = g:
  let g:Anum = 5
  call SaveNewSession()
endfu " }}}

Todo make data.world connection to this data as the way to make it persistent

function! SaveVariable(var, file)
    call writefile([string(a:var)], a:file)
endfun
function! ReadVariable(file)
    let recover = readfile(a:file)[0]
    " it is so far just a string, make it what it should be:
    execute "let result = " . recover
    return result
endfun
" use with:
" call SaveVariable(anyvar, "safe.vimData")
" let restore = ReadVariable("safe.vimdata")
"
let god_names = ['deus', 'god', 'mavutsinim', 'zeus', 'krishna', 'olorum', 'universo', 'tudo', 'papai do céu', 'senhor', 'pai supermo', 'mãe criadora']

fu! StartChatter() " {{{
  let curdir = expand("%:p:h")
  echo curdir
  echo curdir . '/VimChatBot'
  if !isdirectory(curdir . '/VimChatBot')
    let acom = '!git clone https://github.com/ttm/VimChatBot.git ' .  curdir . '/VimChatBot'
    exec acom
  endif
  exec 'source ' . curdir . '/VimChatBot/plugin/VimChatBot.vim'
endfu " }}}

" Notes {{{
" :Note uma música pode ser baseada em 1 ou 3 palavras repetidas (indígena iawanawá etc), frases inteiras (xamanismo gideon), estrofes com ou sem refrão (música pop e de igreja e santo daime), ou apenas materiais de ritmo, melodia e harmonia (e.g. fuga, prelúdio, ou compostos (canon, hickup, etc). Quais equivalências cíclicas ou contínuas são mantidas com que parâmetros da música é uma forma de definir a música.
" :
" :Note - e.g.: ruído com freq central em random walk,
" :      \ o ciclo é tanto 1 (a cada iteração ele repete o passo aleatório)
" :      \ quanto infinito pois se deixar para sempre, não será encontrado
" :      \ padrão que permaneça por suficientes períodos de si próprio.
" :
" :
" :Note markdown/RDF, não só rdf p prv
" :
" :Todo suíte shenkeriana: começa com 3 notas: T D T, q viram acordes, que vão sendo expandidos com notas e estruturas de passagem, mais e mais. Vira rondó, depois dança de suíte barroca: T D :][: D T :]. Vira sonata e tvz preludio.
" :
" :Todo apenas uma peça de material. Aí uma penca de noturnos, prelúdios, suítes, fugas, sobre a peça. Isso chega a 1 album simples ou duplo.
" :
" :Todo peça em homenagem a algum compositor ou pesquisador em física ou matemática ou computação.
" :
" :Todo alg que usa +- a estrutura em https://youtu.be/Mnh3YWarFVE?t=10m39s e permite setar a diversidade e ciclos em diferentes escalas.
" :
" :Todo find out why ChgColor set out of loop all the sudden
" :
" :Cnote r !date +\%d/\%h/\%y,\ \%H:\%\M:\%S
" :
" :Todo exercises in vim for the newbie: repeat commands for doing stuff, copy scripts, then do their own.
" :
" :Music hrvatsky
" :"
" :Todo use L_ V__ VS__ and other advanced sound functions to make notes. A Timbre (or intrument or preset) should vary along durations of the note and along the pitch. Make the oscilations have peaks along the note to make a dubstep and or trap bass.
" :
" :Todo make python function to run just the header, and maybe all import statements
" :
" :Todo: make cs using tints, shades and tones
" :
" :Todo: show new aa shouts to the user. Make the connection with data.world
" :
" :Todo: treinar o bot com palavras e sentencas.  Depois fazer aprendizado por reforco nos paragrafos. Depois em textos completos com texto e assinatura. Generos: narrativa, cronica, carta?
" :
" :Todo: escrever p Cristina.  Contar do esquema de cores e rotina q estou mantendo.
" :
" :Note consider the von Restorff effect (isoletion effect)
" :
" :Note ppl prefer palletes with similar colors but like things best when in contrasting accent colors?
" :http://www.sciencedirect.com/science/article/pii/S1057740810000793
" :https://link.springer.com/article/10.3758%2Fs13414-010-0027-0
" :
" :Todo prv chat rooms (or communication channels) by colors: yellow channel, blue etc... To enable ppl to develop ideas around that color and express in accordance.
" :
" :Todo give fancy names to the colors https://www.helpscout.net/blog/psychology-of-color/ http://onlinelibrary.wiley.com/doi/10.1002/mar.20142/abstract
" :
" :Todo use passive bubblegum pink cs to calm down http://www.nytimes.com/1982/10/19/science/color-has-a-powerful-effect-on-behavior-researchers-assert.html?pagewanted=all
" :
" :Todo look for passive pink and for photobiology and chromoterapy and Faber Birren and Alexander Schauss and Harold Wohlfarth
" :
" :Todo ver jung e cores
" :
" :Todo fazer cs com cores ouro e outras com core prata
" :
" :Todo make +- stimulant button going from warm red to cold blue or green 
" :Let the user choose which tone is more relaxing: green or blue and in which tone.
" :And the more stimulant: orange, red or yellow and in which tone.
" :
" :Note o borogoto eh mais redondo e a borotega eh mais esticada. Sao brinquedos sexuais d@ prv
" :
" :Todo conseguir um fone fmz (caaso?)
" :
" :Todo: see psychopy to make experiments
" :
" :Todo see the argyll and dispcalgui for monitor calibration, see dynare for economic models, power-calibrate for processors
" :
" :Note prv é perva. Ela interage com tudo e gera cria sempre. Ela tb mistura esperma de vários interagentes, de várias interações, para gerar crias híbridas.
" :
" :Todo cs que usa os bastonetes (rods) nao os cones.
" :
" :Todo cs on human skin tones: https://en.wikipedia.org/wiki/Color_wheel#/media/File:Human_Color_Wheel_by_Neil_Harbisson.jpg
" :
" :Cnote :earlier, <C-X> p decrementar numero, :.!date p data na mesma linha
"
" :Todo study https://cloud.ontotext.com to see if really we might
" have a SparQL endpoint with IO and how

" :Todo make a backup scheme to download the mongodb database or at
" least the entries related to the user.
"
"

" }}}
