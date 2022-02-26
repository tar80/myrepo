"# vim:textwidth=0:foldmethod=marker:
"======================================================================
"$$ variables

if has("termguicolors")
  setglobal termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

if !has("nvim")
  set termwinkey=<C-s>
endif

"$$ map

tnoremap <C-q> <C-s><C-c>
tnoremap <C-N> <C-s>N

"$$ colors

"@ relaxed {{{3
let g:terminal_ansi_colors = [
  \ "#151515",
  \ "#bc5653",
  \ "#909d63",
  \ "#ebc17a",
  \ "#6a8799",
  \ "#b06698",
  \ "#c9dfff",
  \ "#d9d9d9",
  \ "#636363",
  \ "#bc5653",
  \ "#a0ac77",
  \ "#ebc17a",
  \ "#7eaac7",
  \ "#b06698",
  \ "#acbbd0",
  \ "#f7f7f7",
  \ ]

"@ iceberg-dark {{{3
" let g:terminal_ansi_colors = [
  "\  "#1e2132",
  "\  "#e27878",
  "\  "#b4be82",
  "\  "#e2a478",
  "\  "#84a0c6",
  "\  "#a093c7",
  "\  "#89b8c2",
  "\  "#c6c8d1",
  "\  "#6b7089",
  "\  "#e98989",
  "\  "#c0ca8e",
  "\  "#e9b189",
  "\  "#91acd1",
  "\  "#ada0d3",
  "\  "#95c4ce",
  "\  "#d2d4de",
  "\  ]

