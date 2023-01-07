"# vim:textwidth=0:foldmethod=marker:foldlevel=1:
"===============================================================================

if jetpack#tap('vim-findroot') "{{{2
  let g:findroot_not_for_subdir = 0
  exe 'autocmd Jetpack  User JetpackVimFindrootPost call findroot#cd(0)'
endif

if jetpack#tap('ale') "{{{2
  nmap <silent> [d  <Cmd>ALEPreviousWrap<CR>
  nmap <silent> ]d  <Cmd>ALENextWrap<CR>
  nmap <silent> glf <Cmd>ALEFix<Bar>echo "[ale] Format code"<CR>
  nmap <silent> glr <Cmd>ALERename<CR>
  nmap <silent> gle <Cmd>ALEPopulateLocList<Bar>wincmd p<CR>
  inoremap <expr> <Tab> pumvisible() ? '<C-n>' : '<Tab>'

  set omnifunc=ale#completion#OmniFunc
  " let g:ale_root = {}
  let g:airline#extensions#ale#enabled = 0
  let g:ale_cache_executable_check_failures = 1
  let g:ale_disable_lsp = 0
  let g:ale_completion_enabled = 1
  " let g:ale_floating_preview = 1
  " let g:ale_detail_to_floating_preview = 1
  let g:ale_hover_cursor = 0
  " let g:ale_hover_to_preview = 1
  " let g:ale_hover_to_floating_preview = 1
  let g:ale_set_balloons = 0
  let g:ale_echo_cursor = 1
  let g:ale_echo_delay = 100
  let g:ale_echo_msg_format = '[%linter%]%code: %%s'
  let g:ale_virtualtext_cursor = 0
  " let g:ale_virtualtext_delay = 100
  " let g:ale_virtualtext_prefix = ''
  "Note: Set "g:ale_history_enabled=1" when checking Log with ALEInfo
  let g:ale_history_enabled = 0
  " let g:ale_sign_column_always = 1
  let g:ale_sign_priority = 9
  let g:ale_sign_error    = ''
  let g:ale_sign_warning  = ''
  let g:ale_linters = {
        \  'javascript': ['deno'],
        \  'markdown': ['textlint'],
        \ }
  let g:ale_lint_delay = 100
  let g:ale_lint_on_enter = 1
  let g:ale_lint_on_filetype_changed = 1
  let g:ale_lint_on_text_changed = 'normal'
  let g:ale_lint_on_insert_leave = 1
  let g:ale_lint_on_save = 1
  let g:ale_fixers = {
        \ 'javascript': ['prettier'],
        \ 'markdown': ['prettier'],
        \ 'lua': ['luafmt'],
        \ }
  let g:ale_fix_on_save = 0
    let g:ale_completion_symbols = {
  \ 'text': '',
  \ 'method': '',
  \ 'function': '',
  \ 'constructor': '',
  \ 'field': '',
  \ 'variable': '',
  \ 'class': '',
  \ 'interface': '',
  \ 'module': '',
  \ 'property': '',
  \ 'unit': 'unit',
  \ 'value': 'val',
  \ 'enum': '',
  \ 'keyword': 'keyword',
  \ 'snippet': '',
  \ 'color': 'color',
  \ 'file': '',
  \ 'reference': 'ref',
  \ 'folder': '',
  \ 'enum member': '',
  \ 'constant': '',
  \ 'struct': '',
  \ 'event': 'event',
  \ 'operator': '',
  \ 'type_parameter': 'type param',
  \ '<default>': 'v'
  \ }
endif

if jetpack#tap('vim-parenmatch') "{{{2
  hi! link ParenMatch MatchParen
  call parenmatch#setup_ignore_filetypes("help")
  call parenmatch#setup_ignore_buftypes("nofile, popup")
endif

