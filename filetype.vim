" for filetype attribution using file extension

if did_filetype()	" filetype already set..
  finish		" ..don't do these checks
endif

augroup filetypedetect
  au! BufRead,BufNewFile *.qweqwe		setfiletype mineqwe
  au! BufRead,BufNewFile *.xyzhw		setfiletype drawing
augroup END
