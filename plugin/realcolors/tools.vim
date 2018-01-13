function! SynStack() " {{{
  " Show syntax highlighting groups for word under cursor
  " last item should be the group last considered, i.e. the most relevant.
  " If it is linked to some other group, you might find it with 
  " synIDtrans
  if !exists("*synstack")
    return
  endif
  let a = map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  " intermediaries
  let b = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "name")')
  let c = []
  let i = 0
  while i < len(a)
    if a[i] != b[i]
      call add(c, [a[i], b[i]])
    else
      call add(c, a[i])
    endif
    let i += 1
  endwhile
  if len(c) == 0
    let c = ['Normal']
  endif
  return c
endfunc " }}}

function! MkBlack() " {{{
  " starting syntax highlighting facilities
  " 1) change the color of the char under cursor to black
  " This mkBlack function and \z mapping is the main syntax highlighting debugger
  "
  " Debugger facility.
  " Only changes the color of the syntax group under cursor to black
  " and prints and creates useful variables
  " Reload color scheme to undo. E.g.: :colo blue

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
endfunc " }}}

function! GetColors(which) " {{{
  " Populates the s:colors dictionary with default (which=2), temp (1) and buffer (0) colors
  let sid = hlID('Normal')
  let sfg = synIDattr(synIDtrans(sid), "fg")
  let sbg = synIDattr(synIDtrans(sid), "bg")
  let name = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "name")')
  if len(name) > 0
    let name = name[-1]
  else
    let name = 'Normal'
  endif
  let fg = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "fg")')
  if fg == []
    let name = synIDattr(synIDtrans(sid), "name")
    let fg = sfg
    " let fg = "#FFFFFF"
  else
    let fg = fg[-1]
  endif
  if has_key(s:named_colors, tolower(fg))
    let fg_named = fg
    let fg = s:named_colors[tolower(fg)]['hex']
    ec fg_named
  endif
  if fg[0] != '#'
    let fg = "#" . fg
  endif
  echo 'fg:' fg
  let rgb = [fg[1:2], fg[3:4], fg[5:6]]
  let rgb_ = map(rgb, 'str2nr(v:val, "16")')

  let bg = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "bg")')
  if bg == []
    let namebg = synIDattr(synIDtrans(sid), "name")
    let bg = sbg
    " let bg = "#FFFFFF"
  else
    let bg = bg[-1]
  endif
  if has_key(s:named_colors, tolower(bg))
    let bg_named = bg
    let bg = s:named_colors[tolower(bg)]['hex']
    echo bg_named
  endif
  if bg[0] != '#'
    let bg = "#" . bg
  endif
  echo 'bg:' bg
  let rgbb = [bg[1:2], bg[3:4], bg[5:6]]
  let rgbb_ = map(rgbb, 'str2nr(v:val, "16")')
  " simple dictionary
  let d = {'fg' : {'r': rgb_[0], 'g': rgb_[1], 'b': rgb_[2]}, 'bg' : {'r': rgbb_[0], 'g': rgbb_[1], 'b': rgbb_[2]}, 'rgb': {'fg': fg, 'bg': bg}}
  if a:which == 2  " default color, to be used when the color has no specification of fg or bg
    let s:colors['default'] = d
  elseif a:which == 1  " temporary
    let s:colors['temp'] = d
  else  " buffer, should be updated whenever a color is manipulated
    let s:colors['buffer'] = l:
  endif
endfunc " }}}

function! IncrementColor(c, g) " {{{
  " c='r', g='f' : color and foreground
  GetColors()  " creates the dictionary in next line
  let s:colors[l:g][l:c] = (colors[l:g][l:c] + 16 ) % 256
  RefreshColors()  " should update the colors of the cursor position
endfunction " }}}

function! InitializeColors() " {{{
  " Should initialize the whole coloring system.
  " If not only changing the color under cursor, should be used
  let s:ground = 'fg'
  cal StandardColors()
  " creates the dictionary with colors on foreground and background
  " default, temporary and buffer in s:dcoulorsd, s:tcolorsd and s:colors
  let s:colors = {}
  cal GetColors(0)
  ec '===> buffer color:' s:colors['buffer']
  cal GetColors(1)
  ec ':::> temp color:' s:colors['temp']
  cal GetColors(2)
  ec '---> default color:' s:colors['default']
  " initialize mappings
  " make named_colors0 and named_colors with the name of the colors:
  " 0: from documentation :h gui-colors
  " : from $VIMRUNTIME/rgb.txt

  let s:cs = {'standard': g:colors_name}
  let s:timers = []
  let s:counters = range(10)
  let s:ncounters = 0
  let s:patterns = {}
  let s:mpatterns = {'wave': 'call WavePattern()', 'std': 'call StandardPattern()', 'wobble': 'call Wobble()', 'silence': 'call BypassPattern'}
  " get all variables to the g:colors_all (new)
  " and g:colors_all_ (new) global variables
  cal GetAll()
  cal StandardColorSchemes()
  ec "type \\x to change color under cursor"
  ec " should be integrated to the mode <C-\ c>"
