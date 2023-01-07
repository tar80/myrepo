"# vim:textwidth=0:foldmethod=marker:foldlevel=1:
"===============================================================================

"##Setup Jetpack {{{2
let s:jetpack_dir = expand('~\.cache\vim-jetpack')
let s:jetpack = expand(s:jetpack_dir.'\pack\jetpack\opt\vim-jetpack\plugin\jetpack.vim')

"@Auto install
if !filereadable(s:jetpack)
  let s:jetpack_url = 'https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim'
  call system(printf('curl -fsSLo %s --create-dirs %s', s:jetpack, s:jetpack_url))
endif

let &packpath = s:jetpack_dir .. ',' .. &packpath

"@Options
" let g:jetpack_copy_method = 'system'
" let g:jetpack_download_method = 'git'
let g:jetpack_ignore_patterns = [
      \   '[\/]doc[\/]tags*',
      \   '[\/]test[\/]*',
      \   '[\/]t[\/]*',
      \   '[\/][.ABCDEFGHIJKLMNOPQRSTUVWXYZ]*',
      \ ]

"##Lazy load {{{2
if has('vim_starting')
  function! Lazyload(timer) abort
    doautocmd User Lazyload
  endfunction

  function! s:load_sources()
    source $REPO\myrepo\vim\rc\config\lazyload.vim
    if jetpack#tap('denops.vim')
      source $REPO\myrepo\vim\rc\config\denos.vim
    endif
    if jetpack#tap('lightline.vim')
      source $REPO\myrepo\vim\rc\config\indicate.vim
    endif
    if jetpack#tap('ctrlp.vim')
      source $REPO\myrepo\vim\rc\config\finder.vim
    endif
    if jetpack#tap('lexima.vim')
      source $REPO\myrepo\vim\rc\config\input.vim
    endif
endfunction

augroup rcPlugins
  autocmd!
  autocmd User LazyLoad ++once call s:load_sources()
augroup End

call timer_start(100, 'Lazyload')
endif

"##Pre-load plugins {{{1
" let g:ambiwidth_add_list = [[0xff000, 0xff499, 2]]

"##Load plugins {{{1
packadd vim-jetpack

call jetpack#begin(s:jetpack_dir)
call jetpack#add('tani/vim-jetpack', {'frozen': 1, 'opt': 1})
call jetpack#add($REPO .. '\vim-parenmatch')
call jetpack#add('tar80/vim-PPxcfg')
" call jetpack#add('rbtnn/vim-ambiwidth')
call jetpack#add('kana/vim-operator-user')
call jetpack#add('kana/vim-textobj-user')
call jetpack#add('itchyny/lightline.vim', {'event': 'VimEnter'})
call jetpack#add('mattn/vim-findroot', {'event': 'User LazyLoad'})
call jetpack#add('cohama/lexima.vim', {'event': 'User LazyLoad'})
call jetpack#add('utubo/vim-registers-lite', {'frozen': 1, 'event': 'User LazyLoad'})
call jetpack#add('kana/vim-operator-replace', {'keys': '<Plug>(operator-replace)'})
call jetpack#add('kana/vim-smartword', {'keys': '<Plug>(smartword-'})
call jetpack#add('rhysd/vim-operator-surround', {'keys': '<Plug>(operator-surround-'})
call jetpack#add('hrsh7th/vim-eft', {'keys': '<Plug>(eft-'})
call jetpack#add('tyru/caw.vim', {'keys': '<Plug>(caw:'})
call jetpack#add('tyru/open-browser.vim', {'keys': '<Plug>(openbrowser-smart-search)'})
call jetpack#add('ctrlpvim/ctrlp.vim', {'cmd': ['CtrlPBuffer', 'CtrlPLine', 'CtrlPMRMrw', 'CtrlPMRMrr', 'CtrlPCurWD', 'CtrlPTag']})
call jetpack#add('mattn/ctrlp-matchfuzzy', {'opt': 1})
call jetpack#add('tsuyoshicho/ctrlp-mr.vim', {'opt': 1})
call jetpack#add('lambdalisue/mr.vim', {'opt': 1})
call jetpack#add('skanehira/translate.vim', {'cmd': 'Translate'})
call jetpack#add('mbbill/undotree', {'cmd': 'UndotreeToggle'})

if expand($PROCESSOR_ARCHITEW6432) == "AMD64"
  call jetpack#add('dense-analysis/ale', {'event': 'User LazyLoad'})
  call jetpack#add('vim-denops/denops.vim', {'event': 'VimEnter'})
  call jetpack#add('yuki-yano/fuzzy-motion.vim', {'event': 'User LazyLoad'})
  call jetpack#add('vim-skk/skkeleton', {'commit': '1c76771', 'event': 'User LazyLoad'})
  " call jetpack#add('skanehira/denops-translate.vim', {'event': 'User Lazyload'})
else
endif

call jetpack#end()


