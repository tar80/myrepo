vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { buffer = true })
vim.keymap.set('t', '<C-q>', function()
  vim.api.nvim_command('bwipeout!')
end, { buffer = true })
