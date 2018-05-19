" fu! ATest()
"   exec 3
"   exec 'let g:abana = range(9)'
"   normal ll
" endfu
" 
" let @a = printf('l%s %s', line('.'), expand('%'))
" fun! TestOne(reg,bang,args) range
"   echo "TestOne(reg<".a:reg.">,bang=".a:bang." q-args=".a:args.") firstline=".a:firstline." lastline=".a:lastline
"   echo "TestOne"
" endfun
" 
" fun! TestTwo(reg,bang,qty,args)
"sd\q   echo "TestTwo(reg<".a:reg.">,bang=".a:bang." qty=".a:qty." q-args=".a:args.")"
"   echo "TestTwo"
" endfun
" 
" " this is a test range
" " this is a test range
" " this is a test range
" " this is a test range
" 
" com! -range -register -bang TestOne <line1>,<line2>call TestOne("<reg>",<bang>0,<q-args>)
" com! -count=1 -register -bang TestTwo call TestTwo("<reg>",<bang>0,<count>,<q-args>)
" nnoremap \aa :TestOne<CR>
" nnoremap \bb :TestOne!<CR>
" nnoremap \cc :TestOne a<CR>
" nnoremap \dd :TestOne! a<CR>
" nnoremap \ee :TestOne! a "abc" "def"<CR>
" nnoremap \ff :10,13TestOne<CR>
" nnoremap \gg :TestTwo 3<CR>



"""""""""""""""""
" 
" 
" nmap <C-\>e :set opfunc=CountSpaces<CR>g@
" vmap <C-\>e :<C-U>call CountSpaces(visualmode(), 1)<CR>
" 
" function! CountSpaces(type, ...)
"   let sel_save = &selection
"   let &selection = "inclusive"
"   let reg_save = @@
" 
"   if a:0  " Invoked from Visual mode, use gv command.
"     silent exe "normal! gvy"
"   elseif a:type == 'line'
"     silent exe "normal! '[V']y"
"   else
"     silent exe "normal! `[v`]y"
"   endif
" 
"   echomsg strlen(substitute(@@, '[^ ]', '', 'g'))
"   echo strlen(substitute(@@, '[^ ]', '', 'g'))
"   let g:tvar = strlen(substitute(@@, '[^ ]', '', 'g'))
" 
"   let &selection = sel_save
"   let @@ = reg_save
" endfunction
" 

fu! AFunc() dict
  echo self.banana
  return self.nabo
endfu

let d = {'banana': 4, 'mf': function("AFunc")}
