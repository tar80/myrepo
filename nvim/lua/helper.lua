--- vim:textwidth=0:foldmethod=marker:foldlevel=1:
-------------------------------------------------------------------------------
local api = vim.api
local fn = vim.fn

local M = {}

---Get the character at the cursor position
---@return string
M.getchr = function()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local charidx = vim.str_utfindex(line, 'utf-8', col)
  return fn.strcharpart(line, charidx, 1)
end

---Check if the character before the cursor position is an alphanumeric character
---@return boolean
M.has_words_before = function()
  local row, col = unpack(api.nvim_win_get_cursor(0))
  return col ~= 0 and api.nvim_buf_get_lines(0, row - 1, row, true)[1]:sub(col, col):match('%w') ~= nil
end

---Returns the escaped key
---@param key string
---@param mode string
---@return string
-- M.get_feedkey = function(key, mode)
--   return fn.feedkeys(api.nvim_replace_termcodes(key, true, true, true), mode)
-- end

---Feeds the specified key
---@param key string
---@param mode string
M.feedkey = function(key, mode)
  api.nvim_feedkeys(api.nvim_replace_termcodes(key, true, false, true), mode, false)
end

---@param bufnr integer
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts vim.api.keyset.keymap
M.buf_setmap = function(bufnr, mode, lhs, rhs, opts)
  if type(mode) == 'string' then
    mode = { mode }
  end
  for _, v in ipairs(mode) do
    if type(rhs) == 'function' then
      opts.callback = rhs
      rhs = 'callback'
    end
    api.nvim_buf_set_keymap(bufnr, v, lhs, rhs, opts)
  end
end

---Replaces "<" in the string with "<lt>"
---@param v string
M.replace_lt = function(v)
  return v:gsub('<([%a-]+>)', '<lt>%1')
end

---Normalize specified path
---@param path string
---@return string
M.normalize = function(path)
  path = ('%s%s'):format(path:sub(1, 1):upper(), path:sub(2))
  return vim.fs.normalize(path)
end

---Get project root path
---@param path string
---@param markers string[]
M.get_project_root = function(path, markers)
  return vim.fs.root(path, markers) or vim.uv.cwd()
end

---Get the executable file path under scoop management
---@param path string
---@return string
M.scoop_apps = function(path)
  return ('%s/%s'):format(os.getenv('SCOOP'), path)
end

---Get the executable file path under mason management
---@param path string
---@return string
M.mason_apps = function(path)
  return ('%s/mason/packages/%s'):format(fn.stdpath('data'), path)
end

---Get an XDG-relative path
---@param xdg string
---@param path string
M.xdg_path = function(xdg, path)
  return ('%s/%s'):format(vim.fn.stdpath(xdg), path)
end

M.myrepo_path = function(path)
  return ('%s/myrepo/%s'):format(vim.g.repo, path)
end

---Check the existence of the executable file
---@param cmd string[]
---@return boolean
M.executable = function(cmd)
  local ok, job = pcall(vim.system, cmd, { text = true })

  if ok then
    vim.defer_fn(function()
      if not job:is_closing() then
        job:kill(9)
      end
    end, 1000)
  end

  return ok
end

return M
