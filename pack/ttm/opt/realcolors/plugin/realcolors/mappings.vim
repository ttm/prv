" <C-\> is reserved, so it is safe to use it in all modes

" Initialization and overall status update
noremap <C-\>I :w<CR>:so %<CR>:call InitializeColors()<CR><CR>
noremap <C-\>I :w<CR>:runtime **/*.vim<CR>:call InitializeColors()<CR><CR>
noremap <C-\>i :w<CR>:so %<CR>:call InitializeColors()<CR><CR>
noremap <C-\>i :call InitializeColors()

" Utilities
noremap <C-\>c :call ChgColor()<CR>
noremap <C-\>s :echo SynStack()<CR>
" make windows with colors
noremap <C-\>W :call StandardColorsOrig()<CR>
noremap <C-\>w :call MakeColorsWindow(3)<CR>
noremap <C-\>ww :call MakeColorsWindow(3)<CR>
noremap <C-\>w0 :call MakeColorsWindow(0)<CR>
noremap <C-\>w1 :call MakeColorsWindow(1)<CR>
noremap <C-\>w2 :call MakeColorsWindow(2)<CR>
noremap <C-\>w3 :call MakeColorsWindow(3)<CR>
" debugger:
noremap <C-\>b :call MkBlack()<CR>

" Use to selectively update status
noremap <C-\>a :call GetAll()<CR>
noremap <C-\>g :call GetColors(0)<CR>
noremap <C-\>gg :call GetColors(0)<CR>
noremap <C-\>g0 :call GetColors(0)<CR>
noremap <C-\>g1 :call GetColors(1)<CR>
noremap <C-\>g2 :call GetColors(2)<CR>

" Recover
noremap <C-\>r :colo blue<CR>
noremap <C-\>R :colo gruvbox<CR>

" Luck
noremap <C-\>l :exec 'hi Normal guibg=#'.(system("echo $RANDOM$RANDOM")[:5])<CR>

" use <C-\ c> (press control and \, release, press c).
" to start the color mode.
" use <C-\ a> for audiovisual or aa, <C-\ m> for music
" Because it is C-\ it should work in any mode because it is reserved.
" checkout how to start a mode
" start mappings of functions to g, z and leader keys
" for normal and insert mode
" try also command mode

" Outline
" \c or so starts these mappings, that are removed
" easily

" r g b adds 16 to each color.
" R G B adds 1
" e f v substracts 16 from each color
" E F V subtracts 1

" w d c adds 16 to each of the other colors
" W D C adds 1
" q s x substracts 16 to each of the other colors
" W D C subtracts 1

" gfds might be replaced for fdsa, down one layer on the keyboard from rewq
let s:ckeys = { 'r': 'rewq', 'g': 'fdsa', 'b': 'vcxz', 'i': 'i', 'fb': 'f' }
" let s:ckeys['g'] = 'j'
" let s:ckeys['i'] = 'h'

