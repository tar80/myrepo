-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------
-- #Autogroup
vim.api.nvim_create_augroup("rcDeno", {})

-- #Autocommand
-- ##Autocmd Skkeleton {{{2
vim.api.nvim_create_autocmd("BufEnter", {
  group = "rcDeno",
  pattern = ".md",
  command = 'call skkeleton#config({"KeepState": v:true})',
})
vim.api.nvim_create_autocmd("BufLeave", {
  group = "rcDeno",
  pattern = ".md",
  command = 'call skkeleton#config({"KeepState": v:false})',
})
vim.api.nvim_create_autocmd("User", {
  group = "rcDeno",
  pattern = "skkeleton-initialize-pre",
  callback = function()
    Skkeleton_init()
  end,
})

-- ##FuzzyMotion {{{2
vim.g.fuzzy_motion_word_filter_regexp_list = { "^[a-zA-Z0-9]" }
-- vim.g.fuzzy_motion_word_regexp_list = [ '[0-9a-zA-Z_-]+', '([0-9a-zA-Z_-]|[.])+', '([0-9a-zA-Z_-]|[().#])+' ]
-- vim.g.fuzzy_motion_auto_jump = false
vim.keymap.set("n", "<Leader>j", function()
  if vim.fn["denops#plugin#is_loaded"]("fuzzy-motion") == 0 then
    vim.fn["denops#plugin#register"]("fuzzy-motion")
  end

  vim.cmd([[FuzzyMotion]])
end)

