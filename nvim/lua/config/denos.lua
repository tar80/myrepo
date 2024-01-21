-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

---@desc Initial
vim.g['denops#deno'] = string.format('%s/apps/deno/current/deno.exe', vim.env.scoop)
local augroup = vim.api.nvim_create_augroup('rcDeno', {})

---@desc Autocommand
-- vim.api.nvim_create_autocmd('BufEnter', { -- {{{2
--   group = augroup,
--   pattern = { '*.md', '*.txt' },
--   command = 'call skkeleton#config({"keepState": v:true})',
--   desc = 'skkeleton keep state',
-- }) -- }}}
-- vim.api.nvim_create_autocmd('BufLeave', { -- {{{2
--   group = augroup,
--   pattern = { '*.md', '*.txt' },
--   command = 'call skkeleton#config({"keepState": v:false})',
--   desc = 'skkeleton keep state',
-- }) -- }}}
vim.api.nvim_create_autocmd('User', { -- {{{2
  group = augroup,
  pattern = 'skkeleton-initialize-pre',
  callback = function()
    Skkeleton_init()
  end,
}) -- }}}

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
  ---@desc keymaps {{{3
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
  ---}}}

  function Skkeleton_init()
    vim.fn['skkeleton#config']({ -- {{{3
      databasePath = '~/.skk/denokv/db',
      globalDictionaries = { '~/.skk/SKK-JISYO.L' },
      globalKanaTableFiles = { vim.g.repo .. '/myrepo/nvim/skk/azik_us.rule' },
      eggLikeNewline = true,
      usePopup = true,
      showCandidatesCount = 1,
      markerHenkan = '🐤',
      markerHenkanSelect = '🐥',
      sources = {'deno_kv'}
    }) -- }}}

    -- vim.fn['skkeleton#register_keymap']('input', ';', 'henkanPoint')
    vim.fn['skkeleton#register_keymap']('input', '@', 'cancel')
    vim.fn['skkeleton#register_keymap']('input', '<Up>', 'disable')
    vim.fn['skkeleton#register_keymap']('input', '<Down>', 'disable')
    vim.fn['skkeleton#register_kanatable']('rom', { -- {{{3
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
    }) -- }}}
  end
end
