"# vim:textwidth=0:foldmethod=marker:foldlevel=1:
"======================================================================

"#Color display of IME status
"#https://sites.google.com/site/fudist/Home/vim-nihongo-ban/vim-color
" if has('multi_byte_ime')
"   set iminsert=0 imsearch=0
"   highlight Cursor guifg=NONE guibg=lightgreen
"   highlight CursorIM guifg=NONE guibg=purple
" endif

"#Suppress cursor blinking
set guicursor=a:ver20-blinkwait0-blinkon700-blinkoff600
set guicursor+=n-v:block-blinkwait0-blinkon1200-blinkoff1000

"#Indicates
set guioptions-=T
" set guioptions -=m
set guioptions+=c
set guioptions-=e
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
set guioptions+=!
set t_vb=

"#Fonts
if has('xfontset')
  set guifontset=a14,r14,k14
elseif has('win32') || has('win64')
  " set guifont=Cica:h14:cSHIFTJIS
  set guifont=HackGen_Console_NF:h13:cSHIFTJIS
  " set guifont=FirgeNerd:h13:w7.2:cSHIFTJIS
  set renderoptions=type:directx,renmode:5,level:1,gamma:1.2,contrast:2
endif

"#For print
"if has('printer')
"  if has('win32') || has('win64')
"   set printfont=MS_Mincho:h12:cSHIFTJIS
"   set printfont=MS_Gothic:h12:cSHIFTJIS
"  endif
"endif
