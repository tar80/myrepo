" Vim Color File
" Name:       bong.vim
" Maintainer: tar80
" License:    MIT(https://opensource.org/licenses/mit-license.php)
" Based On:   https://github.com/kaicataldo/material.vim

highlight clear

if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'bong'
let g:bong_terminal_italics = get(g:, 'bong_terminal_italics', 0)

" Color Palette
let s:gray1     = '#000b00'    " 濡れ羽色
let s:gray2     = '#2B2B2B'    " 蝋色
let s:gray3     = '#595857'    " 墨
let s:gray4     = '#727171'    " 鈍色
let s:gray5     = '#COC6C9'    " 灰青
let s:red       = '#E9546B'    " 薔薇色
let s:green     = '#98D98E'    " 若緑
let s:yellow    = '#F2D675'    " 黄水仙
let s:blue      = '#9093E0'    " 紫陽花青
let s:purple    = '#CC7EB1'    " 菖蒲色
let s:cyan      = '#75C6C3'    " 白群
let s:orange    = '#FF9740'    " 淡朽葉
let s:plum      = '#F73B70'    " 梅重
let s:navy      = '#17184B'    " 鉄紺
let s:brown     = '#250D00'    " 黒檀

function! s:HL(group, fg, bg, attr)
  let l:attr = a:attr
  if !g:bong_terminal_italics && l:attr ==# 'italic'
    let l:attr = 'none'
  endif

  if !empty(a:fg)
      exec 'hi ' . a:group . ' guifg=' . a:fg
  endif
  if !empty(a:bg)
    exec 'hi ' . a:group . ' guibg=' . a:bg
  endif
  if !empty(a:attr)
    exec 'hi ' . a:group . ' gui=' . l:attr . ' cterm=' . l:attr
  endif
endfunction

" Vim Editor
call s:HL('ColorColumn',             '',         s:gray3,    '')
call s:HL('Cursor',                  s:gray2,    s:gray5,    '')
call s:HL('CursorColumn',            '',         s:gray2,    '')
call s:HL('CursorLine',              s:gray1,    s:cyan,     'none')
call s:HL('CursorLineNr',            s:green,    s:gray1,    'none')
call s:HL('Directory',               s:blue,     '',         '')
call s:HL('DiffAdd',                 s:blue,     s:navy,     'none')
call s:HL('DiffChange',              s:purple,   s:gray1,    'none')
call s:HL('DiffDelete',              s:brown,    s:brown,    'none')
call s:HL('DiffText',                s:green,    s:navy,     'none')
call s:HL('ErrorMsg',                s:red,      s:gray1,    'bold')
call s:HL('FoldColumn',              s:yellow,   s:gray1,    '')
call s:HL('Folded',                  s:gray4,    s:gray1,    '')
call s:HL('IncSearch',               s:yellow,   '',         '')
call s:HL('LineNr',                  s:gray4,    '',         '')
call s:HL('LineNrAbove',             s:gray3,    '',         '')
call s:HL('LineNrBelow',             s:gray3,    '',         '')
call s:HL('MatchParen',              s:cyan,     s:gray1,    'bold')
call s:HL('ModeMsg',                 s:green,    '',         '')
call s:HL('MoreMsg',                 s:green,    '',         '')
call s:HL('NonText',                 s:gray4,    '',         'none')
call s:HL('Normal',                  s:gray5,    s:gray1,    'none')
call s:HL('Pmenu',                   s:gray5,    s:gray3,    '')
call s:HL('PmenuSbar',               '',         s:gray2,    '')
call s:HL('PmenuSel',                s:gray2,    s:cyan,     '')
call s:HL('PmenuThumb',              '',         s:gray4,    '')
call s:HL('Question',                s:blue,     '',         'none')
call s:HL('Search',                  s:orange,   s:brown,    '')
call s:HL('SignColumn',              s:gray5,    s:gray1,    '')
call s:HL('SpecialKey',              s:gray3,     s:gray2,     '')
call s:HL('SpellCap',                s:blue,     s:gray2,    'undercurl')
call s:HL('SpellBad',                s:red,      s:gray2,    'undercurl')
call s:HL('StatusLine',              s:gray5,    s:gray3,    'none')
call s:HL('StatusLineNC',            s:gray2,    s:gray4,    '')
call s:HL('TabLine',                 s:gray4,    s:gray2,    'none')
call s:HL('TabLineFill',             s:gray4,    s:gray2,    'none')
call s:HL('TabLineSel',              s:yellow,   s:gray3,    'none')
call s:HL('Title',                   s:green,    '',         'none')
call s:HL('VertSplit',               s:gray4,    s:gray1,    'none')
call s:HL('Visual',                  s:gray5,    s:gray3,    '')
call s:HL('WarningMsg',              s:red,      '',         '')
call s:HL('WildMenu',                s:gray2,    s:cyan,     '')

