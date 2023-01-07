"# vim:textwidth=0:foldmethod=marker:foldlevel=1:
"===============================================================================

"#Variables
let g:mapleader = ';'
let g:update_time = 700

set title
let &g:titlestring = '%{toupper(trim(v:progname, ".exe"))}'

language message C

"#Unload {{{2
let g:loaded_2html_plugin       = 1
let g:loaded_getscriptPlugin    = 1
let g:loaded_gzip               = 1
let g:loaded_logiPat            = 1
let g:loaded_matchparen         = 1
let g:loaded_netrwPlugin        = 1
let g:loaded_rrhelper           = 1
let g:loaded_spellfile_plugin   = 1
let g:loaded_tarPlugin          = 1
let g:loaded_vimballPlugin      = 1
let g:loaded_zipPlugin          = 1
let g:did_install_default_menus = 1
let g:did_install_syntax_menu   = 1
let g:vimsyn_embed              = 0
"}}}2

"#Options
"##Grobal {{{2
setglobal fileformats=unix,dos,mac

if has("termguicolors")
  setglobal termguicolors
  " let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  " let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  let &t_Cs = "\e[4:3m"
  let &t_Ce = "\e[4:0m"
endif

"##Local {{{2

"##Both {{{2
let &updatetime=g:update_time
set fileencodings=utf-8,cp932,euc-jp,sjis
set background=dark
" set autochdir
set diffopt=vertical,filler,iwhite,iwhiteeol,closeoff,indent-heuristic,algorithm:histogram
" set browsedir=buffer
set nobackup
set noswapfile
set noundofile
set undodir=$HOME/.cache/undolog
set history=300
set gdefault
set ignorecase
set incsearch
set hlsearch
set ambiwidth=double
" set smartcase
set formatoptions=mMjql
set nowrap
set nowrapscan
set whichwrap=<,>,[,],h,l
set linebreak
set breakindent
set showbreak=>>
set scrolloff=1
set sidescroll=6
set sidescrolloff=3
set lazyredraw
set list
set listchars=tab:\|\ ,extends:<,precedes:>,trail:_,
set confirm
set display=lastline
set noshowmode
set showtabline=2
set laststatus=2
set cmdheight=1
set autoindent
set ruler
set number
"@ number of columns to use for the line number
" set numberwidth=4
"@ show the relative line number for each line
set relativenumber
set signcolumn=yes
"@ specifies how Insert mode completion works for CTRL-N and CTRL-P
set complete=.,w
"@ whether to use a popup menu for Insert mode completion
set completeopt=menu,menuone,noselect
set showmatch
set matchtime=2
set matchpairs+=【:】,[:],<:>
set tabstop<
set shiftwidth=2
set smarttab
set softtabstop=2
set shiftround
set expandtab
set virtualedit=block
set suffixesadd=.css,.scss,.json,.md,.js,.vim,.lua,.cfg,.txt
set wildmenu
set wildmode=longest:full,full
set wildoptions=pum
set backspace=indent,eol,start
set pumheight=10
"@ number formats recognized for CTRL-A and CTRL-X commands
set nrformats-=octal
"@ display all the information of the tag by the supplement of the Insert mode.
set showfulltag
set spelllang+=cjk
set shortmess=filnrxtToOcsI
set helplang=ja
" set statusline=%!Simple_status()
set foldtext=s:Simple_fold()
" set foldcolumn=1
set noerrorbells
set visualbell t_vb=
" set belloff=all
"}}}2

"#Autocmd {{{1
augroup rcSettings
  autocmd!
  "Depends CtrlP
  " autocmd CmdLineLeave * setlocal relativenumber
  "Editing line highlighting rules
  autocmd CursorHoldI * setlocal cursorline
  autocmd FocusLost,BufLeave * execute (mode() == 'i') ? 'setlocal cursorline' : ''
  autocmd BufEnter,CursorMovedI,InsertLeave * setlocal nocursorline
  "In Insert-Mode, we want a linger updatetime
  autocmd InsertEnter * set updatetime=4000
  autocmd InsertLeave * setlocal iminsert=0 |execute "set updatetime=" .. g:update_time
  "Filetypes
  autocmd Filetype qf setlocal nowrap
