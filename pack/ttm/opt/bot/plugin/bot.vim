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
fu! BotTalk(string)
  let tokens = split(a:string, ' ')
  let cmd = 'b.markovTalk("'.a:string.'")'
  py3 b.lastmsg = b.id + ': ' + eval(vim.eval('l:cmd'))
  cal BotDialogAdd(a:string, py3eval('b.lastmsg'))
  retu py3eval('b.lastmsg')
endf

fu! BotDialogAdd(...)
  let asd = a:
  " maybe replace \n by \r because o last paragraph of :h writefile()
  cal writefile(['','$$$$$ ::: '.system('date')[:-2]], g:bot.paths.dialogs, 'as')
  cal writefile( a:000, g:bot.paths.dialogs, 'as')
endf

fu! BotsInitialize()
  let g:bot = {'paths': {}}
  let g:bot.paths.dialogs = g:bot_dir . 'aux/dialogs.txt'
  let g:bot.sentlen = '2-35'
  let g:bot.a = 6.7
  let cdir = g:bot_dir . 'plugin/b0t/corpus/'
python3 << EOF
import b0t, random
bots = {}
bots['peter'] = b0t.baselineBotFromText("/home/renato/repos/joyce/corpus/1peter.txt", 'Peter')
bots['john' ] =  b0t.baselineBotFromText("/home/renato/repos/joyce/corpus/1john.txt", 'John')
bots['james'] = b0t.baselineBotFromText("/home/renato/repos/joyce/corpus/james.txt", 'James')

bots['pedro'] = b0t.baselineBotFromText(vim.eval('cdir') + "pedro1.txt", 'Pedro')
bots['joao'] = b0t.baselineBotFromText(vim.eval('cdir') + "joao1.txt", 'João')
bots['tiago'] = b0t.baselineBotFromText(vim.eval('cdir') + "tiago.txt", 'Tiago')

bots['srila'] = b0t.baselineBotFromText("/home/renato/.vim/pack/ttm/opt/aa/aux/aashouts.txt", 'Srila')
bots['zer@'] = b0t.baselineBotFromText(vim.eval('cdir') + "butlerPreciado2.txt", 'Zer@')
bots['laila'] = b0t.baselineBotFromText(vim.eval('cdir') + "laila.txt", 'Laila Kaiabi Manuelle')

bots['lula'] = b0t.baselineBotFromText(vim.eval('cdir') + "lula.txt", 'Luís Inácio Lula da Silva')
bots['dilma'] = b0t.baselineBotFromText(vim.eval('cdir') + "dilma.txt", 'Dilma Vana Rousseff')
bots['fhc'] = b0t.baselineBotFromText(vim.eval('cdir') + "fhc.txt", 'Fernando Henrique Cardoso')

bots['morss'] = b0t.baselineBotFromText(vim.eval('cdir') + "fhc.txt", 'Fernando Henrique Cardoso')

b = bots['srila']
# dbots = ['srila', 'tiago', 'joao', 'pedro', 'zer@']
dbots = ['lula', 'dilma', 'fhc', 'pedro', 'joao', 'tiago']
# dbots = ['srila', 'tiago', 'joao', 'pedro', 'zer@', 'preciado', 'butler', 'bock mors', 'etc', 'shakespeare', 'lula']
EOF
endf

fu! BotSetDefault(botname)
  py3 b = bots[vim.eval('a:botname')]
endf

fu! BotConference(...)
  let g:asd = a:
  let g:bot.confmsgs = []
  let g:bot.lastmsg = input("você: ")
  ec "\n\n"
  cal add(g:bot.confmsgs, g:bot.lastmsg)
  let g:bot.nmsgs = 0
  wh g:bot.lastmsg != 'q'
    if g:bot.lastmsg[0] == ':'
      if g:bot.lastmsg[1] == 'l'
        let g:bot.sentlen = g:bot.lastmsg[2:]
      elsei g:bot.lastmsg[1] == 'a'
        let g:bot.a = str2float(g:bot.lastmsg[2:])
      en
    el
      for i in range(float2nr(g:bot.a))
        py3 b = bots[random.choice(dbots)]
        if g:bot.sentlen =~ '-'
          py3 b.sentlen = random.randint(*[int(i) for i in vim.eval('split(g:bot.sentlen, "-")')])
        el
          py3 b.sentlen = int(vim.eval('g:bot.sentlen'))
        en

        cal add(g:bot.confmsgs, BotTalk(g:bot.lastmsg))
        ec g:bot.confmsgs[-1]
      endfo
      let rem = g:bot.a - float2nr(g:bot.a)
      if  py3eval('random.random()') <= l:rem
        py3 b = bots[random.choice(dbots)]
        if g:bot.sentlen =~ '-'
          py3 b.sentlen = random.randint(*[int(i) for i in vim.eval('split(g:bot.sentlen, "-")')])
        el
          py3 b.sentlen = int(vim.eval('g:bot.sentlen'))
        en

        cal add(g:bot.confmsgs, BotTalk(g:bot.lastmsg))
        ec g:bot.confmsgs[-1]
      en
      ec "\n"
    en
    let g:bot.lastmsg = input("você: ")
    cal add(g:bot.confmsgs, g:bot.lastmsg)
    ec "\n"
  endw
  let foo = join(g:bot.confmsgs,"\n")
  new
  PRVbuf
  pu = l:foo
endf
com! -nargs=* Bc call BotConference(<f-args>)
com! -nargs=1 -complete=tag_listfiles Bt ec BotTalk(<q-args>)

nn Bt :Bt 
nn Bc :Bc<CR> 
nn Bi :cal BotsInitialize()<CR>
" vim:foldlevel=2:
