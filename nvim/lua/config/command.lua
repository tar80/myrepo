-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------
local api = vim.api
local fn = vim.fn
local keymap = vim.keymap

---@desc Auto-commands {{{1
local augroup = api.nvim_create_augroup('rc_config', {})

---Remove ignore history from cmdline history{{{2
---@see https://blog.atusy.net/2023/07/24/vim-clean-history/
local ignore_history = [=[^\c\(\_[efqw]!\?\|qa!\?\|ec\a*\|mes\%[sages]\|h\%[elp]\)$]=]
vim.api.nvim_create_autocmd('ModeChanged', {
  desc = 'Remove ignore history',
  pattern = 'c:*',
  group = augroup,
  callback = function()
    vim.schedule(function()
      fn.histdel(':', ignore_history)
    end)
  end,
})

---Delete current line from cmdwin-history {{{2
vim.api.nvim_create_autocmd('CmdWinEnter', {
  desc = 'Attach command window',
  group = augroup,
  callback = function()
    vim.wo.signcolumn = 'no'
    keymap.set('n', 'D', function()
      local line = fn.line('.') - fn.line('$')
      fn.histdel(':', line)
      api.nvim_del_current_line()
    end, { buffer = 0 })
    keymap.set('n', 'q', '<Cmd>quit<CR>', { buffer = 0 })
  end,
})

---Update shada when exiting cmd-window
vim.api.nvim_create_autocmd('CmdWinLeave', {
  desc = 'Update shada',
  group = augroup,
  callback = function()
    vim.cmd.wshada({ bang = true })
  end,
})

---Cursor line highlighting rules {{{2
api.nvim_create_autocmd('CursorHoldI', {
  desc = 'Ignore cursorline highlight',
  group = augroup,
  callback = function()
    if vim.bo.filetype ~= 'snacks_picker_input' then
      vim.opt_local.winhighlight:append('CursorLine:CursorLineHold')
      api.nvim_set_option_value('cursorline', true, {})
    end
  end,
})

---NOTE: FocusLost does not work in Windows-tereminal.
api.nvim_create_autocmd({ 'FocusLost', 'BufLeave' }, {
  desc = 'Ignore cursorline highlight',
  group = augroup,
  callback = function()
    if api.nvim_get_mode().mode == 'i' and vim.bo.filetype ~= 'snacks_picker_input' then
      vim.opt_local.winhighlight:append('CursorLine:CursorLineHold')
      api.nvim_set_option_value('cursorline', true, {})
    end
  end,
})

api.nvim_create_autocmd({ 'BufEnter', 'CursorMovedI', 'InsertLeave' }, {
  desc = 'Ignore cursorline highlight',
  group = augroup,
  -- command = 'setl nocursorline',
  callback = function()
    vim.wo.cursorline = false
    vim.opt_local.winhighlight:remove('CursorLine')
  end
})

---Insert-Mode, we want a longer updatetime {{{2
api.nvim_create_autocmd('InsertEnter', {
  desc = 'Set to longer updatetime',
  group = augroup,
  -- command = 'set updatetime=7000',
  callback = function()
    vim.go.updatetime = 7000
    -- vim.g._ts_force_sync_parsing = true
  end,
})

api.nvim_create_autocmd('InsertLeave', {
  desc = 'Revert to normal updatetime',
  group = augroup,
  -- command = 'setl iminsert=0|execute "set updatetime=" . g:update_time',
  callback = function()
    vim.bo.iminsert = 0
    vim.go.updatetime = vim.g.update_time
    -- vim.g._ts_force_sync_parsing = false
  end,
})

---Yanked, it shines {{{2
api.nvim_create_autocmd('TextYankPost', {
  desc = 'On yank highlight',
  group = augroup,
  pattern = '*',
  callback = function(_)
    vim.hl.on_yank({ higroup = 'Visual', on_visual = false, timeout = 200, prioritiy = 300 })
  end,
})

---Supports changing options that affect diff {{{2
api.nvim_create_autocmd('OptionSet', {
  desc = 'Set settings',
  group = augroup,
  pattern = { 'diff' },
  callback = function(opts)
    if vim.o.diff then
      keymap.set('x', 'do', ':diffget<CR>', { buffer = opts.buf, desc = 'Get selection diff' })
      keymap.set('x', 'dp', ':diffput<CR>', { buffer = opts.buf, desc = 'Put selection diff' })
      keymap.set('x', 'dd', function()
        if vim.o.diff then
          return 'd'
        else
          keymap.del('x', 'do', { buffer = opts.buf })
          keymap.del('x', 'dp', { buffer = opts.buf })
          keymap.del('x', 'dd', { buffer = opts.buf })
          keymap.del({ 'x', 'n' }, 'du', { buffer = opts.buf })
          return 'dd'
        end
      end, { buffer = opts.buf, expr = true, desc = 'Delete selection range' })
      keymap.set(
        { 'n', 'x' },
        'du',
        '<Cmd>diffupdate<CR>',
        { buffer = opts.buf, desc = 'Update diff comparison status' }
      )
    elseif vim.fn.mapcheck('dd', 'x') ~= '' then
      keymap.del('x', 'do', { buffer = opts.buf })
      keymap.del('x', 'dp', { buffer = opts.buf })
      keymap.del('x', 'dd', { buffer = opts.buf })
      keymap.del({ 'x', 'n' }, 'du', { buffer = opts.buf })
    end
  end,
})

---@desc User-commands {{{1
api.nvim_create_user_command('BustedThisFile', function() -- {{{2
  local rgx = vim.regex([[\(_spec\)\?\.lua$]])
  local path = string.gsub(vim.fn.expand('%'), '\\', '/')
  path = string.format('%s_spec.lua', path:sub(1, rgx:match_str(path)))
  vim.cmd.PlenaryBustedFile(path)
end, {})

---@desc "Z <filepath>" zoxide query
-- api.nvim_create_user_command('Z', 'execute "lcd " . system("zoxide query " . <q-args>)', { nargs = 1 })

---@desc Jest compose multi-panel
---@type string
local pane_id
api.nvim_create_user_command('JestDo', function() -- {{{2
  local path = vim.fn.expand('%:t')
  if not path:find('test.ts$') then
    path = path:gsub('.ts$', '.test.ts')
  end
  vim.system(
    { 'wezterm', 'cli', 'send-text', '--pane-id', pane_id, '--no-paste' },
    { stdin = { string.format('npx jest --test-match=**/%s', path) }, text = true }
  )
end, {})

api.nvim_create_user_command('JestSetup', function()
  local has_config = fn.filereadable('jest.config.js') + fn.filereadable('package.json')
  if has_config == 0 then
    vim.notify('Could not found jest configurations', 3)
  end
  vim.system(
    { 'wezterm', 'cli', 'split-pane', '--right', '--percent=40', string.format('--cwd=%s', vim.uv.cwd()), 'bash' },
    { text = true },
    function(obj)
      pane_id = vim.trim(obj.stdout)
      vim.system({ 'wezterm', 'cli', 'activate-pane-direction', 'left' }, { text = true })
    end
  )
  local symbol = 'test'
  local sym_dir = string.format('__%ss__', symbol)
  local parent_dir = vim.fs.dirname(api.nvim_buf_get_name(0))
  local test_dir = vim.fs.joinpath(parent_dir, sym_dir)
  local name = fn.expand('%:t:r')
  if parent_dir and not parent_dir:find(sym_dir, 1, true) then
    local test_path = string.format('%s/%s.%s.ts', test_dir, name, symbol)
    local insert_string = ''
    if fn.filereadable(test_path) ~= 1 then
      local line1 = "import PPx from '@ppmdev/modules/ppx.ts';"
      local line2 = 'global.PPx = Object.create(PPx)'
      local line3 = string.format("import from '../%s'", fn.expand('%:t'))
      insert_string = string.format('|execute "normal! I%s\n%s\n%s\\<Esc>3G06l"', line1, line2, line3)
    end
    if fn.isdirectory(test_dir) ~= 1 then
      fn.mkdir(test_dir)
    end
    api.nvim_command(string.format('bot split %s|set fenc=utf-8|set ff=unix%s', test_path, insert_string))
  end
end, {})