augroup END
"}}}1

"#Functions {{{1
function! s:Make_scratch() abort "{{{2
  new Scratch|setlocal buftype=nofile bufhidden=wipe
endfunction

function! S_mode() abort "{{{2
  let l:mode = {
        \ 'n': ['N', '%*'],
        \ 'i': ['I', '%1*'],
        \ 'v': ['V', '%2*'],
        \ 'V': ['V', '%2*'],
        \ 's': ['V', '%2*'],
        \ 'S': ['V', '%2*'],
        \ 'R': ['R', '%3*'],
        \ 'c': ['C', '%4*'],
        \ 'r': ['r', '%4*'],
        \ '!': ['!', '%4*'],
        \ 't': ['t', '%4*'],
        \ }
  let l:getmode = l:mode[mode()]
  return l:getmode[1] .. '∎ '  .. expand('%:.') .. '%*'
endfunction

function! Simple_status() abort "{{{2
  let l:fg = '%*'
  let l:sep = ' ୲ '
  let l:ro = &readonly ? ' %4*%*' : ''
  let l:mod = &modifiable && &modified ? ' %1*' : ''
  let l:fenc = &fileencoding ? l:sep .. &fileencoding : ''
  let l:ff = &fileformat != '' ? l:sep .. &fileformat : ''
  let l:ft = &filetype != '' ? l:sep .. &filetype : ''
  let l:status = [
        \ '%{%S_mode()%}',
        \ l:ro .. l:mod,
        \ '%=',
        \ l:fg,
        \ '%c:%l/%L',
        \ l:fenc,
        \ l:ff,
        \ l:ft,
        \ ' ',
        \ ]
  return bufname() == bufname(bufnr()) ? join(l:status, '') : ''
endfunction
function! s:Simple_fold() "{{{2
  "Credits:This code is based on https://github.com/tamton-aquib
  let l:start = substitute(getline(v:foldstart), '\t', repeat(' ', &tabstop), 'g')
  let l:end = trim(getline(v:foldend))
  let l:nol = '▶(' .. (v:foldend - v:foldstart) .. ')'
  let l:nollen = strlen(substitute(l:nol, '.', 'x', 'g'))
  let l:sep = '  »  '
  let l:seplen = strlen(substitute(l:sep, '.', 'x', 'g'))
  let l:text = l:nol .. l:start .. l:sep .. l:end

  return l:text .. repeat(' ', &columns - strlen(substitute(l:text, ".", "x", "g")))
endfunction

function! s:SetWrap() abort "{{{2
  let w = &wrap ? 'nowrap' : 'wrap'
  if &diff
    execute 'windo setlocal ' .. w .. '|' .. winnr() .. 'wincmd w'
  else
    execute 'setlocal ' .. w
  endif
  unlet w
endfunction
"}}}2
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

"##Grep cwd {{{2
let s:grep_result = []
function! s:receive_data(ch, msg) abort
  call add(s:grep_result, a:msg)
endfunction
function! s:sweep_out(job, status) abort
  cgete s:grep_result | cw
  let s:grep_result = []
endfunction
function! s:Grep_cwd() abort
  let l:grep = executable('rg') ? 'rg' : 'vimgrep'
  if isdirectory(getcwd() .. '\.git') && executable('git')
    let l:grep = 'git-grep'
  endif

  let l:use_grep = {
        \ 'vimgrep': 'vim expand(l:search_term) **.* | cw',
        \ 'rg': "call job_start(['rg', '-i', '--vimgrep', '-g', '!{node_modules,.git}', l:search_term, '.'], {'callback': 's:receive_data', 'exit_cb': 's:sweep_out'})",
        \ 'git-grep': "call job_start(['git', 'grep', '-nH', '--column', '--color=never', l:search_term, '.'], {'callback': 's:receive_data', 'exit_cb': 's:sweep_out'})",
        \ }[l:grep]

  let l:search_term = input(l:grep .. ': ', '')

  if empty(l:search_term) | return | endif
  execute(l:use_grep)
endfunction

