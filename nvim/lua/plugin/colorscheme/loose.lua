-- vim:textwidth=0:foldmethod=marker:foldlevel=1:

local light_theme = 'light'
local dark_theme = 'mallow'

---Transparent background
---@type boolean|nil
local tr = vim.g.tr_bg
if tr then
  vim.o.winblend = 0
  light_theme = 'veil'
  dark_theme = 'veil'
end

---@type string, string, string
local global_bg = (function()
  local time = require('helper').adapt_time(7, 18)
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
      theme = { light = light_theme, dark = dark_theme },
      borders = true,
      fade_nc = false,
      fade_tr = false,
      styles = {
        comments = 'italic',
        deprecated = 'NONE',
        diagnostics = 'undercurl',
        functions = 'NONE',
        keywords = 'bold',
        references = 'NONE',
        spell = 'undercurl,italic',
        strings = 'NONE',
        variables = 'NONE',
        virtualtext = 'italic',
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
          MsgArea = { bg = '#FBFBE2' },
          CursorLine = { fg = 'NONE', bg = '#FDE3DD' },
        },
        mallow = {
          MsgArea = { bg = '#102025' },
          CursorLine = { fg = 'NONE', bg = '#3E1D31' },
        },
        veil = {
          CursorLine = { fg = 'NONE', bg = '#ff8da7' },
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
        mini_icons = true,
        noice = true,
        rereope = true,
        render_markdown = true,
        skkeleton_indicator = true,
        sandwich = true,
        snacks = true,
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
