"# vim:textwidth=0:foldmethod=marker:foldlevel=1:
"===============================================================================

if jetpack#tap('fuzzy-motion.vim')
  function! s:do_fuzzymotion() abort "{{{2
    if denops#plugin#is_loaded('fuzzy-motion') == 0
      call denops#plugin#wait('fuzzy-motion', 'timeout')
      call denops#plugin#register('fuzzy-motion', 'skip')
    endif

    FuzzyMotion
    return ''
  endfunction "}}}2

  " let g:fuzzy_motion_word_regexp_list =  ['^[a-zA-Z0-9]']
  " let g:fuzzy_motion_auto_jump = v:false
  nnoremap <leader>j <Cmd>call <SID>do_fuzzymotion()<CR>
endif

if jetpack#tap('skkeleton')
  augroup rcPlugins
    autocmd BufEnter *.md call skkeleton#config({'keepState': v:true})
    autocmd BufLeave *.md call skkeleton#config({'keepState': v:false})
    autocmd User skkeleton-initialize-pre call s:skkeleton_init()
  augroup END

  function! s:skkeleton_init() abort "{{{2
    call skkeleton#config({
          \ 'globalJisyo': '~/.skk/SKK-JISYO.L',
          \ 'eggLikeNewline': v:true,
          \ 'usePopup': v:true,
          \ 'showCandidatesCount': 1,
          \ 'markerHenkan': '🐤',
          \ 'markerHenkanSelect': '🐥',
          \ })

    call skkeleton#register_keymap('input', ';', 'henkanPoint')
    call skkeleton#register_keymap('input', '@', 'cancel')
    call skkeleton#register_kanatable('rom', {
          \ "\<Left>": ["←", ''],
          \ "\<Right>": ["→", ''],
          \ "\<Down>": ["", ''],
          \ "\<UP>": ["", ''],
          \ "\<C-j>": ["", ''],
          \ "~": ["～", ''],
          \ ":": ["っ", ''],
          \ "bd": ["べん", ''],
          \ "bj": ["ぶん", ''],
          \ "bk": ["びん", ''],
          \ "bl": ["ぼん", ''],
          \ "bhd": ["びぇん", ''],
          \ "bhj": ["びゅん", ''],
          \ "bhl": ["びょん", ''],
          \ "bhz": ["びゃん", ''],
          \ "chz": ["ちゃん", ''],
          \ "chj": ["ちゅん", ''],
          \ "chd": ["ちぇん", ''],
          \ "chl": ["ちぉん", ''],
          \ "bz": ["ばん", ''],
          \ "dd": ["でん", ''],
          \ "dj": ["づん", ''],
          \ "dk": ["ぢん", ''],
          \ "dl": ["どん", ''],
          \ "dz": ["だん", ''],
          \ "fd": ["ふぇん", ''],
          \ "fj": ["ふん", ''],
          \ "fk": ["ふぃん", ''],
          \ "fl": ["ふぉん", ''],
          \ "fz": ["ふぁん", ''],
          \ "gd": ["げん", ''],
          \ "gj": ["ぐん", ''],
          \ "gk": ["ぎん", ''],
          \ "gl": ["ごん", ''],
          \ "ghd": ["ぎぇん", ''],
          \ "ghj": ["ぎゅん", ''],
          \ "ghl": ["ぎょん", ''],
          \ "ghz": ["ぎゃん", ''],
          \ "gz": ["がん", ''],
          \ "hd": ["へん", ''],
          \ "hj": ["ふん", ''],
          \ "hk": ["ひん", ''],
          \ "hl": ["ほん", ''],
          \ "hhd": ["ひぇん", ''],
          \ "hhj": ["ひゅん", ''],
          \ "hhl": ["ひょん", ''],
          \ "hhz": ["ひゃん", ''],
          \ "hz": ["はん", ''],
          \ "jk": ["じん", ''],
          \ "jd": ["じぇん", ''],
          \ "jj": ["じゅん", ''],
          \ "jl": ["じょん", ''],
          \ "jz": ["じゃん", ''],
          \ "kd": ["けん", ''],
          \ "kj": ["くん", ''],
          \ "kk": ["きん", ''],
          \ "kl": ["こん", ''],
          \ "khd": ["きぇん", ''],
          \ "khj": ["きゅん", ''],
          \ "khl": ["きょん", ''],
          \ "khz": ["きゃん", ''],
          \ "kz": ["かん", ''],
          \ "md": ["めん", ''],
          \ "mj": ["むん", ''],
          \ "mk": ["みん", ''],
          \ "ml": ["もん", ''],
          \ "mhd": ["みぇん", ''],
          \ "mhj": ["みゅん", ''],
          \ "mhl": ["みょん", ''],
          \ "mhz": ["みゃん", ''],
          \ "mz": ["まん", ''],
          \ "nd": ["ねん", ''],
          \ "nj": ["ぬん", ''],
          \ "nk": ["にん", ''],
          \ "nl": ["のん", ''],
          \ "nhd": ["にぇん", ''],
          \ "nhj": ["にゅん", ''],
          \ "nhl": ["にょん", ''],
          \ "nhz": ["にゃん", ''],
          \ "nz": ["なん", ''],
          \ "pd": ["ぺん", ''],
          \ "pj": ["ぷん", ''],
          \ "pk": ["ぴん", ''],
          \ "pl": ["ぽん", ''],
          \ "pz": ["ぱん", ''],
          \ "phd": ["ぴぇん", ''],
          \ "phj": ["ぴゅん", ''],
          \ "phl": ["ぴょん", ''],
          \ "phz": ["ぴゃん", ''],
          \ "rd": ["れん", ''],
          \ "rj": ["るん", ''],
          \ "rk": ["りん", ''],
          \ "rl": ["ろん", ''],
          \ "rz": ["らん", ''],
          \ "rhd": ["りぇん", ''],
          \ "rhj": ["りゅん", ''],
          \ "rhl": ["りょん", ''],
          \ "rhz": ["りゃん", ''],
          \ "sd": ["せん", ''],
          \ "sk": ["しん", ''],
          \ "sl": ["そん", ''],
          \ "shd": ["しぇん", ''],
          \ "shj": ["しゅん", ''],
          \ "shl": ["しょん", ''],
          \ "shz": ["しゃん", ''],
          \ "sz": ["さん", ''],
          \ "td": ["てん", ''],
          \ "tj": ["つん", ''],
          \ "tk": ["ちん", ''],
          \ "tl": ["とん", ''],
          \ "tz": ["たん", ''],
          \ "wd": ["うぇん", ''],
          \ "wk": ["うぃん", ''],
          \ "wz": ["わん", ''],
          \ "xq": ["hankatakana", ''],
          \ "yj": ["ゆん", ''],
          \ "yl": ["よん", ''],
          \ "yz": ["やん", ''],
          \ "zd": ["ぜん", ''],
          \ "zj": ["ずん", ''],
          \ "zk": ["じん", ''],
          \ "zl": ["ぞん", ''],
          \ "zz": ["ざん", ''],
          \ "z\<Space>": ["\u3000", ''],
          \ "z-": ["-", ''],
          \ "z~": ["〜", ''],
          \ "z;": [";", ''],
          \ "z,": [",", ''],
          \ "z[": ["【", ''],
          \ "z]": ["】", ''],
          \ })
  endfunction

  function! s:do_skkeleton() abort "{{{2
    if denops#plugin#is_loaded('skkeleton') == 0
      call denops#plugin#wait('skkeleton', 'timeout')
      call denops#plugin#register('skkeleton', 'skip')
    endif

    call feedkeys("\<Plug>(skkeleton-enable)")
    return ''
  endfunction "}}}2

  inoremap <C-l> <Cmd>call <SID>do_skkeleton()<CR>
  " cmap <C-l> <Plug>(skkeleton-enable)
endif
