" Script standard documentation
" most advanced run: 
" basic run: \z to create color variables based on the cursor position
" and \x to change color under cursor.
" MakeColorsWindow dont match colors in the window made by running colors.vim


" Color many of the substitute patterns.
" Color the @" and @. registers.

" Make colorscheme with X11 colors:
" :echo filter(copy(colors_all['named1']), 'v:val[0:2]=="X11"')

" SynStack(): shows the name of the syn groups under cursor \Z
" MkBlack(): 
" TickColor(timer): 
" StartTick(): 
" GetColors(default): 
" IncrementColor(c,: 
" InitializeColors(): 
" GetAll(): 
" StartMappings(): 
" SwitchGround(): 
" RefreshColors(): 
" ChgColor(): 
" StandardColorsOrig(rgb_fb): 
" MakeColorsWindow(colors): (3,4) for new wintow with all colors
" StandardColors(rgb_fb): 

" References
" /usr/local/share/vim/vim80/doc/syntax.txt
" * For the preferred and minor groups


" ToDo
" * tradutor de verbose de syntax highlighting para colorscheme
" * Integrate Python & vim to convert freq to RGB
" make exercises with each of the vim's python-related functions
" g Write to list or report bug to Vim git: spellbad is lost in colorscheme blue (and other standard colorschemes) when set termguicolors in terminal because no cterm=undercurl or gui(fg/bg).
" * A function that analyses the current file and outputs
" a window with each of the colors used and their hi group and
" specifications.
" It should also allow then that the user toggles the original file
" between normal text view and another with each char substituted with
" the corresponding FG colors and their numbers and another
" with the BG colors and their numbers.
"
" * Commands to add new syntax group, match words and patterns,
" associate with other colors.
" Grab words and patterns under cursor, e.g. to add or remove
" words to a group, or use the same color settings
"
" * Think about making a mode to ease the syntax highlighting
" modifications

" * hlsearch and spellbad should one be bold and underline to avoid
" collision with programming language colors.
" * hlsearch and spellbad should use two of the cues: color, bold, underline.
" (italics?)

" * syntime report to get the syntax highlighting scheme being used
" 


" Show syntax highlighting groups for word under cursor
nmap <leader>z :w<CR>:so %<CR>:call InitializeColors()<CR><CR>
nmap <leader>Z :echo SynStack()<CR>
" nmap <leader>z :call MkBlack()<CR>
function! SynStack()
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
endfunc

" starting syntax highlighting facilities
" 1) change the color of the char under cursor to black
" This mkBlacl function and \z mapping is the main syntax highlighting debugger
let stack = map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
function! MkBlack()
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
endfunc

function! TickColor(timer)
  let s:anum = 0
  let s:tick = 1
  " default:
  " change some of the colors (of text and bg)
  " at the window in some patterns
  while s:tick == 1
    echo "banana =" s:anum
    let s:anum += 1
  endwhile
endfunc

function! StartTick()
  s:tickerids.push( timer_start(400, TickColor(), {'repeat': 3}) )
endfunction

function! GetColors(default)
  " Starts the dictionaries in this script's namespace with the colors on current position
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
  cal timer_stopall()
  let s:cs = g:colors_name
  let s:ground = 'fg'
  " creates the dictionary with colors on foreground and background
  " default, temporary and buffer in s:dcoulorsd, s:tcolorsd and s:colors
  cal GetColors(0)
  cal GetColors(1)
  cal GetColors(2)
  " initialize mappings
  cal StartMappings()
  " to keep track of the tickers___:
  let s:tickerids = []
  ec '---> default color:' s:dcolorsd
  ec '===> buffer color:' s:colors
  ec ':::> temp color:' s:tcolorsd
  " make named0 and named1 with the name of the colors:
  " 0: from documentation :h gui-colors
  " 1: from $VIMRUNTIME/rgb.txt
  cal StandardColors()

  let s:cs = {}
  cal StandardColorSchemes()
  let s:timers = []
  let s:counters = range(10)
  let s:ncounters = 0
  let s:patterns = {}
  let s:mpatterns = {'wave': 'call WavePattern()', 'std': 'call StandardPattern()', 'wobble': 'call Wobble()', 'silence': 'call BypassPattern'}
  " get all variables to the g:colors_all (new)
  " and g:colors_all_ (new) global variables
  cal GetAll()
  ec "type \\x to change color under cursor"
  ec " should be integrated to the mode <C-\ c>"
endf

