" ----------------------- Adding packages {{{1
" in pack/plugins/opt/
" packadd gruvbox
" " in pack/ttm/opt/
pa prv
pa realcolors
pa aa
pa bot
" pa calendar.vim
let g:nv_search_paths = ['~/tempo/mwiki', '~/writing', '~/code', 'docs.md' , './notes.md']
let g:nv_search_paths = ['~/.vim/pack/ttm/opt/prv/aux/vimwiki', '~/tempo/mwiki']
let g:nv_default_extension = '.wiki'
pa vimwiki
pa fzf
pa fzf.vim
pa notational-fzf-vim
pa vimwiki
" pa tokipona
" pa gmail.vim

" ------------------------ ttm final startup {{{1
" hi Terminal guibg=lightgrey guifg=blue
cal CommandColorSchemes()
" colo blue
cal ApplyCS(g:ccs.green1, 'c')
cal ApplyCS(g:ccs.yellow1, 'c')
cal ApplyCS(g:ccs.green2, 'c')

" usar red1, 2, 3 para priorizacao de alerta p detalhes
" blue 1, 2, 3 p criatividade e ficar acordado (acordado sonhando)
" passive pink, branco, preto, outras cores como especiais ou paradigmaticas
" green 1, 2, 3, 4... p priorização d good vibes, cura, esquilíbrio
" yellow 1, 2, 3... p priorização d inteligência (equilíbrio de verde e
" vermelho,
" magenta p trabalho urgente: criatividade e detalhes
" cian p criação e eqiulíbrio
" etc etc

" ['exu1', '_notes', 'yellow1', 'redblackl', 'passivepink1', 'green1', 'green2', 'red1', 'red2', 'red3', 'red4', 'red5', 'blue1', 'blue2', 'red1b', 'red1c']
