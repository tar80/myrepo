"# vim:textwidth=0:foldmethod=marker:foldlevel=1:
"===============================================================================

if jetpack#tap('mr.vim') "{{{2
  let g:mr_mru_disabled = 1
  let g:mr#threshold = 100
  let g:mr#mrw#filename = '~\.cache\mr\mrw'
  let g:mr#mrr#filename = '~\.cache\mr\mrr'
  let g:mr#mrw#predicates = [{ path -> path !~# '.git\' }, { path -> path !~# 'temp\' }, { path -> path !~# '.log' }]
  packadd mr.vim
endif

"##Options {{{2
" let g:ctrlp_map = '<leader>;'
" let b:ctrlp_user_command = 'fd -HL -c never --exclude node_modules --exclude migemo --exclude ".git" "" %s'
" let g:ctrlp_cmd = 'exe "CtrlP".get(["Buffer", "File"], v:count)'
let g:ctrlp_match_window = 'bottom,order:ttb,min:10,max:10,results:50'
let g:ctrlp_reuse_window = 'help\|quickfix'
" let g:ctrlp_root_markers = ['.git']
let g:ctrlp_use_caching = 0
let g:ctrlp_show_hidden = 1
let g:ctrlp_cache_dir = $HOME .. '/.cache/ctrlp'
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v(\.git|\.bundle|_site|vendor|node_modules|images|migemo)$',
      \ 'file': '\v\.(msi|7z|xz|cab|dll|bmp|jpeg)$',
      \ }
let g:ctrlp_max_files = 500
let g:ctrlp_max_history = 0
let g:ctrlp_open_multiple_files = '1vi'
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_prompt_mappings = {
      \ 'PrtBS()':      ['<bs>', '<C-h>'],
      \ 'PrtCurLeft()': ['<left>', '<C-^>'],
      \ 'PrtSelectMove("j")': ['<C-j>', '<C-n>', '<Down>'],
      \ 'PrtSelectMove("k")': ['<C-k>', '<C-p>', '<Up>'],
      \ 'PrtHistory(-1)':     [],
      \ 'PrtHistory(1)':      [],
      \ }
let g:ctrlp_line_prefix = '▶'
let g:ctrlp_mruf_max = 0
let g:ctrlp_mruf_save_on_update = 0
let g:ctrlp_buffer_func = {
      \ 'enter': 'CtrlPEnter',
      \ 'exit': 'CtrlPLeave',
      \ }
" let g:ctrlp_open_func = {
"       \ }
let g:ctrlp_extensions = ['tag', 'line', 'mr/mrw', 'mr/mrr']
let g:ctrlp_types = ['buf', 'fil', 'line']
"}}}2
"##Keymaps {{{1
nnoremap <leader>; <Cmd>CtrlPBuffer<CR>
nnoremap <leader>m <Cmd>CtrlPMRMrw<CR>
nnoremap <leader>n <Cmd>CtrlPMRMrr<CR>
nnoremap <leader>o <Cmd>CtrlPCurWD<CR>
nnoremap <leader>l <Cmd>CtrlPLine<CR>

"##Autocmd {{{1
exe 'autocmd Jetpack User JetpackCtrlpVimPost call <SID>load_extensions()'

"##Functions
function! s:load_extensions() abort "{{{2
  if jetpack#tap('ctrlp-matchfuzzy')
    let g:ctrlp_match_func = {'match': 'ctrlp_matchfuzzy#matcher'}
    packadd ctrlp-matchfuzzy
  endif
  if jetpack#tap('ctrlp-mr.vim')
    packadd ctrlp-mr.vim
  endif
endfunction "}}}2
function! CtrlPEnter() "{{{2
  setlocal laststatus=0
  hi! link Cursor Operator
  hi! link CursorLine Operator
  " hi Normal guifg=#557788
endfunction "}}}2
function! CtrlPLeave() "{{{2
  setlocal laststatus=2
  hi link Cursor NONE
  hi link CursorLine NONE
  " hi Normal guifg=#80B0B6
endfunction "}}}2
" function! CtrlPOpenTag(action, line) abort "{{{2
"   if a:action == 'e'
"     let l:tag = substitute(a:line, "\t.*", "", "")
"       " call ctrlp#exit()
"       echo a:line
"   endif
" endfunction "}}}2


