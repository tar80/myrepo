-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

---@desc INITIAL
---@Variables {{{2
local util = require('module.util')
---@type any
local uv = vim.uv
local api = vim.api
local cmd = vim.cmd
local o = vim.o
local opt = vim.opt
local mapset = vim.keymap.set

util.shell('nyagos')
vim.env.myvimrc = uv.fs_readlink(vim.env.myvimrc, nil)
vim.g.repo = 'c:/bin/repository/tar80'
vim.g.update_time = 700
cmd('language message C')

local FOLD_SEP = ' » '
local foldmarker = vim.split(api.nvim_get_option_value('foldmarker', { win = 0 }), ',', { plain = true })

---@desc Unload {{{2
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

---@desc OPTIONS
---@desc Global {{{2
api.nvim_set_option_value('termguicolors', true, { scope = 'global' })
api.nvim_set_option_value('foldcolumn', '1', { scope = 'global' })
api.nvim_set_option_value('fileformats', 'unix,dos,mac', { scope = 'global' })
api.nvim_set_option_value('hlsearch', false, { scope = 'global' })
api.nvim_set_option_value('shada', "'50,<500,/10,:100,h", { scope = 'global' })

---@desc Local {{{2
-- api.nvim_set_option_value('name', value, { scope = 'local' })
---NOTE:Avoided a bug in neovim itself that causes errors when colons are mixed in spellfile option
vim.opt_local.isfname:append(':')

---@desc Both {{{2
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
o.lazyredraw = true
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
opt.matchpairs:append({ '【:】', '[:]', '<:>' })
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
--}}}2

---@desc AUTOGROUP
local augroup = api.nvim_create_augroup('rcSettings', {})

---@desc Remove ignore history from cmdline history{{{2
---@see https://blog.atusy.net/2023/07/24/vim-clean-history/
local ignore_history = [=[^\c\(\_[efqw]!\?\|qa!\?\|echo\|mes\|h\s.*\)$]=]
vim.api.nvim_create_autocmd('ModeChanged', {
  pattern = 'c:*',
  group = augroup,
  callback = function()
    local hist = vim.fn.histget('cmd', -1)
    vim.schedule(function()
      if vim.regex(ignore_history):match_str(hist) then
        vim.fn.histdel(':', -1)
      end
    end)
  end,
})
---@desc Delete current line from cmdline-history {{{2
vim.api.nvim_create_autocmd('CmdWinEnter', {
  group = augroup,
  callback = function()
    mapset('n', 'D', function()
      local line = vim.fn.line('.') - vim.fn.line('$')
      vim.fn.histdel(':', line)
      api.nvim_del_current_line()
    end, { buffer = 0 })
  end,
})
vim.api.nvim_create_autocmd('CmdWinLeave', {
  group = augroup,
  callback = function()
    vim.cmd.wshada({ bang = true })
  end,
})
---@desc Editing line highlighting rules {{{2
api.nvim_create_autocmd('CursorHoldI', {
  group = augroup,
  callback = function()
    if vim.bo.filetype ~= 'TelescopePrompt' then
      api.nvim_set_option_value('cursorline', true, { win = 0 })
    end
  end,
})
---NOTE: FocusLost does not work mounted in the WindowsTereminal.
api.nvim_create_autocmd({ 'FocusLost', 'BufLeave' }, {
  group = augroup,
  callback = function()
    if vim.fn.mode() == 'i' and vim.bo.filetype ~= 'TelescopePrompt' then
      api.nvim_set_option_value('cursorline', true, { win = 0 })
    end
  end,
})
api.nvim_create_autocmd({ 'BufEnter', 'CursorMovedI', 'InsertLeave' }, {
  group = augroup,
  command = 'setl nocursorline',
})
---@desc Insert-Mode, we want a longer updatetime {{{2
api.nvim_create_autocmd('InsertEnter', {
  group = augroup,
  command = 'set updatetime=4000',
})
api.nvim_create_autocmd('InsertLeave', {
  group = augroup,
  command = 'setl iminsert=0|execute "set updatetime=" . g:update_time',
})
---@desc Yanked, it shines {{{2
api.nvim_create_autocmd('TextYankPost', {
  group = augroup,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ higroup = 'PmenuSel', on_visual = false, timeout = 150 })
  end,
})
---@desc Supports changing options that affect Simple_fold() {{{2
api.nvim_create_autocmd('OptionSet', {
  group = augroup,
  pattern = 'foldmarker',
  callback = function(opts)
    if opts.match == 'foldmarker' then
      foldmarker = vim.split(api.nvim_get_option_value('foldmarker', { win = 0 }), ',')
    end
  end,
})
--}}}2

---@desc FUNCTIONS
Simple_fold = function() -- {{{2
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

local toggleShellslash = function() -- {{{2
  vim.opt_local.shellslash = not api.nvim_get_option_value('shellslash', { scope = 'global' })
  cmd.redrawstatus()
  cmd.redrawtabline()
end

local search_star = function(g, mode) -- {{{2
  local word
  if mode ~= 'v' then
    word = vim.fn.expand('<cword>')
    word = g == 'g' and word or '\\<' .. word .. '\\>'
  else
    local first = vim.fn.getpos('v')
    local last = vim.fn.getpos('.')
    local lines = vim.fn.getline(first[2], last[2])
    if #lines > 1 then
      -- word = table.concat(api.nvim_buf_get_text(0, first[2] - 1, first[3] - 1, last[2] - 1, last[3], {}))
      return util.feedkey('*', 'n')
    else
      word = lines[1]:sub(first[3], last[3])
    end
    util.feedkey('<ESC>', 'n')
  end
  if vim.v.count > 0 then
    return '*'
  else
    vim.fn.setreg('/', word)
    return vim.cmd('set hlsearch')
  end
end

local ppcust_load = function() -- {{{2
  if vim.bo.filetype ~= 'PPxcfg' then
    vim.notify('Not PPxcfg', 1, {})
    return
  end

  vim.fn.system({ os.getenv('PPX_DIR') .. '\\ppcustw.exe', 'CA', api.nvim_buf_get_name(0) })
  vim.notify('PPcust CA ' .. vim.fn.expand('%:t'), 3)
end ---}}}
local cmd_abbrev = function(key, rep, space) -- {{{2
  ---@see https://zenn.dev/vim_jp/articles/2023-06-30-vim-substitute-tips
  local ignore_space = space and '[getchar(), ""][1].' or ''
  local fmt =
    string.format('<expr> %s getcmdtype().getcmdline() ==# ":%s" ? %s"%s" : "%s"', key, key, ignore_space, rep, key)
  vim.cmd.cnoreabbrev(fmt)
end -- }}}

---@desc ABBREVIATE {{{2
vim.cmd.abbreviate('exoprt', 'export')
vim.cmd.abbreviate('exoper', 'export')
vim.cmd.abbreviate('funcion', 'function')
vim.cmd.abbreviate('fuction', 'function')
vim.cmd.abbreviate('stirng', 'string')
vim.cmd.abbreviate('retrun', 'return')
vim.cmd.abbreviate('filed', 'field')

cmd_abbrev("'<,'>", [['<,'>s///|nohls<Left><Left><Left><Left><Left><Left><Left>]], true)
cmd_abbrev('s', '%s///<Left>', true)
cmd_abbrev('ms', 'MugShow', true)
cmd_abbrev('es', 'e<Space>++enc=cp932 ++ff=dos<CR>')
cmd_abbrev('e8', 'e<Space>++enc=utf-8<CR>')
cmd_abbrev('e16', 'e<Space>++enc=utf-16le ++ff=dos<CR>')
cmd_abbrev('sc', 'set<Space>scb<Space><Bar><Space>wincmd<Space>p<Space><Bar><Space>set<Space>scb<CR>')
cmd_abbrev('scn', 'set<Space>noscb<CR>')
cmd_abbrev('del', [[call<Space>delete(expand('%'))]])
cmd_abbrev('cs', [[execute<Space>'50vsplit'g:repo.'/myrepo/nvim/.cheatsheet'<CR>]])
cmd_abbrev('dd', 'diffthis<Bar>wincmd<Space>p<Bar>diffthis<Bar>wincmd<Space>p<CR>')
cmd_abbrev('dof', 'syntax<Space>enable<Bar>diffoff<CR>')
cmd_abbrev(
  'dor',
  'vert<Space>bel<Space>new<Space>difforg<Bar>set<Space>bt=nofile<Bar>r<Space>++edit<Space>#<Bar>0d_<Bar>windo<Space>diffthis<Bar>wincmd<Space>p<CR>'
)
cmd_abbrev('ht', 'so<Space>$VIMRUNTIME/syntax/hitest.vim', true)
cmd_abbrev('ct', 'so<Space>$VIMRUNTIME/syntax/colortest.vim', true)
cmd_abbrev('hl', "lua<Space>print(require('module.util').hl_at_cursor())<CR>")
cmd_abbrev('shadad', '!rm ~/.local/share/nvim-data/shada/main.shada.tmp*')
---}}}

---@desc KEYMAPS
vim.g.mapleader = ';'

---@desc Normal {{{2
mapset('n', '<F1>', function()
  return os.execute('c:/bin/cltc/cltc.exe')
end)
-- mapset('n', '<F5>', function()
--   if o.diff == true then
--     cmd('diffupdate')
--   end
-- end)
mapset({ 'n', 'c' }, '<F4>', function()
  toggleShellslash()
end)
mapset('n', '<C-F9>', function()
  ppcust_load()
end)
mapset('n', '<F12>', function()
  -- local wrap = o.wrap ~= true and "wrap" or "nowrap"
  if o.diff == true then
    local cur = api.nvim_win_get_number(0)
    cmd('windo setlocal wrap!|' .. cur .. 'wincmd w')
  else
    cmd('setl wrap! wrap?')
  end
  return ''
end)
mapset('n', '<C-z>', '<NOP>')

--@see https://github.com/atusy/dotfiles/blob/787634e1444eb5473a08b9965552eea6942437c1/dot_config/nvim/lua/atusy/init.lua#L173
mapset('n', 'q', '<Nop>')
mapset('n', 'Q', 'q')
mapset('n', 'q', function()
  return vim.fn.reg_recording() == '' and '<Plug>(q)' or 'q'
end, { expr = true })
mapset('n', '<Plug>(q):', 'q:')
mapset('n', '<Plug>(q)/', 'q/')
mapset('n', '<Plug>(q)?', 'q?')
mapset('n', ',', function()
  if o.hlsearch then
    o.hlsearch = false
  else
    api.nvim_feedkeys(',', 'n', false)
  end
end)
mapset('n', '<C-m>', 'i<C-M><ESC>')
mapset('n', '/', function()
  o.hlsearch = true
  return '/'
end, { noremap = true, expr = true })
mapset('n', 'n', "'Nn'[v:searchforward].'zv'", { noremap = true, silent = true, expr = true })
mapset('n', 'N', "'nN'[v:searchforward].'zv'", { noremap = true, silent = true, expr = true })
mapset('c', '<CR>', function()
  local cmdtype = vim.fn.getcmdtype()
  if cmdtype == '/' or cmdtype == '?' then
    return '<CR>zv'
  end
  return '<CR>'
end, { noremap = true, expr = true, silent = true })

---Move buffer use <Space>
mapset('n', '<Space>', '<C-w>', { remap = true })
mapset('n', '<Space><Space>', '<C-w><C-w>')
mapset('n', '<Space>n', function()
  local i = 1
  while vim.fn.bufnr('Scratch' .. i) ~= -1 do
    i = i + 1
  end
  cmd.new('Scratch' .. i)
  api.nvim_set_option_value('buftype', 'nofile', { buf = 0 })
  api.nvim_set_option_value('bufhidden', 'wipe', { buf = 0 })
end)
mapset('n', '<Space>Q', '<Cmd>bwipeout!<CR>')
mapset('n', '<Space>c', '<Cmd>tabclose<CR>')

---Close nofile|qf|preview window
mapset('n', '<Space>z', function()
  if api.nvim_get_option_value('buftype', { buf = 0 }) == 'nofile' then
    return api.nvim_buf_delete(0, { force = true })
  end
  local altnr = vim.fn.bufnr('#')
  if altnr ~= -1 and api.nvim_get_option_value('buftype', { buf = altnr }) == 'nofile' then
    return api.nvim_buf_delete(altnr, { force = true })
  end
  local qfnr = vim.fn.getqflist({ qfbufnr = 0 }).qfbufnr
  if qfnr ~= 0 then
    return api.nvim_buf_delete(qfnr, {})
  end
  util.feedkey('<C-w><C-z>', 'n')
end)

---@desc Insert & Command {{{2
mapset('i', '<S-Delete>', '<C-O>D')
mapset('i', '<M-j>', '<Down>')
mapset('i', '<M-k>', '<Up>')
mapset('i', '<M-h>', '<Left>')
mapset('i', '<M-l>', '<Right>')
mapset('i', '<C-k>', '<Delete>')
mapset('i', '<C-e>', '<C-g>U<End>')
mapset('i', '<C-f>', '<C-g>U<Right>')
mapset('!', '<C-b>', '<C-g>U<Left>')
mapset('!', '<C-v>u', '<C-R>=nr2char(0x)<Left>')
mapset('c', '<C-a>', '<Home>')

---@desc Visual {{{2
---clipbord yank
mapset('v', '<C-insert>', '"*y')
mapset('v', '<C-delete>', '"*ygvd')
---do not release after range indentation process
mapset('x', '<', '<gv')
mapset('x', '>', '>gv')
---search for cursor under string without moving cursor
mapset('n', '*', function()
  search_star()
end, { expr = true })
mapset('n', 'g*', function()
  search_star('g')
end, { expr = true })
mapset('x', '*', function()
  search_star(nil, 'v')
end, { expr = true })
--}}}2

---@desc Commands
api.nvim_create_user_command('Busted', function() -- {{{2
  local path = string.gsub(vim.fn.expand('%'), '\\', '/')
  require('module.busted').run(path)
end, {}) -- }}}

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
  local name = vim.fn.expand('%:t')

  if not name:find('utp_', 1, true) then
    local test_path = vim.fs.normalize('t/utp_' .. name)

    if vim.fn.isdirectory(path) ~= 1 then
      vim.fn.mkdir(path)
    end

    -- cmd('bot split ' .. testpath .. '|set fenc=utf-8|set ff=unix')
    cmd(string.format('bot split %s|set fenc=utf-8|set ff=unix', test_path))
  end
end, {}) -- }}}
api.nvim_create_user_command('UTDo', function(...) -- {{{2
  local args = table.concat((...).fargs, ',')
  os.execute(
    os.getenv('PPX_DIR')
      .. '/pptrayw.exe -c *set unit_test_ppm='
      .. api.nvim_buf_get_name(0)
      .. '%:*cd %*extract(C,"%%1")%:*script %*getcust(S_ppm#plugins:ppm-test)/script/jscript/ppmtest_run.js,'
      .. args
  )
end, { nargs = '*' }) -- }}}

---@desc "JestSetup" Unit-test compose multi-panel
api.nvim_create_user_command('JestSetup', function() -- {{{2
  local has_config = vim.fn.filereadable('jest.config.js') + vim.fn.filereadable('package.json')
  if has_config == 0 then
    vim.notify('Config file not found', 3)
  end

  os.execute('wt -w 1 sp -V --size 0.4 nyagos -k wt -w 1 mf left')

  local symbol = 'test'
  local sym_dir = string.format('__%ss__', symbol)
  local parent_dir = vim.fs.dirname(api.nvim_buf_get_name(0))
  local test_dir = vim.fs.joinpath(parent_dir, sym_dir)
  local name = vim.fn.expand('%:t:r')

  if parent_dir and not parent_dir:find(sym_dir, 1, true) then
    local test_path = string.format('%s/%s.%s.ts', test_dir, name, symbol)
    local insert_string = ''

    if vim.fn.filereadable(test_path) ~= 1 then
      local line1 = "import PPx from '@ppmdev/modules/ppx';"
      local line2 = 'global.PPx = Object.create(PPx)'
      local line3 = string.format("import from '../%s'", vim.fn.expand('%:t:r'))
      insert_string = string.format('|execute "normal! I%s\n%s\n%s\\<Esc>3G06l"', line1, line2, line3)
    end

    if vim.fn.isdirectory(test_dir) ~= 1 then
      vim.fn.mkdir(test_dir)
    end

    api.nvim_command(string.format('bot split %s|set fenc=utf-8|set ff=unix%s', test_path, insert_string))
  end
end, {}) -- }}}
