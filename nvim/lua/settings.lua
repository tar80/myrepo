-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

---@desc INITIAL
---@Variables {{{2
local util = require('module.util')
local api = vim.api
local mapset = vim.keymap.set
local o = vim.o
local opt = vim.opt

util.shell('nyagos')
vim.env.myvimrc = vim.uv.fs_readlink(vim.env.myvimrc, nil)
-- vim.env.myvimrc = vim.uv.fs_realpath(vim.env.myvimrc)
vim.g.repo = 'c:\\bin\\repository\\tar80'
vim.g.update_time = 700
api.nvim_command('language message C')

local FOLD_SEP = ' » '
local foldmarker = vim.split(api.nvim_win_get_option(0, 'foldmarker'), ',', { plain = true })

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
api.nvim_set_option('termguicolors', true)
api.nvim_set_option('foldcolumn', '1')
api.nvim_set_option('fileformats', 'unix,dos,mac')

---@desc Local {{{2
--api.nvim_buf_set_option(0, "name", value)

---@desc Both {{{2
o.guicursor = 'n:block,i-c-ci-ve:ver50,v-r-cr-o:hor50'
o.fileencodings = 'utf-8,utf-16le,cp932,euc-jp,sjis'
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
o.pumblend = 10
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
api.nvim_create_augroup('rcSettings', {})

---@desc Editing line highlighting rules {{{2
api.nvim_create_autocmd('CursorHoldI', {
  group = 'rcSettings',
  callback = function()
    if vim.bo.filetype ~= 'TelescopePrompt' then
      api.nvim_win_set_option(0, 'cursorline', true)
    end
  end,
})
---NOTE: FocusLost does not work mounted in the WindowsTereminal.
api.nvim_create_autocmd({ 'FocusLost', 'BufLeave' }, {
  group = 'rcSettings',
  callback = function()
    if vim.fn.mode() == 'i' and vim.bo.filetype ~= 'TelescopePrompt' then
      api.nvim_win_set_option(0, 'cursorline', true)
    end
  end,
})
api.nvim_create_autocmd({ 'BufEnter', 'CursorMovedI', 'InsertLeave' }, {
  group = 'rcSettings',
  command = 'setl nocursorline',
})
---@desc Insert-Mode, we want a longer updatetime {{{2
api.nvim_create_autocmd('InsertEnter', {
  group = 'rcSettings',
  command = 'set updatetime=4000',
})
api.nvim_create_autocmd('InsertLeave', {
  group = 'rcSettings',
  command = 'setl iminsert=0|execute "set updatetime=" . g:update_time',
})
---@desc Yanked, it shines {{{2
api.nvim_create_autocmd('TextYankPost', {
  group = 'rcSettings',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ higroup = 'PmenuSel', on_visual = false, timeout = 150 })
  end,
})
---@desc Supports changing options that affect Simple_fold() {{{2
api.nvim_create_autocmd('OptionSet', {
  group = 'rcSettings',
  pattern = 'foldmarker',
  callback = function(opts)
    if opts.match == 'foldmarker' then
      foldmarker = vim.split(api.nvim_win_get_option(0, 'foldmarker'), ',')
    end
  end,
})
--}}}2

---@desc FUNCTIONS
_G.Simple_fold = function() -- {{{2
  ---this code is based on https://github.com/tamton-aquib/essentials.nvim
  local cms = api.nvim_buf_get_option(0, 'commentstring')
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
api.nvim_win_set_option(0, 'foldtext', 'v:lua.Simple_fold()')

local toggleShellslash = function() -- {{{2
  vim.opt_local.shellslash = not api.nvim_get_option('shellslash')
  api.nvim_command('redrawstatus')
  api.nvim_command('redrawtabline')
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
  print('PPcust CA ' .. vim.fn.expand('%:t'))
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

cmd_abbrev("'<,'>", [['<,'>s/\\//\\\\\\\\/|nohlsearch]], true)
cmd_abbrev('s', '%s///<Left>', true)
cmd_abbrev('ms', 'MugShow', true)
cmd_abbrev('e8', 'e<Space>++enc=utf-8<CR>')
cmd_abbrev('e16', 'e<Space>++enc=utf-16le<CR>')
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
---}}}

---@desc KEYMAPS
vim.g.mapleader = ';'

---@desc Normal {{{2
-- mapset('n', '<C-t>', function()
--   ---this code excerpt from essentials.nvim(https://github.com/tamton-aquib/essentials.nvim)
--   local row, col = unpack(api.nvim_win_get_cursor(0))
--   local cword = vim.fn.expand('<cword>')
--   local line = api.nvim_get_current_line()
--   local keycmd = util.getchr() == ' ' and 'v2iwc ' or 'viwc'
--   if cword == 'true' then
--     api.nvim_command(string.format('normal %sfalse', keycmd))
--     api.nvim_win_set_cursor(0, { row, col })
--   elseif cword == 'false' then
--     api.nvim_command(string.format('normal %strue', keycmd))
--     api.nvim_win_set_cursor(0, { row, col })
--   else
--     local t = line:find('true', 1, true) or 10000
--     local f = line:find('false', 1, true) or 10000
--     if (t + f) == 20000 then
--       return
--     end
--     local subs = t < f and line:gsub('true', 'false', 1) or line:gsub('false', 'true', 1)
--     api.nvim_set_current_line(subs)
--   end
-- end)
mapset('n', '<F1>', function()
  return os.execute('c:/bin/cltc/cltc.exe')
end)
mapset('n', '<F5>', function()
  if o.diff == true then
    api.nvim_command('diffupdate')
  end
end)
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
    api.nvim_command('windo setlocal wrap!|' .. cur .. 'wincmd w')
  else
    api.nvim_command('setl wrap! wrap?')
  end
  return ''
end)
mapset('n', '<C-z>', '<NOP>')
mapset('n', 'q', '<NOP>')
mapset('n', 'Q', 'q')
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
  return '/\\V'
end, { noremap = true, expr = true })
mapset('n', 'n', "'Nn'[v:searchforward].'zv'", { noremap = true, silent = true, expr = true })
mapset('n', 'N', "'nN'[v:searchforward].'zv'", { noremap = true, silent = true, expr = true })
if not vim.g.loaded_kensaku_search then
  mapset('c', '<CR>', function()
    local cmdtype = vim.fn.getcmdtype()

    if cmdtype == '/' or cmdtype == '?' then
      return '<CR>zv'
    end

    return '<CR>'
  end, { noremap = true, expr = true, silent = true })
end
---Move buffer use <SPACE>
mapset('n', '<SPACE>', '<C-W>', { remap = true })
mapset('n', '<SPACE><SPACE>', '<C-W><C-W>')
mapset('n', '<SPACE>n', function()
  local i = 1

  while vim.fn.bufnr('Scratch' .. i) ~= -1 do
    i = i + 1
  end

  api.nvim_command('new Scratch' .. i)
  api.nvim_buf_set_option(0, 'buftype', 'nofile')
  api.nvim_buf_set_option(0, 'bufhidden', 'wipe')
end)
mapset('n', '<SPACE>a', '<Cmd>bwipeout<CR>')
mapset('n', '<SPACE>c', '<Cmd>tabclose<CR>')
---close nofile|qf|preview window
mapset('n', '<SPACE>z', function()
  local altnr = vim.fn.bufnr('#')
  if altnr ~= -1 and api.nvim_buf_get_option(altnr, 'buftype') == 'nofile' then
    return api.nvim_buf_delete(altnr, { force = true })
  end
  local qfnr = vim.fn.getqflist({ qfbufnr = 0 }).qfbufnr
  if qfnr ~= 0 then
    return api.nvim_buf_delete(qfnr, {})
  end
  util.feedkey('<C-w><C-z>', 'n')
end)

---@desc Insert & Command {{{2
mapset('i', '<M-j>', '<DOWN>')
mapset('i', '<M-k>', '<UP>')
mapset('i', '<C-l>', '<DELETE>')
mapset('i', '<C-f>', '<RIGHT>')
mapset('i', '<S-DELETE>', '<C-O>D')
mapset('!', '<C-b>', '<LEFT>')
mapset('!', '<C-v>u', '<C-R>=nr2char(0x)<LEFT>')
mapset('c', '<C-a>', '<HOME>')

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

---@desc "G <subcommand>" git
api.nvim_create_user_command('G', '!git -c core.editor=false <args>', { nargs = 1 })

---@desc "Z <filepath>" zoxide query
api.nvim_create_user_command('Z', 'execute "lcd " . system("zoxide query " . <q-args>)', { nargs = 1 })

---@desc "UTSetup" Unit-test compose multi-panel
api.nvim_create_user_command('UTSetup', function() -- {{{2
  if vim.b.mug_branch_name == nil then
    return print('Not a repository')
  end

  os.execute(os.getenv('PPX_DIR') .. '/pptrayw.exe -c *deletecust _WinPos:BT')
  os.execute('wt -w 1 sp -V --size 0.4 ' .. os.getenv('PPX_DIR') .. '/ppbw.exe -bootid:t -k @wt -w 1 mf left')

  local path = vim.fs.normalize(vim.uv.cwd() .. '/t')
  local name = vim.fn.expand('%:t')

  if not name:find('utp_', 1, 'plain') then
    local testpath = vim.fs.normalize('t/utp_' .. name)

    if vim.fn.isdirectory(path) ~= 1 then
      vim.fn.mkdir(path)
    end

    api.nvim_command('bot split ' .. testpath .. '|set fenc=utf-8|set ff=unix')
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
    print('Config file not found')
  end

  os.execute('wt -w 1 sp -V --size 0.4 nyagos -k wt -w 1 mf left')

  local symbol = 'test'
  local sym_dir = string.format('__%ss__', symbol)
  local parent = vim.fs.dirname(api.nvim_buf_get_name(0))
  local test_dir = vim.fs.joinpath(parent, sym_dir)
  local name = vim.fn.expand('%:t:r')

  if not parent:find(sym_dir, 1, true) then
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
