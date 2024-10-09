local k = vim.keycode

vim.fn.setreg('b', string.format([[V:s \//\\%s]], k('<CR>')))
vim.fn.setreg('d', string.format([[V:s \\/\\\\%s]], k('<CR>')))
vim.fn.setreg('s', string.format([[V:s \\\\/\/%s]], k('<CR>')))
vim.fn.setreg('k', string.format([[:let @=@j%s]], k('<Left><Left><Left>')))
