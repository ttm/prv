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
  let s:you = l:
endfunc

function! TickColor(timer)
  let s:anum = 0
  let s:tick = 1
  while s:tick == 1
    echo "banana =" s:anum
    let s:anum += 1
  endwhile
endfunc

function! StartTick()
  s:tickerids.push( timer_start(400, TickColor(), {'repeat': 3}) )
endfunction

function! GetColors(default)
  " Starts a global dictionary with the colors on current position
  " default=1 sets the default/main fg/bg colors for the colorscheme in s:colorsd
  " default=0 sets last managed colorscheme in s:dcolorsd
  let name = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "name")')[-1]

  let fg = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "fg")')[-1]
  if fg == ''
    let sid = hlID('Normal')
    let name = synIDattr(synIDtrans(sid), "name")
    let fg = synIDattr(synIDtrans(sid), "fg")
    " let fg = "#FFFFFF"
  endif
  echo 'fg:' fg
  let rgb = [fg[1:2], fg[3:4], fg[5:6]]
  let rgb_ = map(rgb, 'str2nr(v:val, "16")')

  let bg = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "bg")')[-1]
  if bg == ''
    let sid = hlID('Normal')
    let namebg = synIDattr(synIDtrans(sid), "name")
    let bg = synIDattr(synIDtrans(sid), "bg")
    " let bg = "#FFFFFF"
  endif
  echo 'bg:' bg
  let rgbb = [bg[1:2], bg[3:4], bg[5:6]]
  let rgbb_ = map(rgbb, 'str2nr(v:val, "16")')
  " simple dictionary
  let d = {'fg' : {'r': rgb_[0], 'g': rgb_[1], 'b': rgb_[2]}, 'bg' : {'r': rgbb_[0], 'g': rgbb_[1], 'b': rgbb_[2]}, 'rgb': {'fg': fg, 'bg': bg}}
  " dictionary of a default set of colors (learn how to get from Normal automatically
  if a:default == 1  " default color, to be used when the color has no specification of fg or bg
    let s:dcolorsd = d
  elseif a:default == 2  " temporary, not default
    let s:tcolorsd = d
  else  " buffer, should be updated whenever a color is manipulated
    let s:colors = l:
  endif
endfunc

" let s:theSID = 
function! IncrementColor(c, g)
  " c='r', g='f' : color and foreground
  GetColors()  " creates the dictionary in next line
  let s:colors[l:g][l:c] = (colors[l:g][l:c] + 16 ) % 256
  RefreshColors()  " should update the colors of the cursor position
endfunction

function! InitializeColors()
  let s:cs = g:colors_name
  let s:ground = 'fg'
  " creates the dictionary with colors on foreground and background
  " default, temporary and buffer in s:dcoulorsd, s:tcolorsd and s:colors
  call GetColors(0)
  call GetColors(1)
  call GetColors(2)
  " initialize mappings
  call StartMappings()
  " to keep track of the tickers___:
  let s:tickerids = []
  echo '---> default color:' s:dcolorsd
  echo '===> buffer color:' s:colors
  echo ':::> temp color:' s:tcolorsd
endfunction

function! GetAll()
  let g:colors_all = s:
  let g:colors_all_ = []
  for vkey in keys(s:)
    call add(g:colors_all_ , vkey)
  endfor
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
  let s:ckeys = { 'r': 'rewq', 'g': 'fdsa', 'b': 'vcxz', 'i': 'i', 'fb': 'f' }
  " let s:ckeys['g'] = 'j'
  " let s:ckeys['i'] = 'h'
endfunction

function! SwitchGround()
  if s:ground == 'fg'
    s:ground = 'bg'
  else
    s:ground = 'fg'
  endif
endfunction

function! RefreshColors()
   let c = s:colors
   let g = s:ground
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
  echo 'initial colors are fg, bs:' fg bg
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

  let s:me = l:
endfunc


function! StandardColorsOrig(rgb_fb)
  " To use, save this file and type ":so %"
  " Optional: First enter ":let g:rgb_fg=1" to highlight foreground only.
  " Restore normal highlighting by typing ":call clearmatches()"
  "
  " Create a new scratch buffer:
  " - Read file $VIMRUNTIME/rgb.txt
  " - Delete lines where color name is not a single word (duplicates).
  " - Delete "grey" lines (duplicate "gray"; there are a few more "gray").
  " Add matches so each color name is highlighted in its color.
  call clearmatches()
  new
  setlocal buftype=nofile bufhidden=hide noswapfile
  0read $VIMRUNTIME/rgb.txt
  let find_color = '^\s*\(\d\+\s*\)\{3}\zs\w*$'
  silent execute 'v/'.find_color.'/d'
  silent g/grey/d
  let namedcolors=[]
  1
  while search(find_color, 'W') > 0
      let w = expand('<cword>')
      call add(namedcolors, w)
  endwhile

  for w in namedcolors
      execute 'hi col_'.w.' guifg=NONE guibg='.w
      execute 'hi col_'.w.'_fg guifg='.w.' guibg=NONE'
      execute '%s/\<'.w.'\>/'.printf("%-36s%s", w, w).'/g'

      call matchadd('col_'.w, '\<'.w.'\>', -1)
      " determine second string by that with large # of spaces before it
      call matchadd('col_'.w.'_fg', ' \{10,}\<'.w.'\>', -1)
  endfor
  1
  nohlsearch
