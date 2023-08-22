-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

if not package.loaded["nvim-treesitter"] then
  return
end

-- ##Treesitter
require('nvim-treesitter.configs').setup({
  textobjects = {
    select = {
      enable = true,
      ---Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = {
        ---You can use the capture groups defined in textobjects.scm
        ['ii'] = '@conditional.inner',
        ['ai'] = '@conditional.outer',
        ['if'] = '@function.inner',
        ['af'] = '@function.outer',
        -- ["ib"] = "@parameter.inner",
      },
      ---You can choose the select mode (default is charwise 'v')
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      ---If you set this to `true` (default is `false`) then any textobject is
      ---extended to include preceding xor succeeding whitespace. Succeeding
      ---whitespace has priority in order to act similarly to eg the built-in
      ---`ap`.
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
      },
      goto_next_end = {
        [']M'] = '@function.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
      },
    },
  },
})