-- ##Skkeleton {{{2
function Skkeleton_init()
  vim.fn["skkeleton#config"]({
    globalJisyo = os.getenv("HOME") .. "/.skk/SKK-JISYO.L",
    eggLikeNewline = true,
    usePopup = true,
    showCandidatesCount = 1,
    markerHenkan = "🐤",
    markerHenkanSelect = "🐥",
  })

  vim.fn["skkeleton#register_keymap"]("input", ";", "henkanPoint")
  vim.fn["skkeleton#register_keymap"]("input", "@", "cancel")
  vim.fn["skkeleton#register_keymap"]("input", "<Up>", "disable")
  vim.fn["skkeleton#register_keymap"]("input", "<Down>", "disable")
  vim.fn["skkeleton#register_kanatable"]("rom", {
    [":"] = { "っ", "" },
    ["bd"] = { "べん", "" },
    ["bj"] = { "ぶん", "" },
    ["bk"] = { "びん", "" },
    ["bl"] = { "ぼん", "" },
    ["bhd"] = { "びぇん", "" },
    ["byj"] = { "びゅん", "" },
    ["byl"] = { "びょん", "" },
    ["byz"] = { "びゃん", "" },
    ["chd"] = { "ちぇん", "" },
    ["chz"] = { "ちゃん", "" },
    ["cyj"] = { "ちゅん", "" },
    ["cyl"] = { "ちょん", "" },
    ["bz"] = { "ばん", "" },
    ["dd"] = { "でん", "" },
    ["dj"] = { "づん", "" },
    ["dk"] = { "ぢん", "" },
    ["dl"] = { "どん", "" },
    ["dz"] = { "だん", "" },
    ["fd"] = { "ふぇん", "" },
    ["fj"] = { "ふん", "" },
    ["fk"] = { "ふぃん", "" },
    ["fl"] = { "ふぉん", "" },
    ["fz"] = { "ふぁん", "" },
    ["gd"] = { "げん", "" },
    ["gj"] = { "ぐん", "" },
    ["gk"] = { "ぎん", "" },
    ["gl"] = { "ごん", "" },
    ["ghd"] = { "ぎぇん", "" },
    ["gyj"] = { "ぎゅん", "" },
    ["gyl"] = { "ぎょん", "" },
    ["gyz"] = { "ぎゃん", "" },
    ["gz"] = { "がん", "" },
    ["hd"] = { "へん", "" },
    ["hj"] = { "ふん", "" },
    ["hk"] = { "ひん", "" },
    ["hl"] = { "ほん", "" },
    ["hhd"] = { "ひぇん", "" },
    ["hyj"] = { "ひゅん", "" },
    ["hyl"] = { "ひょん", "" },
    ["hyz"] = { "ひゃん", "" },
    ["hz"] = { "はん", "" },
    ["jk"] = { "じん", "" },
    ["jd"] = { "じぇん", "" },
    ["jj"] = { "じゅん", "" },
    ["jl"] = { "じょん", "" },
    ["jz"] = { "じゃん", "" },
    ["kd"] = { "けん", "" },
    ["kj"] = { "くん", "" },
    ["kk"] = { "きん", "" },
    ["kl"] = { "こん", "" },
    ["khd"] = { "きぇん", "" },
    ["kyj"] = { "きゅん", "" },
    ["kyl"] = { "きょん", "" },
    ["kyz"] = { "きゃん", "" },
    ["kz"] = { "かん", "" },
    ["md"] = { "めん", "" },
    ["mj"] = { "むん", "" },
    ["mk"] = { "みん", "" },
    ["ml"] = { "もん", "" },
    ["mhd"] = { "みぇん", "" },
    ["myj"] = { "みゅん", "" },
    ["myl"] = { "みょん", "" },
    ["myz"] = { "みゃん", "" },
    ["mz"] = { "まん", "" },
    ["nd"] = { "ねん", "" },
    ["nj"] = { "ぬん", "" },
    ["nk"] = { "にん", "" },
    ["nl"] = { "のん", "" },
    ["nhd"] = { "にぇん", "" },
    ["nyj"] = { "にゅん", "" },
    ["nyl"] = { "にょん", "" },
    ["nyz"] = { "にゃん", "" },
    ["nz"] = { "なん", "" },
    ["pd"] = { "ぺん", "" },
    ["pj"] = { "ぷん", "" },
    ["pk"] = { "ぴん", "" },
    ["pl"] = { "ぽん", "" },
    ["pz"] = { "ぱん", "" },
    ["phd"] = { "ぴぇん", "" },
    ["pyj"] = { "ぴゅん", "" },
    ["pyl"] = { "ぴょん", "" },
    ["pyz"] = { "ぴゃん", "" },
    ["rd"] = { "れん", "" },
    ["rj"] = { "るん", "" },
    ["rk"] = { "りん", "" },
    ["rl"] = { "ろん", "" },
    ["rz"] = { "らん", "" },
    ["rhd"] = { "りぇん", "" },
    ["ryj"] = { "りゅん", "" },
    ["ryl"] = { "りょん", "" },
    ["ryz"] = { "りゃん", "" },
    ["sd"] = { "せん", "" },
    ["sk"] = { "しん", "" },
    ["sl"] = { "そん", "" },
    ["shd"] = { "しぇん", "" },
    ["syj"] = { "しゅん", "" },
    ["syl"] = { "しょん", "" },
    ["syz"] = { "しゃん", "" },
    ["sz"] = { "さん", "" },
    ["td"] = { "てん", "" },
    ["tj"] = { "つん", "" },
    ["tk"] = { "ちん", "" },
    ["tl"] = { "とん", "" },
    ["tz"] = { "たん", "" },
    ["wd"] = { "うぇん", "" },
    ["wk"] = { "うぃん", "" },
    ["wz"] = { "わん", "" },
    ["xq"] = "hankatakana",
    ["yj"] = { "ゆん", "" },
    ["yl"] = { "よん", "" },
    ["yz"] = { "やん", "" },
    ["zd"] = { "ぜん", "" },
    ["zj"] = { "ずん", "" },
    ["zk"] = { "じん", "" },
    ["zl"] = { "ぞん", "" },
    ["zz"] = { "ざん", "" },
    ["z\x20"] = { "\u{3000}", "" },
    ["z-"] = { "-", "" },
    ["z~"] = { "〜", "" },
    ["z;"] = { ";", "" },
    ["z,"] = { ",", "" },
    ["z["] = { "【", "" },
    ["z]"] = { "】", "" },
  })
end

vim.keymap.set("i", "<C-l>", "<Plug>(skkeleton-enable)")
-- vim.keymap.set("c", "<C-l>", "<Plug>(skkeleton-enable)")
