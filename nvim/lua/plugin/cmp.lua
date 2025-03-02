-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

return {
  'hrsh7th/nvim-cmp',
  event = { 'CursorMoved', 'InsertEnter', 'CmdlineEnter' },
  dependencies = { -- {{{
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/vim-vsnip',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'dmitmel/cmp-cmdline-history',
    { 'uga-rosa/cmp-dictionary', opts = { first_case_insensitive = true } },
  }, -- }}}
  config = function()
    local cmp = require('cmp')
    local icon = require('icon').cmp
    local border = require('icon').border
    local helper = require('helper')
    local feedkey = helper.feedkey

    ---@desc Vsnip
    vim.g.vsnip_snippet_dir = helper.myrepo_path('nvim/.vsnip')

    ---@desc kinds{{{
    local kind = {
      vsnip = { icon = icon.vsnip, alias = 'V-snip' },
      dictionary = { icon = icon.dictionary, alias = 'Dictionary' },
      nvim_lsp = { icon = nil, alias = 'Lsp' },
      nvim_lua = { icon = icon.nvim_lua, alias = nil },
      nvim_lsp_signature_help = { icon = icon.nvim_lsp_signature_help, alias = nil },
      buffer = { icon = icon.buffer, alias = 'Buffer' },
      path = { icon = icon.path, alias = nil },
      cmdline = { icon = icon.cmdline, alias = nil },
    }
    local display_kind = function(entry, item)
      local v = kind[entry.source.name]
      if v then
        if v.alias == 'Lsp' then
          v.icon = icon[item.kind]
        end
        item.kind = v.icon
        -- item.kind = string.format('%s%s', v.icon, v.alias or item.kind)
      end
      return item
    end
    local no_display_kind = function(_, item)
      item.kind = ''
      return item
    end -- }}}
    cmp.setup({ -- {{{
      enabled = function()
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
      performance = { debounce = 30, throttle = 30 },
      -- experimental = { ghost_text = { hl_group = 'CmpGhostText' } },
      window = {
        completion = { scrolloff = 1, side_padding = 1 },
        documentation = { border = border.quotation },
      },
      snippet = { -- {{{
        expand = function(args)
          vim.fn['vsnip#anonymous'](args.body)
        end,
      }, -- }}}
      sources = cmp.config.sources({ -- {{{
        { name = 'vsnip' },
        { name = 'nvim_lsp', max_item_count = 20 },
        { name = 'nvim_lsp_signature_help' },
        { name = 'dictionary', keyword_length = 2 },
        {
          name = 'buffer',
          max_item_count = 50,
          option = {
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end,
          },
        },
        { name = 'path', keyword_length = 2 },
        { name = 'nvim_lua', keyword_length = 2 },
      }), -- }}}
      formatting = { -- {{{
        -- fields = {'menu','abbr','kind'},
        format = function(entry, item)
          return display_kind(entry, item)
        end,
      }, -- }}}
      mapping = { -- {{{
        ['<C-p>'] = cmp.mapping(function()
          return cmp.visible() and cmp.select_prev_item() or cmp.complete()
        end, { 'i', 'c' }),
        ['<C-n>'] = cmp.mapping(function()
          return cmp.visible() and cmp.select_next_item() or cmp.complete()
        end, { 'i', 'c' }),
        ['<C-e>'] = cmp.mapping(function(_)
          return cmp.visible() and cmp.abort() or feedkey('<Home>', '')
        end, { 'i' }),
        ['<C-y>'] = cmp.mapping(function(_)
          return cmp.visible() and cmp.close() or feedkey('<End>', '')
        end, { 'i' }),
        ['<Down>'] = cmp.mapping.scroll_docs(4),
        ['<Up>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping(function(fallback)
          return cmp.visible() and cmp.mapping.scroll_docs(4) or fallback()
        end, { 'i', 'c' }),
        ['<C-u>'] = cmp.mapping(function(fallback)
          return cmp.visible() and cmp.mapping.scroll_docs(-4) or fallback()
        end, { 'i', 'c' }),
        ['<CR>'] = function(fallback)
          if cmp.visible() and (cmp.get_selected_entry() ~= nil) then
            return cmp.confirm({ select = false })
          end
          fallback()
        end,
        -- ['<Tab>'] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_next_item()
        --   else
        --     fallback()
        --   end
        -- end, { 'i', 's' }),
        -- ['<S-Tab>'] = cmp.mapping(function()
        --   if cmp.visible() then
        --     cmp.select_prev_item()
        --   end
        -- end, { 'i', 's' }),
        ['<C-j>'] = cmp.mapping(function(fallback)
          if vim.fn['vsnip#available']() == 1 then
            if vim.api.nvim_get_mode().mode == 's' then
              feedkey('<Plug>(vsnip-jump-next)', '')
            else
              feedkey('<Plug>(vsnip-expand-or-jump)', '')
            end
          elseif cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<C-k>'] = cmp.mapping(function(fallback)
          if vim.fn['vsnip#jumpable'](-1) == 1 then
            feedkey('<Plug>(vsnip-jump-prev)', '')
          elseif vim.fn['vsnip#available']() == 1 then
            feedkey('<Plug>(vsnip-expand-or-jump)', '')
            -- elseif cmp.visible() then
            --   cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<C-a>'] = cmp.mapping(function()
          feedkey('<Esc>a', '')
        end, { 's' }),
      }, -- }}}
    }) -- }}}
    cmp.setup.cmdline('/', { -- {{{
      -- window = {
      --   completion = cmp.config.window.bordered(),
      -- },
      completion = { keyword_length = 1 },
      sources = cmp.config.sources({
        { name = 'buffer' },
      }),
      formatting = {
        format = function(entry, item)
          return no_display_kind(entry, item)
        end,
      },
      mapping = cmp.mapping.preset.cmdline(),
    }) -- }}}
    cmp.setup.cmdline(':', { -- {{{
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
          return no_display_kind(entry, item)
        end,
      },
      mapping = cmp.mapping.preset.cmdline(),
    }) -- }}}
    require('cmp_dictionary').setup({ -- {{{
      paths = {
        vim.g.repo .. '/myrepo/nvim/after/dict/javascript.dict',
        vim.g.repo .. '/myrepo/nvim/after/dict/lua.dict',
        vim.g.repo .. '/myrepo/nvim/after/dict/PPxcfg.dict',
      },
      exact_length = 2,
      first_case_insensitive = true,
    }) -- }}}
  end,
}
