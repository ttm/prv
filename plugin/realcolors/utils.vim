fu! Hex(r,g,b)
  " Return RGB in Hex notation: #RRGGBB
  " expects a list [r, g, b] with values in [0, 255]
  if type(a:r) == 3
     return printf("#%02x%02x%02x", a:r[0], a:r[1], a:r[2])
  else
     return printf("#%02x%02x%02x", a:r, a:g, a:b)
  endif
endf

fu! GrayScale(from,to,ncolors)
  " nsteps = ncolors - 1
  let walk = a:to - a:from
  let colors = map(range(a:ncolors), "'#' . repeat(printf('%02x', a:from + v:val*walk/(a:ncolors - 1)), 3)")
  return colors
endfu

