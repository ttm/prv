set lines=999 columns=999

" menu:
se guioptions-=m
" tooltip:
se guioptions-=T
" right bar
se guioptions-=r
" left bar
se guioptions-=L
se guioptions-=e

menu TT&M.&Foo<Tab>yeah :echo "a banana"<CR>
menu TT&M.-Bana- :
menu TT&M.&Bar<Tab>yo :echo "hey man"<CR>

nn <Space>f  :cal system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>
