" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Maintainer:	Renato Fabbri <renato.fabbri@gmail.com>
" Last Change:	2019 Apr

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "yellow"
hi Normal		guifg=red       	guibg=yellow
hi NonText		guifg=magenta
hi comment		guifg=gray
hi constant		guifg=darkcyan
hi identifier	        guifg=gray
hi statement	        guifg=darkred
hi preproc		guifg=darkgreen
hi type			guifg=red
hi special		guifg=orange
hi Underlined   	guifg=cyan
hi label		guifg=lightgreen
hi operator		guifg=orange

hi ErrorMsg		guifg=orange      	guibg=darkBlue
hi WarningMsg   	guifg=cyan		guibg=darkBlue
hi ModeMsg		guifg=lightyellow
hi MoreMsg		guifg=lightyellow
hi Error		guifg=red		guibg=darkBlue

hi Todo			guifg=black		guibg=orange
hi Cursor		guifg=black		guibg=white
hi Search		guifg=black		guibg=orange
hi IncSearch    	guifg=black		guibg=yellow
hi LineNr		guifg=cyan
hi title		guifg=white

hi StatusLineNC	        guifg=black             guibg=blue
hi StatusLine  	        guifg=cyan      	guibg=blue
hi VertSplit   	        guifg=blue      	guibg=blue

hi Visual		term=reverse

hi DiffChange	        guifg=black             guibg=darkGreen
hi DiffText		guifg=black             guibg=olivedrab
hi DiffAdd		guifg=black             guibg=slateblue
hi DiffDelete           guifg=black             guibg=coral
                                                                        
hi Folded		guifg=black             guibg=orange
hi FoldColumn	        guifg=black             guibg=gray30
hi cIf0			guifg=gray

