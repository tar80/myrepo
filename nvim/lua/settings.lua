-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------
local api = vim.api
local uv = vim.uv
local fn = vim.fn
local o = vim.o
local opt = vim.opt
local keymap = vim.keymap
local util = require('module.util')

---@desc Set shell parameters
util.shell('nyagos')

---@desc Variales {{{2
vim.env.myvimrc = uv.fs_readlink(vim.env.myvimrc)
vim.g.repo = 'c:/bin/repository/tar80'
vim.g.update_time = 700
vim.cmd('language message C')

local FOLD_SEP = ' » '
local foldmarker = vim.split(api.nvim_get_option_value('foldmarker', { win = 0 }), ',', { plain = true })

---@desc Unload default plugins {{{2
---NOTE: leave it to lazy.nvim
-- vim.g.loaded_2html_plugin = true
-- vim.g.loaded_gzip = true
-- vim.g.loaded_man = true
-- vim.g.loaded_matchit = true
-- vim.g.loaded_matchparen = true
-- vim.g.loaded_netrwPlugin = true
-- vim.g.loaded_spellfile_plugin = true
-- vim.g.loaded_tarPlugin = true
-- vim.g.loaded_tutor_mode_plugin = true
-- vim.g.loaded_zipPlugin = true
--}}}2
---@desc Options {{{1
---Global {{{2
api.nvim_set_option_value('termguicolors', true, { scope = 'global' })
api.nvim_set_option_value('foldcolumn', '1', { scope = 'global' })
api.nvim_set_option_value('fileformats', 'unix,dos,mac', { scope = 'global' })
api.nvim_set_option_value('hlsearch', false, { scope = 'global' })
api.nvim_set_option_value('shada', "'50,<500,/10,:100,h", { scope = 'global' })

---Local {{{2
-- NOTE: api.nvim_set_option_value('name', value, { scope = 'local' })

vim.opt_local.isfname:append(':')

---General {{{2
o.guicursor = 'n:block,i-c-ci-ve:ver50,v-r-cr-o:hor50'
-- o.fileencodings = 'utf-8,utf-16le,cp932,euc-jp,sjis'
o.fileencodings = 'utf-8,cp932,euc-jp,utf-16le'
-- o.timeoutlen = 1000
o.updatetime = vim.g.update_time
-- o.autochdir = true
-- opt.diffopt:append({"iwhite"})
o.diffopt = 'vertical,filler,iwhite,iwhiteeol,closeoff,indent-heuristic,algorithm:histogram'
-- o.backup= false
o.swapfile = false
o.undofile = true
o.history = 300
o.ambiwidth = 'single'
o.gdefault = true
o.ignorecase = true
o.smartcase = true
o.formatoptions = 'mMjql'
o.wrap = false
o.wrapscan = false
o.whichwrap = '<,>,[,],h,l'
o.linebreak = true
o.breakindent = true
o.showbreak = '>>'
o.scrolloff = 1
o.sidescroll = 6
o.sidescrolloff = 3
o.lazyredraw = false
o.list = true
opt.listchars = { tab = '| ', extends = '<', precedes = '>', trail = '_' }
o.confirm = true
-- o.display = 'lastline'
o.showmode = false
o.showtabline = 2
o.laststatus = 3
o.cmdheight = 1
o.number = true
-- o.numberwidth = 4
o.relativenumber = true
o.signcolumn = 'yes'
-- o.backspace = { indent = true,eol = true, start = true }
o.complete = '.,w'
opt.completeopt = { menu = true, menuone = true, noselect = true }
o.winblend = 10
o.pumblend = 12
o.pumheight = 10
o.pumwidth = 20
o.matchtime = 2
opt.matchpairs:append({ '【:】', '[:]' })
-- vim.cmd[[set tabstop<]]
o.shiftwidth = 2
o.softtabstop = 2
o.shiftround = true
o.expandtab = true
o.virtualedit = 'block'
-- o.wildmenu = true
opt.wildmode = { 'longest:full', 'full' }
opt.wildoptions:remove({ 'tagfile' })
opt.spelllang:append({ 'cjk' })
opt.shortmess:append('csS')
opt.shortmess:remove({ 'fF' })
-- opt.fillchars = { vert = "█", vertleft = "█", vertright = "█", verthoriz = "█", horiz = "█", horizup = "█", horizdown = "█", }
opt.fillchars = { diff = ' ' }
o.keywordprg = ':help'
o.helplang = 'ja'
o.helpheight = 10
o.previewheight = 8
opt.path = { '.', '' }

---@desc Auto-commands {{{1
local augroup = api.nvim_create_augroup('rcSettings', {})

---Remove ignore history from cmdline history{{{2
---@see https://blog.atusy.net/2023/07/24/vim-clean-history/
local ignore_history = [=[^\c\(\_[efqw]!\?\|qa!\?\|ec\a*\|mes\%[sages]\|h\%[elp]\)$]=]
vim.api.nvim_create_autocmd('ModeChanged', {
  desc = 'Remove ignore history',
  pattern = 'c:*',
  group = augroup,
  callback = function()
    local hist = fn.histget('cmd', -1)
    vim.schedule(function()
      if vim.regex(ignore_history):match_str(hist) then
        fn.histdel(':', -1)
      end
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
    if vim.bo.filetype ~= 'TelescopePrompt' then
      api.nvim_set_option_value('cursorline', true, { win = 0 })
    end
  end,
})
---NOTE: FocusLost does not work mounted in the Windows-tereminal.
api.nvim_create_autocmd({ 'FocusLost', 'BufLeave' }, {
  desc = 'Ignore cursorline highlight',
  group = augroup,
  callback = function()
    if api.nvim_get_mode().mode == 'i' and vim.bo.filetype ~= 'TelescopePrompt' then
      api.nvim_set_option_value('cursorline', true, { win = 0 })
    end
  end,
})
api.nvim_create_autocmd({ 'BufEnter', 'CursorMovedI', 'InsertLeave' }, {
  desc = 'Ignore cursorline highlight',
  group = augroup,
  command = 'setl nocursorline',
})
---Insert-Mode, we want a longer updatetime {{{2
api.nvim_create_autocmd('InsertEnter', {
  desc = 'Set to longer updatetime',
  group = augroup,
  command = 'set updatetime=4000',
})
api.nvim_create_autocmd('InsertLeave', {
  desc = 'Set to normal updatetime',
  group = augroup,
  command = 'setl iminsert=0|execute "set updatetime=" . g:update_time',
})
---Yanked, it shines {{{2
api.nvim_create_autocmd('TextYankPost', {
  desc = 'On yank highlight',
  group = augroup,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ higroup = 'PmenuSel', on_visual = false, timeout = 150, prioritiy = 200 })
  end,
})
---Supports changing options that affect Simple_fold() {{{2
api.nvim_create_autocmd('OptionSet', {
  desc = 'Reset Simple_fold()',
  group = augroup,
  pattern = 'foldmarker',
  callback = function(opts)
    if opts.match == 'foldmarker' then
      foldmarker = vim.split(api.nvim_get_option_value('foldmarker', { win = 0 }), ',')
    end
  end,
})
---Set variable for cmdline-abbreviations {{{2
api.nvim_create_autocmd('CmdlineChanged', {
  desc = 'Set variable for abbreviations',
  group = augroup,
  pattern = '*',
  callback = function()
    vim.cmd('let cmdline_abbrev = getcmdtype().getcmdline()')
  end,
})
---@desc Functions {{{1
function Simple_fold() -- {{{2
  ---this code is based on https://github.com/tamton-aquib/essentials.nvim
  local cms = api.nvim_get_option_value('commentstring', { buf = 0 })
  cms = cms:gsub('(%S+)%s*%%s.*', '%1')
  local open, close = api.nvim_get_vvar('foldstart'), api.nvim_get_vvar('foldend')
  local line_count = string.format('%s lines', close - open)
  local forward = api.nvim_buf_get_lines(0, open - 1, open, false)[1]
  forward = forward:gsub(string.format('%s%%s*%s%%d*', cms, foldmarker[1]), '')
  local backward = api.nvim_buf_get_lines(0, close - 1, close, false)[1]
  backward = backward:find(foldmarker[2], 1, true) and backward:sub(0, backward:find(cms, 1, true) - 1) or ''
  local linewise = string.format('%s%s%s... %s', forward, FOLD_SEP, line_count, backward)
  local spaces = (' '):rep(o.columns - #linewise)

  return linewise .. spaces
end
api.nvim_set_option_value('foldtext', 'v:lua.Simple_fold()', { win = 0 })

local function toggleShellslash() -- {{{2
  vim.opt_local.shellslash = not api.nvim_get_option_value('shellslash', { scope = 'global' })
  vim.cmd.redrawstatus()
  vim.cmd.redrawtabline()
end

local function search_star(g, mode) -- {{{2
  local word
  if mode ~= 'v' then
    word = fn.expand('<cword>')
    word = g == 'g' and word or string.format([[\<%s\>]], word)
  else
    local first = fn.getpos('v')
    local last = fn.getpos('.')
    local lines = fn.getline(first[2], last[2])
    if #lines > 1 then
      -- word = table.concat(api.nvim_buf_get_text(0, first[2] - 1, first[3] - 1, last[2] - 1, last[3], {}))
      return util.feedkey('*', 'n')
    else
      word = lines[1]:sub(first[3], last[3])
    end
    util.feedkey('<ESC>', 'n')
  end
  if vim.v.count > 0 then
    return util.feedkey('*', 'n')
  else
    fn.setreg('/', word)
    return api.nvim_set_option_value('hlsearch', true, { scope = 'global' })
  end
end

---@desc refine substitution histories within the command window
---@see https://qiita.com/monaqa/items/e22e6f72308652fc81e2
local function refine_substitutions(input)
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
    vim.notify('Not PPxcfg', 1, {})
    return
  end

  fn.system({ os.getenv('PPX_DIR') .. '\\ppcustw.exe', 'CA', api.nvim_buf_get_name(0) })
  vim.notify('PPcust CA ' .. fn.expand('%:t'), 3)
end

local abbrev = { -- {{{2
  ia = function(word, replaces)
    for _, replace in ipairs(replaces) do
      keymap.set('ia', replace, word)
    end
  end,
  ca = function(word, replace)
    ---@see https://zenn.dev/vim_jp/articles/2023-06-30-vim-substitute-tips
    local getchar = replace[2] and '[getchar(), ""][1].' or ''
    local exp = string.format('cmdline_abbrev ==# ":%s" ? %s"%s" : "%s"', word, getchar, replace[1], word)
    keymap.set('ca', word, exp, { expr = true })
  end,
  va = function(word, replace)
    local getchar = replace[2] and '[getchar(), ""][1].' or ''
    local exp = string.format(
      'cmdline_abbrev ==# ":%s" ? %s"%s" : cmdline_abbrev ==# ":\'<,\'>%s" ? %s"%s" : "%s"',
      word, getchar, replace[1][1], word, getchar, replace[1][2], word
    )
    keymap.set('ca', word, exp, { expr = true })
  end,
  set = function(self, mode)
    local fun = self[mode]
    local iter = vim.iter(self.tbl[mode])
    iter:each(fun)
  end,
} -- }}}

---@desc Abbreviations {{{1
---Table {{{2
abbrev.tbl = {
  ia = {
    export = { 'exprot', 'exoprt' },
    field = { 'filed' },
    string = { 'stirng', 'sting' },
    ['function'] = { 'funcion', 'fuction' },
    ['return'] = { 'reutnr', 'reutrn', 'retrun' },
  },
  ca = {
    bt = { [[T npm run build <C-r>=expand(\"%\:\.\")<CR>]] },
    -- bt = { [[T npm run build <C-r>=expand(\"%\:r\")<CR>\.ts]] },
    bp = { [[!npm run build:prod]] },
    ms = { 'MugShow', true },
    es = { 'e<Space>++enc=cp932 ++ff=dos<CR>' },
    e8 = { 'e<Space>++enc=utf-8<CR>' },
    e16 = { 'e<Space>++enc=utf-16le ++ff=dos<CR>' },
    sc = { 'set<Space>scb<Space><Bar><Space>wincmd<Space>p<Space><Bar><Space>set<Space>scb<CR>' },
    scn = { 'set<Space>noscb<CR>' },
    del = { [[call<Space>delete(expand('%'))]] },
    cs = { [[execute<Space>'50vsplit'g:repo.'/myrepo/nvim/.cheatsheet'<CR>]] },
    dd = { 'diffthis<Bar>wincmd<Space>p<Bar>diffthis<Bar>wincmd<Space>p<CR>' },
    dof = { 'syntax<Space>enable<Bar>diffoff<CR>' },
    dor = {
      'vert<Space>bel<Space>new<Space>difforg<Bar>set<Space>bt=nofile<Bar>r<Space>++edit<Space>#<Bar>0d_<Bar>windo<Space>diffthis<Bar>wincmd<Space>p<CR>',
    },
    ht = { 'so<Space>$VIMRUNTIME/syntax/hitest.vim' },
    ct = { 'so<Space>$VIMRUNTIME/syntax/colortest.vim' },
    shadad = { '!rm ~/.local/share/nvim-data/shada/main.shada.tmp*' },
  },
  -- @desc {{cmdline, visualmode}}
  va = {
    s = { { '%s///<lt>Left>', [[s///|nohls<lt>Left><lt>Left><lt>Left><lt>Left><lt>Left><lt>Left><lt>Left>]] }, true },
  },
}

---Commands {{{2
abbrev:set('ia')
abbrev:set('ca')
abbrev:set('va')
---}}}

---@desc Keymaps {{{1
-- Unmap default-mappings {{{2
-- keymap.del('i', '<C-s>')
keymap.del('n', 'gra')
keymap.del('n', 'grn')
keymap.del('n', 'grr')

vim.g.mapleader = ';'
---Normal mode{{{2
keymap.set('n', '<F1>', function()
  return os.execute('c:/bin/cltc/cltc.exe')
end)
keymap.set({ 'n', 'c' }, '<F4>', function()
  toggleShellslash()
end)
keymap.set('n', '<C-F9>', function()
  ppcust_load()
end)
keymap.set('n', '<F12>', function()
  -- local wrap = o.wrap ~= true and "wrap" or "nowrap"
  if o.diff == true then
    local cur = api.nvim_win_get_number(0)
    vim.cmd('windo setlocal wrap!|' .. cur .. 'wincmd w')
  else
    vim.cmd('setl wrap! wrap?')
  end
  return ''
end)
keymap.set('n', '<C-z>', '<Nop>')

--@see https://github.com/atusy/dotfiles/blob/main/dot_config/nvim/lua/atusy/init.lua
keymap.set('n', 'Q', 'q')
keymap.set('n', 'q', '<Plug>(q)')
keymap.set('n', '<Plug>(q):', 'q:')
keymap.set('n', '<Plug>(q)/', 'q/')
keymap.set('n', '<Plug>(q)?', 'q?')
keymap.set('n', ',', function()
  if o.hlsearch then
    api.nvim_set_option_value('hlsearch', false, { scope = 'global' })
  else
    api.nvim_feedkeys(',', 'n', false)
  end
end)
keymap.set('n', 'H', 'H<Plug>(H)')
keymap.set('n', 'L', 'L<Plug>(L)')
keymap.set('n', '<Plug>(H)H', '<PageUp>H<Plug>(H)')
keymap.set('n', '<Plug>(L)L', '<PageDown>Lzb<Plug>(L)')
keymap.set('n', '<C-m>', 'i<C-M><ESC>')
keymap.set('n', '/', function()
  api.nvim_set_option_value('hlsearch', true, { scope = 'global' })
  return '/'
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
keymap.set('n', '<Space>n', function()
  local i = 1
  while fn.bufnr(string.format('Scratch%s', tostring(i))) ~= -1 do
    i = i + 1
  end
  vim.cmd.new(string.format('Scratch%s', tostring(i)))
  api.nvim_set_option_value('buftype', 'nofile', { buf = 0 })
  api.nvim_set_option_value('bufhidden', 'wipe', { buf = 0 })
end)
keymap.set('n', '<Space>Q', '<Cmd>bwipeout!<CR>')
keymap.set('n', '<Space>c', '<Cmd>tabclose<CR>')

---Search history of replacement
keymap.set('n', '<Space>/', function()
  refine_substitutions([[\v^\%s\/]])
end)
keymap.set('v', '<Space>/', function()
  refine_substitutions([[\v^('[0-9a-z\<lt>]|\d+),('[0-9a-z\>]|\d+)?s\/]])
end)

---Close nofile|qf|preview window
keymap.set('n', '<Space>z', function()
  if api.nvim_get_option_value('buftype', { buf = 0 }) == 'nofile' then
    return api.nvim_buf_delete(0, { force = true })
  end
  local altnr = fn.bufnr('#')
  if altnr ~= -1 and api.nvim_get_option_value('buftype', { buf = altnr }) == 'nofile' then
    return api.nvim_buf_delete(altnr, { force = true })
  end
  local qfnr = fn.getqflist({ qfbufnr = 0 }).qfbufnr
  if qfnr ~= 0 then
    return api.nvim_buf_delete(qfnr, {})
  end
  util.feedkey('<C-w><C-z>', 'n')
end)

---Insert/Command mode {{{2
keymap.set('i', '<M-j>', '<C-g>U<Down>')
keymap.set('i', '<M-k>', '<C-g>U<Up>')
keymap.set('i', '<M-h>', '<C-g>U<Left>')
keymap.set('i', '<M-l>', '<C-g>U<Right>')
keymap.set('i', '<S-Delete>', '<C-g>U<C-o>D')
keymap.set('i', '<C-k>', '<Delete>')
keymap.set('i', '<C-d>', '<C-g>u<C-o>D')
keymap.set('i', '<C-q>', '<C-r>.')
keymap.set('i', '<C-f>', '<Right>')
keymap.set('i', '<C-b>', '<Left>')
keymap.set('c', '<C-a>', '<Home>')
keymap.set('c', '<C-b>', '<Left>')
keymap.set('!', '<C-v>u', '<C-R>=nr2char(0x)<Left>')

---Visual mode{{{2
---clipbord yank
keymap.set('v', '<C-insert>', '"*y')
keymap.set('v', '<C-delete>', '"*ygvd')
---do not release after range indentation process
keymap.set('x', '<', '<gv')
keymap.set('x', '>', '>gv')
---search for cursor under string without moving cursor
keymap.set('n', '*', function()
  search_star()
end, { expr = true })
keymap.set('n', 'g*', function()
  search_star('g')
end, { expr = true })
keymap.set('x', '*', function()
  search_star(nil, 'v')
end, { expr = true })

---@desc Commands {{{1
api.nvim_create_user_command('BustedThisFile', function() -- {{{2
  local rgx = vim.regex([[\(_spec\)\?\.lua$]])
  local path = string.gsub(vim.fn.expand('%'), '\\', '/')
  path = string.format('%s_spec.lua', path:sub(1, rgx:match_str(path)))
  vim.cmd.PlenaryBustedFile(path)
end, {})

---@desc "Z <filepath>" zoxide query
-- api.nvim_create_user_command('Z', 'execute "lcd " . system("zoxide query " . <q-args>)', { nargs = 1 })

---@desc "UTSetup" Unit-test compose multi-panel
api.nvim_create_user_command('UTSetup', function() -- {{{2
  if vim.b.mug_branch_name == nil then
    return vim.notify('Not a repository', 3)
  end

  os.execute(os.getenv('PPX_DIR') .. '/pptrayw.exe -c *deletecust _WinPos:BT')
  os.execute('wt -w 1 sp -V --size 0.4 ' .. os.getenv('PPX_DIR') .. '/ppbw.exe -bootid:t -k @wt -w 1 mf left')

  local path = vim.fs.normalize(uv.cwd() .. '/t')
  local name = fn.expand('%:t')

  if not name:find('utp_', 1, true) then
    local test_path = vim.fs.normalize('t/utp_' .. name)

    if fn.isdirectory(path) ~= 1 then
      fn.mkdir(path)
    end

    -- vim.cmd('bot split ' .. testpath .. '|set fenc=utf-8|set ff=unix')
    vim.cmd(string.format('bot split %s|set fenc=utf-8|set ff=unix', test_path))
  end
end, {})
api.nvim_create_user_command('UTDo', function(...) -- {{{2
  local args = table.concat((...).fargs, ',')
  os.execute(
    os.getenv('PPX_DIR')
      .. '/pptrayw.exe -c *set unit_test_ppm='
      .. api.nvim_buf_get_name(0)
      .. '%:*cd %*extract(C,"%%1")%:*script %*getcust(S_ppm#plugins:ppm-test)/script/jscript/ppmtest_run.js,'
      .. args
  )
end, { nargs = '*' })

---@desc "JestSetup" Unit-test compose multi-panel
api.nvim_create_user_command('JestSetup', function() -- {{{2
  local has_config = fn.filereadable('jest.config.js') + fn.filereadable('package.json')
  if has_config == 0 then
    vim.notify('Config file not found', 3)
  end

  os.execute('wt -w 1 sp -V --size 0.4 nyagos -k wt -w 1 mf left')

  local symbol = 'test'
  local sym_dir = string.format('__%ss__', symbol)
  local parent_dir = vim.fs.dirname(api.nvim_buf_get_name(0))
  local test_dir = vim.fs.joinpath(parent_dir, sym_dir)
  local name = fn.expand('%:t:r')

  if parent_dir and not parent_dir:find(sym_dir, 1, true) then
    local test_path = string.format('%s/%s.%s.ts', test_dir, name, symbol)
    local insert_string = ''

    if fn.filereadable(test_path) ~= 1 then
      local line1 = "import PPx from '@ppmdev/modules/ppx';"
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
