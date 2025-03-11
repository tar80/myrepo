local icon = require('icon')

return {
  'j-hui/fidget.nvim',
  event = 'VeryLazy',
  opts = {
    progress = {
      poll_rate = 100,
      suppress_on_insert = false,
      ignore_done_already = true,
      ignore_empty_message = false,
      clear_on_detach = function(client_id)
        local client = vim.lsp.get_client_by_id(client_id)
        return client and client.name or nil
      end,
      notification_group = function(msg)
        return msg.lsp_client.name
      end,
      ignore = {
        function(msg)
          if
            msg.title:find('iagnos', 2, true)
            or msg.title:find('semantic', 2, true)
            or msg.title:find('completion', 2, true)
          then
            return true
          end
        end,
      },
      display = {
        render_limit = 5,
        done_ttl = 1,
        done_icon = '󰄬',
        done_style = 'DiagnosticOk',
        progress_ttl = math.huge,
        progress_icon = { pattern = 'pipe', period = 1 },
        progress_style = 'Error',
        group_style = 'DiagnosticInfo',
        icon_style = 'DiagnosticSignInfo',
        priority = 30,
        skip_history = false,
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
      poll_rate = 100,
      filter = vim.log.levels.DEBUG,
      history_size = 128,
      override_vim_notify = false,
      -- configs = {
      --   default = {
      --     name = 'Notifications',
      --     icon = icon.symbol.star,
      --     ttl = 5,
      --     group_style = 'WarningMsg',
      --     icon_style = 'WarningMsg',
      --     annote_style = 'IncSearch',
      --     debug_style = 'Comment',
      --     info_style = 'Question',
      --     warn_style = 'WarningMsg',
      --     error_style = 'ErrorMsg',
      --     debug_annote = 'DEBUG',
      --     info_annote = 'INFO',
      --     warn_annote = 'WARN',
      --     error_annote = 'ERROR',
      --   },
      -- },
      redirect = function(msg, level, opts)
        if opts and opts.on_open then
          return require('fidget.integration.nvim-notify').delegate(msg, level, opts)
        end
      end,
      view = {
        stack_upwards = false,
        icon_separator = ' ',
        group_separator = '---',
        group_separator_hl = 'NonText',
        render_message = function(msg, cnt)
          return cnt == 1 and msg or string.format('(%dx) %s', cnt, msg)
        end,
      },
      window = {
        normal_hl = 'Normal',
        winblend = 100,
        border = icon.border.bot_dash,
        zindex = 45,
        max_width = 0,
        max_height = 0,
        x_padding = 1,
        y_padding = 0,
        align = 'top',
        relative = 'editor',
      },
    },
  },
}
