"# vim:textwidth=0:foldmethod=marker:foldlevel=1:
"======================================================================

"#Variables
set termwinkey=<C-s>

"#Keymaps
tnoremap <C-q> <C-s><C-c>
tnoremap <C-N> <C-s>N

"#Commands
if executable('nyagos')
  command! -nargs=* NyagosRun call s:termNyagos(<f-args>)
  command! NyagosQuit call <SID>term_sendkeys(bufnr('Nyagos'), "exit<CR>")

  function! s:termNyagos(...) abort "{{{2
  " setlocal shellcmdflag=-c
  " setlocal shellpipe=\|&\ tee
  " setlocal shellredir=>%s\ 2>&1
  " setlocal shellxquote="\""

    if (!bufexists('Nyagos'))
      call term_start('nyagos --norc', {
            \ 'term_name': 'Nyagos',
            \ 'term_rows': '10',
            \ 'term_finish': 'close',
            \ })
      wincmd j
    endif

    let args = join(map(copy(a:000), 'expand(v:val)'), ' ')
    call term_sendkeys(bufnr("Nyagos"), args . "\<CR>")
  endfunction "}}}2
endif

"#Colors
"##relaxed {{{2
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

"##iceberg-dark {{{2
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