" if jetpack#tap('vim-registers-lite') "{{{2
" let g:registerslite_max_width = 60
" let g:registerslite_max_height = 100
" let g:registerslite_hide_dupricate = 1
" endif

if jetpack#tap('vim-operator-replace') "{{{2
  map \  <Plug>(operator-replace)
  map _  "0<Plug>(operator-replace)
endif

if jetpack#tap('vim-operator-surround') "{{{2
  map <silent> <Leader>r <Plug>(operator-surround-replace)
  map <silent> <Leader>a <Plug>(operator-surround-append)
  map <silent> <Leader>d <Plug>(operator-surround-delete)
  nmap <silent> <Leader>i <Plug>(operator-surround-append)i
  nmap <silent> <Leader>a <Plug>(operator-surround-append)a
  nmap <silent> <Leader>d <Plug>(operator-surround-delete)a
endif

if jetpack#tap('vim-smartword') "{{{2
  nmap w <Plug>(smartword-w)
  nmap b <Plug>(smartword-b)
  nmap e <Plug>(smartword-e)
  nmap ge <Plug>(smartword-ge)
endif

if jetpack#tap('vim-eft') "{{{2
  map f <Plug>(eft-f-repeatable)
  map F <Plug>(eft-F-repeatable)
  map t <Plug>(eft-t-repeatable)
  map T <Plug>(eft-T-repeatable)
endif

if jetpack#tap('caw.vim') "{{{2
  let g:caw_hatpos_startinsert_at_blank_line = 0
  let g:caw_hatpos_skip_blank_line = 1
  let g:caw_hatpos_align = 0
  let g:caw_zeropos_startinsert_at_blank_line = 0
  let g:caw_dollarpos_startinsert = 1
  let g:caw_wrap_skip_blank_line = 0
  let g:caw_no_default_keymappings = 1

  if jetpack#tap('vim-operator-user')
    nmap gcc <Plug>(caw:hatpos:toggle)
    nmap gci <Plug>(caw:hatpos:comment:operator)
    nmap gcui <Plug>(caw:hatpos:uncomment:operator)
    nmap gcI <Plug>(caw:zeropos:comment:operator)
    nmap gcuI <Plug>(caw:zeropos:uncomment:operator)
    nmap gca <Plug>(caw:dollarpos:comment:operator)
    nmap gcua <Plug>(caw:dollarpos:uncomment:operator)
    nmap gco <Plug>(caw:jump:comment-next)
    nmap gcO <Plug>(caw:jump:comment-prev)
  else
    nmap gcc <Plug>(caw:hatpos:toggle)
    nmap gci <Plug>(caw:hatpos:comment)
    nmap gcui <Plug>(caw:hatpos:uncomment)
    nmap gcI <Plug>(caw:zeropos:comment)
    nmap gcuI <Plug>(caw:zeropos:uncomment)
    nmap gca <Plug>(caw:dollarpos:comment)
    nmap gcua <Plug>(caw:dollarpos:uncomment)
    nmap gco <Plug>(caw:jump:comment-next)
    nmap gcO <Plug>(caw:jump:comment-prev)
  endif

  xmap gcc <Plug>(caw:hatpos:toggle)
  xmap gci <Plug>(caw:hatpos:comment)
  xmap gcui <Plug>(caw:hatpos:uncomment)
  xmap gcI <Plug>(caw:zeropos:comment)
  xmap gcuI <Plug>(caw:zeropos:uncomment)
  xmap gca <Plug>(caw:dollarpos:comment)
  xmap gcua <Plug>(caw:dollarpos:uncomment)
endif

if jetpack#tap('open-browser.vim') "{{{2
  " let g:openbrowser_search_engines = {}
  " (default: See below)
  " You can add favorite search engines like: >
  " let g:openbrowser_search_engines = {
        "\   'favorite': 'http://example.com/search?q={query}',
  "\}
  let g:openbrowser_open_vim_command = "split"
  " (default: "vsplit")
  " This value is used for opening looks-like-a-path string.
  " See |g:openbrowser_open_filepath_in_vim| for the details.
    " let g:openbrowser_message_verbosity = 2
    " (default: 2)
    " value meaning ~
    " 0     no messages / no error messages
    " 1     no messages / show error messages
    " 2     show messages / show error messages
    " NOTE: Even if this value is 2, no messages are echoed when
    " |g:openbrowser_format_message|.msg is empty value.
    let g:openbrowser_use_vimproc = 0
    " let g:openbrowser_force_foreground_after_open = 0
    " (default: 0)
    " If this value is non-zero,
    " make Vim foreground after opening URL or searching word(s).
    nmap <Space>/ <Plug>(openbrowser-smart-search)
    xmap <Space>/ <Plug>(openbrowser-smart-search)
  endif

  if jetpack#tap('undotree') "{{{2
    nnoremap <F7> <Cmd>UndotreeToggle<CR>

    let g:undotree_WindowLayout = 2
    let g:undotree_ShortIndicators = 1
    if !exists('g:undotree_SplitWidth')
      if g:undotree_ShortIndicators == 1
        let g:undotree_SplitWidth = 24
      else
        let g:undotree_SplitWidth = 30
      endif
    endif
    let g:undotree_DiffpanelHeight = 6
    let g:undotree_DiffAutoOpen = 1
    let g:undotree_SetFocusWhenToggle = 1
    let g:undotree_TreeNodeShape = '*'
    let g:undotree_TreeVertShape = '|'
    let g:undotree_DiffCommand = "diff"
    let g:undotree_RelativeTimestamp = 1
    let g:undotree_HighlightChangedText = 1
    let g:undotree_HighlightChangedWithSign = 1
    let g:undotree_HighlightSyntaxAdd = "DiffAdd"
    let g:undotree_HighlightSyntaxChange = "DiffChange"
    let g:undotree_HighlightSyntaxDel = "DiffDelete"
    let g:undotree_HelpLine = 1
    let g:undotree_CursorLine = 1
  endif

if jetpack#tap('translate.vim') "{{{2
  let g:translate_source = "en"
  let g:translate_target = "ja"
  let g:translate_popup_window = 1
  " let g:translate_winsize = 5
  nnoremap mj <Cmd>Translate<CR>
  vnoremap mj <Cmd>Translate<CR>
endif

" if jetpack#tap('') "{{{2
" endif
" if jetpack#tap('') "{{{2
" endif
