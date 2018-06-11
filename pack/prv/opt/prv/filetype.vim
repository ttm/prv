" for filetype attribution using file extension

if did_filetype()	" filetype already set..
  finish		" ..don't do these checks
endif

augroup filetypedetect
  au! BufRead,BufNewFile *.qweqwe		setfiletype mineqwe
  au! BufRead,BufNewFile *.xyzhw		setfiletype drawing
  au! BufRead,BufNewFile *.wiki		setfiletype vimwiki
  " au! BufRead,BufNewFile *.wiki		setl key=eusomuitogei
  " au! BufRead,BufNewFile *.wiki		setl cm=blowfish2
  au! BufRead,BufNewFile *.wiki		let g:banana=5
  " au! BufRead,BufNewFile *.wiki		setfiletype markdown
augroup END
