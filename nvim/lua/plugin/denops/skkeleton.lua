-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------
local helper = require('helper')
local api = vim.api
local keymap = vim.keymap
local augroup = api.nvim_create_augroup('rc_skkeleton', { clear = true })
local skkeleton_init = function() -- {{{2
  vim.fn['skkeleton#config']({
    databasePath = '~/.skk/db/jisyo.db',
    globalDictionaries = { '~/.skk/SKK-JISYO.L.yaml' },
    globalKanaTableFiles = { helper.myrepo_path('nvim/skk/azik_us.rule') },
    eggLikeNewline = true,
    usePopup = true,
    showCandidatesCount = 2,
    markerHenkan = '🐤',
    markerHenkanSelect = '🐥',
    sources = { 'deno_kv' },
    -- sources = { 'deno_kv', 'skk_dictionary' },
  })
  vim.fn['skkeleton#register_keymap']('input', ';', 'henkanPoint')
  vim.fn['skkeleton#register_keymap']('input', '@', 'cancel')
  vim.fn['skkeleton#register_keymap']('henkan', '@', 'cancel')
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
end --}}}

return {
  { -- {{{2 skkeleton_indicator
    'delphinus/skkeleton_indicator.nvim',
    event = 'User skkeleton-initialize-pre',
    opts = {
      alwaysShown = false,
      fadeOutMs = 0,
      hiraText = ' 󱌴',
      kataText = ' 󱌵',
      hankataText = ' 󱌶',
      zenkakuText = ' 󰚞',
      abbrevText = ' 󱌯',
      -- border = { "", "", "", "┃", "", "", "", "┃" }
    },
  }, --}}}
  { -- {{{2 skkeleton
    'vim-skk/skkeleton',
    config = function()
      ---@desc Autocommand
      api.nvim_create_autocmd('User', {
        group = augroup,
        pattern = 'skkeleton-initialize-pre',
        callback = skkeleton_init,
      })
      ---@desc Keymaps {{{3
      keymap.set({ 'i', 'c', 't' }, '<C-l>', '<Plug>(skkeleton-enable)')
      keymap.set({ 'n' }, '<Space>i', function()
        vim.fn['skkeleton#handle']('enable', {})
        vim.cmd.startinsert()
      end)
      keymap.set({ 'n' }, '<Space>I', function()
        vim.fn['skkeleton#handle']('enable', {})
        helper.feedkey('I', 'n')
      end)
      keymap.set({ 'n' }, '<Space>a', function()
        vim.fn['skkeleton#handle']('enable', {})
        helper.feedkey('a', 'n')
      end)
      keymap.set({ 'n' }, '<Space>A', function()
        vim.fn['skkeleton#handle']('enable', {})
        vim.cmd.startinsert({ bang = true })
      end) -- }}}
    end,
  }, -- }}}
}
