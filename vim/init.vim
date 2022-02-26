"# vim:textwidth=0:foldmethod=marker:foldlevel=1:
"======================================================================

"$$ Initial {{{2

set fileformats=unix,dos,mac
set encoding=utf-8
scriptencoding utf-8

set title
let &g:titlestring = '%{toupper(trim(v:progname, ".exe"))}'

"@ echo message vim start up time {{{2
if has('vim_starting') && has('reltime')
  function! StartupTimer(timer)
    echomsg 'startuptime:' reltimestr(g:startuptime)
    unlet g:startuptime
  endfunction

  augroup startup
    autocmd!
    let g:startuptime = reltime()
    autocmd VimEnter * let g:startuptime = reltime(g:startuptime) | let timer = timer_start(10, 'StartupTimer')
  augroup END
endif

"$$ variables {{{1

if !exists('g:my_colorscheme')
  let $MYREPO = 'C:/bin/repository/tar80/myrepo'
  "@ シンボリックリンクの読み込みを防ぐ
  let $MYVIMRC = $MYREPO.'/vim/init.vim'
  let $PATH = $MYREPO . '/vim/node_modules/.bin;' . $PATH
  set runtimepath+=$MYREPO/vim/local
endif

language message C

let g:my_colorscheme = 'clover'
set background=dark

let g:mapleader = ';'

"$$ Omits {{{2
let g:loaded_2html_plugin      = v:true
let g:loaded_logiPat           = v:true
let g:loaded_getscriptPlugin   = v:true
let g:loaded_gzip              = v:true
let g:loaded_man               = v:true
let g:loaded_matchit           = v:true
let g:loaded_matchparen        = v:true
let g:loaded_netrwPlugin       = v:true
let g:loaded_rrhelper          = v:true
let g:loaded_shada_plugin      = v:true
let g:loaded_spellfile_plugin  = v:true
let g:loaded_tarPlugin         = v:true
let g:loaded_tutor_mode_plugin = v:true
let g:loaded_vimballPlugin     = v:true
let g:loaded_zipPlugin         = v:true
"@ メニュー
let g:did_install_default_menus = v:true
let g:did_install_syntax_menu   = v:true
"@ 標準のparen ※vim-parenmatchを読み込むのでoff(=1)
let g:loaded_matchparen         = v:true

"$$ Source {{{1

"@ before calling plugins
augroup vimrcDependencies
  autocmd!
  "NOTE:depends CtrlP
  autocmd CmdLineLeave * setlocal relativenumber
augroup END

source $MYREPO/vim/init_dein.vim

 " source $MYREPO/vim/init_map.vim
 " source $MYREPO/vim/init_options.vim
 " source $MYREPO/vim/init_commands.vim
 " source $MYREPO/vim/init_terminal.vim
 " source $MYREPO/vim/init_vim-plug.vim

execute 'colorscheme' g:my_colorscheme

if has('nvim')
  source $MYREPO/vim/init_nvim.vim
endif

syntax enable
filetype plugin indent on