endfu  " }}}

function! GetAll() " {{{
  let g:colors_all = s:
  let g:colors_all_ = []
  for vkey in keys(s:)
    call add(g:colors_all_ , vkey)
  endfor
endfunction " }}}

function! SwitchGround() " {{{
  " To keep a record in our color server
  if s:ground == 'fg'
    s:ground = 'bg'
  else
    s:ground = 'fg'
  endif
endfunction " }}}

function! RefreshColors() " {{{
  " to do what???
  " apply c to current colorscheme
  let c = s:colors
  let g = s:ground
  let fg_ = Hex(c[g],0,0)
endfunction " }}}

fu! IncRGB(co, ch) " {{{
  let co = a:co
  let c = a:ch

  if c == '1' " 0
    let [co[0], co[1]] = [co[1], co[0]]
  elseif c == '2'
    let [co[1], co[2]] = [co[2], co[1]]
  elseif c == '3'
    let [co[0], co[2]] = [co[2], co[0]]
  elseif c == '4'
    let co = [co[2], co[0], co[1]]
  elseif c == '5'
    let co = [co[1], co[2], co[0]]
  elseif c == 't'
    let co[0] = 255 - co[0]
    let co[1] = 255 - co[1]
    let co[2] = 255 - co[2]
  elseif c == 'r' " 1
    let co[0] = (16 + co[0]) % 256
  elseif c == 'g'
    let co[1] = (16 + co[1]) % 256
  elseif c == 'b'
    let co[2] = (16 + co[2]) % 256
  elseif c == 'R'
    let co[0] = (240 + co[0]) % 256
  elseif c == 'G'
    let co[1] = (240 + co[1]) % 256
  elseif c == 'B'
    let co[2] = (240 + co[2]) % 256
  elseif c == 'w' " 2
    let co[0] = (1 + co[0]) % 256
  elseif c == 'd'
    let co[1] = (1 + co[1]) % 256
  elseif c == 'c'
    let co[2] = (1 + co[2]) % 256
  elseif c == 'W'
    let co[0] = (255 + co[0]) % 256
  elseif c == 'D'
    let co[1] = (255 + co[1]) % 256
  elseif c == 'C'
    let co[2] = (255 + co[2]) % 256
  elseif c == 'e' " 3
    let co[1] = (16 + co[1]) % 256
    let co[2] = (16 + co[2]) % 256
  elseif c == 'f'
    let co[0] = (16 + co[0]) % 256
    let co[2] = (16 + co[2]) % 256
  elseif c == 'v'
    let co[0] = (16 + co[0]) % 256
    let co[1] = (16 + co[1]) % 256
  elseif c == 'E'
    let co[1] = (240 + co[1]) % 256
    let co[2] = (240 + co[2]) % 256
  elseif c == 'F'
    let co[0] = (240 + co[0]) % 256
    let co[2] = (240 + co[2]) % 256
  elseif c == 'V'
    let co[0] = (240 + co[0]) % 256
    let co[1] = (240 + co[1]) % 256
  elseif c == 'q' " 4
    let co[1] = (1 + co[1]) % 256
    let co[2] = (1 + co[2]) % 256
  elseif c == 's'
    let co[0] = (1 + co[0]) % 256
    let co[2] = (1 + co[2]) % 256
  elseif c == 'x'
    let co[0] = (1 + co[0]) % 256
    let co[1] = (1 + co[1]) % 256
  elseif c == 'Q'
    let co[1] = (255 + co[1]) % 256
    let co[2] = (255 + co[2]) % 256
  elseif c == 'S'
    let co[0] = (255 + co[0]) % 256
    let co[2] = (255 + co[2]) % 256
  elseif c == 'X'
    let co[0] = (255 + co[0]) % 256
    let co[1] = (255 + co[1]) % 256
  endif
  return co
endfu " }}}

