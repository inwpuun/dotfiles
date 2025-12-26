syntax on

set relativenumber
set numberwidth=2

set cpoptions+=n

set showcmd
set showmatch

set autoindent
set tabstop=4

set clipboard=unnamed

highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
" Enables cursor line position tracking:
set cursorline

" Removes the underline causes by enabling cursorline:
highlight clear CursorLine
highlight clear CursorLineNR

" Sets the line numbering to red background:
highlight CursorLineNR ctermbg=darkgrey

" Set highlight to 1000 ms
let g:highlightedyank_highlight_duration = 1000

" on pressing tab, insert 2 spaces
set expandtab
" show existing tab with 2 spaces width
set tabstop=2
set softtabstop=2
" when indenting with '>', use 2 spaces width
set shiftwidth=2


nnoremap m h|xnoremap m h|onoremap m h|
nnoremap h m|xnoremap h m|onoremap h m|
nnoremap H M|xnoremap H M|onoremap H M|

nnoremap n j|xnoremap n j|onoremap n j|
nnoremap N J|xnoremap N J|onoremap N J|
nnoremap j n|xnoremap j n|onoremap j n|
nnoremap J N|xnoremap J N|onoremap J N|

nnoremap e k|xnoremap e k|onoremap e k|
nnoremap E K|xnoremap E K|onoremap E K|
nnoremap k e|xnoremap k e|onoremap k e|
nnoremap K E|xnoremap K E|onoremap K E|

nnoremap i l|xnoremap i l|onoremap i l|
nnoremap l i|xnoremap l i|onoremap l i|
nnoremap L I|xnoremap L I|onoremap L I|

nnoremap I $|xnoremap I $|onoremap I $|
nnoremap M ^|xnoremap M ^|onoremap M ^|
