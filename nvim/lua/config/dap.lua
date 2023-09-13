-- vim:textwidth=0:foldmethod=marker:foldlevel=1
--------------------------------------------------------------------------------

local dap = require('dap')
local dapui = require('dapui')

local dap_internal = 0
local jest_path = 'C:/bin/repository/ppmdev/node_modules/jest/bin/jest.js'
local data_path = vim.fn.stdpath('data')
local keymap = vim.keymap
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

---@desc autocmd
local augroup = vim.api.nvim_create_augroup('rcDap', {})
vim.api.nvim_create_autocmd('User', { -- {{{2
  group = augroup,
  pattern = 'DapTerminated',
  once = true,
  callback = function()
    vim.cmd[[DapClose]]
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
  },
  options = {
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
      runtimeArgs = { jest_path, '--runInBand' },
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

---@desc ui
dapui.setup({ -- {{{2
  icons = { expanded = '', collapsed = '' },
  layouts = {
    {
      elements = {
        { id = 'stacks', size = 0.20 },
        { id = 'watches', size = 0.20 },
        { id = 'scopes', size = 0.40 },
        { id = 'breakpoints', size = 0.20 },
      },
      size = 0.30,
      position = 'left',
    },
    {
      elements = {
        { id = 'repl', size = 0.5 },
        { id = 'console', size = 0.5 },
      },
      size = 0.20,
      position = 'bottom',
    },
    floating = {
      max_height = nil,
      max_width = nil,
      border = 'single',
      mappings = {
        close = { 'q', '<Esc>' },
      },
    },
  },
}) -- }}}

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
  -- dapui.open({})
end -- }}}
dap.listeners.before.event_terminated['dapui_config'] = function() -- {{{2
  -- dapui.close({})
  dap.clear_breakpoints()
  dap.disconnect()
  vim.cmd.doautocmd('<nomodeline> User DapTerminated')
end -- }}}
dap.listeners.before.event_exited['dapui_config'] = function() -- {{{2
  -- dapui.close({})
  vim.notify('event_exited', 3)
end -- }}}

---@cmd {{2
vim.api.nvim_create_user_command('DapUiToggle', function()-- {{{2
  require('dapui').toggle()
end, {})-- }}}

vim.api.nvim_create_user_command('DapOpen', function()-- {{{2
  dap_internal = 1
  keymap.set('n', '<leader>d', function()
    dap.continue()
  end)
  keymap.set('n', '<Leader>b', function()
    dap.toggle_breakpoint()
  end)
  keymap.set('n', '<Leader>B', function()
    dap.clear_breakpoints()
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
end, {})-- }}}

vim.api.nvim_create_user_command('DapClose', function()-- {{{2
  dap_internal = 0
  keymap.del('n', '<leader>b')
  keymap.del('n', '<leader>B')
  keymap.del('n', '<leader>d')
  keymap.del('n', '<F8>')
  keymap.del('n', '<F9>')
  keymap.del('n', '<F10>')
end, {})-- }}}

---@keymaps {{2
keymap.set('n', '<F5>', function()
  if dap_internal == 0 then
    vim.cmd([[DapOpen]])
  else
    vim.cmd([[DapClose]])
  end
end)

vim.cmd([[DapOpen]])
