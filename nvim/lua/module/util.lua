local M = {}

M.getchr = function()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local getline = vim.api.nvim_get_current_line()
  return getline:sub(col, col)
end

M.has_words_before = function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]:sub(col, col):match('[^%w]') == nil
end

M.feedkey = function(key, mode)
  return vim.fn.feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode)
end

M.hl_at_cursor = function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  col = col + 1
  local hl_name = '(vim-syntax)' .. vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.synID(row, col, 2)), 'name')

  if not hl_name == '' then
    --[[
    -- This code from https://github.com/nvim-treesitter/playground/blob/master/lua/nvim-treesitter-playground/utils.lua
    -- under the Apatch license 2.0
    ]]
    if not package.loaded['nvim-treesitter'] then
      vim.notify('treesitter is not loaded', 3)
      return
    end

    local ts_utils = require('nvim-treesitter.ts_utils')
    local highlighter = require('vim.treesitter.highlighter')

    local bufnr = vim.api.nvim_get_current_buf()
    local buf_highlighter = highlighter.active[bufnr]

    if not buf_highlighter then
      return
    end

    row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row = row - 1

    buf_highlighter.tree:for_each_tree(function(tstree, tree)
      if not tstree then
        return
      end

      local root = tstree:root()
      local root_start_row, _, root_end_row, _ = root:range()

      -- Only worry about trees within the line range
      if root_start_row > row or root_end_row < row then
        return
      end

      local query = buf_highlighter:get_query(tree:lang())

      -- Some injected languages may not have highlight queries.
      if not query:query() then
        return
      end

      local matche = 'empty'
      local iter = query:query():iter_captures(root, buf_highlighter.bufnr, row, row + 1)

      for capture, node, _ in iter do
        local hl = query.hl_cache[capture]

        if hl and ts_utils.is_in_node_range(node, row, col) then
          -- name of the capture in the query
          local c = query._query.captures[capture]
          if c ~= nil then
            matche = c
          end
        end
      end

      hl_name = '(treesitter)' .. matche
    end, true)
  end

  print(hl_name)
end

M.shell = function(name)
  local scoop = os.getenv('scoop'):gsub('\\', '/')
  local s = {
    cmd = { path = 'cmd.exe', flag = '/s /c', pipe = '>%s 2>&1', quote = '', xquote = '"', slash = false },
    bash = {
      path = scoop .. '/apps/git/current/bin/bash.exe',
      flag = '-c',
      pipe = '2>1| tee',
      quote = '"',
      xquote = '"',
      slash = true,
    },
  }
  local new = s[name]
  local set = vim.api.nvim_set_option
  set('shell', new.path)
  set('shellcmdflag', new.flag)
  set('shellpipe', new.pipe)
  set('shellquote', new.quote)
  set('shellxquote', new.xquote)
  set('shellslash', new.slash)
end

return M
