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

hi Normal         guifg=white         guibg=#e2725b
hi NonText        guifg=black         guibg=#e2725b
hi comment        guifg=black         guibg=#e2725b
hi constant       guifg=black         guibg=#e2725b
hi identifier     guifg=black         guibg=#e2725b
hi statement      guifg=black         guibg=#e2725b
hi preproc        guifg=black         guibg=#e2725b
hi type           guifg=black         guibg=#e2725b
hi special        guifg=black         guibg=#e2725b
hi Underlined     guifg=black         guibg=#e2725b
hi label          guifg=black         guibg=#e2725b
hi operator       guifg=black         guibg=#e2725b

hi ErrorMsg       guifg=black         guibg=#e2725b
hi WarningMsg     guifg=black         guibg=#e2725b
hi ModeMsg        guifg=black         guibg=#e2725b
hi MoreMsg        guifg=black         guibg=#e2725b
hi Error          guifg=black         guibg=#e2725b

hi Todo           guifg=black         guibg=#e2725b
hi Cursor         guifg=black         guibg=#e2725b
hi Search         guifg=black         guibg=#e2725b
hi IncSearch      guifg=black         guibg=#e2725b
hi LineNr         guifg=black         guibg=#e2725b
hi title          guifg=black         guibg=#e2725b

hi StatusLineNC   guifg=black         guibg=#e2725b
hi StatusLine     guifg=black         guibg=#e2725b
hi VertSplit      guifg=black         guibg=#e2725b

hi Visual         guifg=black         guibg=#e2725b

hi DiffChange     guifg=black         guibg=#e2725b
hi DiffText       guifg=black         guibg=#e2725b
hi DiffAdd        guifg=black         guibg=#e2725b
hi DiffDelete     guifg=black         guibg=#e2725b

hi Folded         guifg=black         guibg=#e2725b
hi FoldColumn     guifg=black         guibg=#e2725b
hi cIf0           guifg=black         guibg=#e2725b
