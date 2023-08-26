-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

---@desc INITIAL {{{2
---@Variables {{{2
local api = vim.api
local mapset = vim.keymap.set
local o = vim.o
local opt = vim.opt
local pack_path = 'C:\\bin\\HOME\\.local\\share\\nvim-data\\lazy'

vim.g.update_time = 700

---@desc Unload {{{2
vim.g.loaded_2html_plugin = true
vim.g.loaded_gzip = true
vim.g.loaded_man = true
vim.g.loaded_matchit = true
vim.g.loaded_matchparen = true
vim.g.loaded_netrwPlugin = true
vim.g.loaded_spellfile_plugin = true
vim.g.loaded_tarPlugin = true
vim.g.loaded_tutor_mode_plugin = true
vim.g.loaded_zipPlugin = true
--}}}2

---@desc OPTIONS {{{2
o.guicursor = 'n:block,i-c-ci-ve:ver50,v-r-cr-o:hor50'
o.fileencodings = 'utf-8,utf-16le,cp932,euc-jp,sjis'
o.updatetime = vim.g.update_time
-- o.backup= false
o.swapfile = false
o.undofile = true
o.showtabline = 2
o.laststatus = 3
o.cmdheight = 1
o.number = true
-- o.numberwidth = 4
o.relativenumber = true
o.signcolumn = 'yes'
o.shiftwidth = 2
o.softtabstop = 2
o.shiftround = true
o.expandtab = true
o.virtualedit = 'block'
opt.wildmode = { 'longest:full', 'full' }
opt.wildoptions:remove({ 'tagfile' })
opt.spelllang:append({ 'cjk' })
o.keywordprg = ':help'
o.helplang = 'ja'
o.helpheight = 10
o.previewheight = 8
--}}}2

---@desc AUTOGROUP
api.nvim_create_augroup('rcMinimal', {})

---@desc KEYMAPS {{{2
vim.g.mapleader = ';'

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
mapset('n', '<C-Z>', '<NOP>')
mapset('n', 'q', '<NOP>')
mapset('n', 'Q', 'q')
mapset('n', ',', function()
  if o.hlsearch then
    o.hlsearch = false
  else
    api.nvim_feedkeys(',', 'n', false)
  end
end)
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

---@desc Insert & Command {{{2
mapset('i', '<C-J>', '<DOWN>')
mapset('i', '<C-K>', '<UP>')
mapset('i', '<C-F>', '<RIGHT>')
mapset('i', '<S-DELETE>', '<C-O>D')
mapset('!', '<C-B>', '<LEFT>')
mapset('!', '<C-V>u', '<C-R>=nr2char(0x)<LEFT>')
mapset('c', '<C-A>', '<HOME>')

---@desc Visual {{{2
---clipbord yank
mapset('v', '<C-insert>', '"*y')
mapset('v', '<C-delete>', '"*ygvd')
---do not release after range indentation process
mapset('x', '<', '<gv')
mapset('x', '>', '>gv')
--}}}2

---@desc Commands
---@desc "Z <filepath>" zoxide query
api.nvim_create_user_command('Z', 'execute "lcd " . system("zoxide query " . <q-args>)', { nargs = 1 })

vim.cmd [[set runtimepath=$VIMRUNTIME]]

---@desc TEMPORARY {{{2
local plugin_name = 'telescope.nvim'
opt.runtimepath:append(string.format('%s\\%s', pack_path, 'plenary.nvim'))
opt.runtimepath:append(string.format('%s\\%s', pack_path, plugin_name))

require('telescope').setup()

---@desc COLORSCHEME {{{1
vim.cmd('colorscheme habamax')
