"# vim:textwidth=0:foldmethod=marker:foldlevel=1:
"===============================================================================

let g:lexima_ctrlh_as_backspace = 1
let g:lexima_disable_abbrev_trigger = 1

"##Autocmd {{{1
exe 'autocmd Jetpack User JetpackLeximaVimPost call <SID>load_rules()'

"Credit: https://github.com/yuki-yano/dotfiles/blob/main/.vimrc
function! s:load_rules() abort
  "###rules {{{3
  let s:rules = []
  "Auto path completion
  let s:rules += [{ 'char': "<Tab>",'at': "\\w\\+\\\\\\%#$",  'input': "<C-g>u<C-x><C-f>" }]
  " let s:rules += [
  "       \ { 'char': '\', 'at': '\a\+\%#', 'input': '<C-g>u\<C-x><C-f><C-n>' },
  "       \ { 'char': '\', 'at': '\a\+\\\%#', 'input': '<C-g>u<C-x><C-f><C-n>' },
  "       \ { 'char': '/', 'at': '\a\+\%#', 'input': '<C-g>u/<C-x><C-f><C-n>' },
  "       \ { 'char': '/', 'at': '\a\+/\%#', 'input': '<C-g>u<C-x><C-f><C-n>' },
  "       \ ]
  "Leave parenthesis
  let s:rules += [
        \ { 'char': ';', 'at': '\%#''\s*)$', 'leave': ')', 'input': ';' },
        \ { 'char': ';', 'at': '\%#"\s*)$', 'leave': ')', 'input': ';' },
        \ { 'char': ';', 'at': '\%#`\s*)$', 'leave': ')', 'input': ';' },
        \ { 'char': ';', 'at': '\%#''\s*}$', 'leave': '}', 'input': ';' },
        \ { 'char': ';', 'at': '\%#"\s*}$', 'leave': '}', 'input': ';' },
        \ { 'char': ';', 'at': '\%#`\s*}$', 'leave': '}', 'input': ';' },
        \ ]
  let s:rules += [
        \ { 'char': '=', 'at': '\%#'']$', 'leave': ']', 'input': '<Space>=<Space>' },
        \ { 'char': '=', 'at': '\%#"]$', 'leave': ']', 'input': '<Space>=<Space>' },
        \ { 'char': '=', 'at': '\%#`]$', 'leave': ']', 'input': '<Space>=<Space>' },
        \ { 'char': '=', 'at': '\%#]$', 'leave': ']', 'input': '<Space>=<Space>' },
        \ ]
  let s:rules += [
        \ { 'char': '<Space>', 'at': '(\s*\%#\s*)', 'input': '<Space><Space><Left>' },
        \ ]
  let s:rules += [
        \ { 'char': '<BS>', 'at': '(\s*\%#\s*)', 'input': '<BS><Del>' },
        \ ]

  for s:rule in s:rules
    call lexima#add_rule(s:rule)
  endfor
  "}}}3
  "###Cmdline abbrev {{{3
  "Credit:https://scrapbox.io/vim-jp/lexima.vim%E3%81%A7Better_vim-altercmd%E3%82%92%E5%86%8D%E7%8F%BE%E3%81%99%E3%82%8B
  function! s:lexima_alter_command(original, altanative) abort
    let input_space = '<C-w>' . a:altanative . '<Space>'
    let input_cr    = '<C-w>' . a:altanative . '<CR>'

    let rule = {
          \ 'mode': ':',
          \ 'at': '^\(''<,''>\)\?' . a:original . '\%#$',
          \ }

    call lexima#add_rule(extend(rule, { 'char': '<Space>', 'input': input_space }))
    call lexima#add_rule(extend(rule, { 'char': '<CR>',    'input': input_cr    }))
  endfunction
  "}}}3

  command! -nargs=+ LeximaAlterCommand call <SID>lexima_alter_command(<f-args>)

  LeximaAlterCommand eu8 e<Space>++enc=utf-8<CR>
  LeximaAlterCommand eu16 e<Space>++enc=utf-16le<CR>
  LeximaAlterCommand sc set<Space>scb<Space><Bar><Space>wincmd<Space>p<Space><Bar><Space>set<Space>scb<CR>
  LeximaAlterCommand scn set<Space>noscb<CR>
  LeximaAlterCommand del call<Space>delete(expand('%'))
  LeximaAlterCommand cs execute<Space>'50vsplit'$repo.'\\myrepo\\nvim\\.cheatsheet'<CR>
  LeximaAlterCommand dd diffthis<Bar>wincmd<Space>p<Bar>diffthis<Bar>wincmd<Space>p<CR>
  LeximaAlterCommand dof syntax<Space>enable<Bar>diffoff<CR>
  LeximaAlterCommand dor vert<Space>bel<Space>new<Space>difforg<Bar>set<Space>bt=nofile<Bar>r<Space>++edit<Space>#<Bar>0d_<Bar>windo<Space>diffthis<Bar>wincmd<Space>p<CR>
  LeximaAlterCommand ht so<Space>$VIMRUNTIME/syntax/hitest.vim
  LeximaAlterCommand ct so<Space>$VIMRUNTIME/syntax/colortest.vim
endfunction
