-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

local util = require('module.util')

---#VARIABLES
vim.env.myvimrc = vim.loop.fs_readlink(vim.env.myvimrc, nil)
-- vim.env.myvimrc = vim.loop.fs_realpath(vim.env.myvimrc)
vim.g.repo = 'c:\\bin\\repository\\tar80'
vim.g.update_time = 700
vim.api.nvim_command('language message C')

local FOLD_SEP = ' » '
local foldmarker = vim.split(vim.api.nvim_win_get_option(0, 'foldmarker'), ',', { plain = true })
local tab2space = (' '):rep(vim.api.nvim_buf_get_option(0, 'tabstop'))
local cms

---NOTE: leave it to lazy.nvim
---##Unload {{{2
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

---#OPTIONS
---##Global {{{2
vim.api.nvim_set_option('termguicolors', true)
vim.api.nvim_set_option('foldcolumn', '1')
vim.api.nvim_set_option('fileformats', 'unix,dos,mac')

---##Local {{{2
--vim.api.nvim_buf_set_option(0, "name", value)

---##Both {{{2
vim.o.fileencodings = 'utf-8,utf-16le,cp932,euc-jp,sjis'
-- vim.o.timeoutlen = 1000
vim.o.updatetime = vim.g.update_time
-- vim.o.autochdir = true
-- vim.opt.diffopt:append({"iwhite"})
vim.o.diffopt = 'vertical,filler,iwhite,iwhiteeol,closeoff,indent-heuristic,algorithm:histogram'
-- vim.o.backup= false
vim.o.swapfile = false
vim.o.undofile = true
vim.o.history = 300
-- vim.o.ambiwidth = 'single'
vim.o.gdefault = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.formatoptions = 'mMjql'
vim.o.wrap = false
vim.o.wrapscan = false
vim.o.whichwrap = '<,>,[,],h,l'
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.showbreak = '>>'
vim.o.scrolloff = 1
vim.o.sidescroll = 6
vim.o.sidescrolloff = 3
vim.o.lazyredraw = true
vim.o.list = true
vim.opt.listchars = { tab = '| ', extends = '<', precedes = '>', trail = '_' }
vim.o.confirm = true
-- vim.o.display = 'lastline'
vim.o.showmode = false
vim.o.showtabline = 2
vim.o.laststatus = 3
vim.o.cmdheight = 1
vim.o.number = true
-- vim.o.numberwidth = 4
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
-- vim.o.backspace = { indent = true,eol = true, start = true }
vim.o.complete = '.,w'
vim.opt.completeopt = { menu = true, menuone = true, noselect = true }
vim.o.winblend = 6
vim.o.pumblend = 6
vim.o.pumheight = 10
vim.o.pumwidth = 20
vim.o.matchtime = 2
vim.opt.matchpairs:append({ '【:】', '[:]', '<:>' })
-- vim.cmd[[set tabstop<]]
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.shiftround = true
vim.o.expandtab = true
vim.o.virtualedit = 'block'
-- vim.o.wildmenu = true
vim.opt.wildmode = { 'longest:full', 'full' }
vim.opt.wildoptions:remove({ 'tagfile' })
vim.opt.spelllang:append({ 'cjk' })
vim.opt.shortmess:append('cs')
vim.opt.shortmess:remove({ 'F' })
-- vim.opt.fillchars = { vert = "█", vertleft = "█", vertright = "█", verthoriz = "█", horiz = "█", horizup = "█", horizdown = "█", }
vim.opt.fillchars = { diff = ' ' }
vim.o.keywordprg = ':help'
vim.o.helplang = 'ja'
vim.o.helpheight = 10
vim.o.previewheight = 8
vim.opt.path = { '.', '' }
--}}}2

---#AUTOGROUP
vim.api.nvim_create_augroup('rcSettings', {})

