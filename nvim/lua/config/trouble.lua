-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

require('trouble').setup({
  auto_close = false,
  auto_open = false,
  auto_preview = false,
  auto_refresh = false,
  auto_jump = false,
  focus = true,
  restore = false,
  follow = true,
  indent_guides = true,
  max_items = 50,
  multiline = true,
  pinned = false,
  warn_no_results = true,
  open_no_results = false,
  throttle = {
    refresh = 200, -- fetches new data when needed
    update = 100, -- updates the window
    render = 100, -- renders the window
    follow = 100, -- follows the current item
    preview = { ms = 100, debounce = true }, -- shows the preview for the current item
  },
  keys = { -- {{{2
    ['g?'] = 'help',
    ['<Tab>'] = 'cancel',
    ['<C-l>'] = 'refresh',
    ['<cr>'] = 'jump_close',
    ['j'] = 'next',
    ['k'] = 'prev',
    -- ['h'] = 'fold_close',
    -- ['l'] = 'fold_open',
    ['o'] = 'jump',
    ['<2-leftmouse>'] = 'jump',
  },
  modes = { -- {{{2
    lsp_definitions = {
      mode = 'lsp_definitions',
      auto_preview = true,
      auto_close = true,
      win = {
        --   type = 'float',
        --   border = 'rounded',
        --   title = 'Lsp definitions',
        --   title_pos = 'center',
        --   size = { width = 0.6, height = 0.5 },
        --   zindex = 200,
        size = 0.2,
      },
      preview = {
        type = 'split',
        relative = 'win',
        position = 'right',
        size = 0.7,
      },
    },
    diagnostics_buffer = {
      auto_close = true,
      auto_refresh = true,
      auto_preview = true,
      focus = false,
      mode = 'diagnostics',
      filter = { buf = 0 },
    },
  },
})
