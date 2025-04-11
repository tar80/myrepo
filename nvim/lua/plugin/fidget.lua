-- vim:textwidth=0:foldmethod=marker:foldlevel=1
---@diagnostic disable: duplicate-set-field

local MAX_INSPECT_LINES = 500

--- This code was copied from snacks.debug.
---@param ... unknown
---@return string, string
local function inspect(...) -- {{{2
  local len = select('#', ...) ---@type number
  local obj = { ... } ---@type unknown[]
  local caller = debug.getinfo(1, 'S')
  for level = 2, 10 do
    local info = debug.getinfo(level, 'S')
    if
      info
      and info.source ~= caller.source
      and info.what ~= 'C'
      and info.source ~= 'lua'
      and info.source ~= '@' .. (os.getenv('MYVIMRC') or '')
    then
      caller = info
      break
    end
  end
  local dirname = vim.fs.dirname(caller.source):gsub('^.*/', '')
  local basename = vim.fs.basename(caller.source)
  local info = ('%s/%s:%s'):format(dirname, basename, caller.linedefined)
  -- local info = vim.fn.fnamemodify(caller.source:sub(2), ':t') .. ':' .. caller.linedefined
  local lines = vim.split(vim.inspect(len == 1 and obj[1] or len > 0 and obj or nil), '\n')
  if #lines > MAX_INSPECT_LINES then
    local c = #lines
    lines = vim.list_slice(lines, 1, MAX_INSPECT_LINES)
    lines[#lines + 1] = ''
    lines[#lines + 1] = (c - MAX_INSPECT_LINES) .. ' more lines have been truncated...'
  end
  local msg = table.concat(lines, '\n')
  msg = vim.trim(msg)
  return info, msg
end -- }}}2

return {
  'j-hui/fidget.nvim',
  event = 'VeryLazy',
  init = function()
    vim.keymap.set('n', 'ms', '<Cmd>Fidget history<CR>', { desc = 'Fidget history' })
    local _fast_event_wrap = require('tartar.helper').fast_event_wrap
    local fidget = require('fidget')
    local notify = fidget.notification.notify
    vim.print = function(...)
      local info, lines = inspect(...)
      local msg = ('[%s]\n%s'):format(info, lines)
      _fast_event_wrap(notify)(msg, vim.log.levels.INFO, {
        key = 'vim.print',
        group = 'messages',
        annote = 'vim.print',
      })
    end
    print = function(...)
      local msg = tostring(...):gsub('\\n', '\n')
      _fast_event_wrap(notify)(msg, vim.log.levels.INFO, {
        key = 'print',
        group = 'messages',
        annote = 'print',
      })
    end
  end,
  opts = {
    progress = {
      poll_rate = 20,
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
        priority = 300,
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
      override_vim_notify = true,
      configs = {
        default = {
          name = 'Notifications',
          icon = '󰎟',
          icon_on_left = true,
          ttl = 5,
          update_hook = function(item)
            require('fidget').notification.set_content_key(item)
          end,
          group_style = '@text.emphasis',
          icon_style = '@text.emphasis',
          annote_style = '@comment',
          -- debug_style = 'Comment',
          -- info_style = 'ModeMsg',
          -- warn_style = 'WarningMsg',
          -- error_style = 'ErrorMsg',
          -- debug_annote = 'DEBUG',
          -- info_annote = 'INFO',
          -- warn_annote = 'WARN',
          -- error_annote = 'ERROR',
        },
        messages = {
          name = 'Messages',
          icon = '󰋽',
          icon_on_left = true,
          ttl = 3,
          group_style = '@text.emphasis',
          icon_style = '@text.emphasis',
          annote_style = '@comment',
        },
      },
      -- redirect = function(msg, level, opts)
      --   if opts and opts.on_open then
      --     return require('fidget.integration.nvim-notify').delegate(msg, level, opts)
      --   end
      -- end,
      view = {
        stack_upwards = true,
        icon_separator = ' ',
        group_separator = '┄',
        group_separator_hl = 'NonText',
        render_message = function(msg, cnt)
          return cnt == 1 and msg or string.format('(%dx) %s', cnt, msg)
        end,
      },
      window = {
        normal_hl = 'Constant',
        winblend = 0,
        border = require('tartar.icon.ui').border.bot_dash,
        zindex = 45,
        max_width = 200,
        max_height = 0,
        x_padding = 1,
        y_padding = 0,
        align = 'bottom',
        relative = 'editor',
      },
    },
  },
}
