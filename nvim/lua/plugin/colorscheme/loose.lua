-- vim:textwidth=0:foldmethod=marker:foldlevel=1:

local LIGHT_THEME = 'light'
local DARK_THEME = 'mallow'

---Transparent background
---@type boolean|nil
local tr = vim.g.tr_bg
vim.g.tr_bg = nil

---@type string, string, string
local global_bg = (function()
  local time = require('util').adapt_time(7, 18)
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
      fade_nc = false,
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
        eob_lines = true,
        -- cursorline = true,
        statusline = true,
        -- tabline = tr,
        -- tabsel = true,
        tabfill = true,
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
        treesitter = true,
        telescope = 'border_fade',
        cmp = true,
        gitsigns = true,
        flash = true,
        fret = true,
        matchwith = true,
        noice = true,
        rereope = true,
        skkeleton_indicator = true,
        sandwich = true,
        staba = true,
        trouble = true,
        dap = true,
        dap_virtual_text = true,
        -- lspsaga = true,
        -- notify = true
      },
    },
  },
}
