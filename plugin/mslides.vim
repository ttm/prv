nn mn /^=====<CR>zt<C-E>
nn mp ?^=====<CR>nzt<C-E>
nn mo /http<CR>:exe '!google-chrome '.expand("<cfile>")<CR><CR>
nn mi ml:g/\s\{3,}\S.*/normal >><CR>`l
nn mI ml:g/\s\{3,}\S.*/normal <<<CR>`l

2match Constant /\v.*http.*/
match Special /\v\~.*\~/

