"# vim:textwidth=0:foldmethod=marker:foldlevel=1:
"======================================================================

autocmd! vimrcDependencies CmdLineLeave * call s:SetRelNr()

"$$ Functions {{{2

function s:SetRelNr() abort
  if &filetype !=# 'ctrlp' | setlocal relativenumber | endif
endfunction

function! CtrlPEnter()
  setlocal laststatus=0
  hi Cursor guifg=purple guibg=#110011
  hi CursorLine guifg=#8660C0 guibg=#110011
  hi CtrlPNoEntries guifg=#FF9740
  hi CtrlPMatch guifg=#F2D675
  hi CtrlPLinePre guifg=blue
  hi CtrlPPrtBase guifg=#75C6C3
  hi CtrlPPrtText guifg=#F2D675
  hi CtrlPPrtCursor guifg=#F2D675
  hi Normal guifg=#595857
endfunction

function! CtrlPLeave()
  setlocal laststatus=2
  hi Cursor guifg=black guibg=lightgreen
  hi CursorLine guifg=#000B00 guibg=#75C6C3
  hi Normal guifg=#C0C6C9
endfunction

"$$ Maps {{{1

nnoremap <leader>; <cmd>CtrlPBuffer<CR>
nnoremap <leader>m <cmd>CtrlPMRUFiles<CR>
nnoremap <leader>o <cmd>CtrlPCurWD<CR>
nnoremap <leader>r <cmd>CtrlPRoot<CR>
nnoremap <leader>b <cmd>CtrlPBookmarkDir<CR>

"$$ Options {{{2

" let g:ctrlp_map = '<leader>;'
" let g:ctrlp_cmd = 'CtrlP'
" let g:ctrlp_cmd = 'exe "CtrlP".get(["Buffer", "File"], v:count)'
" let g:loaded_ctrlp = 1
" let g:ctrlp_by_filename = 0
" let g:ctrlp_regexp = 0
let g:ctrlp_match_window = 'bottom,order:btt,min:7,max:7,result:50'
" let g:ctrlp_switch_buffer = 'Et'
let g:ctrlp_reuse_window = 'help\|quickfix'
" let g:ctrlp_tabpage_position = 'ac'
" let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_root_markers = ['.git']
let g:ctrlp_use_caching = 0
let g:ctrlp_show_hidden = 1
" let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
" let g:ctrlp_show_hidden = 0
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v(\.git|\.bundle|_site|vendor|node_modules|images|migemo)$',
  \ 'file': '\v\.(exe|msi|zip|7z|xz|cab|dll)$',
  \ }
" let g:ctrlp_max_files = 10000
" let g:ctrlp_max_depth = 40
" let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files']
let g:ctrlp_max_history = 10
" let g:ctrlp_open_new_file = 'v'
let g:ctrlp_open_multiple_files = '1vi'
" let g:ctrlp_arg_map = 0
let g:ctrlp_follow_symlinks = 1
" let g:ctrlp_lazy_update = 0
" let g:ctrlp_default_input = 'anystring'
" let g:ctrlp_match_current_file = 1
" let g:ctrlp_types = ['fil', 'buf', 'line']
" let g:ctrlp_abbrev = {}
" let g:ctrlp_key_loop = 0
let g:ctrlp_prompt_mappings = {
      \ 'PrtBS()':      ['<bs>', '<c-h>'],
      \ 'PrtCurLeft()': ['<left>', '<c-^>'],
      \ }
let g:ctrlp_line_prefix = ''
" let g:ctrlp_open_single_match = ['buffer tags', 'buffer']
let g:ctrlp_mruf_max = 50
" let g:ctrlp_mruf_exclude = ''
" let g:ctrlp_mruf_include = ''
" let g:ctrlp_tilde_homedir = 0
" let g:ctrlp_mruf_relative = 0
let g:ctrlp_mruf_default_order = 1
" let g:ctrlp_mruf_case_sensitive = 1
let g:ctrlp_mruf_save_on_update = 0
" let g:ctrlp_bufname_mod = ':t'
" let g:ctrlp_bufpath_mod = ':~:.:h'
" let g:ctrlp_open_func = {}
" let g:ctrlp_status_func = {}
let g:ctrlp_buffer_func = {
  \ 'enter': 'CtrlPEnter',
  \ 'exit': 'CtrlPLeave',
  \ }
" let g:ctrlp_match_func = {'match': 'ctrlp_matchfuzzy#matcher'}
" let g:ctrlp_path_nolim = 1
" let g:ctrlp_extensions = ['dir',  'file', 'buf']
