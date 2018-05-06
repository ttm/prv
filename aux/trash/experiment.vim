let d={'b':4, 'a':19}
fu! d.aa()
  ec self.b
endf

fu! TClass()
    let d = {'b':4, 'a':19}
    fu! d.aa()
      ec self.b
    endf
    return d
endf
