-- vim:textwidth=0:foldmethod=marker:foldlevel=1:

return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    build = ':TSUpdate',
    config = function()
      vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
      vim.keymap.set('n', 'zc', function()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        if vim.wo.foldlevel ~= 99 and vim.fn.foldlevel(row) == 0 then
          vim.wo.foldlevel = 99
          vim.wo.foldmethod = 'expr'
        end
        return 'zc'
      end, { noremap = true, expr = true })
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
              ['ir'] = '@loop.inner',
              ['ar'] = '@loop.outer',
              ['ii'] = '@conditional.inner',
              ['ai'] = '@conditional.outer',
              ['if'] = '@function.inner',
              ['af'] = '@function.outer',
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
              [']r'] = '@loop.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']I'] = '@conditional.outer',
              [']R'] = '@loop.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[i'] = '@conditional.outer',
              ['[r'] = '@loop.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[I'] = '@conditional.outer',
              ['[R'] = '@loop.outer',
            },
          },
        },
      })
    end,
  },
}
