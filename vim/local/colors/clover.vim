""
" Colorscheme: " Author: tar80" License: MIT""

set background=dark
hi clear

if exists("syntax_on")
  unlet syntax_on
endif
if exists("syntax_manual")
  unlet syntax_manual
endif

let Italic = ""
if exists('g:clover_italic')
  let Italic = "italic"
endif
let g:clover_italic = get(g:, 'clover_italic', 0)

let Bold = ""
if exists('g:clover_bold')
  let Bold = "bold"
endif

let g:clover_bold = get(g:, '_bold', 0)

  hi ALEErrorSign guifg=#fd5c70 ctermfg=203 gui=NONE cterm=NONE
  hi ALEWarningSign guifg=#e2dc79 ctermfg=186 gui=NONE cterm=NONE
  hi ALEVirtualTextError guifg=#fd5c70 ctermfg=203 gui=NONE cterm=NONE
  hi ALEVirtualTextWarning guifg=#e2dc79 ctermfg=186 gui=NONE cterm=NONE
  hi ColorColumn guibg=#14231e ctermbg=234 gui=NONE cterm=NONE
  hi Conceal guifg=#715b2f ctermfg=58 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Cursor guifg=#0b1611 ctermfg=233 guibg=#9ece6e ctermbg=149 gui=NONE cterm=NONE
  hi CursorIM guifg=#0b1611 ctermfg=233 guibg=#81b5c3 ctermbg=109 gui=NONE cterm=NONE
  hi CursorLine guifg=#0b1611 ctermfg=233 guibg=#81b5c3 ctermbg=109 gui=NONE cterm=NONE
  hi CursorLineNr guifg=#0b1611 ctermfg=233 guibg=#4d7976 ctermbg=243 gui=NONE cterm=NONE
  hi Directory guifg=#839a87 ctermfg=102 guibg=#0b1611 ctermbg=233 gui=NONE cterm=NONE
  hi DiffAdd guifg=#81b5c3 ctermfg=109 guibg=#092532 ctermbg=235 gui=NONE cterm=NONE
  hi DiffChange guifg=#6c806f ctermfg=243 guibg=#20331d ctermbg=234 gui=NONE cterm=NONE
  hi DiffDelete guifg=#2e1b19 ctermfg=234 guibg=#2e1b19 ctermbg=234 gui=NONE cterm=NONE
  hi DiffText guifg=#9ece6e ctermfg=149 guibg=#2d4d19 ctermbg=236 gui=NONE cterm=NONE
  hi ErrorMsg guifg=#fc6f8d ctermfg=204 guibg=#2e1b19 ctermbg=234 gui=NONE cterm=NONE
  hi VertSplit guifg=#344137 ctermfg=237 guibg=#344137 ctermbg=237 gui=NONE cterm=NONE
  hi Folded guifg=#77679f ctermfg=97 guibg=#141921 ctermbg=234 gui=NONE cterm=NONE
  hi FoldColumn guifg=#77679f ctermfg=97 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi SignColumn guifg=#c4ccbe ctermfg=251 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi IncSearch guifg=#daba6f ctermfg=179 gui=reverse cterm=reverse
  hi LineNr guifg=#4e5f50 ctermfg=239 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi LineNrAbove guifg=#344137 ctermfg=237 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi LineNrBelow guifg=#344137 ctermfg=237 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi MatchParen guifg=#a1e1e5 ctermfg=152 guibg=NONE ctermbg=NONE gui=underline cterm=underline
  hi ModeMsg guifg=#715b2f ctermfg=58 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi MoreMsg guifg=#9ece6e ctermfg=149 guibg=#14231e ctermbg=234 gui=NONE cterm=NONE
  hi NonText guifg=#344137 ctermfg=237 gui=NONE cterm=NONE
  hi Normal guifg=#c4ccbe ctermfg=251 guibg=#0b1611 ctermbg=233 gui=NONE cterm=NONE
  hi PMenu guifg=#839a87 ctermfg=102 guibg=#344137 ctermbg=237 gui=NONE cterm=NONE
  hi PMenuSel guifg=#14231e ctermfg=234 guibg=#77679f ctermbg=97 gui=NONE cterm=NONE
  hi PmenuSbar guifg=#4e5f50 ctermfg=239 guibg=#4e5f50 ctermbg=239 gui=NONE cterm=NONE
  hi PmenuThumb guifg=#839a87 ctermfg=102 guibg=#839a87 ctermbg=102 gui=NONE cterm=NONE
  hi Question guifg=#a1e1e5 ctermfg=152 guibg=#14231e ctermbg=234 gui=NONE cterm=NONE
  hi Search guifg=#daba6f ctermfg=179 guibg=#2e1b19 ctermbg=234 gui=NONE cterm=NONE
  hi SpecialKey guifg=#a980d1 ctermfg=140 guibg=#14231e ctermbg=234 gui=NONE cterm=NONE
  hi SpellBad guifg=#fc6f8d ctermfg=204 gui=underline cterm=underline
  hi SpellCap guifg=#81b5c3 ctermfg=109 gui=underline cterm=underline
  hi StatusLine guifg=#4e5f50 ctermfg=239 guibg=#14231e ctermbg=234 gui=NONE cterm=NONE
  hi StatusLineNC guifg=#fc6f8d ctermfg=204 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi TabLine guifg=#715b2f ctermfg=58 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi TabLineFill guifg=#715b2f ctermfg=58 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi TabLineSel guifg=#715b2f ctermfg=58 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Title guifg=#a1e1e5 ctermfg=152 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Visual guifg=#c4ccbe ctermfg=251 guibg=#3d5446 ctermbg=238 gui=NONE cterm=NONE
  hi WarningMsg guifg=#fc89b4 ctermfg=211 guibg=#2e1b19 ctermbg=234 gui=NONE cterm=NONE
  hi WildMenu guifg=#14231e ctermfg=234 guibg=#81b5c3 ctermbg=109 gui=NONE cterm=NONE
  hi LspReference guibg=#14231e ctermbg=234 gui=NONE cterm=NONE
  hi Comment guifg=#4e5f50 ctermfg=239 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Constant guifg=#9ece6e ctermfg=149 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi String guifg=#a6936a ctermfg=137 guibg=#14231e ctermbg=234 gui=NONE cterm=NONE
  hi Character guifg=#81b5c3 ctermfg=109 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi link Boolean Character
  hi link Number Character
  hi link Float Character
  hi Identifier guifg=#a980d1 ctermfg=140 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Function guifg=#e2dc79 ctermfg=186 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Statement guifg=#a1e1e5 ctermfg=152 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Conditional guifg=#9ece6e ctermfg=149 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Repeat guifg=#9ece6e ctermfg=149 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Label guifg=#a1e1e5 ctermfg=152 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Operator guifg=#fc89b4 ctermfg=211 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Keyword guifg=#a1e1e5 ctermfg=152 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi link Exception Conditional
  hi PreProc guifg=#a980d1 ctermfg=140 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Include guifg=#715b2f ctermfg=58 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Define guifg=#e2dc79 ctermfg=186 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Macro guifg=#715b2f ctermfg=58 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi PreCondit guifg=#715b2f ctermfg=58 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Type guifg=#9ece6e ctermfg=149 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi StorageClass guifg=#715b2f ctermfg=58 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Structure guifg=#715b2f ctermfg=58 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Typedef guifg=#715b2f ctermfg=58 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Special guifg=#fc89b4 ctermfg=211 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Underlined guifg=#c4ccbe ctermfg=251 guibg=NONE ctermbg=NONE gui=underline cterm=underline
  hi Ignore guifg=#715b2f ctermfg=58 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Error guifg=#fc6f8d ctermfg=204 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Todo guifg=#e2dc79 ctermfg=186 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssVendor guifg=#759759 ctermfg=101 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssTagName guifg=#759759 ctermfg=101 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssBackgroundProp guifg=#3d5446 ctermfg=238 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssBorderProp guifg=#3d5446 ctermfg=238 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssBoxProp guifg=#4d7976 ctermfg=243 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssDimensionProp guifg=#4d7976 ctermfg=243 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssFontProp guifg=#3d5446 ctermfg=238 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssPositioningProp guifg=#4d7976 ctermfg=243 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssTextProp guifg=#3d5446 ctermfg=238 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssIdentifier guifg=#759759 ctermfg=101 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssIncludeKeyword guifg=#e2dc79 ctermfg=186 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssImportant guifg=#fd5c70 ctermfg=203 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssClassName guifg=#4c6244 ctermfg=239 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssProp guifg=#3d5446 ctermfg=238 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssNoise guifg=#fd5c70 ctermfg=203 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi javaScriptParens guifg=#a1e1e5 ctermfg=152 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi javaScriptValue guifg=#81b5c3 ctermfg=109 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi javaScriptOperator guifg=#fc6f8d ctermfg=204 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi javaScriptBraces guifg=#daba6f ctermfg=179 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi javaScriptNull guifg=#81b5c3 ctermfg=109 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownH1 guifg=#3d5446 ctermfg=238 guibg=NONE ctermbg=NONE gui=Bold cterm=Bold
  hi markdownHeadingRule guifg=#fc6f8d ctermfg=204 guibg=NONE ctermbg=NONE gui=Bold cterm=Bold
  hi markdownHeadingDelimiter guifg=#daba6f ctermfg=179 guibg=NONE ctermbg=NONE gui=Bold cterm=Bold
  hi markdownListMarker guifg=#e2dc79 ctermfg=186 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownBlockquote guifg=#e2dc79 ctermfg=186 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownRule guifg=#fc6f8d ctermfg=204 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownLinkTextDelimiter guifg=#a1e1e5 ctermfg=152 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownLinkDelimiter guifg=#a1e1e5 ctermfg=152 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownIdDeclaration guifg=#759759 ctermfg=101 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownAutomaticLink guifg=#4d7976 ctermfg=243 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownUrl guifg=#fc89b4 ctermfg=211 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownUrlTitle guifg=#e2dc79 ctermfg=186 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownUrlDelimiter guifg=#e2dc79 ctermfg=186 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownUrlTitleDelimiter guifg=#e2dc79 ctermfg=186 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownCodeDelimiter guifg=#fc6f8d ctermfg=204 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi link markdownCode Comment
  hi markdownEscape guifg=#4d7976 ctermfg=243 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownError guifg=#fd5c70 ctermfg=203 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi GitGutterAdd guifg=#9ece6e ctermfg=149 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi GitGutterChange guifg=#a980d1 ctermfg=140 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi GitGutterDelete guifg=#fc6f8d ctermfg=204 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi GitGutterChangeDelete guifg=#fc6f8d ctermfg=204 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi vimCommentString guifg=#e2dc79 ctermfg=186 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi vimCommentTitle guifg=#fc89b4 ctermfg=211 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi vimFiletype guifg=#daba6f ctermfg=179 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi vimError guifg=#fd5c70 ctermfg=203 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi vimIsCommand guifg=#e2dc79 ctermfg=186 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi vimOpenParen guifg=#a1e1e5 ctermfg=152 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi xmlNamespace guifg=#e2dc79 ctermfg=186 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi xmlAttribPunct guifg=#fd5c70 ctermfg=203 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi xmlProcessingDelim guifg=#fd5c70 ctermfg=203 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi yamlFlowString guifg=#e2dc79 ctermfg=186 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi yamlKeyValueDelimiter guifg=#fd5c70 ctermfg=203 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
