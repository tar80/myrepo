"# vim:textwidth=0:foldmethod=marker:foldlevel=1:
"======================================================================

if !filereadable($HOME . '\vimfiles\autoload\plug.vim')
  call system('curl -fLo' . $HOME . '\vimfiles\autoload\plug.vim --create-dirs
       \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  call system('curl -fLo' . $HOME . '\vimfiles\doc\plug.txt --create-dirs
       \ https://raw.githubusercontent.com/junegunn/vim-plug/master/doc/plug.txt')
endif

let g:plug_shallow = 0

call plug#begin('$HOME\vimfiles')

Plug 'tar80/vim-PPxcfg', {'for': 'cfg'}
Plug 'vim-jp/vimdoc-ja', {'for': 'help'}
Plug 'itchyny/vim-parenmatch'
Plug 'itchyny/vim-gitbranch'
Plug 'itchyny/lightline.vim'
Plug 'lifepillar/vim-mucomplete'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'
Plug 'kana/vim-smartinput'
Plug 'kana/vim-textobj-user'
  Plug 'rhysd/vim-textobj-anyblock'
Plug 'kana/vim-operator-user'
  Plug 'kana/vim-operator-replace', {'on': '<Plug>(operator-replace)'}
  Plug 'rhysd/vim-operator-surround', {'on': '<Plug>(operator-surround-'}
  Plug 'tyru/caw.vim', {'on': '<Plug>(caw:'}
Plug 'rhysd/clever-f.vim', {'on': '<Plug>(clever-f-'}
Plug 'ctrlpvim/ctrlp.vim', {'on': ['CtrlPBuffer', 'CtrlPMRUFiles', 'CtrlPCurWD', 'CtrlPRoot', 'CtrlPBookmarkDir']}
Plug 'leafCage/yankround.vim', {'on': '<Plug>(yankround-'}
Plug 'mbbill/undotree'

call plug#end()

let s:plugs_config_dir = $MYREPO . '\vim\plugrc86\'
let s:plugs = get(g:, 'plugs', {})
for name in keys(s:plugs)
  let s:plug_config_path = s:plugs_config_dir . substitute(name, '\(\.vim\|\)$', '.vim', '')
  " let s:plug_config_path = s:plugs_config_dir . fnamemodify(plug, ':r') . '.vim'
  if filereadable(s:plug_config_path)
    execute 'source' s:plug_config_path
  endif
endfor

