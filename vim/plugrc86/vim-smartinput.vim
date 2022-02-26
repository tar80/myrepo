"# vim:textwidth=0:foldmethod=marker:foldlevel=1:
"======================================================================

"@ template
"  call smartinput#define_rule({
"       \ 'at'    : '',
"       \ 'char'  : '',
"       \ 'input' : '',
"       \ })

"@ コマンドライン短縮コマンド {{{2
"@ 参照元:https://scrapbox.io/vim-jp/lexima.vimでBetter_vim-altercmdを再現する

command! -nargs=+ SmartinputCommand call <SID>smartinput_command(<f-args>)

function! s:smartinput_command(original, altanative) abort
  let input_space = '<C-w>' . a:altanative . '<Space>'
  let input_cr = '<C-w>' . a:altanative . '<CR>'
  let rule = {
        \   'mode': ':',
        \   'at': '^\(''<,''>\)\?' . a:original . '\%#',
        \   }
  call smartinput#define_rule(extend(rule, { 'char': '<Space>', 'input': input_space }))
  call smartinput#define_rule(extend(rule, { 'char': '<CR>', 'input': input_cr }))
endfunction

"$$ cmdline expands {{{1

SmartinputCommand gs 30vs<Bar>Gina<Space>status<Space>-s
SmartinputCommand nn NyagosRun
SmartinputCommand gg GitGutterEnable
SmartinputCommand uu call<Space>undotree#UndotreeToggle()
SmartinputCommand sy set<Space>scb<Space><Bar><Space>wincmd<Space>p<Space><Bar><Space>set<Space>scb
SmartinputCommand su set<Space>noscb

"}}}
"@ triggers {{{2

call smartinput#map_to_trigger('i', '<Plug>(smartinput_CR)', '<Enter>', '<Enter>')
call smartinput#map_to_trigger('i', '<Plug>(smartinput_C-h)', '<BS>',  '<C-h>')
call smartinput#map_to_trigger('i', '<Space>', '<Space>', '<Space>')
call smartinput#map_to_trigger('i', '=', '=', '=')
call smartinput#map_to_trigger('i', '.', '.', '.')
call smartinput#map_to_trigger('c', '<CR>', '<CR>', '<CR>')
call smartinput#map_to_trigger('c', '<Space>', '<Space>', '<Space>')

"@ key strokes {{{1

"@ ppx {{{2
"@ ppx -> . -> PPx.
call smartinput#define_rule({
     \   'at'       : 'ppx\%#',
     \   'char'     : '.',
     \   'input'    : '<BS><BS><BS>PPx.',
     \   'filetype' : ['javascript'],
     \   })
"@ ppa| -> . -> PPx.Execute(|);
call smartinput#define_rule({
     \   'at'       : 'ppa\%#',
     \   'char'     : '.',
     \   'input'    : '<C-w>PPx.Arguments',
     \   'filetype' : ['javascript'],
     \   })

"@ ppe| -> . -> PPx.Execute(|);
call smartinput#define_rule({
     \   'at'       : 'ppe\%#',
     \   'char'     : '.',
     \   'input'    : '<C-w>PPx.Execute();<Left><Left>',
     \   'filetype' : ['javascript'],
     \   })

"@ ppt| -> . -> PPx.Extract(|);
call smartinput#define_rule({
     \   'at'       : 'ppt\%#',
     \   'char'     : '.',
     \   'input'    : '<C-w>PPx.Extract();<Left><Left>',
     \   'filetype' : ['javascript'],
     \   })

"@ ppq| -> . -> PPx.Quit(|1);
call smartinput#define_rule({
     \   'at'       : 'ppq\%#',
     \   'char'     : '.',
     \   'input'    : '<C-w>PPx.Quit(1);<Left><Left><Left>',
     \   'filetype' : ['javascript'],
     \   })

