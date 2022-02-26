"# vim:textwidth=0:foldmethod=marker:foldlevel=1:
"======================================================================

" $$ Initial {{{1

if !exists('s:dein_dir')
  "@ setup dein
  let s:dein_dir = expand('~/.cache/dein')
  let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
  let s:rc_dir = $MYREPO . '/vim/deinrc'

  "@ install dein
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif

  execute 'set runtimepath^=' . substitute(fnamemodify(s:dein_repo_dir, ':p') , '[/\\]$', '', '')
endif

"$$ Options {{{1

" let g:dein#auto_recache = !has('win32')

let g:dein#lazy_rplugins = v:true
" let g:dein#install_progress_type = 'tabline'
let g:dein#install_check_diff = v:true
" let g:dein#enable_notification = v:true

"$$ commands {{{2

command! DeinRemove call s:dein_remove()

function! s:dein_remove() abort
  let l:no_uses = dein#check_clean()
  if len(l:no_uses) > 0
    call map(l:no_uses, "delete(v:val, 'rf')")
    call dein#recache_runtimepath()
  endif
endfunction

"$$ Setup {{{1

if dein#min#load_state(s:dein_dir)
  "$ read init_files {{{2
  let s:base_dir = fnamemodify(expand('<sfile>'), ':h') . '/'
  let g:dein#inline_vimrcs = [
        \ 'init_map.vim',
        \ 'init_options.vim',
        \ 'init_commands.vim',
        \ 'init_terminal.vim'
        \ ]
  call map(g:dein#inline_vimrcs, { _, val -> s:base_dir . val })

  let s:dein_notlazy  = s:base_dir . 'deinrc/notlazy.toml'
  let s:dein_lazy     = s:base_dir . 'deinrc/lazy.toml'
  let s:dein_complete = s:base_dir . 'deinrc/complete.toml'
  let s:dein_textobj  = s:base_dir . 'deinrc/textobj.toml'
  let s:dein_reserve  = s:base_dir . 'deinrc/reserve.toml'
  let s:dein_ft       = s:base_dir . 'deinrc/ft.toml'

  call dein#begin(s:dein_dir, [
        \ expand('<sfile>'),
        \ s:dein_notlazy,
        \ s:dein_lazy,
        \ s:dein_textobj,
        \ s:dein_reserve,
        \ s:dein_ft
        \ ])

  call dein#load_toml(s:dein_notlazy, {'lazy': 0})
  call dein#load_toml(s:dein_lazy, {'lazy' : 1})
  call dein#load_toml(s:dein_complete, {'lazy' : 1})
  call dein#load_toml(s:dein_textobj, {'lazy' : 1})
  call dein#load_toml(s:dein_reserve)
  call dein#load_toml(s:dein_ft)
  call dein#add('itchyny/lightline.vim', {
        \ 'on_event': ['VimEnter'],
        \ 'hook_source': 'source $MYREPO/vim/deinrc/lightline.vim'
        \ })
  call dein#add('kana/vim-smartinput', {
        \ 'on_event': ['InsertEnter', 'CmdlineEnter'],
        \ 'hook_source': 'source $MYREPO/vim/deinrc/smartinput.vim'
        \ })
  call dein#add('vim-skk/skkeleton', {
        \ 'depends': 'denops.vim',
        \ 'on_func': 'skkeleton',
        \ 'hook_source': 'source $MYREPO/vim/deinrc/skkeleton.vim'
        \ })

  " call dein#load_toml(s:rc_dir . '/nvim-treesitter.toml', {})
  " call dein#load_toml(s:rc_dir . '/ale.toml', {})
  " call dein#load_toml(s:rc_dir . '/fzf.toml', {} )
  " call dein#load_toml(s:rc_dir . '/gina.toml', {})
  " " call dein#load_toml(s:rc_dir . '/vim-gist.toml', {})

  call dein#end()
  call dein#save_state()

  if dein#check_install()
    call dein#install()
    call dein#get_progress()
  endif
endif

