--- vim:textwidth=0:foldmethod=marker:foldlevel=1:
-------------------------------------------------------------------------------
local M = {}
local api = vim.api

M.getchr = function()
  local col = api.nvim_win_get_cursor(0)[2] + 1
  local getline = api.nvim_get_current_line()
  return getline:sub(col, col)
end

M.has_words_before = function()
  local row, col = unpack(api.nvim_win_get_cursor(0))
  return col ~= 0 and api.nvim_buf_get_lines(0, row - 1, row, true)[1]:sub(col, col):match('[^%w]') == nil
end

M.feedkey = function(key, mode)
  return vim.fn.feedkeys(api.nvim_replace_termcodes(key, true, true, true), mode)
end

M.normalize = function(path)
  path = path:sub(1, 1):upper() .. path:sub(2)
  return vim.fs.normalize(path)
end

M.shell = function(name) -- {{{2
  local scoop = os.getenv('scoop'):gsub('\\', '/')
  local obj = {
    cmd = { path = 'cmd.exe', flag = '/c', pipe = '>%s 2>&1', quote = '', xquote = '"', slash = false },
    nyagos = {
      path = scoop .. '/apps/nyagos/current/nyagos.exe',
      flag = '-c',
      pipe = '|& tee',
      quote = '',
      xquote = '',
      slash = true,
    },
    bash = {
      path = scoop .. '/apps/git/current/bin/bash.exe',
      flag = '-c',
      pipe = '2>1| tee',
      quote = '"',
      xquote = '"',
      slash = true,
    },
  }
  local cui = obj[name]
  local set = function(key, value)
    api.nvim_set_option_value(key, value, { scope = 'global' })
  end
  set('shell', cui.path)
  set('shellcmdflag', cui.flag)
  set('shellpipe', cui.pipe)
  set('shellquote', cui.quote)
  set('shellxquote', cui.xquote)
  set('shellslash', cui.slash)
end -- }}}

return M
