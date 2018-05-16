let g:reldir = expand("<sfile>:p:h:h") . '/'
let g:auxfile = g:reldir . 'aux/wikisyn.vim'
exe 'so '.g:auxfile

hi Normal guibg=darkgreen guifg=black

hi link wTitle Constant
hi link wSubtitle WarningMsg
hi link wSubsubtitle Comment
hi link wPath Cursor
hi link wEnd LineNr

sy match wTitle /\v\~.*\~/
sy match wSubtitle /\v\~\~.*\~\~/
sy match wSubsubtitle /\v\~\~\~.*\~\~\~/
sy match wPath /\v\.\/\f{3,}/

sy match wEnd /\v^:::/