"@ ppw| -> . -> PPx.Echo(|);
call smartinput#define_rule({
     \   'at'       : 'ppw\%#',
     \   'char'     : '.',
     \   'input'    : '<C-w>PPx.Echo();<Left><Left>',
     \   'filetype' : ['javascript'],
     \   })
"}}}
"@ folding {{{2
"NOTE:動かない。理由不明
call smartinput#define_rule({
      \ 'at'    : '\s"{{\%#"',
      \ 'char'  : '{',
      \ 'input' : '{2<Del><Del>',
      \ })
call smartinput#define_rule({
      \ 'at'    : '\S{{\%#}}',
      \ 'char'  : '{',
      \ 'input' : '<BS><BS><Space>{{{<Del><Del>',
      \ })
call smartinput#define_rule({
      \ 'at'    : '\s{{\%#}}',
      \ 'char'  : '{',
      \ 'input' : '{<Del><Del>',
      \ })

"@ lists {{{2
let s:BracketList = [
     \ ['(', ')'],
     \ ['{', '}'],
     \ ['[', ']'],
     \ ]
let s:QuoteList = [
     \ '"',
     \ '`',
     \ "'"
     \ ]

"@ bracket {{{2
for [bigin, end] in copy(s:BracketList)
  "@ 後ろに文字があった時の振舞い
  call smartinput#define_rule({
        \ 'at'    : '\%#\()\|}\|]\|\s\|$\)\@!',
        \ 'char'  : bigin,
        \ 'input' : bigin,
        \ })
  "@ leave_block
  "@ *標準のはコマンドラインに文字が残る。<C-o>に関係ある何かの処理っぽい
  call smartinput#define_rule({
        \ 'at'    : '\%#\_s*' . end,
        \ 'char'  : end,
        \ 'input' : '<Right>',
        \ })
endfor

"@ 誤爆するので個別対応
  "@ (|) -> <Space> -> ( | )
  call smartinput#define_rule({
        \ 'at'    : '(\%#)',
        \ 'char'  : '<Space>',
        \ 'input' : '<Space><Space><Left>',
        \ })
  call smartinput#define_rule({
        \ 'at'    : '{\%#}',
        \ 'char'  : '<Space>',
        \ 'input' : '<Space><Space><Left>',
        \ })
  call smartinput#define_rule({
        \ 'at'    : '\[\%#]',
        \ 'char'  : '<Space>',
        \ 'input' : '<Space><Space><Left>',
        \ })
  "@ ( | ) -> <BS> -> (|)
  call smartinput#define_rule({
        \ 'at'    : '(\s\%#\s)',
        \ 'char'  : '<BS>',
        \ 'input' : '<BS><Del>',
        \ })
  call smartinput#define_rule({
        \ 'at'    : '{\s\%#\s}',
        \ 'char'  : '<BS>',
        \ 'input' : '<BS><Del>',
        \ })
  call smartinput#define_rule({
        \ 'at'    : '\[\s\%#\s]',
        \ 'char'  : '<BS>',
        \ 'input' : '<BS><Del>',
        \ })

"@ quote {{{2
for quote in copy(s:QuoteList)
  call smartinput#define_rule({
        \ 'at'    : '\s\%#\(\s\|$\)',
        \ 'char'  : quote,
        \ 'input' : quote . quote . '<left>',
        \ })
  call smartinput#define_rule({
        \ 'at'    : '(\%#)',
        \ 'char'  : quote,
        \ 'input' : quote . quote . '<left>',
        \ })
  call smartinput#define_rule({
        \ 'at'    : '{\%#}',
        \ 'char'  : quote,
        \ 'input' : quote . quote . '<left>',
        \ })
  call smartinput#define_rule({
        \ 'at'    : '\[\%#]',
        \ 'char'  : quote,
        \ 'input' : quote . quote . '<left>',
        \ })
  call smartinput#define_rule({
        \ 'at'    : '\%#',
        \ 'char'  : quote,
        \ 'input' : quote,
        \ })
endfor

