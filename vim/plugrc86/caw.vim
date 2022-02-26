"# vim:textwidth=0:foldmethod=marker:foldlevel=1:
"======================================================================

"$$ Map {{{2

if has_key(g:plugs, 'vim-operator-user')
  nmap gcc <Plug>(caw:hatpos:toggle)
  nmap gci <Plug>(caw:hatpos:comment:operator)
  nmap gcui <Plug>(caw:hatpos:uncomment:operator)
  nmap gcI <Plug>(caw:zeropos:comment:operator)
  nmap gcuI <Plug>(caw:zeropos:uncomment:operator)
  nmap gca <Plug>(caw:dollarpos:comment:operator)
  nmap gcua <Plug>(caw:dollarpos:uncomment:operator)
  nmap gcw <Plug>(caw:wrap:comment:operator)
  nmap gcuw <Plug>(caw:wrap:uncomment:operator)
  nmap gcb <Plug>(caw:box:comment:operator)
else
  nmap gcc <Plug>(caw:hatpos:toggle)
  nmap gci <Plug>(caw:hatpos:comment)
  nmap gcui <Plug>(caw:hatpos:uncomment)
  nmap gcI <Plug>(caw:zeropos:comment)
  nmap gcuI <Plug>(caw:zeropos:uncomment)
  nmap gca <Plug>(caw:dollarpos:comment)
  nmap gcua <Plug>(caw:dollarpos:uncomment)
  nmap gcw <Plug>(caw:wrap:comment)
  nmap gcuw <Plug>(caw:wrap:uncomment)
  nmap gcb <Plug>(caw:box:comment)
endif

xmap gcc <Plug>(caw:hatpos:toggle)
xmap gci <Plug>(caw:hatpos:comment)
xmap gcui <Plug>(caw:hatpos:uncomment)
xmap gcI <Plug>(caw:zeropos:comment)
xmap gcuI <Plug>(caw:zeropos:uncomment)
xmap gca <Plug>(caw:dollarpos:comment)
xmap gcua <Plug>(caw:dollarpos:uncomment)
xmap gcw <Plug>(caw:wrap:comment)
xmap gcuw <Plug>(caw:wrap:uncomment)
xmap gcb <Plug>(caw:box:comment)

"$$ Options {{{1

let g:caw_hatpos_startinsert_at_blank_line = 0
let g:caw_hatpos_skip_blank_line = 1
let g:caw_hatpos_align = 0
let g:caw_zeropos_startinsert_at_blank_line = 0
let g:caw_dollarpos_startinsert = 1
let g:caw_wrap_skip_blank_line = 0
let g:caw_no_default_keymappings = 1

