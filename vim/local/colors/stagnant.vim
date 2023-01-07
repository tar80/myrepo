""
" Colorscheme: " Author: tar80" License: MIT""

set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif
let g:colors_name="stagnant"


let Italic = ""
if exists('g:stagnant_italic')
  let Italic = "italic"
endif
let g:stagnant_italic = get(g:, 'stagnant_italic', 0)

let Bold = ""
if exists('g:stagnant_bold')
  let Bold = "bold"
endif

let g:stagnant_bold = get(g:, '_bold', 0)

  hi ALEErrorSign guifg=#926161 ctermfg=95 gui=NONE cterm=NONE
  hi ALEWarningSign guifg=#B2AC78 ctermfg=144 gui=NONE cterm=NONE
  hi ALEVirtualTextError guifg=#926161 ctermfg=95 gui=NONE cterm=NONE
  hi ALEVirtualTextWarning guifg=#B2AC78 ctermfg=144 gui=NONE cterm=NONE
  hi ColorColumn guibg=#000000 ctermbg=0 gui=NONE cterm=NONE
  hi Conceal guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Cursor guifg=#002222 ctermfg=234 guibg=#74A471 ctermbg=107 gui=NONE cterm=NONE
  hi CursorIM guifg=#002222 ctermfg=234 guibg=#A2866D ctermbg=137 gui=NONE cterm=NONE
  hi CursorLine guifg=#000000 ctermfg=0 guibg=#668F8F ctermbg=66 gui=NONE cterm=NONE
  hi CursorLineNr guifg=#000000 ctermfg=0 guibg=#668F8F ctermbg=66 gui=NONE cterm=NONE
  hi Directory guifg=#4F6B75 ctermfg=242 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi DiffAdd guifg=#668F8F ctermfg=66 guibg=#00393B ctermbg=237 gui=NONE cterm=NONE
  hi DiffChange guifg=#708A90 ctermfg=66 guibg=#103230 ctermbg=236 gui=NONE cterm=NONE
  hi DiffDelete guifg=#252A2C ctermfg=235 guibg=#252A2C ctermbg=235 gui=NONE cterm=NONE
  hi DiffText guifg=#A4BBBA ctermfg=250 guibg=#1A4944 ctermbg=238 gui=NONE cterm=NONE
  hi ErrorMsg guifg=#926161 ctermfg=95 guibg=#252A2C ctermbg=235 gui=NONE cterm=NONE
  hi VertSplit guifg=#344B4E ctermfg=239 guibg=#344B4E ctermbg=239 gui=NONE cterm=NONE
  hi Folded guifg=#3A567E ctermfg=60 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi FoldColumn guifg=#3A567E ctermfg=60 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi SignColumn guifg=#708A90 ctermfg=66 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi IncSearch guifg=#B2AC78 ctermfg=144 gui=reverse cterm=reverse
  hi LineNr guifg=#4F6B75 ctermfg=242 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi LineNrAbove guifg=#3A5258 ctermfg=239 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi LineNrBelow guifg=#3A5258 ctermfg=239 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi MatchParen guifg=#B2AC78 ctermfg=144 guibg=NONE ctermbg=NONE gui=underline cterm=underline
  hi ModeMsg guifg=#926161 ctermfg=95 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi MoreMsg guifg=#A4BBBA ctermfg=250 guibg=NONE ctermbg=NONE gui=reverse cterm=reverse
  hi NonText guifg=#344B4E ctermfg=239 gui=NONE cterm=NONE
  hi Normal guifg=#708A90 ctermfg=66 guibg=#002222 ctermbg=234 gui=NONE cterm=NONE
  hi PMenu guifg=#708A90 ctermfg=66 guibg=#344B4E ctermbg=239 gui=NONE cterm=NONE
  hi PMenuSel guifg=#A4BBBA ctermfg=250 guibg=#4F6B75 ctermbg=242 gui=NONE cterm=NONE
  hi PmenuSbar guifg=#708A90 ctermfg=66 guibg=#344B4E ctermbg=239 gui=NONE cterm=NONE
  hi PmenuThumb guifg=#A4BBBA ctermfg=250 guibg=#4F6B75 ctermbg=242 gui=NONE cterm=NONE
  hi Question guifg=#599D9D ctermfg=73 guibg=NONE ctermbg=NONE gui=reverse cterm=reverse
  hi Search guifg=#668F8F ctermfg=66 guibg=#002222 ctermbg=234 gui=reverse cterm=reverse
  hi SpecialKey guifg=#708A90 ctermfg=66 gui=NONE cterm=NONE
  hi SpellBad guifg=#926161 ctermfg=95
  hi SpellCap guifg=#B2AC78 ctermfg=144
  hi StatusLine guifg=#668F8F ctermfg=66 guibg=#3A5258 ctermbg=239 gui=NONE cterm=NONE
  hi StatusLineNC guifg=#708A90 ctermfg=66 guibg=#344B4E ctermbg=239 gui=NONE cterm=NONE
  hi TabLine guifg=#708A90 ctermfg=66 guibg=#344B4E ctermbg=239 gui=NONE cterm=NONE
  hi TabLineFill guifg=#708A90 ctermfg=66 guibg=#3A5258 ctermbg=239 gui=NONE cterm=NONE
  hi TabLineSel guifg=#668F8F ctermfg=66 guibg=#4F6B75 ctermbg=242 gui=NONE cterm=NONE
  hi Title guifg=#B2AC78 ctermfg=144 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Visual guifg=#A4BBBA ctermfg=250 guibg=#3A5258 ctermbg=239 gui=NONE cterm=NONE
  hi WarningMsg guifg=#A85D94 ctermfg=132 guibg=#252A2C ctermbg=235 gui=NONE cterm=NONE
  hi WildMenu guifg=#599D9D ctermfg=73 guibg=#344B4E ctermbg=239 gui=NONE cterm=NONE
  hi Comment guifg=#4F6B75 ctermfg=242 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Constant guifg=#A4BBBA ctermfg=250 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi String guifg=#90A874 ctermfg=108 guibg=#252A2C ctermbg=235 gui=NONE cterm=NONE
  hi Character guifg=#B2AC78 ctermfg=144 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi link Boolean Character
  hi link Number Character
  hi link Float Character
  hi Identifier guifg=#A4BBBA ctermfg=250 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Function guifg=#74A471 ctermfg=107 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Statement guifg=#599D9D ctermfg=73 guibg=NONE ctermbg=NONE gui=Bold cterm=Bold
  hi Conditional guifg=#668F8F ctermfg=66 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi link Repeat Conditional
  hi link Label Conditional
  hi Operator guifg=#B2AC78 ctermfg=144 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi link Keyword Conditional
  hi link Exception Conditional
  hi PreProc guifg=#668F8F ctermfg=66 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi link Include PreProc
  hi link Define PreProc
  hi link Macro PreProc
  hi link PreCondit PreProc
  hi Type guifg=#668F8F ctermfg=66 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi link StorageClass Type
  hi link Structure Type
  hi link Typedef Type
  hi Special guifg=#8775A0 ctermfg=103 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi SpecialChar guifg=#B2AC78 ctermfg=144 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi link Tag Special
  hi link Delimiter Special
  hi SpecialComment guifg=#599D9D ctermfg=73 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Underlined guifg=#A4BBBA ctermfg=250 guibg=NONE ctermbg=NONE gui=underline cterm=underline
  hi Ignore guifg=#90A874 ctermfg=108 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi Error guifg=#926161 ctermfg=95 guibg=#252A2C ctermbg=235 gui=NONE cterm=NONE
  hi Todo guifg=#B2AC78 ctermfg=144 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssVendor guifg=#74A471 ctermfg=107 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssTagName guifg=#74A471 ctermfg=107 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssBackgroundProp guifg=#668F8F ctermfg=66 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssBorderProp guifg=#668F8F ctermfg=66 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssBoxProp guifg=#668F8F ctermfg=66 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssDimensionProp guifg=#668F8F ctermfg=66 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssFontProp guifg=#668F8F ctermfg=66 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssPositioningProp guifg=#668F8F ctermfg=66 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssTextProp guifg=#668F8F ctermfg=66 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssIdentifier guifg=#74A471 ctermfg=107 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssIncludeKeyword guifg=#B2AC78 ctermfg=144 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssImportant guifg=#926161 ctermfg=95 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssClassName guifg=#74A471 ctermfg=107 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssProp guifg=#668F8F ctermfg=66 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi cssNoise guifg=#926161 ctermfg=95 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi link CtrlPNoEntries SpecialComment
  hi CtrlPMatch guifg=#A85D94 ctermfg=132 guibg=NONE ctermbg=NONE gui=Bold cterm=Bold
  hi CtrlPLinePre guifg=#A4BBBA ctermfg=250 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi link CtrlPPrtBase SpecialComment
  hi link CtrlPPrtText SpecialComment
  hi CtrlPPrtCursor guifg=#A4BBBA ctermfg=250 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi EftChar guifg=#A2866D ctermfg=137 guibg=NONE ctermbg=NONE gui=underline,Bold cterm=underline,Bold
  hi EftSubChar guifg=#926161 ctermfg=95 guibg=NONE ctermbg=NONE gui=underline cterm=underline
  hi javaScriptParens guifg=#599D9D ctermfg=73 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi javaScriptValue guifg=#668F8F ctermfg=66 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi javaScriptOperator guifg=#926161 ctermfg=95 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi javaScriptBraces guifg=#A2866D ctermfg=137 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi javaScriptNull guifg=#668F8F ctermfg=66 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownH1 guifg=#668F8F ctermfg=66 guibg=NONE ctermbg=NONE gui=Bold cterm=Bold
  hi markdownHeadingRule guifg=#926161 ctermfg=95 guibg=NONE ctermbg=NONE gui=Bold cterm=Bold
  hi markdownHeadingDelimiter guifg=#A2866D ctermfg=137 guibg=NONE ctermbg=NONE gui=Bold cterm=Bold
  hi markdownListMarker guifg=#B2AC78 ctermfg=144 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownBlockquote guifg=#B2AC78 ctermfg=144 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownRule guifg=#926161 ctermfg=95 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownLinkTextDelimiter guifg=#599D9D ctermfg=73 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownLinkDelimiter guifg=#599D9D ctermfg=73 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownIdDeclaration guifg=#74A471 ctermfg=107 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownAutomaticLink guifg=#668F8F ctermfg=66 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownUrl guifg=#A85D94 ctermfg=132 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownUrlTitle guifg=#B2AC78 ctermfg=144 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownUrlDelimiter guifg=#B2AC78 ctermfg=144 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownUrlTitleDelimiter guifg=#B2AC78 ctermfg=144 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownCodeDelimiter guifg=#926161 ctermfg=95 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi link markdownCode Comment
  hi markdownEscape guifg=#668F8F ctermfg=66 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi markdownError guifg=#926161 ctermfg=95 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi link RegistersLite PMenu
  hi link RegistersLiteNumber Number
  hi link RegistersLiteChar Number
  hi link RegistersLiteSymbol Delimiter
  hi link RegistersLiteCoron Comment
  hi link RegistersLiteNonText Comment
  hi User1 guifg=#59FEF9 ctermfg=87 guibg=#3A5258 ctermbg=239 gui=NONE cterm=NONE
  hi User2 guifg=#C188F6 ctermfg=141 guibg=#3A5258 ctermbg=239 gui=NONE cterm=NONE
  hi User3 guifg=#FE817C ctermfg=210 guibg=#3A5258 ctermbg=239 gui=NONE cterm=NONE
  hi User4 guifg=#FEEF76 ctermfg=228 guibg=#3A5258 ctermbg=239 gui=NONE cterm=NONE
  hi User5 guifg=#344B4E ctermfg=239 guibg=#3A5258 ctermbg=239 gui=NONE cterm=NONE
  hi GitGutterAdd guifg=#74A471 ctermfg=107 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi GitGutterChange guifg=#8775A0 ctermfg=103 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi GitGutterDelete guifg=#926161 ctermfg=95 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi GitGutterChangeDelete guifg=#926161 ctermfg=95 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi vimOpenParen guifg=#599D9D ctermfg=73 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi xmlNamespace guifg=#B2AC78 ctermfg=144 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi xmlAttribPunct guifg=#926161 ctermfg=95 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi xmlProcessingDelim guifg=#926161 ctermfg=95 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi yamlFlowString guifg=#B2AC78 ctermfg=144 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  hi yamlKeyValueDelimiter guifg=#926161 ctermfg=95 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE

