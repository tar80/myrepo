"@ vim:textwidth=0:foldmethod=marker:foldlevel=1:
"======================================================================

"$$ Options {{{2

let g:lightline = {
      \ 'colorscheme': g:my_colorscheme,
      \ 'active': {
        \ 'left':   [['mode', 'paste'], ['lsp'], ['status']],
        \ 'right':  [['lineinfo'],['percent'],['filetype', 'file'],['gina', 'gitstatus']]
        \ },
      \ 'component': {
        \ 'lineinfo':  'L%2v:%3l/%3L',
        \ 'wd':        '%.36(%{fnamemodify(getcwd(), ":~")}%)'
        \ },
      \ 'component_function' : {
        \ 'mode':       'Skkgetmode',
        \ 'lsp':        'LSPStatus',
        \ 'status':     'Status',
        \ 'gitstatus':  'Branch',
        \ 'gina':       'GinaInfo',
        \ 'file':       'FileInfo',
        \ 'filetype':   'FileType'
        \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' },
      \ 'tab': {
        \ 'active': ['tabnum', 'filename', 'tabstatus'],
        \ 'inactive': ['tabnum', 'filename', 'modified']
        \ },
      \ 'tab_component_function': {
        \ 'tabstatus':     'TabStatus'
        \ },
      \ 'tabline': {
        \ 'left':    [['tabs']],
        \ 'right':   [['wd']]
        \ }
      \ }

if !has('nvim')
  set ambiwidth=double
  let g:lightline.separator.right = ''
  let g:lightline.subseparator.right = '|'
endif

let s:skk_exist = dein#is_available('skkeleton')

autocmd vimrcDependencies User skkeleton-mode-changed lightline#update()

"$$ Functions {{{1

function! Skkgetmode() abort "{{{2
  if s:skk_exist is 1
    let mode = {
          \ 'hira': '仮名',
          \ 'kata': 'カナ',
          \ 'hankata': '半ｶﾅ',
          \ '': lightline#mode()
          \ }[skkeleton#mode()]

    return mode
  else
    return lightline#mode()
  endif

  return ''
endfunction

function! LSPStatus() abort "{{{2
  let l:total = 0
  let l:count = ''
  let l:err = ''
  let l:war = ''
  let l:info = ''
  let l:sign_err = ' '
  let l:sign_war = ' '
  let l:sign_info = ' '

  if dein#is_available('vim-lsp') && g:lsp_diagnostics_enabled
    let l:count = lsp#get_buffer_diagnostics_counts()
    let l:err = l:count.error
    let l:war = l:count.warning
    let l:info = l:count.information
    let l:total = l:err + l:war + l:info
  endif

  if dein#is_available('ale')
    let l:count = ale#statusline#Count(bufnr(''))
    let l:err = l:err + l:count.error + l:count.style_error
    let l:war = l:war + l:count.warning + l:count.style_warning
    let l:total = l:total + l:count.total
  endif

  return l:total isnot 0 ? l:sign_err . l:err . ' ' . l:sign_war . l:war . ' ' . l:sign_info . l:info : ''
endfunction

function! Branch() abort "{{{2
  if dein#is_available('vim-gitbranch') && (gitbranch#name() !=# '')
    return winwidth(0) > 70 ? '' . gitbranch#name() . GitGutterStatus() : ''
  endif

  return ''
endfunction

function! GitGutterStatus() abort "{{{2
  if dein#is_available('vim-gitgutter') && g:gitgutter_enabled
    let [a,m,r] = GitGutterGetHunkSummary()
    return printf('  +%d ~%d -%d', a, m, r)
  else
    return ''
  endif
endfunction

function! GinaInfo() abort "{{{2
  if dein#is_available('gina.vim') && (&filetype ==# 'gina-log')
    return ''.gina#component#repo#branch()
    " let branch = gina#component#repo#branch()
    " let staged = gina#component#status#staged()
    " let unstaged = gina#component#status#unstaged()
    " let conflicted = gina#component#status#conflicted()
    " return printf(
          "\ '%s  s:%s u:%s c:%s',
          "\ branch,
          "\ staged,
          "\ unstaged,
          "\ conflicted,
          "\ )
  endif

  return ''
endfunction

function! Status() abort "{{{2
  let l:ro = (&ft !=# 'help') && &readonly ? ' |' : ''
  let l:mod = &modifiable && &modified ? ' ' : ''
  let l:path = expand('%:.')
  let l:path_length = strlen(path)
  if l:path_length is 0
    let l:path = 'no name'
    elseif l:path_length > 30
        let l:path = ''
  endif

  return l:ro . l:mod . l:path
endfunction


function! TabStatus(...) abort "{{{2
  let l:mod = &modifiable && &modified ? '+' : ' '

  return l:mod
endfunction

function! FileInfo() abort "{{{2
  return winwidth(0) > 100 ? (&fenc !=# '' ? &fenc : &enc) . '[' . &fileformat . ']' : ''
endfunction

function! FileType() abort "{{{2
  return winwidth(0) > 90 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

