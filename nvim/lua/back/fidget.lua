return {
  'j-hui/fidget.nvim',
  event = 'VeryLazy',
  opts = {
    progress = {
      poll_rate = 0,
      suppress_on_insert = false,
      ignore_done_already = false,
      ignore_empty_message = false,
      clear_on_detach = function(client_id)
        local client = vim.lsp.get_client_by_id(client_id)
        return client and client.name or nil
      end,
      notification_group = function(msg)
        return msg.lsp_client.name
      end,
      ignore = {}, -- List of LSP servers to ignore
      display = {
        render_limit = 7,
        done_ttl = 3,
        done_icon = '󰄬',
        done_style = 'DiagnosticSignOk',
        progress_ttl = math.huge,
        progress_icon = { pattern = 'pipe', period = 1 },
        progress_style = 'WarningMsg',
        group_style = 'Added',
        icon_style = '@variable',
        priority = 30,
        skip_history = true,
        -- format_message = require('fidget.progress.display').default_format_message,
        format_annote = function(msg)
          return msg.title
        end,
        format_group_name = function(group)
          return tostring(group)
        end,
        overrides = {},
      },
      lsp = {
        progress_ringbuf_size = 0,
        log_handler = false,
      },
    },
    notification = {
      poll_rate = 10,
      filter = vim.log.levels.DEBUG,
      history_size = 128,
      override_vim_notify = false,
      redirect = function(msg, level, opts)
        if opts and opts.on_open then
          return require('fidget.integration.nvim-notify').delegate(msg, level, opts)
        end
      end,
      view = {
        stack_upwards = true,
        icon_separator = ' ',
        group_separator = '---',
        group_separator_hl = 'NonText',
        render_message = function(msg, cnt)
          return cnt == 1 and msg or string.format('(%dx) %s', cnt, msg)
        end,
      },
      window = {
        normal_hl = 'NonText',
        winblend = 100,
        border = 'none',
        zindex = 45,
        max_width = 0,
        max_height = 0,
        x_padding = 1,
        y_padding = 0,
        align = 'bottom',
        relative = 'win',
      },
    },
  },
}
