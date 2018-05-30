" 4) Obaluaie - preto, branco e
"     vermelho terracota:
"   ./obaluiaie
" http://encycolorpedia.pt/e2725b

set background =dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "obaluaie"

hi Normal         guibg=black         guifg=white
hi NonText        guibg=black         guifg=#e2725b
hi comment        guibg=black         guifg=#e2725b
hi constant       guibg=black         guifg=#e2725b
hi identifier     guibg=black         guifg=#e2725b
hi statement      guibg=black         guifg=#e2725b
hi preproc        guibg=black         guifg=#e2725b
hi type           guibg=black         guifg=#e2725b
hi special        guibg=black         guifg=#e2725b
hi Underlined     guibg=black         guifg=#e2725b
hi label          guibg=black         guifg=#e2725b
hi operator       guibg=black         guifg=#e2725b

hi ErrorMsg       guibg=black         guifg=#e2725b
hi WarningMsg     guibg=black         guifg=#e2725b
hi ModeMsg        guibg=black         guifg=#e2725b
hi MoreMsg        guibg=black         guifg=#e2725b
hi Error          guibg=black         guifg=#e2725b

hi Todo           guibg=black         guifg=#e2725b
hi Cursor         guibg=black         guifg=#e2725b
hi Search         guibg=black         guifg=#e2725b
hi IncSearch      guibg=black         guifg=#e2725b
hi LineNr         guibg=black         guifg=#e2725b
hi title          guibg=black         guifg=#e2725b

hi StatusLineNC   guibg=black         guifg=#e2725b
hi StatusLine     guibg=black         guifg=#e2725b
hi VertSplit      guibg=black         guifg=#e2725b

hi Visual         guibg=blue         guifg=#e2725b

hi DiffChange     guibg=black         guifg=#e2725b
hi DiffText       guibg=black         guifg=#e2725b
hi DiffAdd        guibg=black         guifg=#e2725b
hi DiffDelete     guibg=black         guifg=#e2725b

hi Folded         guibg=black         guifg=#e2725b
hi FoldColumn     guibg=black         guifg=#e2725b
hi cIf0           guibg=black         guifg=#e2725b