function! GetAll()
  let g:colors_all = s:
  let g:colors_all_ = []
  for vkey in keys(s:)
    call add(g:colors_all_ , vkey)
  endfor
endfunction


function! StartMappings()
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
endfunction

function! SwitchGround()
  " To keep a record in our color server
  if s:ground == 'fg'
    s:ground = 'bg'
  else
    s:ground = 'fg'
  endif
endfunction

function! RefreshColors()
  " to do what???
  let c = s:colors
  let g = s:ground
  let fg_ = printf('#%02x%02x%02x', c[g]['r'], c[g]['g'], c[g]['b'])
endfunction

nmap <leader>x :call ChgColor()<CR>
function! ChgColor()
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
  elseif
    let name = Normal
    let fg = sfg
    let bg = sbg
  endif
  if has_key(s:named_colors, tolower(fg))
    let fg_named = fg
    let fg = s:named_colors[tolower(fg)]['hex']
  end
  let rgb = [fg[1:2], fg[3:4], fg[5:6]]
  let rgb_ = map(rgb, 'str2nr(v:val, "16")')

  if has_key(s:named_colors, tolower(bg))
    let bg_named = bg
    let bg = s:named_colors[tolower(bg)]['hex']
  endif
  let rgbb = [bg[1:2], bg[3:4], bg[5:6]]
  let rgbb_ = map(rgbb, 'str2nr(v:val, "16")')

  let [fg_, bg_] = [fg, bg]
  let c = 'foo'
  let who = 'fg'
  echo 'initial colors are fg, bs:' fg bg
  call getchar(1)
  while c != 'q'
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
      else
        let mex = 0
      endif
      if mex
        execute mcmd
        redraw
        echo fg_ bg_
      endif
      " echo 'hi' name 'guifg=' . fg_
  endwhile

  let s:me = l:
endfunc


function! StandardColorsOrig()
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
  " silent g/grey/d
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

fu! StandardColorSchemes()
  let s:scs = {'desc': 'dictionary for all color schemes'}
  let s:scs['Monochromatic'] = {'desc': 'one color shades'}
  let s:scs['LGray'] = {'desc': 'linear grayscale colorschemes'}
  let s:scs['LRGB'] = {'desc': 'linear maximum distance RGB colorschemes'}
  let s:scs['ERGB'] = {'desc': 'exponential maximum distance RGB colorschemes'}
  let s:scs['ERGB'] = {'desc2': 'Weber-Fechner laws'}
  let s:scs['PRGB'] = {'desc': 'power-law maximum distance RGB colorschemes'}
  let s:scs['PRGB'] = {'desc2': "Steven's laws"}
  let s:scs['PRGB'] = {'desc2': "Steven's laws"}
  " Linear distance maximization
  cal MakeLRGBD()
  " LF, EF, EF Frequency-related colorschemes (translate with wlrgb)
  " using harmonic series
  " how is rgb related to final frequency of the light?
  " RRGB randomic coloschemes
  " EERGB PPRGB Double Web-Fech and Stev laws
  " Arbitrary series or rgb or final frequency
endf

function! StandardColors()
  " Run :call StandardColors(1) for a more lightweight version
  " This function gets all the names of the all the colors on the system
  " See MakeColorsWindow(0) to display all named colors
  " as foreground and background against
  " black, white and default colors in a window

  " these names are from from :h gui-colors in Jan/05/2018
  let s:named0 = ['Red', 'LightRed', 'DarkRed', 'Green', 'LightGreen', 'DarkGreen', 'SeaGreen', 'Blue', 'LightBlue', 'DarkBlue', 'SlateBlue', 'Cyan', 'LightCyan', 'DarkCyan', 'Magenta', 'LightMagenta', 'DarkMagenta', 'Yellow', 'LightYellow', 'BrownsDarkYellow', 'Gray', 'LightGray', 'DarkGray', 'Black', 'White', 'Orange', 'PurplesViolet']
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
  while tline <=  mline
    exec tline
    normal yy
    if @" == ''
      let tline += 1
      continue
    endif
    let [r, g, b, name] = [@"[0:2], @"[4:6], @"[8:10], @"[13:-2]]
    "  str2nr(@a[0:2])
    let tempdict = {'r'   :   str2nr(r),
                  \ 'g'   :   str2nr(g),
                  \ 'b'   :   str2nr(b),
                  \ 'hex' :   printf("%02x%02x%02x", r,g,b)}
    let named_colors[tolower(name)] = tempdict
    let tline += 1
  endwhile
  let g:chicrute=55
  unlet named_colors['']  " find out why I am getting this 000 '' color...
  let s:named_colors = named_colors
  q
