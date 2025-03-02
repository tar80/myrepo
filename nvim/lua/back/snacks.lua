local icon = require('icon')

return {
  'folke/snacks.nvim',
  priority = 1000,
  event = 'VeryLazy',
  opts = {
    styles = {
      notification = {
        border = 'rounded',
        zindex = 100,
        ft = 'markdown',
        wo = {
          winblend = 5,
          wrap = false,
          conceallevel = 2,
          colorcolumn = '',
          fillchars = 'eob: ',
          listchars = 'extends: ,tab:  ,eol: ',
        },
        bo = { filetype = 'snacks_notif' },
      },
    },
    bigfile = { enabled = false },
    dashboard = { enabled = true },
    debug = { enabled = true },
    notifier = { enabled = false },
    statuscolumn = { enabled = true },
    terminal = { enabled = false },
    words = { enabled = false },
  },
}