endfunction

function! MakeColorsWindow(colors)
  " colors=0,1,2,3 for 
  " only the most basic colors against default, against default and B&W
  " All named colors against default, against default and B&W
  if a:colors < 2
    let nc = s:named0
  else
    let nc = s:named1
  endif

  call clearmatches()
  new
  setlocal buftype=nofile bufhidden=hide noswapfile
  0read $VIMRUNTIME/rgb.txt
  silent g/grey/d
  1
  for w in l:nc
      " default bg against color in fg,
      " default fg against color in bg
      " black fg against color in bg
      " white fg against color in bg
      " black bg against color in fg,
      " white bg against color in fg
      execute 'hi col_'.w.'_fg guifg='.w.' guibg=NONE'
      execute 'hi col_'.w.'_bg guifg=NONE guibg='.w
      if a:colors % 2 == 1
        execute 'hi col_'.w.'_bfg guifg=black guibg='.w
        execute 'hi col_'.w.'_wfg guifg=white guibg='.w
        execute 'hi col_'.w.'_bbg guifg='.w.' guibg=black'
        execute 'hi col_'.w.'_wbg guifg='.w.' guibg=white'
        execute '%s/\<'.w.'\>/'.printf("%s Foreground, %s Background, %s Black FG, %s White FG, %s Black BG, %s White BG", w, w, w , w, w, w).'/g'
        call matchadd('col_'.w.'_bfg', '\<' . w . ' Black FG\>', -1)
        call matchadd('col_'.w.'_wfg', '\<' . w . ' White FG\>', -1)
        call matchadd('col_'.w.'_bbg', '\<' . w . ' Black BG\>', -1)
        call matchadd('col_'.w.'_wbg', '\<' . w . ' White BG\>', -1)
      else
        execute '%s/\<'.w.'\>/'.printf("%s Foreground, %s Background", w, w).'/g'
      endif
      call matchadd('col_'.w.'_fg',  '\<' . w . ' Foreground\>', -1)
      call matchadd('col_'.w.'_bg',  '\<' . w . ' Background\>', -1)

      " determine second string by that with large # of spaces before it
  endfor
  1
  nohlsearch
  let g:banana = l:
endfun

function! StandardColors(rgb_fb)
  " Run :call StandardColors(1) for a more lightweight version
  " This function gets all the names of the all the colors on the system
  " See MakeColorsWindow(0) to display all named colors
  " as foreground and background against
  " black, white and default colors in a window

  " these names are from from :h gui-colors in Jan/05/2018
  let s:named0 = ['Red', 'LightRed', 'DarkRed', 'Green', 'LightGreen', 'DarkGreen', 'SeaGreen', 'Blue', 'LightBlue', 'DarkBlue', 'SlateBlue', 'Cyan', 'LightCyan', 'DarkCyan', 'Magenta', 'LightMagenta', 'DarkMagenta', 'Yellow', 'LightYellow', 'BrownsDarkYellow', 'Gray', 'LightGray', 'DarkGray', 'Black', 'White', 'Orange', 'PurplesViolet']
  " how to determine the rgb value of the default colors?
  " parse $VIMRUNTIME/rgb.txt
  " To use, save this file and type ":so %"
  " Optional: First enter ":let g:rgb_fg=1" to highlight foreground only.
  " Restore normal highlighting by typing ":call clearmatches()"
  "
  " Create a new scratch buffer:
  " - Read file $VIMRUNTIME/rgb.txt
  " - Delete lines where color name is not a single word (duplicates).
  " - Delete "grey" lines (duplicate "gray"; there are a few more "gray").
  " Add matches so each color name is highlighted in its color.
  call clearmatches()
  new
  setlocal buftype=nofile bufhidden=hide noswapfile
  0read $VIMRUNTIME/rgb.txt
  let find_color = '^\s*\(\d\+\s*\)\{3}\zs\w*$'
  silent execute 'v/'.find_color.'/d'
  silent g/grey/d
  let named=[]
  1
  while search(find_color, 'W') > 0
      let w = expand('<cword>')
      call add(named, w)
  endwhile
  let s:named1 = named
  let s:std = l:
  q
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


" function s___:MYSID()
"   return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
" endfun
" let s:mysid = s___:SID()
