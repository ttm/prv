" Vim plugin for bots {{{3
" Author: Renato Fabbri <renato.fabbri@gmail.com>
" Date: 2018 Apr 09 (when I wrote this header...)
" Installing:	:help bot-install 
" Usage:	:help botplug         
" Notes: * This plugin is part of the PRV framework, check https://github.com/ttm/prv
"        * check and hack also after/plugin/botstartup.vim
" Goals: enabling bots to give insights with specific training and corpus
" Copyright: Public Domain

" Load Once: {{{3
if exists("g:loaded_botplugin") && (exists("g:bot_not_hacking") || exists("g:prv_not_hacking_all"))
 fini
en
let g:loaded_botplugin = "v0.01b"
let g:bot_dir = expand("<sfile>:p:h:h") . '/'

let g:bot_default_leader = 'B'
let g:bot_default_localleader = ''

" FUNCTIONS: {{{1
" -- MAIN {{{2
fu! BotsInitialize() " {{{
  let g:bot = {'paths': {}}
  let g:bot.paths.dialogs = g:bot_dir . 'aux/dialogs.txt'
  let g:bot.sentlen = '2-35'
  let g:bot.nmsgs = 6.7
  let g:bot.paths.corpus = g:bot_dir . 'plugin/b0t/corpus/'
  py3 cdir = vim.eval('g:bot.paths.corpus')
python3 << EOF
import b0t, random
bots = {}
bots['peter'] = b0t.baselineBotFromText("/home/renato/repos/joyce/corpus/1peter.txt", 'Peter')
bots['john' ] =  b0t.baselineBotFromText("/home/renato/repos/joyce/corpus/1john.txt", 'John')
bots['james'] = b0t.baselineBotFromText("/home/renato/repos/joyce/corpus/james.txt", 'James')

bots['pedro'] = b0t.baselineBotFromText(cdir + "pedro1.txt", 'Pedro')
bots['joao'] = b0t.baselineBotFromText( cdir + "joao1.txt", 'João')
bots['tiago'] = b0t.baselineBotFromText(cdir + "tiago.txt", 'Tiago')

bots['srila'] = b0t.baselineBotFromText("/home/renato/.vim/pack/ttm/opt/aa/aux/aashouts.txt", 'Srila')
bots['zer@'] = b0t.baselineBotFromText( cdir + "butlerPreciado2.txt", 'Zer@')
bots['laila'] = b0t.baselineBotFromText(cdir + "laila.txt", 'Laila Kaiabi Manuelle')

bots['lula'] = b0t.baselineBotFromText( cdir + "lula.txt", 'Luís Inácio Lula da Silva')
bots['dilma'] = b0t.baselineBotFromText(cdir + "dilma.txt", 'Dilma Vana Rousseff')
bots['fhc'] = b0t.baselineBotFromText(  cdir + "fhc.txt", 'Fernando Henrique Cardoso')

bots['morss'] = b0t.baselineBotFromText(cdir + "buckMorss.txt", 'Susan Buck-Morss')
# bots['butler'] = b0t.baselineBotFromText(cdir + "buttler.txt", 'Susan Buck-Morss')
# bots['preciado'] = b0t.baselineBotFromText(cdir + "preciado.txt", '')
# bots['haraway'] = b0t.baselineBotFromText(cdir + "buckMorss.txt", 'Donna Haraway')
# bots['shiva'] = b0t.baselineBotFromText(cdir + "buckMorss.txt", 'Susan Buck-Morss')

# achar autores africanos e orientais TTM

b = bots['srila']
# dbots = ['srila', 'tiago', 'joao', 'pedro', 'zer@']
dbots = ['pedro', 'joao', 'tiago', 'srila', 'zer@']
# dbots = ['srila', 'tiago', 'joao', 'pedro', 'zer@', 'preciado', 'butler', 'bock mors', 'etc', 'shakespeare', 'lula']
EOF
endf " }}}
fu! BotTalk(string) " {{{
  let tokens = split(a:string, ' ')
  let cmd = 'b.markovTalk("'.a:string.'")'
  py3 b.lastmsg = b.id + ': ' + eval(vim.eval('l:cmd'))
  cal BotDialogAdd(a:string, py3eval('b.lastmsg'))
  retu py3eval('b.lastmsg')
endf " }}}
fu! BotConference(...) " {{{
  let g:bot.confmsgs = []
  if a:0 == 0
    ec 'starting user-asks conference'
    cal BotConferenceUserAsks()
  elsei a:1 == 'a'
    if a:0 > 1
      cal BotConferenceAuto(join(a:000[1:], ' '))
    el
      cal BotConferenceAuto()
    en
  en
