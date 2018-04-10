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

fu! BotTalk(string)
  let tokens = split(a:string, ' ')
  let cmd = 'b.markovTalk("'.a:string.'")'
  retu py3eval('b.id'). ': '.py3eval(l:cmd)
endf

fu! BotsInitialize()
  let cdir = g:bot_dir . 'plugin/b0t/corpus/'
python3 << EOF
import b0t
bots = {}
bots['peter'] = b0t.baselineBotFromText("/home/renato/repos/joyce/corpus/1peter.txt", 'Peter')
bots['john' ] =  b0t.baselineBotFromText("/home/renato/repos/joyce/corpus/1john.txt", 'John')
bots['james'] = b0t.baselineBotFromText("/home/renato/repos/joyce/corpus/james.txt", 'James')
bots['pedro'] = b0t.baselineBotFromText(vim.eval('cdir') + "pedro1.txt", 'Peter')
bots['joao'] = b0t.baselineBotFromText(vim.eval('cdir') + "pedro1.txt", 'Peter')
bots['tiago'] = b0t.baselineBotFromText(vim.eval('cdir') + "pedro1.txt", 'Peter')
bots['srila'] = b0t.baselineBotFromText("/home/renato/.vim/pack/ttm/opt/aa/aux/aashouts.txt", 'Srila')
b = bots['srila']
EOF
endf

fu! BotSetDefault(botname)
  py3 b = bots[vim.eval('a:botname')]
endf
