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

---@param keys string|string[]
local _iter_maps = function(keys, callback)
  local t = type(keys)
  if t == 'string' then
    callback(keys)
  elseif t == 'table' then
    vim.iter(keys):each(function(key)
      callback(key)
    end)
  end
end

---A operator that issues a specific key standby
---https://zenn.dev/mattn/articles/83c2d4c7645faa
---https://github.com/atusy/dotfiles/blob/main/dot_config/nvim/lua/atusy/init.lua
---@param startkey string A trigger key spec
---@param mode string A list of modes
---@param is_repeat? boolean Whether to repeat the key sequence
---@return fun(keys: string|string[], addkey?: string):nil
M.plugkey = function(startkey, mode, is_repeat)
  local plug = ('<Plug>(%s)'):format(startkey)
  if is_repeat then
    return function(keys, replacekey)
      if replacekey and keys == startkey then
        vim.keymap.set(mode, startkey, startkey .. plug)
        vim.keymap.set(mode, plug .. keys, replacekey .. plug)
      else
        _iter_maps(keys, function(nextkey)
          local repeatkey = startkey .. nextkey
          vim.keymap.set(mode, repeatkey, repeatkey .. plug)
          vim.keymap.set(mode, plug .. nextkey, repeatkey .. plug)
        end)
      end
    end
  else
    vim.keymap.set(mode, startkey, ('<Plug>(%s)'):format(startkey))
    return function(keys)
      _iter_maps(keys, function(nextkey)
        vim.keymap.set(mode, plug .. nextkey, startkey .. nextkey)
      end)
    end
  end
end

---Unload preset plugins
M.unload_presets = function()
  vim.g.loaded_2html_plugin = true
  vim.g.loaded_gzip = true
  vim.g.loaded_matchit = true
  vim.g.loaded_matchparen = true
  vim.g.loaded_netrwPlugin = true
  vim.g.loaded_spellfile_plugin = true
  vim.g.loaded_tarPlugin = true
  vim.g.loaded_tutor_mode_plugin = true
  vim.g.loaded_zipPlugin = true
end

---Measure the time it takes to start vim
M.measure_startup = function()
  if vim.fn.has('vim_starting') then
    local pre = vim.fn.reltime()
    local augroup = vim.api.nvim_create_augroup('rc_helper', {})
    vim.api.nvim_create_autocmd('UIEnter', {
      group = augroup,
      once = true,
      callback = function()
        local post = vim.fn.reltime(pre)
        local msg = ('Startup time: %s'):format(vim.fn.reltimestr(post))
        vim.notify(msg, vim.log.levels.INFO)
        vim.api.nvim_del_augroup_by_id(augroup)
      end,
    })
  end
end

---Set vim client server
---@param port? string|integer
---@param level? string
M.set_client_server = function(port, level) -- {{{
  if level then
    return
  end
  local pipe = ([[\\.\pipe\nvim.%s.0]]):format(port or '100')
  local server = vim.v.servername
  if not server then
    pcall(vim.fn.serverstart, pipe)
  elseif server ~= pipe then
    local ok = pcall(vim.fn.serverstart, pipe)
    if ok then
      pcall(vim.fn.serverstop, server)
    end
  end
end -- }}}

---Optimize the environment variable "PATH"
---@param remove string[]
M.optimize_env_path = function(remove) -- {{{
  local env_path = vim.env.path
  if not env_path then
    return
  end
  local seen = {}
  local iter = vim.iter(vim.gsplit(env_path, ';', { plain = true }))
  vim.env.path = iter
    :filter(function(path)
      return not vim.tbl_contains(remove, function(v)
        return path:lower():find(v, 1, true)
      end, { predicate = true })
    end)
    :map(function(path)
      if not seen[path] then
        seen[path] = true
        return path
      end
    end)
    :join(';')
end -- }}}

---Set the specified shell environment
---@param name string Specify the shell name
M.shell = function(name) -- {{{
  local obj = {
    cmd = { path = 'cmd.exe', flag = '/c', pipe = '>%s 2>&1', quote = '', xquote = '"', slash = false },
    nyagos = {
      path = M.scoop_apps('/apps/nyagos/current/nyagos.exe'),
      flag = '-c',
      pipe = '|& tee',
      quote = '',
      xquote = '',
      slash = true,
      completeslash = 'slash',
    },
    bash = {
      path = M.scoop_apps('/apps/git/current/bin/bash.exe'),
      flag = '-c',
      pipe = '2>&1| tee',
      quote = '',
      xquote = '"',
      slash = true,
      completeslash = 'slash',
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
  set('completeslash', cui.completeslash)
end -- }}}

---Create new scratch buffer
M.scratch_buffer = function() -- {{{
  ---@type string
  local bufname
  local i = 1
  repeat
    bufname = ('Scratch%s'):format(i)
    i = i + 1
  until fn.bufnr(bufname) == -1
  vim.cmd.new(bufname)
  api.nvim_set_option_value('buftype', 'nofile', { buf = 0 })
  api.nvim_set_option_value('bufhidden', 'wipe', { buf = 0 })
end -- }}}

---Toggle wrap option
M.toggleWrap = function()
  if vim.o.diff == true then
    local win_num = api.nvim_win_get_number(0)
    api.nvim_command(('windo setlocal wrap!|%swincmd w'):format(win_num))
  else
    api.nvim_command('setl wrap! wrap?')
  end
end

M.set_macros = function()
  local k = vim.keycode
  vim.fn.setreg('e', string.format([[:let @=@w%s]], k('<Left><Left><Left>')))
  vim.fn.setreg('b', string.format([[V:s \//\\%s]], k('<CR>')))
  vim.fn.setreg('d', string.format([[V:s \\/\\\\%s]], k('<CR>')))
  vim.fn.setreg('s', string.format([[V:s \\\\/\/%s]], k('<CR>')))
  vim.fn.setreg('k', string.format([[:let @=@w%s]], k('<Left><Left><Left>')))
  vim.notify('[Info] Registered macros', vim.log.levels.INFO)
end

---Get adapt time
---@param daytime integer
---@param nighttime integer
M.adapt_time = function(daytime, nighttime)
  local hour = os.date('*t').hour
  if daytime < hour and hour < nighttime then
    return 'daytime'
  else
    return 'nighttime'
  end
end

---Start hlsearch at cursor position
---@param has_g? boolean Has plefix "g"
---@param is_visual? boolean Visual mode or not
M.search_star = function(has_g, is_visual)
  local word
  if not is_visual then
    word = fn.expand('<cword>')
    word = has_g and word or string.format([[\<%s\>]], word)
  else
    local first = fn.getpos('v')
    local last = fn.getpos('.')
    local lines = api.nvim_buf_get_lines(0, first[2] - 1, last[2], false)
    if #lines > 1 then
      return M.feedkey('*', 'n')
    else
      word = lines[1]:sub(first[3], last[3])
    end
    vim.defer_fn(function ()
      M.feedkey('<Esc>', 'x')
    end, 0)
  end
  if vim.v.count > 0 then
    return M.feedkey('*', 'n')
  else
    fn.setreg('/', word)
    return api.nvim_set_option_value('hlsearch', true, { scope = 'global' })
  end
end

return M
