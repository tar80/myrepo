-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

-- vim.api.nvim_set_option_value('encoding', 'utf-8', {})
-- vim.scriptencoding = 'utf-8'

-- ##Echo message vim startup time {{{2
if vim.fn.has('vim_starting') then
  local pre = vim.fn.reltime()
  local augroup = vim.api.nvim_create_augroup('rcInit', {})
  vim.api.nvim_create_autocmd('UIEnter', {
    group = augroup,
    once = true,
    callback = function()
      local post = vim.fn.reltime(pre)
      print('StartupTime:' .. vim.fn.reltimestr(post))
      vim.api.nvim_del_augroup_by_id(augroup)
    end,
  })
end

-- ##Pipe {{{2
local pipe = [[\\.\pipe\nvim.100.0]]
local server = vim.v.servername

if server then
  if server ~= pipe then
    local ok = pcall(vim.fn.serverstart, pipe)
    if ok then
      pcall(vim.fn.serverstop, server)
    end
  end
else
  pcall(vim.fn.serverstart, pipe)
end --}}}2

-- #Requires
local minimal = false

if minimal then
  require('minimal')
else
  require('private')
  require('settings')
  require('plugins')
end
