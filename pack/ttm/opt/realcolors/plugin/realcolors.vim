" pallete: choice of colors
" scheme: association of colors with syntax groups
" :sy creates groups and associates them to textual elements
" :hi associates them to display parameters: colors + (bold + italics + underline + reverse)
" underline + strikeout)
" Script minimal documentation {{{
" most advanced run: 
" basic run: \z to create color variables based on the cursor position
" and \x to change color under cursor.
" MakeColorsWindow dont match colors in the window made by running colors.vim
"
" All commands are in <C-\> namespace and are valid for all modes.
" Start the system with <C-\>I (reloads all files from all plugins)
" or <C-\>i (reloads current file) 
" Look at the global variables g:colors_all and g:colors_all_ after
" starting.
" Check mappings in realcolor/mappings.vim to grasp overall functionality
" }}}

" -Structure: Auto loaded by vim's plugin system {{{
" ### so realcolors/cs.vim
"
" ### so realcolors/tools.vim
" InitializeColors() - calls functions markied with ***
" GetColors(default)  ***
" StandardColors() ***
" StandardColorSchemes() ***
" GetAll() ***
" ChgColor() - Masterpiece. TODO: enhance key mappings
" SynStack()                
" MkBlack()                
" MakeColorsWindow(colors)  - Masterpiece. Shows named colors agains b&w and Normal fg/bg. TODO: make it work for all 0 1 2 3
" StandardColorsOrig() - Masterpiece. Shows the named colors available as fg
" and bg against default fg abd bg
"
" Undeveloped, maybe remove:
" IncrementColor(c, g) -  changes s:colors and uses RefreshColors() TODO
" SwitchGround() - global variable ground
" RefreshColors() TODO
"
" ### so realcolors/mappings.vim
" <C-\> standard routines
"
" ### so realcolors/dynamic.vim
" Wobble(nlines)           
" TickColor(timer)         
" StartTick()              
"
" ### ascii art ??
" }}}

" References {{{
" /usr/local/share/vim/vim80/doc/syntax.txt
" * For the preferred and minor groups
" }}}

" TODO {{{
" * Account for coloring that does not appear with <c-\> s as is: search
" highligh when typing and afterwards, spellbad, other spell classes?
" Lines number bar. statusbar and tabs bar colors. Colors of the command-line
" * Relation of all basic syn groups and their colors
" * tradutor de verbose de syntax highlighting para colorscheme
" * Integrate Python & vim to convert freq to RGB
" make exercises with each of the vim's python-related functions
" * Write to list or report bug to Vim git: spellbad is lost in colorscheme blue (and other standard colorschemes) when set termguicolors in terminal because no cterm=undercurl or gui(fg/bg).
"   - Show my solution let mysyntaxfile = '~/.vim/syntax/mysyntaxfileTTM.vim'
" * A function that analyses the current file and outputs
" a window with each of the colors used and their hi group and
" specifications.
" It should also allow then that the user toggles the original file
" between normal text view and another with each char substituted with
" the corresponding FG colors and their numbers and another
" with the BG colors and their numbers.
"
" * Commands to add new syntax group, match words and patterns,
" associate with other colors.
" Grab words and patterns under cursor, e.g. to add or remove
" words to a group, or use the same color settings
"
" * Think about making a mode to ease the syntax highlighting
" modifications

" * hlsearch and spellbad should one be bold and underline to avoid
" collision with programming language colors.
" * hlsearch and spellbad should use two of the cues: color, bold, underline.
" (italics?)

" * syntime report to get the syntax highlighting scheme being used
" }}}

" Further notes: {{{
" Color many of the substitute patterns.
" Color the @" and @. registers.

" Make colorscheme with X11 colors:
" :echo filter(copy(colors_all['named1']), 'v:val[0:2]=="X11"')
"
" syntax change undo
" increment/decrement rgb
" in the char under cursor

" start a function that receives
" the modifications throug the
" keys RGB and before it (rewq, gfds, bvcx).
" for backgound, press j and use the same keys.
" uppercase is used for more resolution.

" q quits.

" Another functionality:
" Makes a color pallete from the special colors
" or other palletes that are special or
" that are derived from a color or set of colors.

" Another functionality:
" swap two colors grabed from cursor.
" rotate all the colors maintaining the background
" or not.

" find make tests with synID trans false and true
" We have the syngroups givem by synstack
" and the effectively used one, given
" by synIDtrans

" their name might be found with
" synIDattr

" If set hi group from synstack,
" the link used beforehand is lost.
" e.g.  :hi vimHiGuiFgBg guifg=#000000
" Makes you loose the link to gruvboxYellow
" }}}

" Function to the the SID as a last resort {{{
" function s:MYSID()
"   return matchstr(expand('<sfile>'),  '<SNR>\zs\d\+\ze_SID$')
" endfun
" let s:mysid = s:SID()
" }}}
let g:loaded_colorsPlugin = 'v01'
" GetLatestVimScripts: 5650 1 :AutoInstall: Realcolors

fu! HiFile() " {{{1
  " Does a bad job... But the idea is good, enhance it! TTM
  " run to hightlight the buffer with the highlight output
  " e.g. after :Split sy or :Split hi
    let i = 1
    while i <= line("$")
        if strlen(getline(i)) > 0 && len(split(getline(i))) > 2
            let w = split(getline(i))[0]
            exe "syn match " . w . " /\\(" . w . "\\s\\+\\)\\@<=xxx/"
        endif
        let i += 1
    endwhile
endfu
