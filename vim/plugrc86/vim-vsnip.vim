"# vim:textwidth=0:foldmethod=marker:foldlevel=1:
"======================================================================

" let g:vsnip_extra_mapping = v:true
let g:vsnip_snippet_dir = $MYREPO . '\vim\.vsnip'
" let g:vsnip_namespace = 'vsnip'

imap <expr> <C-j> vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<Down>'
smap <expr> <C-j> vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Down>'
imap <expr> <C-k> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<Up>'
smap <expr> <C-k> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<Up>'
