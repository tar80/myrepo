-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

-- ##Treesitter
require('nvim-treesitter.configs').setup({
  -- ensure_installed = {"lua", "javascript", "markdown"},
  sync_install = false,
  auto_install = false,
  ignore_install = { 'text', 'help' },
  highlight = {
    enable = true,
    disable = { 'help', 'text' },
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<Space><CR>',
      node_incremental = '<C-J>',
      node_decremental = '<C-K>',
      scope_incremental = '<Space><CR>',
    },
  },
})
