fu! PRVReinitializeAll() " {{{3
  if exists("g:loaded_prvplugin")
    exe 'so '.g:prv_dir.'plugin/prv.vim' 
    cal PRVInit()
  en
  if exists("g:loaded_aaplugin")
    exe 'so '.g:aa_dir.'plugin/aa.vim' 
    " AAInit() will clear sessions and etc. Settings
    " are already rerun when sourcing script
  en
  if exists("g:loaded_realcolorsplugin")
    " TODO TTM
  en
  if exists("g:loaded_tokiponaplugin")
    " TODO TTM
  en
endf
fu! Undoline() " {{{3  --- make mapping for this fu! TTM
  let pos = getpos(".")
  let current = getline(pos[1])
  let chg = changenr()
  wh changenr() > 0 && current ==# getline(pos[1])
    sil exe 'u'
  endw
  let old = getline(pos[1])

  wh changenr() < chg
    sil exe 'redo'
  endw
  " undo if we jumped over a gap
  if changenr() > chg
    sil exe 'u'
  en
  cal setpos('.', pos)
  if old ==# current
    ec 'no change found'
  el
    cal setline(pos[1], old)
  en
endf
fu! PToggleSO() " {{{3
  if &so < 10
    let g:p_so = &so
    se so = 999
  el
    se so = g:p_so
  en
endf


