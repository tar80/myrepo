-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------
---@desc Autocommand {{{2
local augroup = vim.api.nvim_create_augroup('rcDeno', {})
vim.api.nvim_create_autocmd('User', {
  group = augroup,
  pattern = 'skkeleton-initialize-pre',
  callback = function()
    Skkeleton_init()
  end,
})

---@desc FuzzyMotion {{{2
if vim.g.fuzzy_motion_labels then
  vim.g.fuzzy_motion_matchers = { 'fzf', 'kensaku' }
  -- vim.g.fuzzy_motion_word_filter_regexp_list = { '^[a-zA-Z0-9]' }
  -- vim.g.fuzzy_motion_word_regexp_list = [ '[0-9a-zA-Z_-]+', '([0-9a-zA-Z_-]|[.])+', '([0-9a-zA-Z_-]|[().#])+' ]
  -- vim.g.fuzzy_motion_auto_jump = false
  vim.keymap.set('n', '<Leader>j', function()
    if vim.fn['denops#plugin#is_loaded']('fuzzy-motion') == 0 then
      vim.fn['denops#plugin#register']('fuzzy-motion')
    end
    vim.cmd('FuzzyMotion')
  end)
end

---@desc Skkeleton {{{2
if vim.g.loaded_skkeleton then
  ---Keymaps {{{3
  local feedkey = require('module.util').feedkey
  vim.keymap.set({ 'i', 'c', 't' }, '<C-l>', '<Plug>(skkeleton-enable)')
  vim.keymap.set({ 'n' }, '<Space>i', function()
    vim.fn['skkeleton#handle']('enable', {})
    vim.cmd.startinsert()
  end)
  vim.keymap.set({ 'n' }, '<Space>I', function()
    vim.fn['skkeleton#handle']('enable', {})
    feedkey('I', 'n')
  end)
  vim.keymap.set({ 'n' }, '<Space>a', function()
    vim.fn['skkeleton#handle']('enable', {})
    feedkey('a', 'n')
  end)
  vim.keymap.set({ 'n' }, '<Space>A', function()
    vim.fn['skkeleton#handle']('enable', {})
    vim.cmd.startinsert({ bang = true })
  end)

  function Skkeleton_init() -- {{{3
    vim.fn['skkeleton#config']({
      databasePath = '~/.skk/db/jisyo.db',
      globalDictionaries = { '~/.skk/SKK-JISYO.L', '~/.skk/SKK-JISYO.emoji' },
      globalKanaTableFiles = { vim.g.repo .. '/myrepo/nvim/skk/azik_us.rule' },
      eggLikeNewline = true,
      usePopup = true,
      showCandidatesCount = 2,
      markerHenkan = '🐤 ',
      markerHenkanSelect = '🐥 ',
      sources = { 'deno_kv' },
      -- sources = { 'deno_kv', 'skk_dictionary' },
    })
    vim.fn['skkeleton#register_keymap']('input', '@', 'cancel')
    vim.fn['skkeleton#register_keymap']('input', '<Up>', 'disable')
    vim.fn['skkeleton#register_keymap']('input', '<Down>', 'disable')
    vim.fn['skkeleton#register_kanatable']('rom', {
      [':'] = { 'っ', '' },
      ['xq'] = 'hankatakana',
      ['vh'] = { '←', '' },
      ['vj'] = { '↓', '' },
      ['vk'] = { '↑', '' },
      ['vl'] = { '→', '' },
      ['z\x20'] = { '\u{3000}', '' },
      ['z-'] = { '-', '' },
      ['z~'] = { '〜', '' },
      ['z;'] = { ';', '' },
      ['z:'] = { ':', '' },
      ['z,'] = { ',', '' },
      ['z.'] = { '.', '' },
      ['z['] = { '【', '' },
      ['z]'] = { '】', '' },
    })
  end
end
