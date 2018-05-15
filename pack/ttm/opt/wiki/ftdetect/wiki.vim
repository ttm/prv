au BufNewFile,BufRead index setfiletype wikiindex
au BufNewFile,BufRead about,notes,readme, setfiletype wikiabout
au BufNewFile,BufRead releases setfiletype wikireleases

au BufNewFile,BufRead Antunes,Barros,Basbaum,Bez,Cardaci,Costa,Glerm,Gularte,Machado,Mantovani,Martigli,Otto,Pataca,Prado,Ruiz,Sampaio,Vanazzi,deborahAntunes setfiletype wikirec
au BufNewFile,BufRead \d\d\d setfiletype wikirel

au BufNewFile,BufRead * setfiletype wiki