endfunc

""""""""""""""""""" {{{ Minimal Patterner
func! MyHandler(timer)
  echo 'Handler called' s:i
  let s:i += 1
endfunc
func! MyTimer(repeat, period)
  let s:i = 0
  let timer = timer_start(a:period, 'MyHandler',
        \ {'repeat': a:repeat})
  call add(s:timers, timer)
endfu
" }}}

"""""""""""" Don't Know {{{
" make a rhythm on numbers by updating a variable with list
" of numbers or patterns
"
" one calls the other to repeat n times.
" displacement/offset might be performed with repeat=1, period=silence)
" pattern(offset=2000, repeat=4, period=500)
func! MyHandler2(offset, timer, makeoffset)
  echo 'Handler called' s:counters
  if a:makeoffset == 1
    call MyHandler2(a:offset, 1, )
  let s:counters[i] += 1
endfunc

func! MyTimer2(offset, repeat, period)
  let timer = timer_start(a:period, 'MyHandler2',
        \ {'repeat': a:repeat, 'offset': a:offset, 'makeOffset': 1})
  call add(s:timers, timer)
endfu
" let s:pattern = s:MyTimer2
" }}}

""""""""""""""""""" {{{ Z-Patterner
fu! StandardPattern()
  let s:counters[s:ncounters] += s:ncounters
  let s:ncounters = (s:ncounters + 1) % len(s:counters)
endf

fu! BypassPattern()
  " for silence
  let foo = 'bar'
endf

fu! Pattern1(value)
  let s:counters[a:value] += a:value
endf

fu! WavePattern()
  call Voice(100, 20, 'std')
  call Voice(1, 1000, 'silence')
  call Voice(100, 20, 'std')
endf

function! Wobble(nlines)
  " Make curent line and next ones wobble
  let i = 0
  let mstart = system("echo $RANDOM")
  while i < nlines
    exec line('.')+i . 'center' 30+(i*1+mstart)%80
    let i += 1
  endwhile
endfunc

fu! PWobble()
  " let timer = timer_start(500, 'Wobble')
  " let timer = timer_start(500, 'Wobble',
  "      			\ {'repeat': a:repeat})
  call Voice(3, 200, 'Wobble(5)')
endf

fu! OverallPattern()
  call Voice(-1, 2000, 'PWobble')
endf


fu! MyHandler3(timerID)
  " a:timer is the number of repeats.
  " the duration is set by MyTimer3(timer=a:timer, duration=XXX)
  let foo = copy(s:counters)
  if !has_key(s:patterns, a:timerID)
    " call StandardPattern()
    cal BypassPattern()
  el
    exe s:patterns[a:timerID]
  en
  " let rand = system("echo $RANDOM")%len(s:counters)
  " echo [rand, len(s:counters)]
  " let s:counters[rand] += rand
  let bar = [s:ncounters, len(s:counters)]
  " echo bar 'Handler called' foo
  "     \ '\nHandler finished' s:counters ' ' a:timer
  ec bar 'Handler called' foo
      \ '\nHandler finished' s:counters ' ' a:timerID
endf

func! MyTimer3(repeats, duration, value)
  " timer is number of subsequent timer onsets
  " duration is period in ms
  " value is simpy not being used
  let timerID_ = timer_start(a:duration, 'MyHandler3',
        \ {'repeat': a:repeats})
  echo timerID_
  let s:patterns[timerID_] = "call Pattern1(". a:value .")"
  call add(s:timers, timerID_)
endfu
" let s:pattern = s:MyTimer3
"
"
" }}}

""""""""""""""""""" {{{ Z-Patterner2
fu! SporkVoice(timerID)
  " a:timer is the number of repeats.
  " the duration is set by MyTimer3(timer=a:timer, duration=XXX)
  let foo = copy(s:counters)
  if !has_key(s:patterns, a:timerID)
    " call StandardPattern()
    cal BypassPattern()
  el
    exe s:patterns[a:timerID]
  en
  " let rand = system("echo $RANDOM")%len(s:counters)
  " echo [rand, len(s:counters)]
  " let s:counters[rand] += rand
  let bar = [s:ncounters, len(s:counters)]
  " echo bar 'Handler called' foo
  "     \ '\nHandler finished' s:counters ' ' a:timer
  ec bar 'Handler called' foo
      \ '\nHandler finished' s:counters ' ' a:timerID
endf

