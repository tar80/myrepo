-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

---#Valiables
vim.g.vsnip_snippet_dir = vim.g.repo .. '\\myrepo\\nvim\\.vsnip'

---#Setup
local cmp = require('cmp')
local feed_key = require('module.util').feedkey
local kind = { -- {{{2
  vsnip = { icon = '', alias = 'V-snip' },
  dictionary = { icon = '', alias = 'Dictionary' },
  nvim_lsp = { icon = '', alias = nil },
  nvim_lua = { icon = '', alias = nil },
  nvim_lsp_signature_help = { icon = '', alias = nil },
  buffer = { icon = '', alias = 'Buffer' },
  path = { icon = '', alias = nil },
  cmdline = { icon = '', alias = nil },
} -- }}}
local display_kind = function(entry, item)
  local v = kind[entry.source.name]
  item.kind = string.format('%s%s', v.icon, v.alias or item.kind)
  return item
end
local undisplay_kind = function(_, item)
  item.kind = ''
  return item
end

---#Insert-mode {{{2
cmp.setup({
  enabled = function()
    -- local context = require("cmp.config.context")
    if vim.api.nvim_get_mode().mode == 'c' then
      return true
    end
    if vim.bo.filetype == 'TelescopePrompt' then
      return false
    end
    if vim.g['skkeleton#enabled'] then
      return false
    end
    return true
  end,
  -- completion = { keyword_length = 2 },
  performance = { debounce = 10, throttle = 50 },
  --matching = {disallow_prefix_unmatching = false},
  -- experimental = { ghost_text = { hl_group = 'CmpGhostText' } },
  window = {
    completion = { scrolloff = 1 },
    -- completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = 'vsnip' },
    { name = 'nvim_lsp', keyword_length = 2, max_item_count = 10 },
    { name = 'nvim_lsp_signature_help' },
    { name = 'dictionary', keyword_length = 2 },
    {
      name = 'buffer',
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end,
      },
    },
    { name = 'path', keyword_length = 2 },
    { name = 'nvim_lua', keyword_length = 2 },
  }),
  formatting = {
    format = function(entry, item)
      return display_kind(entry, item)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping(function()
      return cmp.visible() and cmp.select_prev_item() or cmp.complete()
    end, { 'i', 'c' }),
    ['<C-n>'] = cmp.mapping(function()
      return cmp.visible() and cmp.select_next_item() or cmp.complete()
    end, { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping(function(fallback)
      return cmp.visible() and cmp.abort() or fallback()
    end, { 'i' }),
    ['<C-y>'] = cmp.mapping(function(fallback)
      return cmp.visible() and cmp.close() or fallback()
    end, { 'i' }),
    ['<Down>'] = cmp.mapping.scroll_docs(4),
    ['<Up>'] = cmp.mapping.scroll_docs(-4),
    ['<CR>'] = function(fallback)
      if cmp.visible() and (cmp.get_selected_entry() ~= nil) then
        return cmp.confirm({ select = false })
      end
      fallback()
    end,
    ['<Tab>'] = cmp.mapping(function(fallback)
      -- if vim.fn['vsnip#available'](1) == 1 then
      --   feed_key('<Plug>(vsnip-expand-or-jump)', '')
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function()
      -- if vim.fn['vsnip#jumpable'](-1) == 1 then
      --   feed_key('<Plug>(vsnip-jump-prev)', '')
      if cmp.visible() then
        cmp.select_prev_item()
      end
    end, { 'i', 's' }),
    ['<C-j>'] = cmp.mapping(function(fallback)
      if vim.fn['vsnip#available']() == 1 then
        if vim.api.nvim_get_mode().mode == 's' then
          feed_key('<Plug>(vsnip-jump-next)', '')
        else
          feed_key('<Plug>(vsnip-expand-or-jump)', '')
        end
      elseif cmp.visible() then
        cmp.select_next_item({ behavior = true })
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-k>'] = cmp.mapping(function(fallback)
      if vim.fn['vsnip#jumpable'](-1) == 1 then
        feed_key('<Plug>(vsnip-jump-prev)', '')
      elseif vim.fn['vsnip#available']() == 1 then
        feed_key('<Plug>(vsnip-expand-or-jump)', '')
      -- elseif cmp.visible() then
      --   cmp.select_prev_item({ behavior = true })
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-a>'] = cmp.mapping(function()
      feed_key('<Esc>a', '')
    end, { 's' }),
  },
})
--}}}2
-- #Search-mode {{{2
cmp.setup.cmdline('/', {
  completion = { keyword_length = 1 },
  sources = cmp.config.sources({
    { name = 'buffer' },
  }),
  formatting = {
    format = function(entry, item)
      return undisplay_kind(entry, item)
    end,
  },
  mapping = cmp.mapping.preset.cmdline(),
})
--}}}2
-- #Command-mode {{{2
cmp.setup.cmdline(':', {
  window = {
    completion = { scrolloff = 1 },
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  completion = { keyword_length = 2 },
  sources = cmp.config.sources(
    { { name = 'path', max_item_count = 20 } },
    { { name = 'cmdline', max_item_count = 20 } },
    { { name = 'cmdline_history', max_item_count = 20 } }
  ),
  formatting = {
    format = function(entry, item)
      return undisplay_kind(entry, item)
    end,
  },
  mapping = cmp.mapping.preset.cmdline(),
})
--}}}2
-- #cmp-dictionary {{{2
require('cmp_dictionary').setup({
  paths = {
    vim.g.repo .. '\\myrepo\\nvim\\after\\dict\\javascript.dict',
    vim.g.repo .. '\\myrepo\\nvim\\after\\dict\\lua.dict',
    vim.g.repo .. '\\myrepo\\nvim\\after\\dict\\PPxcfg.dict',
  },
  exact_length = 2,
  first_case_insensitive = true,
})
