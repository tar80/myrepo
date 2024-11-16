-- vim:textwidth=0:foldmethod=marker:foldlevel=1:

local LIGHT_THEME = 'light'
local DARK_THEME = 'mallow'

---Transparent background
---@type boolean|nil
local tr = vim.g.tr_bg
vim.g.tr_bg = nil

---@type string, string, string
local global_bg = (function()
  local time = require('util').adapt_time(7, 17)
  return time == 'daytime' and 'light' or 'dark'
end)()

return {
  {
    'tar80/loose.nvim',
    dev = true,
    lazy = false,
    priority = 1000,
    opts = {
      enable_usercmd = true,
      background = global_bg,
      theme = { light = LIGHT_THEME, dark = DARK_THEME },
      borders = true,
      fade_nc = true,
      fade_tr = false,
      styles = {
        comments = 'italic',
        strings = 'NONE',
        keywords = 'bold',
        functions = 'NONE',
        variables = 'NONE',
        deprecated = 'NONE',
        diagnostics = 'undercurl',
        references = 'NONE',
        virtualtext = 'italic',
        spell = 'undercurl,italic',
      },
      disable = {
        background = tr,
        cursorline = false,
        eob_lines = true,
        statusline = true,
        tabline = tr,
        tabsel = true,
        tabfille = false,
      },
      custom_highlights = {
        light = {
          CursorLine = { fg = 'NONE', bg = '#FDE3DD' },
        },
        dark = {
          CursorLine = { fg = 'NONE', bg = '#3E1D31' },
        },
      },
      plugins = {
        lazy = true,
        lsp = true,
        lsp_semantic = true,
        lspconfig = true,
        treesitter = true,
        telescope = 'border_fade',
        fuzzy_motion = true,
        cmp = true,
        gitsigns = true,
        fret = true,
        matchwith = true,
        skkeleton_indicator = true,
        sandwich = true,
        trouble = true,
        dap = true,
        dap_virtual_text = true,
        -- lspsaga = true,
        -- notify = true
      },
    },
  },
}
