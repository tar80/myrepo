return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    build = ':TSUpdate',
    config = function()
      vim.g._ts_force_sync_parsing = true
      require('nvim-treesitter.configs').setup({
        -- ensure_installed = {'lua', 'typescript', 'javascript', 'markdown'},
        sync_install = false,
        ignore_install = { 'text', 'help' },
        highlight = {
          enable = true,
          disable = function(_lang, buf)
            local max_filesize = 100 * 1024
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
          additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<Nop>',
            -- scope_incremental = '<CR>',
            node_incremental = '<C-j>',
            node_decremental = '<C-k>',
          },
        },
        textobjects = {
          select = {
            enable = true,
            ---Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
              ['il'] = '@loop.inner',
              ['al'] = '@loop.outer',
              ['ii'] = '@conditional.inner',
              ['ai'] = '@conditional.outer',
              ['im'] = '@function.inner',
              ['am'] = '@function.outer',
              -- ["ib"] = "@parameter.inner",
            },
            selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@loop.outer'] = 'V', -- linewise
              ['@conditional.outer'] = 'V', -- linewise
              ['@function.outer'] = 'V', -- linewise
              -- ['@class.outer'] = '<c-v>', -- blockwise
            },
            include_surrounding_whitespace = false,
          },
          swap = {
            enable = true,
            swap_next = {
              ['<C-k>'] = '@parameter.inner',
            },
            swap_previous = {
              ['<C-j>'] = '@parameter.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
              [']i'] = '@conditional.outer',
              [']l'] = '@loop.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']I'] = '@conditional.outer',
              [']L'] = '@loop.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[i'] = '@conditional.outer',
              ['[l'] = '@loop.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[I'] = '@conditional.outer',
              ['[L'] = '@loop.outer',
            },
          },
        },
      })
    end,
  },
}
