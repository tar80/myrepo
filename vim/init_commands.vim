"# vim:textwidth=0:foldmethod=marker:foldlevel=1
"======================================================================
"$$ commands {{{1

"@ syntax info on cursor
command! CheckHighlight echo map(synstack(line('.'),col('.')),'synIDattr(synIDtrans(v:val),"name")')
"@ open cheatsheet
command! Cheatsheet execute '50vsplit' $MYREPO . '/vim/.cheatsheet'
"@ open markdown viewer
command! Shiba call job_start('shiba ' . expand('%'))
"@ diff commands
command! Diff diffthis | wincmd p | diffthis | wincmd h
command! DiffExit syntax enable | diffoff
command! Difforg vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis
"@ ':L <cmd>' 結果をバッファに表示
command! -nargs=1 -complete=command L
      \ <mods> new | setlocal buftype=nofile bufhidden=hide noswapfile |
      \ call setline(1, split(execute(<q-args>), '\n'))
"@ nyagos
if executable('nyagos') && !has('nvim')
  command! -nargs=* NyagosRun call s:termNyagos(<f-args>)
  command! NyagosQuit call term_sendkeys(bufnr('Nyagos'), "exit<CR>")

  function! s:termNyagos(...) abort "{{{2
  " setlocal shellcmdflag=-c
  " setlocal shellpipe=\|&\ tee
  " setlocal shellredir=>%s\ 2>&1
  " setlocal shellxquote="\""

    if (!bufexists('Nyagos'))
      call term_start('nyagos --norc', {
            \ 'term_name': 'Nyagos',
            \ 'term_rows': '10',
            \ 'term_finish': 'close',
            \ })
      wincmd j
    endif

    let args = join(map(copy(a:000), 'expand(v:val)'), ' ')
    call term_sendkeys(bufnr("Nyagos"), args . "\<CR>")
  endfunction "}}}
endif

"$$ Autocmd {{{1

augroup vimrc
  autocmd!
  "@ コマンドモードでは行番号表示
  " autocmd CmdLineEnter * setlocal norelativenumber | redraw
  "@ 挿入モードで一定時間キー入力がなければ着色
  autocmd CursorHoldI * setlocal cursorline
  "@ 挿入モード中にフォーカスが外れたら着色
  autocmd FocusLost,BufLeave * execute (mode() == 'i') ? 'setlocal cursorline' : ''
  "@ 挿入モード中にアクションがあれば色を戻す
  autocmd BufEnter,CursorMovedI,InsertLeave * setlocal nocursorline
  "@ 挿入モードを抜けるときにime off
  autocmd InsertLeave * setlocal iminsert=0
  "@ quickfix
  autocmd Filetype qf setlocal nowrap
augroup END

"@ Diff起動時の設定
" autocmd vimrcAU QuitPre * call s:quit_diff()
" autocmd vimrcAU VimEnter,FilterWritePre * call s:set_diff()
" function s:set_diff() abort
"   if &diff
"     let g:diff_translations=0
"     syntax off
"     highlight Normal guifg=#3C3C40
"   endif
" endfunction
" function s:quit_diff() abort
"   if &diff
"     DiffExit
"   endif
" endfunction

