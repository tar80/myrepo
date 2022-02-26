"# vim:textwidth=0:foldmethod=marker:foldlevel=1:
"======================================================================

"$$ Options

"@ let g:acp_enableAtStarup = 1
let g:AutoComplPopDontSelectFirst = 1
let g:acp_completeOption        = '.,w,b,k,i'
"@ let g:acp_behaviorKeywordCommand = "\<C-n>"
"@ let g:acp_behaviorKeywordLength = 2
let g:acp_behaviorFileLength    = 3
let g:acp_behaviorRubyOmniMethodLength  = -1
let g:acp_behaviorRubyOmniSymbolLength  = -1
let g:acp_behaviorPythonOmniLength      = -1
let g:acp_behaviorjavascript            = 1

"$$ Map

"@ 補完表示時のEnterで改行をしない
imap <expr> <CR> pumvisible() ? "<C-y>" : "<Plug>(smartinput_CR)"
"@ 候補選択時に補完しない
inoremap <expr> <C-n> pumvisible() ? "<Down>" : "<C-n>"
inoremap <expr> <C-p> pumvisible() ? "<Up>"   : "<C-p>"
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : <SID>ComplTabKey()

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

