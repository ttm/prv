" for mapping of letters in insert mode {{{ 
" (test with <Space> to replicate normal commands)
" au InsertEnter * set timeoutlen=200
" au InsertLeave * set timeoutlen=1000
" }}}
function! QuitNetrw()
  for i in range(1, bufnr($))
    if buflisted(i)
      if getbufvar(i, '&filetype') == "netrw"
        silent exe 'bwipeout ' . i
      endif
    endif
  endfor
endfunction

autocmd VimLeavePre *  call QuitNetrw()

au Colorscheme * runtime ~/.vim/aux/underlineSpellBad.vim
" What is this for?? TTM
aug vimrcEx
  au!
  " restore-cursor, usr-05.txt
  au BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
aug END

au InsertLeave * call RotateRegisters()
au CmdwinEnter * map <buffer> <C-D> <CR>q:
au CmdwinEnter * map <buffer> <C-E> <CR> input("")q:


" filetype settings --- {{{
" Vimscript file settings ---------------------- {{{
aug filetype_vim
  au!
  au FileType vim setl foldmethod=marker softtabstop=2 shiftwidth=2 expandtab
aug END
" }}}

" Help file settings ---------------------- {{{
aug filetype_help
  au!
  au FileType help setlocal iskeyword+=-,.,(,)
aug END
" }}}

" Python file settings ---------------------- {{{
aug pythonaus
  au!
  " TTM removed tabstop=4
  au BufNewFile,BufRead *.py setl softtabstop=4 shiftwidth=4 textwidth=0 expandtab autoindent fileformat=unix
  au BufNewFile,BufRead *.py nnoremap <buffer> cd /\<def\><CR>
  au BufNewFile,BufRead *.py nnoremap <buffer> cD ?\<def\><CR> 
  au BufNewFile,BufRead *.py nnoremap <buffer> cc /\<class\><CR>
  au BufNewFile,BufRead *.py nnoremap <buffer> cC ?\<class\><CR>
  " validade this (from usr_05.txt):
  vnoremap _g y:exe "grep /" . escape(@", '\\/') . "/ *.py"<CR>
  nnoremap <leader>R :call PythonShowRun()<CR>
aug END
" }}}
" }}}
