-- vim:textwidth=0:foldmethod=marker:foldlevel=1:

local api = vim.api
local opt = vim.opt
local o = vim.o
local keymap = vim.keymap
local helper = require('helper')

---@desc OPTIONS {{{2
o.guicursor = 'n:block,i-c-ci-ve:ver50,v-r-cr-o:hor50'
o.fileencodings = 'utf-8,cp932,euc-jp,utf-16le'
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
---@desc KEYMAPS
---@desc Normal {{{2
vim.g.mapleader = ';'

keymap.set('n', '<F12>', helper.toggleWrap)
keymap.set('n', '<C-Z>', '<NOP>')
keymap.set('n', ',', function()
  if o.hlsearch then
    o.hlsearch = false
  else
    api.nvim_feedkeys(',', 'n', false)
  end
end)
---Move buffer use <SPACE>
keymap.set('n', '<SPACE>', '<C-W>', { remap = true })
keymap.set('n', '<SPACE><SPACE>', '<C-W><C-W>')
keymap.set('n', '<Space>n', helper.scratch_buffer)
keymap.set('n', '<SPACE>a', '<Cmd>bwipeout<CR>')
keymap.set('n', '<SPACE>c', '<Cmd>tabclose<CR>')

---@desc Insert & Command {{{2
keymap.set('i', '<C-J>', '<DOWN>')
keymap.set('i', '<C-K>', '<UP>')
keymap.set('i', '<C-F>', '<RIGHT>')
keymap.set('i', '<S-DELETE>', '<C-O>D')
keymap.set('!', '<C-B>', '<LEFT>')
keymap.set('!', '<C-V>u', '<C-R>=nr2char(0x)<LEFT>')
keymap.set('c', '<C-A>', '<HOME>')

---@desc Visual {{{2
---clipbord yank
keymap.set('v', '<C-insert>', '"*y')
keymap.set('v', '<C-delete>', '"*ygvd')
---do not release after range indentation process
keymap.set('x', '<', '<gv')
keymap.set('x', '>', '>gv')
--}}}2

---@desc Commands
---@desc "Z <filepath>" zoxide query
api.nvim_create_user_command('Z', 'execute "lcd " . system("zoxide query " . <q-args>)', { nargs = 1 })

---@desc COLORSCHEME {{{1
-- vim.cmd('colorscheme habamax')
