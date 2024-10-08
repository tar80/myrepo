-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

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

local mode = vim.g.start_mode

-- ##Pipe {{{2
if not mode then
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
  end
end --}}}2

if mode == 'minimal' then
  require('minimal')
else
  -- transparent background
  vim.g.tr_bg = false
  require('private')
  require('settings')
  require(mode or 'plugins')
end
