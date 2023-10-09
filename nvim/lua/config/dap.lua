-- vim:textwidth=0:foldmethod=marker:foldlevel=1
--------------------------------------------------------------------------------

local dap = require('dap')

local jest_path = 'C:/bin/repository/ppmdev/node_modules/jest/bin/jest.js'
local data_path = vim.fn.stdpath('data')
local keymap = vim.keymap
local internal = {-- {{{2
  enable = false,
  termnr = 0,
  termwin = 0,
  toggle_term = function(self)
    if self.termwin == 0 then
      return
    end

    local is_active = false

    for _, id in ipairs(vim.api.nvim_list_wins()) do
      if id == self.termwin then
        is_active = true
        break
      end
    end

    if is_active then
      vim.api.nvim_win_close(self.termwin, {})
      -- vim.cmd.quit({ count = self.termnr })
    else
      local winid = vim.api.nvim_get_current_win()
      vim.cmd(string.format('vertical belowright sbuffer %s|vert resize 60', self.termnr))
      self.termnr = vim.api.nvim_get_current_buf()
      self.termwin = vim.api.nvim_get_current_win()
      vim.api.nvim_set_current_win(winid)
    end
  end,
  close_term = function(self)
    if self.termwin ~= 0 then
      vim.api.nvim_buf_delete(self.termnr, { force = true })
      self.termnr = 0
      self.termwin = 0
    end
  end,
}-- }}}

---@desc dap signs
local signs = { -- {{{2
  Breakpoint = '',
  BreakpointCondition = '',
  BreakpointRejected = '',
  Stopped = '▶️',
}

for type, icon in pairs(signs) do
  local name = 'Dap' .. type
  vim.fn.sign_define(name, { text = icon, texthl = name, linehl = 'NONE', numhl = 'NONE' })
end -- }}}

---@desc defaults
-- dap.defaults.fallback.stepping_granularity = 'statement'
dap.defaults.fallback.terminal_win_cmd = function()-- {{{2
  local winid = vim.api.nvim_get_current_win()
  vim.cmd('belowright 60vsplit new')
  internal.termnr = vim.api.nvim_get_current_buf()
  internal.termwin = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(winid)
  return internal.termnr, internal.termwin
end-- }}}

---@desc autocmd
local augroup = vim.api.nvim_create_augroup('rcDap', {})
vim.api.nvim_create_autocmd('FileType', { -- {{{2
  group = augroup,
  pattern = 'dap-repl',
  callback = function()
    require('dap.ext.autocompl').attach()
  end,
}) -- }}}
vim.api.nvim_create_autocmd('User', { -- {{{2
  group = augroup,
  pattern = 'DapTerminated',
  once = true,
  callback = function()
    dap.clear_breakpoints()
    dap.disconnect()
    dap.repl.close()
    internal:close_term()
    vim.cmd.DapDetach()
  end,
}) -- }}}

---@desc js-debug
require('dap-vscode-js').setup({ -- {{{2
  debugger_path = data_path .. '/mason/packages/js-debug-adapter',
  debugger_cmd = { 'js-debug-adapter' },
  adapters = { 'pwa-node', 'node-terminal', 'pwa-extensionHost' },
}) -- }}}
dap.adapters['pwa-node'] = { -- {{{2
  type = 'server',
  host = 'localhost',
  port = '${port}',
  executable = {
    command = 'node',
    args = { data_path .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js', '${port}' },
    detached = true,
  },
} -- }}}

---@desc configurations
for _, language in ipairs({ 'typescript', 'javascript' }) do -- {{{2
  dap.configurations[language] = {
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Launch',
      program = '${file}',
      cwd = '${workspaceFolder}',
      console = 'integratedTerminal',
      internalConsoleOptions = 'neverOpen',
    },
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Jest',
      -- trace = true, -- include debugger info
      runtimeExecutable = 'node',
      runtimeArgs = { jest_path, '--runInBand', '--testMatch', '**/${fileBasenameNoExtension}.test.${fileExtname}' },
      rootPath = '${workspaceFolder}',
      cwd = '${workspaceFolder}',
      console = 'integratedTerminal',
      internalConsoleOptions = 'neverOpen',
    },
    {
      type = 'pwa-node',
      request = 'attach',
      name = '_Attach',
      processId = require('dap.utils').pick_process,
      cwd = '${workspaceFolder}',
    },
  }
end -- }}}

---@desc nvim-dap-virtual-text
require('nvim-dap-virtual-text').setup({ -- {{{2
  enabled = true,
  enabled_commands = false,
  highlight_changed_variables = true,
  highlight_new_as_changed = false,
  show_stop_reason = true,
  commented = false,
  only_first_definition = true,
  all_references = false,
  clear_on_continue = false,
  display_callback = function(variable, buf, stackframe, node, options)
    if options.virt_text_pos == 'inline' then
      return ' = ' .. variable.value
    else
      return variable.name .. ' = ' .. variable.value
    end
  end,

  virt_text_pos = 'inline',

  -- experimental features:
  all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
  virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
  virt_lines_above = true,
  virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
}) -- }}}

---@desc event
dap.listeners.after.event_initialized['dapui_config'] = function() -- {{{2
  vim.notify('[Dap] session start', 3)
  dap.repl.open({ height = 5 })
end -- }}}
dap.listeners.before.event_terminated['dapui_config'] = function() -- {{{2
  vim.cmd.doautocmd('<nomodeline> User DapTerminated')
  vim.notify('[Dap] session end', 3)
end -- }}}
dap.listeners.before.event_exited['dapui_config'] = function() -- {{{2
  vim.notify('[Dap] listeners event_exited', 4)
end -- }}}

---@cmd
vim.api.nvim_create_user_command('DapAttach', function() -- {{{2
  internal.enable = true
  keymap.set('n', '<leader>d', function()
    dap.continue()
  end)
  keymap.set('n', '<Leader>b', function()
    dap.toggle_breakpoint()
  end)
  keymap.set('n', '<Leader>B', function()
    dap.clear_breakpoints()
  end)
  keymap.set('n', '<Leader>t', function()
    internal:toggle_term()
  end)
  keymap.set('n', '<F8>', function()
    dap.step_over()
  end)
  keymap.set('n', '<F9>', function()
    dap.step_into()
  end)
  keymap.set('n', '<F10>', function()
    dap.step_out()
  end)
end, {}) -- }}}
vim.api.nvim_create_user_command('DapDetach', function() -- {{{2
  internal.enable = false
  keymap.del('n', '<leader>b')
  keymap.del('n', '<leader>B')
  keymap.del('n', '<leader>d')
  keymap.del('n', '<leader>t')
  keymap.del('n', '<F8>')
  keymap.del('n', '<F9>')
  keymap.del('n', '<F10>')
end, {}) -- }}}

---@keymaps
keymap.set('n', '<F5>', function()-- {{{2
  local msg
  if not internal.enable then
    vim.cmd.DapAttach()
    msg = '[Dap] attach'
  else
    vim.cmd.doautocmd('<nomodeline> User DapTerminated')
    msg = '[Dap] detach'
  end

  vim.notify(msg, 2)
end)-- }}}

vim.cmd.DapAttach()
