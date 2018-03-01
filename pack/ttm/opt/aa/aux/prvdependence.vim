" this file is automatically sourced if |aa| does not find |prv| loaded.
com! PRVbuf setlocal buftype=nofile noswapfile bufhidden=wipe nobuflisted ft=python
com! -nargs=+ PRVLeader cal PRVLeaderHelper(<f-args>)

let g:prv = {'leaders':{}}
fu! PRVLeaderHelper(...)
  if a:1 == 'd'
    cal PRVDeclareLeader(a:2)
  elsei a:1 == 'r'
    cal PRVRestoreLeader(a:2)
  en
  let g:asd = a:
endf
fu! PRVDeclareLeader(plug)
  cal assert_equal(type(a:plug), 1, 'only strings are accepted as arg to PRVDeclareLeader(plug)')
  let g:prv.leaders[a:plug] = [g:mapleader, g:maplocalleader]
  " exe 'let g:'.a:plug.'_keepleaders = [g:mapleader, g:maplocalleader]'
  if has_key(g:prvset.leaders, a:plug)
    let g:mapleader = g:prvset.leaders[a:plug][0]
    let g:maplocalleader = g:prvset.leaders[a:plug][1]
  en
endf
fu! PRVRestoreLeader(plug)
  let [g:mapleader, g:maplocalleader] = g:prv.leaders[a:plug]
endf

