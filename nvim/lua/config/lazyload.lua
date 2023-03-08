-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

-- #Lazy load plugins

-- ##Vim-eft {{{2
vim.keymap.set({ 'n', 'x', 'o' }, 'f', '<Plug>(eft-f-repeatable)')
vim.keymap.set({ 'n', 'x', 'o' }, 'F', '<Plug>(eft-F-repeatable)')
vim.keymap.set({ 'n', 'x', 'o' }, 't', '<Plug>(eft-t-repeatable)')
vim.keymap.set({ 'n', 'x', 'o' }, 'T', '<Plug>(eft-T-repeatable)')

-- ##Operator-replace {{{2
-- if pcall(require, 'vim-operator-replace') then
vim.keymap.set('n', '_', '<Plug>(operator-replace)')
vim.keymap.set('n', '\\', '"0<Plug>(operator-replace)')
-- end

-- ##Oparetor-surround {{{2
-- if pcall(require, 'vim-operator-surround') then
vim.g['operator#surround#blocks'] = {
  javascript = { { block = { '${', '}' }, motionwise = { 'char', 'line', 'block' }, keys = { '$', '$' } } },
}
vim.keymap.set('x', '<Leader>r', '<Plug>(operator-surround-replace)')
vim.keymap.set('x', '<Leader>a', '<Plug>(operator-surround-append)')
vim.keymap.set('x', '<Leader>d', '<Plug>(operator-surround-delete)')
vim.keymap.set('n', '<Leader>r', '<Plug>(operator-surround-replace)a')
vim.keymap.set('n', '<Leader>i', '<Plug>(operator-surround-append)i')
vim.keymap.set('n', '<Leader>a', '<Plug>(operator-surround-append)a')
vim.keymap.set('n', '<Leader>d', '<Plug>(operator-surround-delete)a')
-- end

-- ##Smartword {{{2
-- if pcall(require, 'vim-smartword') then
vim.keymap.set('n', 'w', '<Plug>(smartword-w)')
vim.keymap.set('n', 'b', '<Plug>(smartword-b)')
vim.keymap.set('n', 'e', '<Plug>(smartword-e)')
vim.keymap.set('n', 'ge', '<Plug>(smartword-ge)')
-- end

-- ##Nvim-select-multi-line {{{2
-- if pcall(require, 'nvim-select-multi-line') then
vim.keymap.set('n', '<Leader>v', function()
  require('nvim-select-multi-line').start()
end)
-- end

-- ##Translate {{{2
-- if pcall(require, 'translate.nvim') then
vim.keymap.set({ 'n', 'x' }, 'me', '<Cmd>Translate EN<CR>', { silent = true })
vim.keymap.set({ 'n', 'x' }, 'mj', '<Cmd>Translate JA<CR>', { silent = true })
vim.keymap.set({ 'n', 'x' }, 'mE', '<Cmd>Translate EN -output=replace<CR>', { silent = true })
vim.keymap.set({ 'n', 'x' }, 'mJ', '<Cmd>Translate JA -output=replace<CR>', { silent = true })
-- end

-- ##Undotree {{{2
-- if pcall(require, 'undotree') then
vim.keymap.set('n', '<F7>', function()
  vim.fn['undotree#UndotreeToggle']()
end)
vim.g.undotree_WindowLayout = 2
vim.g.undotree_ShortIndicators = 1
vim.g.undotree_SplitWidth = 28
vim.g.undotree_DiffpanelHeight = 6
vim.g.undotree_DiffAutoOpen = 1
vim.g.undotree_SetFocusWhenToggle = 1
vim.g.undotree_TreeNodeShape = '*'
vim.g.undotree_TreeVertShape = '|'
vim.g.undotree_DiffCommand = 'diff'
vim.g.undotree_RelativeTimestamp = 1
vim.g.undotree_HighlightChangedText = 1
vim.g.undotree_HighlightChangedWithSign = 1
vim.g.undotree_HighlightSyntaxAdd = 'DiffAdd'
vim.g.undotree_HighlightSyntaxChange = 'DiffChange'
vim.g.undotree_HighlightSyntaxDel = 'DiffDelete'
vim.g.undotree_HelpLine = 1
vim.g.undotree_CursorLine = 1
-- end

-- ##Luadev {{{2
-- if pcall(require, 'nvim-luadev') then
vim.api.nvim_create_user_command('LuadevRun', function()
  vim.api.nvim_command('Luadev')
  vim.api.nvim_command('wincmd K|resize +5')
  vim.b.loaded_luadev = true
  vim.keymap.set('n', 'gtt', '<Plug>(Luadev-RunLine)', { buffer = true })
  vim.keymap.set('v', 'gtt', '<Plug>(Luadev-Run)', { buffer = true })
  vim.keymap.set('n', 'gtq', function()
    local dev_buf_nr = vim.fn.bufnr(vim.fs.normalize(vim.loop.cwd() .. '/[nvim-lua]'))
    vim.api.nvim_buf_delete(dev_buf_nr, { unload = true })
    vim.keymap.del('n', 'gtq', { buffer = true })
    vim.keymap.del({ 'n', 'v' }, 'gtt', { buffer = true })
    vim.b.loaded_luadev = false
  end, { buffer = true })
end, {})
-- end

-- ##OpenBrowser {{{2
-- if pcall(require, 'open-browser.vim') then
vim.g.openbrowser_open_vim_command = 'split'
vim.g.openbrowser_use_vimproc = 0
vim.keymap.set('n', '<SPACE>/', "<Cmd>call openbrowser#_keymap_smart_search('n')<CR>")
vim.keymap.set('x', '<SPACE>/', "<Cmd>call openbrowser#_keymap_smart_search('v')<CR>")
-- vim.keymap.set({ "n", "x" }, "<SPACE>/", "<Plug>(openbrowser-smart-search)")
-- end

-- ##Colorizer {{{2
-- if pcall(require, 'nvim-colorizer.lua') then
vim.api.nvim_create_user_command('Colorizer', 'packadd nvim-colorizer.lua|ColorizerAttachToBuffer', {})
-- end
