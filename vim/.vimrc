"# vim:textwidth=0:foldmethod=marker:foldlevel=1:
"===============================================================================

set encoding=utf-8
scriptencoding utf-8

"##Echo message vim start up time {{{2
if has('vim_starting') && has('reltime')
  function StartupTimer(timer)
    echomsg 'startuptime:' reltimestr(g:startuptime)
    unlet g:startuptime
  endfunction

  augroup startup
    autocmd!
    let g:startuptime = reltime()
    autocmd VimEnter * ++once let g:startuptime = reltime(g:startuptime) | let timer = timer_start(10, 'StartupTimer')
  augroup END
endif
"}}}2

"#Variables
if !exists('g:my_colorscheme')
  let $REPO = 'C:\bin\repository\tar80'
  let $MYVIMRC = $REPO .. '\myrepo\vim\.vimrc'
  let $PATH = $REPO .. '\myrepo\vim\node_modules\.bin;' .. $PATH
  set runtimepath+=$REPO\myrepo\vim\local
endif

"#Colorscheme
let g:colors_name= 'stagnant'

"#Source
"@ $REPO\myrepo\vim\.gvimrc
source $REPO\myrepo\vim\rc\settings.vim
source $REPO\myrepo\vim\rc\plugins.vim

if !has('gui_running')
  highlight Normal guibg=NONE
  highlight LineNr guibg=NONE
  highlight SignColumn guibg=NONE
endif

syntax enable
" filetype plugin indent on
