"# vim:textwidth=0:foldmethod=marker:foldlevel=1:
"======================================================================
scriptencoding utf-8

" IME制御
if has('multi_byte_ime')
  set iminsert=0 imsearch=0
" IMEの状態をカラー表示 (https://sites.google.com/site/fudist/Home/vim-nihongo-ban/vim-color)
  highlight Cursor guifg=black guibg=lightgreen
  highlight CursorIM guifg=white guibg=#D1934C
endif
" カーソル点滅抑止
set guicursor=a:ver20-blinkwait0-blinkon700-blinkoff600
set guicursor+=n-v:block-blinkwait0-blinkon1200-blinkoff1000

" 表示設定
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
"
"" フォント設定 ※英語名で指定すると問題が起きにくい
if has('xfontset')
  set guifontset=a14,r14,k14
elseif has('win32') || has('win64')
  " set guifont=Cica:h14:cSHIFTJIS
  " set guifont=HackGenNerd_Console:h13:cSHIFTJIS
  " set guifont=FirgeNerd:h14:w8.6:cSHIFTJIS
  set guifont=FirgeNerd:h13.2:w8:cSHIFTJIS
  " set guifont=PlemolJP_HS_Text:h13:cSHIFTJIS
  " set guifont=Rounded_M+_1mn_regular:h14:cSHIFTJIS
  set renderoptions=type:directx,renmode:5,level:1,gamma:1.2,contrast:2
endif
"
" 印刷用フォント
"if has('printer')
"  if has('win32') || has('win64')
"   set printfont=MS_Mincho:h12:cSHIFTJIS
"   set printfont=MS_Gothic:h12:cSHIFTJIS
"  endif
"endif
"
"" Window位置の保存と復帰
" let s:infofile = '~/_vimpos'
" "
" function! s:SaveWindowParam(filename)
"   redir => pos
"   exec 'winpos'
"   redir END
"   let pos = matchstr(pos, 'X[-0-9 ]\+,\s*Y[-0-9 ]\+$')
"   let file = expand(a:filename)
"   let str = []
"   let cmd = 'winpos '.substitute(pos, '[^-0-9 ]', '', 'g')
"   cal add(str, cmd)
"   let l = &lines
"   let c = &columns
"   cal add(str, 'set lines='. l.' columns='. c)
"   silent! let ostr = readfile(file)
"   if str != ostr
"     call writefile(str, file)
"   endif
" endfunction
" "
" augroup SaveWindowParam
"   autocmd!
"   execute 'autocmd SaveWindowParam VimLeave * call s:SaveWindowParam("'.s:infofile.'")'
" augroup END
" "
" if filereadable(expand(s:infofile))
"   execute 'source '.s:infofile
" endif
" unlet s:infofile

