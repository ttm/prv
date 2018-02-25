command! PRVbuff setlocal buftype=nofile noswapfile bufhidden=wipe nobuflisted ft=python

fu! PRVDeclareLeader(plug)
  cal assert_equal(type(a:plug), 1, 'only strings are accepted as arg to PRVDeclareLeader(plug)')
  let g:prv_keepleaders = [g:mapleader, g:maplocalleader]
  if exists('g:'.a:plug.'_leader')
    exe 'let mapleader = g:'.a:plug.'_leader'
  el
    exe 'let mapleader = g:'.a:plug.'_default_leader'
    exe 'let g:'.a:plug.'_leader = g:'.a:plug.'_default_leader'
  en
  if exists("g:aa_localleader")
    exe 'let maplocalleader = g:'.a:plug.'_localleader'
  el
    exe 'let maplocalleader = g:'.a:plug.'_default_localleader'
    exe 'let g:'.a:plug.'_localleader = g:'.a:plug.'_default_localleader'
  en
endf

fu! PRVRestoreLeader(plug)
  let [mapleader, maplocalleader] = g:prv_keepleaders
endf