---##Editing line highlighting rules {{{2
vim.api.nvim_create_autocmd('CursorHoldI', {
  group = 'rcSettings',
  callback = function()
    if vim.bo.filetype ~= 'TelescopePrompt' then
      vim.api.nvim_win_set_option(0, 'cursorline', true)
    end
  end,
})
---NOTE: FocusLost does not work mounted in the WindowsTereminal.
vim.api.nvim_create_autocmd({ 'FocusLost', 'BufLeave' }, {
  group = 'rcSettings',
  callback = function()
    if vim.fn.mode() == 'i' and vim.bo.filetype ~= 'TelescopePrompt' then
      vim.api.nvim_win_set_option(0, 'cursorline', true)
    end
  end,
})
vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorMovedI', 'InsertLeave' }, {
  group = 'rcSettings',
  command = 'setl nocursorline',
})
---##In Insert-Mode, we want a longer updatetime {{{2
vim.api.nvim_create_autocmd('InsertEnter', {
  group = 'rcSettings',
  command = 'set updatetime=4000',
})
vim.api.nvim_create_autocmd('InsertLeave', {
  group = 'rcSettings',
  command = 'setl iminsert=0|execute "set updatetime=" . g:update_time',
})
---##Yanked, it shines {{{2
vim.api.nvim_create_autocmd('TextYankPost', {
  group = 'rcSettings',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ higroup = 'PmenuSel', on_visual = false, timeout = 150 })
  end,
})
---##Supports changing options that affect Simple_fold() {{{2
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = 'rcSettings',
  callback = function()
    cms = vim.api.nvim_buf_get_option(0, 'commentstring')
    cms = cms:gsub('(%S+)%s*%%s.*', '%1%%s*')
  end,
})
vim.api.nvim_create_autocmd('OptionSet', {
  group = 'rcSettings',
  pattern = { 'tabstop', 'foldmarker' },
  callback = function(opts)
    if opts.match == 'tabstop' then
      tab2space = (' '):rep(vim.api.nvim_buf_get_option(0, 'tabstop'))
    elseif opts.match == 'foldmarker' then
      foldmarker = vim.split(vim.api.nvim_win_get_option(0, 'foldmarker'), ',')
    end
  end,
})
--}}}2

