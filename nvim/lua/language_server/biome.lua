return {
  cmd = { require('helper').scoop_apps('apps/biome/current/biome.exe'), 'lsp-proxy' },
  root_dir = require('lspconfig').util.root_pattern('biome.json', 'biome.jsonc'),
  autostart = true,
  single_file_support = false,
  capabilities = vim.NIL,
  -- filetypes = { 'typescript', 'javascript', 'json', 'jsonc', 'css' },
  filetypes = { 'json', 'jsonc', 'css' },
}
