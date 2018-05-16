au BufNewFile,BufRead index setfiletype wikiindex
au BufNewFile,BufRead about,notes,readme, setf wikiabout
au BufNewFile,BufRead releases setf wikireleases
au BufNewFile,BufRead \d\d\d setf wikirel

au BufNewFile,BufRead Antunes,Barros,Basbaum,Bez,Cardaci,Costa,
      \Glerm,Gularte,Machado,Mantovani,Martigli,Otto,Pataca,
      \Prado,Ruiz,Sampaio,Vanazzi,deborahAntunes,
      \Moisés,Skárnio,Valdivieso,Amiantus,TPPL,Bez setf wikirec

au BufNewFile,BufRead * setf wiki
