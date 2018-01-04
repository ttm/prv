" Show syntax highlighting groups for word under cursor
nmap <leader>z :call InitializeColors()<CR>
nmap <leader>Z :call SynStack()<CR>
" nmap <leader>z :call MkBlack()<CR>
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" starting syntax highlighting facilities
" 1) change the color of the char under cursor to black
" This mkBlacl function and \z mapping is the main syntax highlighting debugger
let stack = map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
function! MkBlack()
"  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')

  let stack = map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  let stack_ = synstack(line('.'), col('.'))
  let stack__ = map(synstack(line('.'), col('.')), 'synIDattr(v:val, "fg")')
  echo stack
  if len(stack) == 0
    let name1 = 'Normal'
  else
    let name1 = stack[-1]
  endif

  let stack2 = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "name")')
  let stack2_ = map(synstack(line('.'), col('.')), 'synIDtrans(v:val)')
  let stack2__ = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "fg")')
  echo stack2
  if len(stack2) == 0
    let name2 = 'Normal'
  else
    let name2 = stack[-1]
  endif

  execute 'hi' name2
  execute 'hi' name2 'guifg=black'
  echo 'hi' name2 'guibg=white'
  echo 'hi' name1 'guibg=white'
  colo
  let g:you = l:
endfunc

function! TickColor(timer)
  let g:anum = 0
  let g:tick = 1
  while g:tick == 1
    echo "banana =" g:anum
    let g:anum += 1
  endwhile
endfunc

function! StartTick()
  g:tickerids.push( timer_start(400, TickColor(), {'repeat': 3}) )
endfunction

function! GetColors(default)
  " Starts a global dictionary with the colors on current position
  " default=1 sets the default/main fg/bg colors for the colorscheme in g:colorsd
  " default=0 sets last managed colorscheme in g:dcolorsd
  let name = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "name")')[-1]

  let fg = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "fg")')[-1]
  if fg == ''
    let fg = "#FFFFFF"
  endif
  let rgb = [fg[1:2], fg[3:4], fg[5:6]]
  let rgb_ = map(rgb, 'str2nr(v:val, "16")')

  let bg = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "bg")')[-1]
  if bg == ''
    let bg = "#FFFFFF"
  endif
  let rgbb = [bg[1:2], bg[3:4], bg[5:6]]
  let rgbb_ = map(rgbb, 'str2nr(v:val, "16")')
  " simple dictionary
  let d = {'fg' : {'r': rgb_[0], 'g': rgb_[1], 'b': rgb_[2]}, 'bg' : {'r': rgbb_[0], 'g': rgbb_[1], 'b': rgbb_[2]}}
  " sictionary of a default set of colors (learn how to get from Normal automatically
  if a:default == 1
    let g:dcolorsd = d
  elseif
    let g:colorsd = d
  endif
  let g:colors = l:
endfunc

" let g:theSID = 
function! IncrementColor(c, g)
  " c='r', g='f' : color and foreground
  GetColors()  " creates the dictionary in next line
  let g:colors[l:g][l:c] = (colors[l:g][l:c] + 16 ) % 256
  RefreshColors()  " should update the colors of the cursor position
endfunction

function! InitializeColors()
  let g:ground = 'fg'
  " creates the dictionary with colors on foreground and background:
  call GetColors(0)
  call GetColors(1)
  " initialize mappings
  call StartMappings()
  " to keep track of the tickers:
  let g:tickerids = []
  echo g:dcolors
endfunction

function! StartMappings()
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
  let g:ckeys = { 'r': 'rewq', 'g': 'fdsa', 'b': 'vcxz', 'i': 'i', 'fb': 'f' }
  " let g:ckeys['g'] = 'j'
  " let g:ckeys['i'] = 'h'
endfunction

function! SwitchGround()
  if g:ground == 'fg'
    g:ground = 'bg'
  else
    g:ground = 'fg'
  endif
endfunction

function! RefreshColors()
   let c = g:colors
   let g = g:ground
   let fg_ = printf('#%02x%02x%02x', c[g]['r'], c[g]['g'], c[g]['b'])
endfunction

nmap <leader>x :call ChgColor()<CR>
function! ChgColor()
  let name = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "name")')[-1]

  let fg = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "fg")')[-1]
  if fg == ''
    let fg = "#FFFFFF"
  endif
  let rgb = [fg[1:2], fg[3:4], fg[5:6]]
  let rgb_ = map(rgb, 'str2nr(v:val, "16")')

  let bg = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "bg")')[-1]
  if bg == ''
    let bg = "#FFFFFF"
  endif
  let rgbb = [bg[1:2], bg[3:4], bg[5:6]]
  let rgbb_ = map(rgbb, 'str2nr(v:val, "16")')

  let [fg_, bg_] = [fg, bg]
  let c = 'foo'
  let who = 'fg'
  echo 'initial colors are fg, bg:' fg bg
  call getchar(1)
  while c != 'q'
			let c = nr2char(getchar())
      if c == 'j'
        let who = 'bg'
        let mcmd = 'echo "on the background color"'
      elseif c == 'h'
        let [rgb_, rgbb_] = [rgbb_, rgb_]
        let mcmd = 'echo "colors inverted"'
        let fg_ = printf('#%02x%02x%02x', rgb_[0], rgb_[1], rgb_[2])
        execute 'hi' name 'guifg=' . fg_
        let bg_ = printf('#%02x%02x%02x', rgbb_[0], rgbb_[1], rgbb_[2])
        execute 'hi' name 'guibg=' . bg_
      elseif who == 'fg'
        if c == 'r'
          let rgb_[0] = (16 + rgb_[0]) % 256
        elseif c == 'g'
          let rgb_[1] = (16 + rgb_[1]) % 256
        elseif c == 'b'
          let rgb_[2] = (16 + rgb_[2]) % 256
        endif
        let fg_ = printf('#%02x%02x%02x', rgb_[0], rgb_[1], rgb_[2])
        let mcmd = printf('hi %s guifg=%s', name, fg_)
      elseif who == 'bg'
        if c == 'r'
          let rgbb_[0] = (16 + rgbb_[0]) % 256
        elseif c == 'g'
          let rgbb_[1] = (16 + rgbb_[1]) % 256
        elseif c == 'b'
          let rgbb_[2] = (16 + rgbb_[2]) % 256
        endif
        let bg_ = printf('#%02x%02x%02x', rgbb_[0], rgbb_[1], rgbb_[2])
        let mcmd = printf('hi %s guibg=%s', name, bg_)
      endif
      execute mcmd
      redraw
      echo fg_ bg_
      " echo 'hi' name 'guifg=' . fg_
  endwhile

  let g:me = l:
endfunc
" syntax change undo
" increment/decrement rgb
" in the char under cursor

" start a function that receives
" the modifications throug the
" keys RGB and before it (rewq, gfds, bvcx).
" for backgound, press j and use the same keys.
" uppercase is used for more resolution.

" q quits.

" Another functionality:
" Makes a color pallete from the special colors
" or other palletes that are special or
" that are derived from a color or set of colors.

" Another functionality:
" swap two colors grabed from cursor.
" rotate all the colors maintaining the background
" or not.

" find make tests with synID trans false and true
" We have the syngroups givem by synstack
" and the effectively used one, given
" by synIDtrans

" their name might be found with
" synIDattr

" If set hi group from synstack,
" the link used beforehand is lost.
" e.g.  :hi vimHiGuiFgBg guifg=#000000
" Makes you loose the link to gruvboxYellow


" function s:MYSID()
"   return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
" endfun
" let g:mysid = s:SID()
