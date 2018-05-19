nn mn /^=====<CR>zt<C-E>
nn mp ?^=====<CR>nzt<C-E>

nn mi ml:g/\s\{3,}\S.*/normal >><CR>`l
nn mI ml:g/\s\{3,}\S.*/normal <<<CR>`l

nn mo /http<CR>:exe '!google-chrome '.expand("<cfile>")<CR><CR>
nn mo /file:<CR>ww:exe '!eog '.expand("<cfile>")<CR><CR>
nn mO /\.pdf<CR>:exe '!evince '.expand("<cfile>")<CR><CR>

2match Constant /\v.*http.*/
match Special /\v\~.*\~/

