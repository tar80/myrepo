local util = require('util')

---@desc Disable preset plugins
vim.g.editorconfig = false
vim.g.loaded_man = true

---@desc Environments
vim.g.repo = 'c:/bin/repository/tar80'
vim.env.myvimrc = vim.uv.fs_readlink(vim.env.myvimrc)

vim.g.update_time = 700
vim.cmd('language message C')

---@desc Configuration file level
---There are three modes: "general", "minimal" and "extended"
local level = vim.g.start_level
vim.g.start_level = nil

if level == 'minimal' then
  util.unload_presets()
  require('config._minimal')
elseif level == 'test' then
  util.shell('nyagos')
  -- require('config.private')
  -- require('config.option')
  -- require('config.keymap')
  -- require('config.command')
  require('config.lazy_test').setup()
else
  vim.g.tr_bg = level == 'general'

  util.set_client_server(100, level)
  util.shell('nyagos')

  require('config.private')
  require('config.option')
  require('config.keymap')
  require('config.command')
  require('config.lazy').setup(level)
end
