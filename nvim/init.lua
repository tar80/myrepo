-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

vim.api.nvim_set_option("encoding", "utf-8")
vim.scriptencoding = "utf-8"

-- #Echo message vim startup time {{{2
if vim.fn.has("vim_starting") then
  local pre = vim.fn.reltime()
  vim.api.nvim_create_augroup("Startup", {})
  vim.api.nvim_create_autocmd("UIEnter", {
    group = "Startup",
    once = true,
    callback = function()
      local post = vim.fn.reltime(pre)
      print("StartupTime:" .. vim.fn.reltimestr(post))
      vim.api.nvim_del_augroup_by_name("Startup")
    end,
  })
end --}}}

-- #Requires
require("settings")
require("plugins")