function! s:LineSearch_File() abort "{{{2
  let l:text = input('vimgrep: ', expand('<cword>'))
  if !empty(l:text)
   execute 'lvim' l:text '%' | 7lw
 endif
endfunction

function! s:LoadPPxcfg() abort "{{{2
  if &filetype !=# 'PPxcfg'
    echo 'filetype is not PPxcfg'
    return ''
  endif

  call job_start($PPX_DIR .. '\ppcustw.exe CA ' .. expand('%:p'))
  echo 'PPcust CA ' .. expand("%:t")
endfunction "}}}2

"#Keymaps {{{1
"##Normal {{{2
nnoremap <F1> <Cmd>!start C:/bin/cltc/cltc.exe <CR>
noremap <expr> <F3> <SID>ToggleRelNr()
noremap <expr> <F4> <SID>ToggleShellslash()
nnoremap <expr> <C-F9> <SID>LoadPPxcfg()
noremap <F12> <Cmd>call <SID>SetWrap()<CR>
noremap <silent> , :<C-u>nohlsearch<CR>
nnoremap <C-j> i<CR><ESC>
noremap <C-z> <Nop>
nnoremap Y y$
nnoremap <silent> <expr> * v:count ?
      \ '*' :
      \ ':sil exe "keepj norm! *" <Bar> call winrestview(' .. string(winsaveview()) .. ')<CR>'
nnoremap <silent> <expr> g* v:count ?
      \ 'g*' :
      \ ':sil exe "keepj norm! *" <Bar> call winrestview(' .. string(winsaveview()) .. ')<CR>'

"@ Move buffer use <Space>
noremap <Space> <C-w>
noremap <nowait> <Space><Space> <C-w><C-w>
noremap <nowait> <Space>h <C-w><Left>
noremap <nowait> <Space>l <C-w><Right>
noremap <Space>c <Cmd>tabclose<CR>
noremap <Space>n <Cmd>call <SID>Make_scratch()<CR>
"@ search lines
" noremap <silent> <leader>l :<C-u>call <SID>LineSearch_File()<CR>
noremap <silent> <leader>g :<C-u>call <SID>Grep_cwd()<CR>

"##Insert/Command {{{2
noremap! <S-insert> <C-r>*
noremap! <expr> <F3> <SID>ToggleRelNr()
noremap! <expr> <F4> <SID>ToggleShellslash()
noremap! <C-b> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-d> <Delete>
inoremap <C-f> <Right>
inoremap <C-w>  <C-g>u<C-w>
inoremap <C-u>  <C-g>u<C-u>
inoremap <C-v>u  <C-r>=nr2char(0x)<Left>
inoremap <S-Delete> <C-o>D

cnoremap <C-a> <Home>
cnoremap <F12> <C-u>rviminfo ~/_xxxinfo<CR>:

"##Visual {{{2
xnoremap < <gv
xnoremap > >gv
xnoremap <silent> g* "vy:<C-u>let @/ = "<C-R>v"<CR>:<C-u>set hls<CR>gv
xnoremap <silent> * "vy:<C-u>let @/ = "\\\<<C-R>v\\\>"<CR>:<C-u>set hls<CR>gv
"}}}1

"#Commands {{{1
"@ syntax info on cursor
command! CheckHighlight echo map(synstack(line('.'),col('.')),'synIDattr(synIDtrans(v:val),"name")')
"@ open markdown viewer
command! Shiba call job_start('shiba ' .. expand('%'))
"@':Z <term>' zoxide query
function! s:zoxide_query(ch, msg) abort
  execute 'tcd ' .. a:msg
endfunction
command! -nargs=1 -complete=command Z
      \ call job_start(['zoxide', 'query', <q-args>], {'callback': 's:zoxide_query'})
"@':L <cmd>' Display command result in buffer
command! -nargs=1 -complete=command L
      \ <mods> new | setlocal buftype=nofile bufhidden=hide noswapfile |
      \ call setline(1, split(execute(<q-args>), '\n'))
"@'E <filepath>' Edit the file and set current directory to parent direcotry
command! -nargs=1 -complete=file E edit <args> | chdir %:p:h
"@'F <filename>' Rename editing file
command! -nargs=1 F file %:p:h\<args>
