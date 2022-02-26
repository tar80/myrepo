"# vim:textwidth=0:foldmethod=marker:foldlevel=1:
"======================================================================

augroup vimrcDependencies
  autocmd FileType javascript setlocal dictionary=$MYREPO\vim\local\dict\javascript.dict,$MYREPO\vim\local\dict\ppx.dict
  autocmd FileType PPxcfg setlocal dictionary=$MYREPO\vim\local\dict\xcfg.dict
augroup END

let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#no_mappings = 1
let g:mucomplete#chains = {
  \ 'default' : ['path', 'vsnip', 'omni', 'keyn', 'dict'],
  \ 'vim'     : ['path', 'vsnip', 'cmd', 'keyn']
  \ }
let g:mucomplete#completion_delay = 10
let g:mucomplete#empty_text = 1
let g:mucomplete#no_popup_mappings = 1

"$$ Maps

imap <expr> <CR> pumvisible() ? "<C-y>" : "<Plug>(smartinput_CR)"
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : <SID>ComplTabKey()
imap <expr> <s-tab> pumvisible() ? "\<C-p>" : "<S-tab>"

function! s:ComplTabKey()
  const l:chr = strpart(getline('.'),col('.') -2, 1)
  if l:chr == '/'
    set csl =slash
  elseif l:chr == '\'
    set csl =backslash
  else
    return "\<TAB>"
  endif
    return "\<C-x>\<C-f>"
endfunction