fu! Voice(repeats, duration, patternID)
  " timer is number of subsequent timer onsets
  " duration is period in ms
  " value is simpy not being used
  let timerID_ = timer_start(a:duration, 'SporkVoice',
        \ {'repeat': a:repeats})
  echo timerID_
  if type(a:patternID) == 0
    let s:patterns[timerID_] = "call Pattern1(". a:value .")"
  elsei has_key(s:mpatterns, a:patternID)
    let s:patterns[timerID_] = s:mpatterns[a:patternID]
  else
    let s:patterns[timerID_] = 'call' a:patternID
  en
  call add(s:timers, timerID_)
endfu
" let s:pattern = s:MyTimer3
"
"
" }}}

" TTM {{{
" function! StandardColors()
" endfunc
" To use, save this file and type ":so %"
" Optional: First enter ":let g:rgb_fg=1" to highlight foreground only.
" Restore normal highlighting by typing ":call clearmatches()"
"
" Create a new scratch buffer:
" - Read file $VIMRUNTIME/rgb.txt
" - Delete lines where color name is not a single word (duplicates).
" - Delete "grey" lines (duplicate "gray"; there are a few more "gray").
" Add matches so each color name is highlighted in its color.
" call clearmatches()
" new
" setlocal buftype=nofile bufhidden=hide noswapfile
" 0read $VIMRUNTIME/rgb.txt
" let find_color = '^\s*\(\d\+\s*\)\{3}\zs\w*$'
" silent execute 'v/'.find_color.'/d'
" silent g/grey/d
" let namedcolors=[]
" 1
" while search(find_color, 'W') > 0
"     let w = expand('<cword>')
"     call add(namedcolors, w)
" endwhile
" 
" for w in namedcolors
"     execute 'hi col_'.w.' guifg=black guibg='.w
"     execute 'hi col_'.w.'_fg guifg='.w.' guibg=NONE'
"     execute '%s/\<'.w.'\>/'.printf("%-36s%s", w, w).'/g'
" 
"     call matchadd('col_'.w, '\<'.w.'\>', -1)
"     " determine second string by that with large # of spaces before it
"     call matchadd('col_'.w.'_fg', ' \{10,}\<'.w.'\>', -1)
" endfor
" 1
" nohlsearch
" 
" " TTM }}}










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
"
"  "/usr/local/share/vim/vim80/rgb.txt" "/usr/local/share/vim/vim80/rgb.txt"
"  782L, 17780CPress ENTER or type command to continue 
"
"  ---- Color Schmems {{{
fu! Hex(c)
 return printf("#%02x%02x%02x", a:c[0], a:c[1], a:c[2])
endf

fu! AppyCS(cs)
  let c = a:cs
  exec "hi Normal     guibg=" . Hex(c[0]) . " guifg=" . Hex(c[1])
  exec "hi Comment    guifg=" . Hex(c[2])
  exec "hi Constant   guifg=" . Hex(c[3])
  exec "hi Identifier guifg=" . Hex(c[4])
  exec "hi Statement  guifg=" . Hex(c[5])
  exec "hi PreProc    guifg=" . Hex(c[6])
  exec "hi Type       guifg=" . Hex(c[7])
  exec "hi Special    guifg=" . Hex(c[8])

  hi Underlined gui=underline
  hi Error gui=reverse
  hi Todo guifg=black guibg=white
endf
fu! MakeLRGBD()
  let mean_colors = [[255, 128, 0],
                   \ [0, 255, 128],
                   \ [128, 0, 255],
                   \ [0, 128, 255],
                   \ [255, 0, 128],
                   \ [128, 255, 0]]
  let l = []
  let bwg = [[0,0,0],[255,255,255],[128,128,128]]
  for c in mean_colors
    let cs_ = MkRotationFlipCS(c) + bwg
    call add(l, cs_)
  endfor
  let s:cs['lmean_doc'] = 'has bw and colors in between. should have precedence given by the bg'
  let s:cs['lmean'] = l
endfu

fu! Warp(where, distortion)
  " Make cs more white or black or gray or tend
  " to a specific color
endf
fu! MkRotationFlipCS(color)
  let c = a:color
  let f = [255 - c[0], 255 - c[1], 255 - c[2]]
  let cs =   [c,
           \ [c[2], c[0], c[1]],
           \ [c[1], c[2], c[0]],
           \  f,
           \ [f[2], f[0], f[1]],
           \ [f[1], f[2], f[0]]
           \ ]
  return cs
endf
"  }}}


