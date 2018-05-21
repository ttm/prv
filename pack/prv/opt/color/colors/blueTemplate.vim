set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "blueTemplate"

hi Normal         guifg=yellow        guibg=darkBlue
hi NonText        guifg=magenta
hi comment        guifg=gray
hi constant       guifg=cyan
hi identifier     guifg=gray
hi statement      guifg=white
hi preproc        guifg=green
hi type           guifg=orange
hi special        guifg=magenta
hi Underlined     guifg=cyan
hi label          guifg=yellow
hi operator       guifg=orange

hi ErrorMsg       guifg=orange        guibg=darkBlue
hi WarningMsg     guifg=cyan          guibg=darkBlue
hi ModeMsg        guifg=yellow
hi MoreMsg        guifg=yellow
hi Error          guifg=red           guibg=darkBlue

hi Todo           guifg=black         guibg=orange
hi Cursor         guifg=black         guibg=white
hi Search         guifg=black         guibg=orange
hi IncSearch      guifg=black         guibg=yellow
hi LineNr         guifg=cyan
hi title          guifg=white

hi StatusLineNC   guifg=black         guibg=blue
hi StatusLine     guifg=cyan          guibg=blue
hi VertSplit      guifg=blue          guibg=blue

hi Visual         guifg=black         guibg=darkCyan

hi DiffChange     guifg=black         guibg=darkGreen
hi DiffText       guifg=black         guibg=olivedrab
hi DiffAdd        guifg=black         guibg=slateblue
hi DiffDelete     guifg=black         guibg=coral    
                                                     
hi Folded         guifg=black         guibg=orange   
hi FoldColumn     guifg=black         guibg=gray30   
hi cIf0           guifg=gray

hi SpellBad       guifg=red
