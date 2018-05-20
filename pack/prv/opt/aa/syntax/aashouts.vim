sy match aSessionSeparator /^$$$$$$/
hi link aSessionSeparator Function

sy match aShoutSeparator /-----/
hi link aShoutSeparator Special

" 3match Comment /.*\n-----\&.*/
" " todas estas formas dao certo:
" " 3match Comment /.*\n-----\&.*/
" " 3match Comment /.*\n\ze-----/
" 3match Comment /.*\n\(-----\)\@=/

" 3match Comment /.*\n-----/

" match tags, with hi or matchadd()
