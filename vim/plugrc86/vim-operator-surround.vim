"# vim:textwidth=0:foldmethod=marker:foldlevel=1:
"======================================================================

map <silent> <Space>a <Plug>(operator-surround-append)
map <silent> <Space>d <Plug>(operator-surround-delete)
map <silent> <Space>r <Plug>(operator-surround-replace)

nmap <silent> <Space>dd <Plug>(operator-surround-delete)<Plug>(textobj-anyblock-a)
nmap <silent> <Space>rr <Plug>(operator-surround-replace)<Plug>(textobj-anyblock-a)