endf " }}}
" -- AUX {{{2
fu! BotDialogAdd(...) " {{{
  let asd = a:
  " maybe replace \n by \r because o last paragraph of :h writefile()
  cal writefile(['','$$$$$ ::: '.system('date')[:-2]], g:bot.paths.dialogs, 'as')
  cal writefile( a:000, g:bot.paths.dialogs, 'as')
endf " }}}
fu! BotSetDefault(botname) " {{{
  py3 b = bots[vim.eval('a:botname')]
endf " }}}
" -- AUX CONFEFERENCE {{{2
fu! BotConferenceAuto(...)
  if a:0 == 0
    let smsg = ''
  el
    let smsg = a:1
  en
  let g:bot.lastmsg = input("você (<enter> para abster-se, q para sair): ")
  wh g:bot.lastmsg != 'q'
    let cmdmsg = BotParseConferenceMsg()
    if l:cmdmsg == 0
      let rem = g:bot.nmsgs - float2nr(g:bot.nmsgs)
      let onemore = py3eval('random.random()') <= l:rem
      for i in range(float2nr(g:bot.nmsgs) + l:onemore)
        cal BotConferenceBotMessage()
        let g:bot.lastmsg = g:bot.confmsgs[-1]
      endfo
      ec "\n"
    en
    cal BotConferenceGetUserMsg()
    if g:bot.lastmsg == ''
      g:bot.lastmsg = g>bot.confmsgs[-2]
    en
    ec "\n"
  endw
  let foo = join(g:bot.confmsgs,"\n")
  new
  PRVbuf
  pu = l:foo
endf
fu! BotConferenceUserAsks() " {{{
  cal BotConferenceGetUserMsg()
  ec "\n\n"
  cal add(g:bot.confmsgs, g:bot.lastmsg)
  wh g:bot.lastmsg != 'q'
    let cmdmsg = BotParseConferenceMsg()
    if l:cmdmsg == 0
      let rem = g:bot.nmsgs - float2nr(g:bot.nmsgs)
      let onemore = py3eval('random.random()') <= l:rem
      for i in range(float2nr(g:bot.nmsgs) + l:onemore)
        cal BotConferenceBotMessage()
      endfo
      ec "\n"
    en
    cal BotConferenceGetUserMsg()
    ec "\n"
  endw
  let foo = join(g:bot.confmsgs,"\n")
  new
  PRVbuf
  pu = l:foo
endf " }}}
fu! BotConferenceGetUserMsg() " {{{
  let g:bot.lastmsg = input("você: ")
  cal add(g:bot.confmsgs, g:bot.lastmsg)
endf " }}}
fu! BotConferenceBotMessage() " {{{
  py3 b = bots[random.choice(dbots)]
  if g:bot.sentlen =~ '-'
    py3 b.sentlen = random.randint(*[int(i) for i in vim.eval('split(g:bot.sentlen, "-")')])
  el
    py3 b.sentlen = int(vim.eval('g:bot.sentlen'))
  en
  cal add(g:bot.confmsgs, BotTalk(g:bot.lastmsg))
  ec g:bot.confmsgs[-1]
endf " }}}
fu! BotParseConferenceMsg() " {{{
  if g:bot.lastmsg[0] == ':'
    if g:bot.lastmsg[1] == 'l'
      let g:bot.sentlen = g:bot.lastmsg[2:]
    elsei g:bot.lastmsg[1] == 'n'
      let g:bot.nmsgs = str2float(g:bot.lastmsg[2:])
    el
      retu 0
    en
    retu 1
  el
    retu 0
  en
endf " }}}
" COMMANDS: {{{1
" -- MAIN {{{2
com! -nargs=* Bc call BotConference(<f-args>)
com! -nargs=1 -complete=tag_listfiles Bt ec BotTalk(<q-args>)

" MAPPINGS: {{{1
" -- MAIN {{{2
nn BT :Bt 
nn Bc :Bc<CR> 
nn Bi :cal BotsInitialize()<CR>
nn Be :exe 'e '.g:bot.paths.dialogs<CR>
nn Bv :exe 'vs '.g:bot.paths.dialogs<CR>
nn Bt :exe 'tabe '.g:bot.paths.dialogs<CR>

" LAST COMMANDS: {{{1
" -- STTARTUP {{{2
if !exists('g:bot')
  cal BotsInitialize()
en
" -- MODELINE {{{2
" vim:foldlevel=1:
