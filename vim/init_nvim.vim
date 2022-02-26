"# vim:textwidth=0:foldmethod=marker:
"======================================================================

"@ Enables pseudo-transparency for the popup-window
set pumblend=10
"@ list of directories for undo files
set undodir=$HOME/.cache/nvim-data/undolog

"@ disable background color
highlight Normal guibg=NONE
highlight LineNr guibg=NONE
highlight SignColumn guibg=NONE

"@ yank clipbord
nnoremap <S-insert> "*p
vnoremap <C-insert> "*y
vnoremap <C-delete> "*ygvd