function! ChgColor() " {{{
  " should integrate bold italics and underline (strikeout?) TTM
  let sid = hlID('Normal')
  let sfg = synIDattr(synIDtrans(sid), "fg")
  let sbg = synIDattr(synIDtrans(sid), "bg")
  let name = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "name")')
  if len(name) > 0
    let name = name[-1]
    let fg = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "fg")')[-1]
    if fg == ''
      let fg = sfg
    en
    let bg = map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "bg")')[-1]
    if bg == ''
      let bg = sbg
    endif
  else
    let name = 'Normal'
    let fg = sfg
    let bg = sbg
  endif
  if has_key(s:named_colors, tolower(fg))
    let fg_named = fg
    let fg = s:named_colors[tolower(fg)]['hex']
  endif
  if fg[0] != '#'
    let fg = "#" . fg
  endif
  let rgb = [fg[1:2], fg[3:4], fg[5:6]]
  let rgb_ = map(rgb, 'str2nr(v:val, "16")')

  if has_key(s:named_colors, tolower(bg))
    let bg_named = bg
    let bg = s:named_colors[tolower(bg)]['hex']
  endif
  if bg[0] != '#'
    let bg = "#" . bg
  endif
  let rgbb = [bg[1:2], bg[3:4], bg[5:6]]
  let rgbb_ = map(rgbb, 'str2nr(v:val, "16")')

  let [fg_, bg_] = [fg, bg]
  echo [fg_, bg_]
  let c = 'foo'
  let who = 'fg'
  echo 'initial colors are fg, bs:' fg bg
  call getchar(1)
  let emphn = 0
  let emph = ['bold', 'underline', 'bold,underline', 'NONE']
  while c != 'n'
      let mex = 1
			let c = nr2char(getchar())
      if c == 'j'
        if who == 'fg'
          let who = 'bg'
          let mcmd = 'echo "on the background color"'
        else
          let who = 'fg'
          let mcmd = 'echo "on the background color"'
        endif
      elseif c == 'h'
        let [rgb_, rgbb_] = [rgbb_, rgb_]
        let mcmd = 'echo "colors inverted"'
        let fg_ = Hex(rgb_[0], rgb_[1], rgb_[2])
        execute 'hi' name 'guifg=' . fg_
        let bg_ = Hex(rgbb_[0], rgbb_[1], rgbb_[2])
        execute 'hi' name 'guibg=' . bg_
      elseif c == 'p' " power, preeminence, prominance
        let emphn  = ( emphn + 1 ) % len(emph)
        execute 'hi' name 'cterm=' . emph[emphn]
        let mcmd = ''
      elseif c == 'P' " power, preeminence, prominance
        let emphn  = ( emphn + 3 ) % len(emph)
        execute 'hi' name 'cterm=' . emph[emphn]
        let mcmd = ''
      elseif who == 'fg'
        let rgb_ = IncRGB(rgb_, c)
        let fg_ = Hex(rgb_,0,0)
        let mcmd = printf('hi %s guifg=%s', name, fg_)
      elseif who == 'bg'
        let rgbb_ = IncRGB(rgbb_, c)
        let bg_ = Hex(rgbb_,0,0)
        let mcmd = printf('hi %s guibg=%s', name, bg_)
      else
        let mex = 0
      endif
      if mex
        execute mcmd
        redraw
        echo fg_ bg_ '(rewqgfdsbvcxhjp to change, n to quit)'
      endif
      " echo 'hi' name 'guifg=' . fg_
  endwhile
  let s:me = l:
endfunc " }}}

function! StandardColorsOrig() " {{{
  "  Shows the named colors available as fg and bg against default fg and bg    
  " Restore normal highlighting by typing ":call clearmatches()"

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
  " silent g/grey/d
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
endfunction " }}}

function! MakeColorsWindow(colors) " {{{
  " colors=0,1,2,3 for 
  " only the most basic colors against default, against default and B&W
  " All named colors against default, against default and B&W
  if a:colors < 2
    let nc = s:named_colors0
  else
    let nc = keys(s:named_colors_)
  endif

  call clearmatches()
  new
  setlocal buftype=nofile bufhidden=hide noswapfile
  0read $VIMRUNTIME/rgb.txt
  " silent g/grey/d
  1
  for w_ in l:nc
     if w_ == ''
       continue
     endif
      " default bg against color in fg,
      " default fg against color in bg
      " black fg against color in bg
      " white fg against color in bg
      " black bg against color in fg,
      " white bg against color in fg
      let w = substitute(w_, " ", "__", "g")
      let w__ = copy(w_)
      if w_ =~ ' '
        let w_ = "'" . w_ . "'"
      endif
      " echo 'hi col_' . w . '_fg guifg=' . w_ . ' guibg=NONE'
      " echo 'hi col_' . w . '_bg guifg=NONE guibg=' . w_
      " echo w w_ w__
      execute 'hi col_' . w . '_fg guifg=' . w_ . ' guibg=NONE'
      execute 'hi col_' . w . '_bg guifg=NONE guibg=' . w_
      if a:colors % 2 == 1
        " echo 'aaaaaaaaaaaaa ' w
        execute 'hi col_' . w . '_bfg guifg=black guibg=' . w_
        execute 'hi col_' . w . '_wfg guifg=white guibg=' . w_
        execute 'hi col_' . w . '_bbg guifg=' . w_ . ' guibg=black'
        execute 'hi col_' . w . '_wbg guifg=' . w_ . ' guibg=white'
        execute '%s/\s\s' . w__ . '$/' . printf("  %s Foreground, %s Background, %s Black FG, %s White FG, %s Black BG, %s White BG", w__, w__, w__, w__, w__, w__) . '/g'
        call matchadd('col_' . w . '_bfg', '\<' . w__ . ' Black FG\>', -1)
        call matchadd('col_' . w . '_wfg', '\<' . w__ . ' White FG\>', -1)
        call matchadd('col_' . w . '_bbg', '\<' . w__ . ' Black BG\>', -1)
        call matchadd('col_' . w . '_wbg', '\<' . w__ . ' White BG\>', -1)
      else
        execute '%s/\s\s' . tolower(w__) . '$/'.printf("%s Foreground, %s Background", w, w).'/g'
      endif
      call matchadd('col_' . w . '_fg',  '\<' . w__ . ' Foreground\>', -1)
      call matchadd('col_' . w . '_bg',  '\<' . w__ . ' Background\>', -1)

      " determine second string by that with large # of spaces before it
  endfor
  1
  nohlsearch
  let g:banana = l:
