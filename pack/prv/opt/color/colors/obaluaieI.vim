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

hi Normal         guibg=white         guifg=black
hi NonText        guibg=white         guifg=#e2725b
hi comment        guibg=white         guifg=#e2725b
hi constant       guibg=white         guifg=#e2725b
hi identifier     guibg=white         guifg=#e2725b
hi statement      guibg=white         guifg=#e2725b
hi preproc        guibg=white         guifg=#e2725b
hi type           guibg=white         guifg=#e2725b
hi special        guibg=white         guifg=#e2725b
hi Underlined     guibg=white         guifg=#e2725b
hi label          guibg=white         guifg=#e2725b
hi operator       guibg=white         guifg=#e2725b

hi ErrorMsg       guibg=white         guifg=#e2725b
hi WarningMsg     guibg=white         guifg=#e2725b
hi ModeMsg        guibg=white         guifg=#e2725b
hi MoreMsg        guibg=white         guifg=#e2725b
hi Error          guibg=white         guifg=#e2725b

hi Todo           guibg=white         guifg=#e2725b
hi Cursor         guibg=white         guifg=#e2725b
hi Search         guibg=white         guifg=#e2725b
hi IncSearch      guibg=white         guifg=#e2725b
hi LineNr         guibg=white         guifg=#e2725b
hi title          guibg=white         guifg=#e2725b

hi StatusLineNC   guibg=white         guifg=#e2725b
hi StatusLine     guibg=white         guifg=#e2725b
hi VertSplit      guibg=white         guifg=#e2725b

hi Visual         guibg=white         guifg=#e2725b

hi DiffChange     guibg=white         guifg=#e2725b
hi DiffText       guibg=white         guifg=#e2725b
hi DiffAdd        guibg=white         guifg=#e2725b
hi DiffDelete     guibg=white         guifg=#e2725b

hi Folded         guibg=white         guifg=#e2725b
hi FoldColumn     guibg=white         guifg=#e2725b
hi cIf0           guibg=white         guifg=#e2725b
