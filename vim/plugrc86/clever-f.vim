"# vim:textwidth=0:foldmethod=marker:foldlevel=1:
"======================================================================

"$$ Maps {{{1

nmap f <Plug>(clever-f-f)
xmap f <Plug>(clever-f-f)
omap f <Plug>(clever-f-f)
nmap F <Plug>(clever-f-F)
xmap F <Plug>(clever-f-F)
omap F <Plug>(clever-f-F)
nmap t <Plug>(clever-f-t)
xmap t <Plug>(clever-f-t)
omap t <Plug>(clever-f-t)
nmap T <Plug>(clever-f-T)
xmap T <Plug>(clever-f-T)
omap T <Plug>(clever-f-T)

"$$ Options {{{1

"@ 行を跨がない = 1
let g:clever_f_across_no_line = 0
let g:clever_f_ignore_case    = 1
let g:clever_f_smart_case     = 1
let g:clever_f_use_migemo     = 0
let g:clever_f_fix_key_direction  = 0
let g:clever_f_mark_cursor        = 1
let g:clever_f_mark_cursor_color  = "ErrorMsg"
let g:clever_f_mark_char          = 1
let g:clever_f_mark_char_color    = "SpellBad"