endfun " }}}

function! ColorsNotFound() " {{{
  let cnotf = []
  let cc = keys(s:named_colors)
  for c in s:named_colors0
    if index(cc, tolower(c)) >= 0
      " color found, pass
    else
      call add(cnotf, c)
    endif
  endfor
  let s:cnotf = cnotf
  let s:named_colors['lightred']  = '#ff8b8b'
  let s:named_colors_['LightRed'] = '#ff8b8b'
  let s:named_colors['lightmagenta']  = '#ff8bff'
  let s:named_colors_['LightMagenta'] = '#ff8bff'
  let s:named_colors['darkyellow']  = '#8b8b00'
  let s:named_colors_['DarkYellow'] = '#8b8b00'
endfu " }}}

function! StandardColors() " {{{
  " This function gets all the names of the all the colors on the system
  " See MakeColorsWindow(3) to display all named colors
  " as foreground and background against
  " black, white and default colors in a window

  " these names are from from :h gui-colors in Jan/05/2018
  let s:named_colors0 = ['Red', 'LightRed', 'DarkRed', 'Green', 'LightGreen', 'DarkGreen', 'SeaGreen', 'Blue', 'LightBlue', 'DarkBlue', 'SlateBlue', 'Cyan', 'LightCyan', 'DarkCyan', 'Magenta', 'LightMagenta', 'DarkMagenta', 'Yellow', 'LightYellow', 'Brown', 'DarkYellow', 'Gray', 'LightGray', 'DarkGray', 'Black', 'White', 'Orange', 'Purple', 'Violet']
  call clearmatches()
  new
  setlocal buftype=nofile bufhidden=hide noswapfile
  0read $VIMRUNTIME/rgb.txt
  " - Delete lines where color name is not a single word (duplicates).
  " - Delete "grey" lines (duplicate "gray"; there are a few more "gray").
  "   TTM ??
  let tline = 1
  let mline = line('$')
  let named_colors = {}
  let named_colors_ = {}
  while tline <=  mline
    exec tline
    normal yy
    if @" == ''
      let tline += 1
      continue
    endif
    let [r, g, b, name] = [str2nr(@"[0:2]), str2nr(@"[4:6]), str2nr(@"[8:10]), @"[13:-2]]
    let mhex = Hex(r,g,b)
    " if name =~ 'gray'
    "   echo r g b mhex name
    " endif
    " echo r g b mhex name
    let tempdict = {'r'   :   r,
                  \ 'g'   :   g,
                  \ 'b'   :   b,
                  \ 'hex' :   mhex}
    let named_colors[tolower(name)] = tempdict
    let named_colors_[name] = tempdict
    let tline += 1
  endwhile
  let g:chicrute=55
  unlet named_colors['']  " find out why I am getting this 000 '' color...
  let s:named_colors = named_colors
  let s:named_colors_ = named_colors_
  call ColorsNotFound()
  call SpecialColors()
  q
endfunc " }}}

function! SpecialColors() " {{{
  " blood reds, blues, etcsss
  let snamed_colors = {}
  " from https://en.wikipedia.org/wiki/Blood_red
  let snamed_colors['blood'] = ['#660000', '#aa0000', '#af111c', '#830303', '#7e3517']
  let most10 = ['#3f5d7d', '#279b61', '#008ab8', '#993333', '#a3e496', '#95cae4', '#cc3333', '#ffcc33', '#ffff7a', '#cc6699']
endfu " }}}