" Standard Syntax
call s:HL('Comment',                 s:gray4,    '',         'italic')
call s:HL('Constant',                s:orange,   '',         '')
call s:HL('String',                  s:green,    '',         '')
call s:HL('Character',               s:green,    '',         '')
call s:HL('Identifier',              s:red,      '',         'none')
call s:HL('Function',                s:blue,     '',         '')
call s:HL('Statement',               s:purple,   '',         'none')
call s:HL('Operator',                s:cyan,     '',         '')
call s:HL('PreProc',                 s:cyan,     '',         '')
call s:HL('Include',                 s:blue,     '',         '')
call s:HL('Define',                  s:purple,   '',         'none')
call s:HL('Macro',                   s:purple,   '',         '')
call s:HL('Type',                    s:yellow,   '',         'none')
call s:HL('Structure',               s:cyan,     '',         '')
call s:HL('Special',                 s:plum,   '',         '')
call s:HL('Underlined',              s:blue,     '',         'none')
call s:HL('Error',                   s:red,      s:gray1,    '')
call s:HL('Todo',                    s:orange,   s:gray1,    'italic')

" CSS
call s:HL('cssAttrComma',            s:gray5,    '',         '')
call s:HL('cssPseudoClassId',        s:yellow,   '',         '')
call s:HL('cssBraces',               s:gray5,    '',         '')
call s:HL('cssClassName',            s:yellow,   '',         '')
call s:HL('cssClassNameDot',         s:yellow,   '',         '')
call s:HL('cssFunctionName',         s:blue,     '',         '')
call s:HL('cssImportant',            s:cyan,     '',         '')
call s:HL('cssIncludeKeyword',       s:purple,   '',         '')
call s:HL('cssTagName',              s:red,      '',         '')
call s:HL('cssMediaType',            s:orange,   '',         '')
call s:HL('cssProp',                 s:gray5,    '',         '')
call s:HL('cssSelectorOp',           s:cyan,     '',         '')
call s:HL('cssSelectorOp2',          s:cyan,     '',         '')

" Commit Messages (Git)
call s:HL('gitcommitHeader',         s:purple,   '',         '')
call s:HL('gitcommitUnmerged',       s:green,    '',         '')
call s:HL('gitcommitSelectedFile',   s:green,    '',         '')
call s:HL('gitcommitDiscardedFile',  s:red,      '',         '')
call s:HL('gitcommitUnmergedFile',   s:yellow,   '',         '')
call s:HL('gitcommitSelectedType',   s:green,    '',         '')
call s:HL('gitcommitSummary',        s:blue,     '',         '')
call s:HL('gitcommitDiscardedType',  s:red,      '',         '')
hi link gitcommitNoBranch       gitcommitBranch
hi link gitcommitUntracked      gitcommitComment
hi link gitcommitDiscarded      gitcommitComment
hi link gitcommitSelected       gitcommitComment
hi link gitcommitDiscardedArrow gitcommitDiscardedFile
hi link gitcommitSelectedArrow  gitcommitSelectedFile
hi link gitcommitUnmergedArrow  gitcommitUnmergedFile

" HTML
call s:HL('htmlEndTag',                     s:blue,     '',         '')
call s:HL('htmlLink',                       s:red,      '',         '')
call s:HL('htmlTag',                        s:blue,     '',         '')
call s:HL('htmlTitle',                      s:gray5,    '',         '')
call s:HL('htmlSpecialTagName',             s:purple,   '',         '')
call s:HL('htmlArg',                        s:yellow,   '',         'italic')

" Javascript
call s:HL('javaScriptBraces',               s:gray5,    '',         '')
call s:HL('javaScriptNull',                 s:orange,   '',         '')
call s:HL('javaScriptIdentifier',           s:purple,   '',         '')
call s:HL('javaScriptNumber',               s:orange,   '',         '')
call s:HL('javaScriptRequire',              s:cyan,     '',         '')
call s:HL('javaScriptReserved',             s:purple,   '',         '')
" pangloss/vim-javascript
call s:HL('jsArrowFunction',                s:purple,   '',         '')
call s:HL('jsAsyncKeyword',                 s:purple,   '',         '')
call s:HL('jsExtendsKeyword',               s:purple,   '',         '')
call s:HL('jsClassKeyword',                 s:purple,   '',         '')
call s:HL('jsDocParam',                     s:green,    '',         '')
call s:HL('jsDocTags',                      s:cyan,     '',         '')
call s:HL('jsForAwait',                     s:purple,   '',         '')
call s:HL('jsFlowArgumentDef',              s:yellow,   '',         '')
call s:HL('jsFrom',                         s:purple,   '',         '')
call s:HL('jsImport',                       s:purple,   '',         '')
call s:HL('jsExport',                       s:purple,   '',         '')
call s:HL('jsExportDefault',                s:purple,   '',         '')
call s:HL('jsFuncCall',                     s:blue,     '',         '')
call s:HL('jsFunction',                     s:purple,   '',         '')
call s:HL('jsGlobalObjects',                s:yellow,   '',         '')
call s:HL('jsGlobalNodeObjects',            s:yellow,   '',         '')
call s:HL('jsModuleAs',                     s:purple,   '',         '')
call s:HL('jsNull',                         s:orange,   '',         '')
call s:HL('jsStorageClass',                 s:purple,   '',         '')
call s:HL('jsTemplateBraces',               s:red,      '',         '')
call s:HL('jsTemplateExpression',           s:red,      '',         '')
call s:HL('jsThis',                         s:red,      '',         '')
call s:HL('jsUndefined',                    s:orange,   '',         '')

