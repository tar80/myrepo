-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------
local api = vim.api
local fn = vim.fn
local o = vim.o
local keymap = vim.keymap
local util = require('util')
local helper = require('helper')

---@desc Functions {{{1
local function toggleShellslash() -- {{{2
  vim.opt_local.shellslash = not api.nvim_get_option_value('shellslash', { scope = 'global' })
  vim.bo.completeslash = vim.o.shellslash and 'slash' or 'backslash'
  vim.cmd.redrawstatus()
  vim.cmd.redrawtabline()
end

---@desc Refine substitution histories within the command window
---@see https://qiita.com/monaqa/items/e22e6f72308652fc81e2
local function refine_substitutions(input) -- {{{2
  local search_str = fn.getreg('/')
  local redraw_value = api.nvim_get_option_value('lazyredraw', { scope = 'global' })
  api.nvim_set_option_value('hlsearch', false, { scope = 'global' })
  api.nvim_set_option_value('lazyredraw', true, { scope = 'global' })
  api.nvim_input(string.format('q:<Cmd>silent! v/%s/d<CR>', input))
  vim.schedule(function()
    fn.histdel('/', -1)
    fn.setreg('/', search_str)
    api.nvim_set_option_value('lazyredraw', redraw_value, { scope = 'global' })
  end)
end

local function ppcust_load() -- {{{2
  if vim.bo.filetype ~= 'PPxcfg' then
    vim.notify('Not PPxcfg', 1)
    return
  end

  vim.system({ os.getenv('PPX_DIR') .. '\\ppcustw.exe', 'CA', api.nvim_buf_get_name(0) }, { text = true }):wait()
  vim.notify('PPcust CA ' .. fn.expand('%:t'), 3)
end

---@desc Abbreviations {{{1
local abbrev = { -- {{{2
  ia = function(word, replaces)
    for _, replace in ipairs(replaces) do
      keymap.set('ia', replace, word)
    end
  end,
  ca = function(word, replace)
    ---@see https://zenn.dev/vim_jp/articles/2023-06-30-vim-substitute-tips
    local getchar = replace[2] and '[getchar(), ""][1].' or ''
    local exp = string.format('getcmdtype()..getcmdline() ==# ":%s" ? %s"%s" : "%s"', word, getchar, replace[1], word)
    keymap.set('ca', word, exp, { expr = true })
  end,
  va = function(word, replace)
    local getchar = replace[2] and '[getchar(), ""][1].' or ''
    local exp = string.format(
      'getcmdtype()..getcmdline() ==# ":%s" ? %s"%s" : getcmdtype()..getcmdline() ==# ":\'<,\'>%s" ? %s"%s" : "%s"',
      word,
      getchar,
      helper.replace_lt(replace[1][1]),
      word,
      getchar,
      helper.replace_lt(replace[1][2]),
      word
    )
    keymap.set('ca', word, exp, { expr = true })
  end,
  set = function(self, mode)
    local func = self[mode]
    local iter = vim.iter(self.tbl[mode])
    iter:each(func)
  end,
} ---}}}2
abbrev.tbl = { --- {{{2
  ia = {
    ['cache'] = { 'chace', 'chache' },
    ['export'] = { 'exprot', 'exoprt' },
    ['field'] = { 'filed' },
    ['string'] = { 'stirng', 'sting' },
    ['function'] = { 'funcion', 'fuction' },
    ['return'] = { 'reutnr', 'reutrn', 'retrun' },
  },
  ca = {
    bt = { [[T deno task build <C-r>=expand(\"%\:\.\")<CR>]] },
    bp = { [[!npm run build:prod]] },
    ms = { 'MugShow', true },
    es = { 'e<Space>++enc=cp932 ++ff=dos<CR>' },
    e8 = { 'e<Space>++enc=utf-8<CR>' },
    eu = { 'e<Space>++enc=utf-16le ++ff=dos<CR>' },
    sc = { 'set<Space>scb<Space><Bar><Space>wincmd<Space>p<Space><Bar><Space>set<Space>scb<CR>' },
    scn = { 'set<Space>noscb<CR>' },
    del = { [[call<Space>delete(expand('%'))]] },
    cs = { [[execute<Space>'50vsplit'g:repo.'/myrepo/nvim/.cheatsheet'<CR>]] },
    dd = { 'diffthis<Bar>wincmd<Space>p<Bar>diffthis<Bar>wincmd<Space>p<CR>' },
    dof = { 'syntax<Space>enable<Bar>diffoff!<CR>' },
    dor = {
      'vert<Space>bel<Space>new<Space>difforg<Bar>set<Space>bt=nofile<Bar>r<Space>++edit<Space>#<Bar>0d_<Bar>windo<Space>diffthis<Bar>wincmd<Space>p<CR>',
    },
    ht = { 'so<Space>$VIMRUNTIME/syntax/hitest.vim' },
    ct = { 'so<Space>$VIMRUNTIME/syntax/colortest.vim' },
    shadad = { '!rm ~/.local/share/nvim-data/shada/main.shada.tmp*' },
  },
  ---NOTE: {{cmdline, visualmode}}
  va = {
    s = { { '%s//<Left>', 's//<Left>' }, true },
    ss = { { '%s///<Left>', 's///<Left>' }, true },
  },
} ---}}}2
abbrev:set('ia')
abbrev:set('ca')
abbrev:set('va')

---@desc Keymaps {{{1
-- Unmap default-mappings {{{2
if vim.fn.has('nvim-0.11') == 1 then
  keymap.del('i', '<C-s>')
  keymap.del('n', 'gra')
  keymap.del('n', 'grn')
  keymap.del('n', 'grr')
  keymap.del('n', 'gri')
  keymap.del('n', 'gO')
end

vim.g.mapleader = ';'

---Operator mode{{{2
keymap.set({ 'o', 'x' }, 'iq', 'iW')
keymap.set({ 'o', 'x' }, 'aq', 'aW')

---Normal mode{{{2
keymap.set('n', '<F1>', function()
  return os.execute('c:/bin/cltc/cltc.exe')
end)
keymap.set({ 'n', 'c' }, '<F4>', toggleShellslash)
keymap.set('n', '<C-F9>', ppcust_load)
keymap.set('n', '<F12>', util.toggleWrap)
keymap.set('n', '<C-z>', '<Nop>')
keymap.set('n', 'dD', '"_dd')

local operatable_q = helper.plugkey('q', 'n')
operatable_q({ ':', 'w', '/', '?' })
local repeatable_g = helper.plugkey('g', 'n', true)
repeatable_g({ 'j', 'k' })
local repeatable_z = helper.plugkey('z', 'n', true)
repeatable_z({ 'h', 'j', 'k', 'l' })
local replaceable_H = helper.plugkey('H', 'n', true)
replaceable_H('H', '<PageUp>H')
local replaceable_L = helper.plugkey('L', 'n', true)
replaceable_L('L', '<PageDown>L')

keymap.set('n', ',', function()
  if o.hlsearch then
    api.nvim_set_option_value('hlsearch', false, { scope = 'global' })
  else
    api.nvim_feedkeys(',', 'n', false)
  end
end)
keymap.set('n', '<C-m>', 'i<C-M><ESC>')
keymap.set('n', '/', function()
  api.nvim_set_option_value('hlsearch', true, { scope = 'global' })
  return '/'
end, { noremap = true, expr = true })
keymap.set('n', '?', function()
  api.nvim_set_option_value('hlsearch', true, { scope = 'global' })
  return '?'
end, { noremap = true, expr = true })
keymap.set('n', 'n', "'Nn'[v:searchforward].'zv'", { noremap = true, silent = true, expr = true })
keymap.set('n', 'N', "'nN'[v:searchforward].'zv'", { noremap = true, silent = true, expr = true })
keymap.set('c', '<CR>', function()
  local cmdtype = fn.getcmdtype()
  if cmdtype == '/' or cmdtype == '?' then
    return '<CR>zv'
  end
  return '<CR>'
end, { noremap = true, expr = true, silent = true })

---Move buffer use <Space>
keymap.set('n', '<Space>', '<C-w>', { remap = true })
keymap.set('n', '<Space><Space>', '<C-w><C-w>')
keymap.set('n', '<Space>n', util.scratch_buffer)
-- keymap.set('n', '<Space>q', function()
--   if not vim.bo.buflisted then
--     vim.api.nvim_buf_delete(0, { force = true })
--   else
--     local bufcount = 0
--     vim.iter(vim.fn.tabpagebuflist()):each(function(bufnr)
--       if vim.bo[bufnr].buflisted then
--         bufcount = bufcount + 1
--       end
--     end)
--     if bufcount > 1 then
--       vim.api.nvim_win_close(0, false)
--     else
--       vim.cmd.close({ mods = { emsg_silent = true } })
--     end
--   end
-- end)
-- keymap.set('n', '<Space>Q', '<Cmd>lua vim.api.nvim_buf_delete(0,{unload=false})<CR>')
-- keymap.set('n', '<Space>c', '<Cmd>tabclose<CR>')
keymap.set('n', '<Space>-', '<C-w>-<Plug>(space)')
keymap.set('n', '<Plug>(space)-', '<C-w>-<Plug>(space)')
keymap.set('n', '<Space>;', '<C-w>+<Plug>(space)')
keymap.set('n', '<Plug>(space);', '<C-w>+<Plug>(space)')
keymap.set('n', '<Space>,', '<C-w><<Plug>(space)')
keymap.set('n', '<Plug>(space),', '<C-w><<Plug>(space)')
keymap.set('n', '<Space>.', '<C-w>><Plug>(space)')
keymap.set('n', '<Plug>(space).', '<C-w>><Plug>(space)')

---Search history of replacement
keymap.set('n', 'g/', function()
  refine_substitutions([[\v^\%s\/]])
end)
keymap.set('v', 'g/', function()
  refine_substitutions([[\v^('[0-9a-z\<lt>]|\d+),('[0-9a-z\>]|\d+)?s\/]])
end)

---Close nofile|qf|preview window
keymap.set('n', '<Space>z', function()
  if api.nvim_get_option_value('buftype', { buf = 0 }) == 'nofile' then
    return api.nvim_buf_delete(0, { unload = true })
  end
  local altnr = fn.bufnr('#')
  if altnr ~= -1 and api.nvim_get_option_value('buftype', { buf = altnr }) == 'nofile' then
    vim.cmd.bdelete(altnr)
    return
    -- return api.nvim_buf_delete(altnr, {unload = true})
  end
  if vim.wo.diff then
    vim.wo.diff = false
    vim.cmd.bdelete(altnr)
  end
  local qfnr = fn.getqflist({ qfbufnr = 0 }).qfbufnr
  if qfnr ~= 0 then
    return api.nvim_buf_delete(qfnr, {})
  end
  helper.feedkey('<C-w><C-z>', 'n')
end)

---Insert/Command mode {{{2
---@see https://zenn.dev/vim_jp/articles/2024-10-07-vim-insert-uppercase
keymap.set('i', '<C-q>', function()
  local line = api.nvim_get_current_line()
  local col = api.nvim_win_get_cursor(0)[2]
  local substring = line:sub(1, col)
  local result = vim.fn.matchstr(substring, [[\v<(\k(<)@!)*$]])
  return string.format('<C-w>%s', result:upper())
end, { expr = true })
keymap.set('i', '<M-j>', '<C-g>U<Down>')
keymap.set('i', '<M-k>', '<C-g>U<Up>')
keymap.set('i', '<M-h>', '<C-g>U<Left>')
keymap.set('i', '<M-l>', '<C-g>U<Right>')
keymap.set('i', '<S-Delete>', '<C-g>U<C-o>D')
keymap.set('i', '<C-k>', '<Delete>')
keymap.set('i', '<C-f>', '<Right>')
keymap.set('i', '<C-b>', '<Left>')
keymap.set('i', '<C-z>', '<C-a><Esc>')
keymap.set('c', '<C-a>', '<Home>')
keymap.set('c', '<C-b>', '<Left>')
keymap.set('!', '<C-v>u', '<C-R>=nr2char(0x)<Left>')

---Visual mode{{{2
keymap.set('x', '@', function()
  local input = fn.nr2char(fn.getchar() --[[@as number]])
  if input:match('[%d%l]') then
    local rgx = '^V?:%%?s'
    local value = fn.getreg(input)
    local subst = value:find(rgx, 1)
    if input == 'w' then
      api.nvim_input(string.format(':g/^/normal @%s<CR>', input))
    elseif subst and subst <= 2 then
      local keyemu = value:gsub(rgx, ':s', 1)
      api.nvim_input(keyemu)
    elseif value:match('%C') then
      api.nvim_input(string.format(':ss %s<CR>', value))
    end
  end
end, { expr = true })
---@see https://zenn.dev/vim_jp/articles/43d021f461f3a4
-- keymap.set('v', 'y', 'mmy`m')
keymap.set('v', '<C-insert>', '"*y')
keymap.set('v', '<C-delete>', '"*ygvd')
---do not release after range indentation process
keymap.set('x', '<', '<gv')
keymap.set('x', '>', '>gv')
---search for cursor under string without moving cursor
-- keymap.set('n', '*', function()
--   util.search_star()
-- end, { expr = true })
-- keymap.set('n', 'g*', function()
--   util.search_star(true)
-- end, { expr = true })
-- keymap.set('x', '*', function()
--   util.search_star(false, true)
-- end, { expr = true })
