"# vim:textwidth=0:foldmethod=marker:foldlevel=1:
"===============================================================================

"##Lightline {{{2
let g:lightline = {
      \ 'colorscheme': g:colors_name,
      \ 'active': {
        \ 'left':   [['mode', 'paste'], ['ale'], ['status']],
        \ 'right':  [['filetype', 'file', 'lineinfo']]
        \ },
      \ 'component': {
        \ 'lineinfo':  'L%2v:%3l/%3L',
        \ 'wd':        '%.36(%{fnamemodify(getcwd(), ":~")}%)'
        \ },
      \ 'component_function' : {
        \ 'mode':       'Skkgetmode',
        \ 'ale':        'ALEstatus',
        \ 'status':     'Status',
        \ 'file':       'FileInfo',
        \ 'filetype':   'FileType'
        \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '୲', 'right': '୲'},
      \ 'tab': {
        \ 'active': ['tabnum', 'filename', 'tabstatus'],
        \ 'inactive': ['tabnum', 'filename', 'modified']
        \ },
      \ 'tab_component_function': {
        \ 'tabstatus': 'TabStatus'
        \ },
      \ 'tabline': {
        \ 'left':    [['tabs']],
        \ 'right':   [['wd']]
        \ }
      \ }
"}}}2

if jetpack#tap('skkeleton')
  autocmd rcPlugins User skkeleton-mode-changed lightline#update()
endif

"##Functions {{{2
let s:icon = {
      \ 'dos': "",
      \ 'unix': "",
      \ 'mac': "",
      \ 'err': "",
      \ 'warn': "",
      \ 'info': "",
      \ }

function! Skkgetmode() abort "{{{2
  if jetpack#tap('skkeleton')
    let mode = {
          \ 'hira': lightline#mode() .. ' あ',
          \ 'kata': lightline#mode() .. ' ア',
          \ 'hankata': lightline#mode() .. ' ｱ',
          \ '': lightline#mode()
          \ }[skkeleton#mode()]

    return mode
  else
    return lightline#mode()
  endif

  return ''
endfunction

function! ALEstatus() abort "{{{2
  let l:total = 0
  let l:count = ''
  let l:err = ''
  let l:war = ''
  let l:info = ''

  if jetpack#tap('ale')
    let l:count = ale#statusline#Count(bufnr(''))
    let l:err = l:count.error + l:count.style_error
    let l:war = l:count.warning + l:count.style_warning
    let l:total = l:count.total
  endif

  return l:total isnot 0 ? s:icon.err . l:err . ' ' . s:icon.warn . l:war . ' ' . s:icon.info . l:info : ''
endfunction

function! Status() abort "{{{2
  let l:ro = (&ft !=# 'help') && &readonly ? '' : ''
  let l:mod = &modifiable && &modified ? '' : ''
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
  return winwidth(0) > 100 ? (&fenc !=# '' ? &fenc : &enc) .. ' ' ..  s:icon[&fileformat] : ''
endfunction

function! FileType() abort "{{{2
  return winwidth(0) > 90 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

call lightline#update()
