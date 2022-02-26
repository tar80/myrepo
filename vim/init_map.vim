"# vim:textwidth=0:foldmethod=marker:foldlevel=1
"======================================================================

"$$ functions {{{1

" function! s:SetNoRelNr() abort "{{{2
  " setlocal norelativenumber | redraw | call feedkeys(':', 'n')
" endfunction

function! s:SetWrap() abort "{{{2
  let wr = &wrap ? 'nowrap' : 'wrap'
  if &diff
    execute 'wincmd p | setlocal' wr '| wincmd p | setlocal' wr
  else
    execute 'setlocal' wr
  endif
  unlet wr
endfunction

" TODO: vimgrepの**.*が正しく展開されてない
function! s:ToggleRelNr() abort "{{{2
  setlocal relativenumber!
  redraw
  return ''
endfunction

function! s:ToggleShellslash() abort "{{{2
  if &shellslash
    echo '\noshellslash\'
    setlocal noshellslash
  else
    echo '/shellslash/'
    setlocal shellslash
  endif
  return ''
endfunction

function! s:GrepSearch_Directory() abort "{{{2
  let use_grep = {
        \ '0': ['vimgrep', 'lvim expand(text) **.* | lw'],
        \ '1': ['git-grep', 'lgete system("git grep -nH --column --color=never ".text." .") | lw'],
        \ }[executable('git')]

  let text = input(use_grep[0].': ', expand('<cword>'))

  if empty(text) | return | endif
  execute(use_grep[1])
endfunction

function! s:LineSearch_File() abort "{{{2
  let text = input('vimgrep: ', expand('<cword>'))
  if !empty(text)
   execute 'lvim' text '%' | 7lw
 endif
endfunction

function! s:LoadPPxcfg() abort "{{{2
  if &filetype !=# 'PPxcfg'
    echo 'filetype is not PPxcfg'
    return ''
  endif

  call job_start($PPX_DIR . '\ppcustw.exe CA ' . expand('%:p'))
  echo 'PPcust CA ' . expand("%:t")
endfunction

"$$ general {{{1

if has('gui_running')
  nnoremap <expr> <C-F9> <SID>LoadPPxcfg()
  cnoremap <F12> <C-u>rviminfo ~/_xxxinfo<CR>:
endif

"@ cltc
nnoremap <F1> <Cmd>!start C:/bin/cltc/cltc.exe<CR>

"@ ppx
nnoremap <F6> :<C-u>tabnew<CR>:edit $MYREPO/ppx/xTest.js<CR>
nnoremap <C-F6> :<C-u>execute '!start' $PPX_DIR."\\ppcw.exe -r -k *script \\%'myrepo'\\%\\ppx\\xTest.js"<CR>

"@ search directory with grep
noremap <silent> <leader>g :<C-u>call <SID>GrepSearch_Directory()<CR>
"@ search lines
noremap <silent> <leader>l :<C-u>call <SID>LineSearch_File()<CR>
"@ highlight-search off
noremap <silent> , :<C-u>nohlsearch<CR>
"@ Buffer movement control use <space>
noremap <space> <C-w>
noremap <nowait> <Space><Space> <C-w><C-w>
map <nowait> <space>h <C-w><Left>
noremap <nowait> <space>l <C-w><Right>
"@ toggle line-number
noremap <expr> <F3> <SID>ToggleRelNr()
"@ toggle shellslash
noremap <expr> <F4> <SID>ToggleShellslash()
"@ toggle wrap
noremap <F12> <Cmd>call <SID>SetWrap()<CR>

"@ ignore
noremap <C-z> <Nop>

"$$ normal_mode {{{1
"@ line split
nnoremap <C-j> i<CR><ESC>
"@ yank until the end of the line
nnoremap Y y$
"@ for '*'search do not go to next
nnoremap <silent> <expr> * v:count ?
      \ '*' :
      \ ':sil exe "keepj norm! *" <Bar> call winrestview(' . string(winsaveview()) . ')<CR>'
nnoremap <silent> <expr> g* v:count ?
      \ 'g*' :
      \ ':sil exe "keepj norm! *" <Bar> call winrestview(' . string(winsaveview()) . ')<CR>'
"@ norelativenumber cmdline
" nnoremap <silent>g: :<C-u>call <SID>SetNoRelNr()<CR>
"@ vimrc
nnoremap <silent> <F5> :<C-u>source $MYVIMRC<CR>
nnoremap <F9> :<C-u>tabnew<CR>:edit $MYVIMRC<CR>


"$$ insert_mode command_mode {{{1
noremap! <S-insert> <C-r>*
noremap! <expr> <F3> <SID>ToggleRelNr()
noremap! <expr> <F4> <SID>ToggleShellslash()
noremap! <C-j> <Down>
noremap! <C-k> <Up>
noremap! <C-l> <Delete>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-w>  <C-g>u<C-w>
inoremap <C-u>  <C-g>u<C-u>
inoremap <C-v>u  <C-r>=nr2char(0x)<Left>
inoremap <S-Delete> <C-o>D

cnoremap <C-a> <Home>
cnoremap <C-b> <Left>

"$$ visual_mode {{{1
"@ 範囲を括る
xnoremap <space>" c"<C-r>""<ESC>
xnoremap <space>' c'<C-r>"'<ESC>
xnoremap <space>` c`<C-r>"`<ESC>
xnoremap <space>( c(<C-r>")<ESC>
xnoremap <space>[ c[<C-r>"]<ESC>
xnoremap <space>{ c{<C-r>"}<ESC>
xnoremap <space>$ c${<C-r>"}<ESC>
xnoremap <space>< c【<C-r>"】<ESC>
"@ 範囲インデント処理後に解除しないように
xnoremap < <gv
xnoremap > >gv
"@ カーソルを動かさず選択した文字列を検索
xnoremap <silent> g* "vy:<C-u>let @/ = "<C-R>v"<CR>:<C-u>set hls<CR>gv
xnoremap <silent> * "vy:<C-u>let @/ = "\\\<<C-R>v\\\>"<CR>:<C-u>set hls<CR>gv


