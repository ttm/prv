py3f ~/.vim/pack/ttm/opt/bot/plugin/b0t/b0t/n4ive.py

fu! BotTalk(string)
  let tokens = split(a:string, ' ')
  let cmd = 'b.markovTalk("'.a:string.'")'
  retu py3eval('b.id'). ': '.py3eval(l:cmd)
endf
