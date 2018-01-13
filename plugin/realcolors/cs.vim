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
  let colors = []
  for color in pallete
    let color_ = rgb[color]
    call add(colors, color_)
  endfor
  while len(colors) < 12
    let acolor = MaxDiff(colors)
    call add(colors, acolor)
  endwhile
  return colors
endfu " }}}
fu! MaxDiff(colors) " {{{
  " Return a color that is maximally different from all the colors given


endfu " }}}
fu! MkCS(pallete) " {{{
  " Return a CS relating each basic group to a color
endfu " }}}

fu! ApplyCS(pallete) " {{{
  " Apply a CS which should relate colors to groups
endfu " }}}

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
endf " }}}

fu! AppyCS(cs) " {{{
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
endf " }}}

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
endf " }}}

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
endf " }}}

let g:cs_set = v:true
let g:cstatus = 'ended loading color schemes'
