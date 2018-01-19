let g:cstatus = 'started loading color schemes'

fu! ParseOrixas() " {{{
  let f = readfile(expand('%:p:h') . '/data/orixas1.txt')
  let os = []
  let infos = {}
  for o in f[1:]
    if o =~ '.*:'
      let name = tolower(substitute(o, ':.*', '', ''))
      let info = substitute(o, '.*:', '', '')
      let info_ = substitute(info, '\s\{2,\}', ' ', 'g')
      call add(os, name)
      if !has_key(infos, name)
        let infos[name] = []
      endif
      call add(infos[name], info_)
    endif
  endfor
  let g:f = f
  let os_ = filter(copy(os), 'index(os, v:val, v:key+1)==-1')
  let g:os = sort(os_)
  let g:infos = infos
  return os
endfu " }}}

fu! AfricanCS() " {{{
  " https://www.pinterest.com/pin/456974693425216689/
  let synon = {'osanha': 'ossain', 'xapanã': 'xapana',
        \ 'oxaguiã': 'oxaguia', 'omulu': 'umulu',
        \ 'yansa': 'iansa'}
  " let allnames = ParseOrixas()
  let allnames = ['cosme', 'exu', 'ibeji', 'obaluaie', 'ogum', 'oxala', 'oxum', 'oxossi', 'pomba gira', 'preto velho', 'xango', 'xapana', 'yansa', 'yemanja', 'yori', 'yorima']
  let morenames = ['umulu', 'nana', 'olorum', 'ossain', 'oxaguia', 'oxumare', 'oba', 'ewa', 'logun ede', 'iroko']
  let palletes = {}
  let palletes.exu = ['redblood', 'black', 'yellow']
  let palletes.exu_ = MkPallte12(palletes.exu)
  let cs = {}
  let cs.exu = MkCS(palletes.exu_)
  " call ApplyCS(cs.exu
endfu " }}}

fu! MkPallte12(pallete) " {{{
  " return a 12 colors pallete from what comes
  " assuming pallete is a sequence of lists with three
  " values in [0,255] for rgb.
  let nder = 12.0/len(a:pallete)
  let colors = []
  for color in a:pallete
    let sum = 0
    for c in color
      let sum += c
    endfor
    let sum = sum/3
    let c_ = [color]
    let nder_ = 1
    if sum > 128 " closer to white
      while nder_ < nder
        let color = GetShade(color, 0.5)
        call add(c_, color)
        let nder_ += 1
      endwhile
    else
      while nder_ < nder
        let color = GetTint(color, 0.5)
        call add(c_, color)
        let nder_ += 1
      endwhile
    endif
    call extend(colors, c_)
  endfor
  " while len(colors) < 12
  "   let acolor = MaxDiff(colors)
  "   call add(colors, acolor)
  " endwhile
  return colors
endfu " }}}

fu! MaxDiff(colors) " {{{
  " Return a color that is maximally different from all the colors given
endfu " }}}

fu! MkCS(pallete) " {{{
  " Return a CS relating each basic group to a color
endfu " }}}

fu! ApplyCS(cs_pallete, method) " {{{
  " Apply a CS which should relate colors to groups
  " if a:method == 'commands'
    " let coms = a:cs_pallete.commands
  if a:method =~ "^c.*"
    let coms = a:cs_pallete
    if type(a:cs_pallete) == 0
      let coms = ['colo blue', 'hi Normal  guifg=#0fffe0 guibg=#03800b']
    endif
    for c in coms
      exec c
    endfor
  endif
endfu " }}}