" JSON
call s:HL('jsonBraces',                     s:gray5,    '',         '')

" Less
call s:HL('lessAmpersand',                  s:red,      '',         '')
call s:HL('lessClassChar',                  s:yellow,   '',         '')
call s:HL('lessCssAttribute',               s:gray5,    '',         '')
call s:HL('lessFunction',                   s:blue,     '',         '')
call s:HL('lessVariable',                   s:purple,   '',         '')

" Markdown
call s:HL('markdownBold',                   s:yellow,   '',         'bold')
call s:HL('markdownCode',                   s:cyan,     '',         '')
call s:HL('markdownCodeBlock',              s:cyan,     '',         '')
call s:HL('markdownCodeDelimiter',          s:cyan,     '',         '')
call s:HL('markdownHeadingDelimiter',       s:green,    '',         '')
call s:HL('markdownHeadingRule',            s:gray4,    '',         '')
call s:HL('markdownId',                     s:purple,   '',         '')
call s:HL('markdownItalic',                 s:blue,     '',         'italic')
call s:HL('markdownListMarker',             s:orange,   '',         '')
call s:HL('markdownOrderedListMarker',      s:orange,   '',         '')
call s:HL('markdownRule',                   s:gray4,    '',         '')
call s:HL('markdownUrl',                    s:purple,   '',         '')
call s:HL('markdownUrlTitleDelimiter',      s:green,    '',         '')

" Ruby
call s:HL('rubyInterpolation',              s:cyan,     '',         '')
call s:HL('rubyInterpolationDelimiter',     s:plum,   '',         '')
call s:HL('rubyRegexp',                     s:cyan,     '',         '')
call s:HL('rubyRegexpDelimiter',            s:plum,   '',         '')
call s:HL('rubyStringDelimiter',            s:green,    '',         '')

" Sass
call s:HL('sassAmpersand',                  s:red,      '',         '')
call s:HL('sassClassChar',                  s:yellow,   '',         '')
call s:HL('sassMixinName',                  s:blue,     '',         '')
call s:HL('sassVariable',                   s:purple,   '',         '')

" Vim-Fugitive
call s:HL('diffAdded',                      s:green,    '',         '')
call s:HL('diffRemoved',                    s:red,      '',         '')

" Vim-Gittgutter
call s:HL('GitGutterAdd',                   s:green,    '',         '')
call s:HL('GitGutterChange',                s:yellow,   '',         '')
call s:HL('GitGutterChangeDelete',          s:orange,   '',         '')
call s:HL('GitGutterDelete',                s:red,      '',         '')

" Vim-Signify
hi link SignifySignAdd GitGutterAdd
hi link SignifySignChange GitGutterChange
hi link SignifySignDelete GitGutterDelete

" XML
call s:HL('xmlAttrib',                      s:yellow,   '',         'italic')
call s:HL('xmlEndTag',                      s:blue,     '',         '')
call s:HL('xmlTag',                         s:blue,     '',         '')
call s:HL('xmlTagName',                     s:blue,     '',         '')

" Neovim terminal colors
if has('nvim')
    let g:terminal_color_0 = s:gray1
    let g:terminal_color_1 = s:red
    let g:terminal_color_2 = s:green
    let g:terminal_color_3 = s:yellow
    let g:terminal_color_4 = s:blue
    let g:terminal_color_5 = s:purple
    let g:terminal_color_6 = s:cyan
    let g:terminal_color_7 = s:gray5
    let g:terminal_color_8 = s:gray3
    let g:terminal_color_9 = s:red
    let g:terminal_color_10 = s:green
    let g:terminal_color_11 = s:yellow
    let g:terminal_color_12 = s:blue
    let g:terminal_color_13 = s:purple
    let g:terminal_color_14 = s:cyan
    let g:terminal_color_15 = s:gray4
    let g:terminal_color_background = g:terminal_color_0
    let g:terminal_color_foreground = g:terminal_color_7
endif