---#FUNCTIONS
---this code is based on https://github.com/tamton-aquib/essentials.nvim
_G.Simple_fold = function() -- {{{2
  local open, close = vim.api.nvim_get_vvar('foldstart'), vim.api.nvim_get_vvar('foldend')
  local line_count = close - open .. ': '
  local forward = unpack(vim.api.nvim_buf_get_lines(0, open - 1, open, false))
  forward = forward:gsub(cms .. foldmarker[1] .. '%d*', '')
  local backward = unpack(vim.api.nvim_buf_get_lines(0, close - 1, close, false))
  backward = backward:find(foldmarker[2], 1, true) and backward:sub(#backward) or ''
  local linewise = (line_count .. forward .. FOLD_SEP .. backward):gsub('\t', tab2space)
  local spaces = (' '):rep(vim.o.columns - #linewise)

  return linewise .. spaces
end
vim.api.nvim_win_set_option(0, 'foldtext', 'v:lua.Simple_fold()')

local toggleShellslash = function() -- {{{2
  vim.opt_local.shellslash = not vim.api.nvim_get_option('shellslash')
  vim.api.nvim_command('redrawstatus')
  vim.api.nvim_command('redrawtabline')
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
      -- word = table.concat(vim.api.nvim_buf_get_text(0, first[2] - 1, first[3] - 1, last[2] - 1, last[3], {}))
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

  vim.fn.system({ os.getenv('PPX_DIR') .. '\\ppcustw.exe', 'CA', vim.api.nvim_buf_get_name(0) })
  print('PPcust CA ' .. vim.fn.expand('%:t'))
end

---#KEYMAPS
vim.g.mapleader = ';'

---##Normal {{{2
vim.keymap.set('n', '<leader>t', function()
  ---this code excerpt from essentials.nvim(https://github.com/tamton-aquib/essentials.nvim)
  local cword = vim.fn.expand('<cword>')
  local line = vim.api.nvim_get_current_line()
  if cword == 'true' then
    vim.api.nvim_command('normal viwcfalse')
  elseif cword == 'false' then
    vim.api.nvim_command('normal viwctrue')
  else
    local t = line:find('true', 1, true) or 1000
    local f = line:find('false', 1, true) or 1000
    if (t + f) == 2000 then
      return
    end
    local subs = t < f and line:gsub('true', 'false', 1) or line:gsub('false', 'true', 1)
    vim.api.nvim_set_current_line(subs)
  end
end)
vim.keymap.set('n', '<F1>', function()
  return os.execute('c:/bin/cltc/cltc.exe')
end)
vim.keymap.set('n', '<F5>', function()
  if vim.o.diff == true then
    vim.api.nvim_command('diffupdate')
  end
end)
vim.keymap.set({ 'n', 'c' }, '<F4>', function()
  toggleShellslash()
end)
vim.keymap.set('n', '<C-F9>', function()
  ppcust_load()
end)
vim.keymap.set('n', '<F12>', function()
  -- local wrap = vim.o.wrap ~= true and "wrap" or "nowrap"
  if vim.o.diff == true then
    local cur = vim.api.nvim_win_get_number(0)
    vim.api.nvim_command('windo setlocal wrap!|' .. cur .. 'wincmd w')
  else
    vim.api.nvim_command('setl wrap! wrap?')
  end
  return ''
end)
vim.keymap.set('n', '<C-Z>', '<NOP>')
vim.keymap.set('n', 'q', '<NOP>')
vim.keymap.set('n', 'Q', 'q')
vim.keymap.set('n', ',', function()
  if vim.o.hlsearch then
    vim.o.hlsearch = false
  else
    vim.api.nvim_feedkeys(',', 'n', false)
  end
end)
vim.keymap.set('n', '<C-J>', 'i<C-M><ESC>')
vim.keymap.set('n', '/', function()
  vim.o.hlsearch = true
  return '/'
end, { expr = true })
---Move buffer use <SPACE>
vim.keymap.set('n', '<SPACE>', '<C-W>', { remap = true })
vim.keymap.set('n', '<SPACE><SPACE>', '<C-W><C-W>')
vim.keymap.set('n', '<SPACE>n', function()
  local i = 1

  while vim.fn.bufnr('Scratch' .. i) ~= -1 do
    i = i + 1
  end

  vim.api.nvim_command('new Scratch' .. i)
  vim.api.nvim_buf_set_option(0, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(0, 'bufhidden', 'wipe')
end)
vim.keymap.set('n', '<SPACE>a', '<Cmd>bwipeout<CR>')
vim.keymap.set('n', '<SPACE>c', '<Cmd>tabclose<CR>')
---close nofile|qf|preview window
vim.keymap.set('n', '<SPACE>z', function()
  local altnr = vim.fn.bufnr('#')
  if altnr ~= -1 and vim.api.nvim_buf_get_option(altnr, 'buftype') == 'nofile' then
    return vim.api.nvim_buf_delete(altnr, { force = true })
  end
  local qfnr = vim.fn.getqflist({ qfbufnr = 0 }).qfbufnr
  if qfnr ~= 0 then
    return vim.api.nvim_buf_delete(qfnr, {})
  end
  util.feedkey('<C-w><C-z>', 'n')
end)

---##Insert & Command {{{2
vim.keymap.set('i', '<C-J>', '<DOWN>')
vim.keymap.set('i', '<C-K>', '<UP>')
vim.keymap.set('i', '<C-L>', '<DELETE>')
vim.keymap.set('i', '<C-F>', '<RIGHT>')
vim.keymap.set('i', '<S-DELETE>', '<C-O>D')
vim.keymap.set('!', '<C-B>', '<LEFT>')
vim.keymap.set('!', '<C-V>u', '<C-R>=nr2char(0x)<LEFT>')
vim.keymap.set('c', '<C-A>', '<HOME>')

---##Visual {{{2
---clipbord yank
vim.keymap.set('v', '<C-insert>', '"*y')
vim.keymap.set('v', '<C-delete>', '"*ygvd')
---do not release after range indentation process
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')
---search for cursor under string without moving cursor
vim.keymap.set('n', '*', function()
  search_star()
end, { expr = true })
vim.keymap.set('n', 'g*', function()
  search_star('g')
end, { expr = true })
vim.keymap.set('x', '*', function()
  search_star(nil, 'v')
end, { expr = true })
--}}}2

---##Commands
---##"Busted" {{{2
vim.api.nvim_create_user_command('Busted', function()
  local path = string.gsub(vim.fn.expand('%'), '\\', '/')
  require('module.busted').run(path)
end, {})

---#"Z <filepath>" zoxide query {{{2
vim.api.nvim_create_user_command('Z', 'execute "lcd " . system("zoxide query " . <q-args>)', { nargs = 1 })

---#"UTSetup" Unit-test compose multi-panel {{{2
vim.api.nvim_create_user_command('UTSetup', function()
  if vim.b.mug_branch_name == nil then
    return print('Not repository')
  end

  os.execute(os.getenv('PPX_DIR') .. '/pptrayw.exe -c *deletecust _WinPos:BT')
  os.execute('wt -w 1 sp -V --size 0.4 ' .. os.getenv('PPX_DIR') .. '/ppbw.exe -bootid:t -k @wt -w 1 mf left')

  local path = vim.fs.normalize(vim.loop.cwd() .. '/t')
  local name = vim.fn.expand('%:t')

  if not name:find('utp_', 1, 'plain') then
    local testpath = vim.fs.normalize('t/utp_' .. name)

    if vim.fn.isdirectory(path) ~= 1 then
      vim.fn.mkdir(path)
    end

    vim.api.nvim_command('bot split ' .. testpath .. '|set fenc=utf-8|set ff=unix')
  end
end, {})

-- #"UTDo <arguments>" Unit-test doing {{{2
vim.api.nvim_create_user_command('UTDo', function(...)
  local args = table.concat((...).fargs, ',')
  os.execute(
    os.getenv('PPX_DIR')
      .. '/pptrayw.exe -c *set unit_test_ppm='
      .. vim.api.nvim_buf_get_name(0)
      .. '%:*cd %*extract(C,"%%1")%:*script %*getcust(S_ppm#plugins:ppm-test)/script/jscript/ppmtest_run.js,'
      .. args
  )
end, { nargs = '*' })

---##Shell
util.shell('nyagos')
