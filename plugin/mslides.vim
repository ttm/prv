nn <space>sn /^=====<CR>zt<C-E>
nn <space>sp ?^=====<CR>nzt<C-E>

nn <space>so /http<CR>:exe '!google-chrome '.expand("<cfile>")<CR><CR>
nn <space>s<space>o /file:<CR>ww:exe '!eog '.expand("<cfile>")<CR><CR>
nn <space>s<space>O /\.pdf<CR>:exe '!evince '.expand("<cfile>")<CR><CR>

" needed ? TTM
nn <space>si ml:g/\s\{3,}\S.*/normal >><CR>`l
nn <space>sI ml:g/\s\{3,}\S.*/normal <<<CR>`l

" enhance and incorporate into colors for slides
" use in last line vim:ft=slide:
2match Constant /\v.*http.*/
match Special /\v\~.*\~/