fu! CommandColorSchemes() " {{{
  let cs = {}
  let cs.green1 = ['colo blue', 'hi Normal  guifg=#0fffe0 guibg=#03800b']
  let cs.green2 = ['colo torte', 'highlight Normal guifg=white  guibg=darkGreen']
  
  let cs.yellow1 = ['colo morning', 'hi Normal guibg=#ffff00', 'hi Constant cterm=bold guifg=#a0a010 guibg=NONE']

  let cs.red1 = ['colo koehler', 'hi Normal guibg=#800000']
  let cs.red1c = ['colo koehler', 'hi Normal guibg=#800000', 'hi Folded guifg=cyan guibg=#bb0000']
  let cs.red1b = ['colo koehler', 'hi Normal guibg=#900000']
  let cs.red2 = ['colo koehler', 'hi Normal guibg=#ff0000']
  let cs.red3 = ['colo koehler', 'hi Normal guibg=#ff8833']
  let cs.red4 = ['colo koehler', 
        \ 'highlight Normal guifg=black guibg=red', 
        \ 'highlight Comment guifg=black guibg=red gui=bold']
  let cs.red4 = ['colo koehler', 
        \ 'highlight Normal guifg=black guibg=red', 
        \ 'highlight Comment guifg=black guibg=red gui=bold',
        \ 'hi Constant guifg=#004444 cterm=NONE',
        \ 'hi Constant cterm=bold guifg=#900000',
        \ 'hi Comment cterm=bold guifg=#606000',
        \ 'hi Type guifg=#600060']
  let cs.red5 = ['colo torte',
        \ 'hi Folded guibg=#702020 guifg=#000000 cterm=bold',
        \ 'hi Comment ctermfg=12 guifg=#d0808f',
        \ 'hi Constant guifg=#ff0000',
        \ 'hi Identifier cterm=bold guifg=#e00f4f',
        \ 'hi Normal guifg=#ac3c3c guibg=Black',
        \ 'hi vimIsCommand cterm=bold guifg=#9c3c00',
        \ 'hi vimFunction guifg=#bcbc0c',
        \ 'hi vimOperParen cterm=bold guifg=#fc2c2c']
  let cs.redblackl = ['colo koehler', 'hi Normal guibg=#800000']
  let cs.passivepink1 = ['colo koehler', 'hi Normal guibg=#ff91af', 'hi Comment guifg=#888888', 'hi Identifier guifg=#bb7777', 'hi Constant guifg=#ffcccc']
  
  
  let cs.exu1 = cs.red4

  " Holy spirit: (many colors, each with a specific simbolism, look for them)

  let cs.blue1 = ['colo blue', 'hi Normal guibg=#0000ff']
  let cs.blue2 = ['colo blue', 'hi Normal guibg=#444488']

  let cs.blue2 = ['colo blue', 'hi Normal guibg=#444488']
  
  let cs._notes = {}
  let cs._notes.red1_4 = '~mythologically related to exu through yellow and red'
  let g:ccs = cs
endfu " }}}

" use
" call CommandColorSchemes()
" call ApplyCS(g:ccs['green1'], 'c')

fu! StandardColorSchemes() " {{{
  let s:scs = {'desc': 'dictionary for all color schemes'}
  let s:scs['Monochromatic'] = {'desc': 'one color shades'}
  let s:scs['Analogous'] = {'desc': 'one color shades'}
  let s:scs['LGray'] = {'desc': 'linear grayscale colorschemes'}
  " print(["%x" % ((i*255)//(N-1),) for i in range(N)])
  let s:scs['LGray']['2bit'] = ['#000000', '#ffffff', '#555555', '#aaaaaa']
  let vals4b = ['0', '24', '48', '6d', '91', 'b6', 'da', 'ff']
  let s:scs['LGray']['4bit'] = map(vals4b, '"#" . v:val . v:val  . v:val')
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
endfu " }}}

fu! AppyCS2(cs) " {{{
  " Most basic: 1 bg + 8fg + 3fg = 12 colors
  " Basic grouping of them?
  " Basic partitioning of them?
  " As in :h 
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
endfu " }}}

fu! MakeLRGBD() " {{{
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
  let g:colors_all['cs']['lmean_doc'] = 'has bw and colors in between. should have precedence given by the bg'
  let g:colors_all['cs']['lmean'] = l
endfu " }}}

fu! Warp(where, distortion) " {{{
  " Make cs more white or black or gray or tend
  " to a specific color
endfu " }}}

fu! MkRotationFlipCS(color) " {{{
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
endfu " }}}

fu! GetShade(color, factor) " {{{
  " new intensity = current intensity * (1 – shade factor)
  " factor = 1 => black
  let f = 1 - a:factor
  let c = map(a:color, "v:val*f")
  let c_ = CheckColor(c) " to enable the use of negative factor
  return c_
endfu " }}}

fu! GetTint(color, factor) " {{{
  " new intensity = current intensity + (255 – current intensity) * tint factor
  " factor = 1 => white
  let c = map(a:color, "v:val + (255 - v:val) * a:factor")
  let c_ = CheckColor(c) " to enable the use of negative factor
  return c_
endfu " }}}

fu! GetTone(color, factor) " {{{
  " Algorithm made as whished... TODO: find out the canonic routine
  " factor = 1 => gray
  let value = (a:color[0] + a:color[1] + a:color[2])/3
  let c = map(a:color, "v:val + (value - v:val) * a:factor")
  let c_ = CheckColor(c) " to enable the use of negative factor
  return c_
endfu " }}}

fu! CheckColor(c) " {{{
  let c = copy(a:c)
  for i in range(len(c))
    if c[i] > 255
      let c[i] = 255
    elseif c[i] < 0
      let c[i] = 0
    endif
  endfor
  return c
endfu " }}}

" Anti-Shade Tint and Tone: away from black, white or gray
" Anti-shade is a tint? an anti-tint is a shade?
" An anti-tone is a what?

let g:cs_set = v:true
let g:cstatus = 'ended loading color schemes'
