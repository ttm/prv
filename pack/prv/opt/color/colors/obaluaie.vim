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

hi Normal         guifg=white        guibg=#e2725b
hi NonText        guifg=black
hi comment        guifg=black
hi constant       guifg=black
hi identifier     guifg=black
hi statement      guifg=black
hi preproc        guifg=black
hi type           guifg=black
hi special        guifg=black
hi Underlined     guifg=black
hi label          guifg=black
hi operator       guifg=black

hi ErrorMsg       guifg=black
hi WarningMsg     guifg=black
hi ModeMsg        guifg=black
hi MoreMsg        guifg=black
hi Error          guifg=black

hi Todo           guifg=black
hi Cursor         guifg=black
hi Search         guifg=black
hi IncSearch      guifg=black
hi LineNr         guifg=black
hi title          guifg=black

hi StatusLineNC   guifg=black
hi StatusLine     guifg=black
hi VertSplit      guifg=black

hi Visual         guifg=black

hi DiffChange     guifg=black
hi DiffText       guifg=black
hi DiffAdd        guifg=black
hi DiffDelete     guifg=black

hi Folded         guifg=black
hi FoldColumn     guifg=black
hi cIf0           guifg=black
