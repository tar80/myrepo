local M = {}
M.has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
M.feedkey = function(key, mode)
  return vim.fn.feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode)
end
-- M.buf_parent_dir = function(path)
--   if vim.bo.buftype ~= "" or path == "" or path:find("://", 1, true) ~= nil then
--     return ""
--   end
--   return vim.fs.normalize(vim.fs.dirname(path))
-- end
-- M.detect_workspace = function(path, patterns)
--   local path_ = path:gsub(" ", "\\ ")
--   local current
--   repeat
--     for _, pattern in ipairs(patterns) do
--       current = path_ .. "/" .. pattern
--       if pattern:find("*", 1, true) ~= nil and vim.fn.glob(current, 1) ~= "" then
--         return path_
--       end
--       if pattern:match("/$") and vim.fn.isdirectory(current) ~= 0 then
--         if pattern == ".git/" then
--           require("module.repository").get_branch_name(path_)
--         end
--         return path_
--       end
--       if vim.fn.filereadable(current) ~= 0 then
--         if pattern == ".gitignore" then
--           require("module.repository").get_branch_name(path_)
--         end
--         return path_
--       end
--     end
--     path_ = path_:match("^(.+)/")
--   until not path_
--   return nil
-- end
--- Credits:This code from https://github.com/tamton-aquib/essentials.nvim
--- vim.ui.input emulation in a float
---@param opts table usual opts like in vim.ui.input()
---@param callback function callback to invoke
M.ui_input = function(opts, callback)
  local buf = vim.api.nvim_create_buf(false, true)

  vim.cmd[[hi! link NormalNC Normal]]
  vim.api.nvim_open_win(buf, true, {
    relative = "cursor",
    style = "minimal",
    border = "single",
    row = 1,
    col = 1,
    width = opts.width or 15,
    height = 1,
  })

  if opts.default then
    vim.api.nvim_put({ opts.default }, "", true, true)
  end

  vim.cmd([[startinsert!]])

  vim.keymap.set("i", "<C-A>", "<HOME>", { buffer = true, silent = true })
  vim.keymap.set("i", "<C-E>", "<END>", { buffer = true, silent = true })
  vim.keymap.set("i", "<CR>", function()
    local content = vim.api.nvim_get_current_line()
    -- if opts.prompt then content = content:gsub(opts.prompt, '') end
    vim.cmd([[bw | stopinsert! | hi link NormalNC NONE]])
    callback(content)
  end, { buffer = true, silent = true })
  vim.keymap.set("i", "<ESC>", "<ESC>:bw! | hi link NormalNC NONE<CR>", { buffer = true, silent = true })
  vim.keymap.set("n", "q", ":bw! | hi link NormalNC NONE<CR>", { buffer = true, silent = true })
  vim.keymap.set("n", "<ESC>", ":bw! | hi link NormalNC NONE<CR>", { buffer = true, silent = true })
end

return M
