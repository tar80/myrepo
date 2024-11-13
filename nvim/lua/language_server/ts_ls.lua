local inlayHints = {
  includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all';
  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  includeInlayEnumMemberValueHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayVariableTypeHints = false,
  includeInlayVariableTypeHintsWhenTypeMatchesName = true,
}

return {
  cmd = {
    require('helper').mason_apps('typescript-language-server/node_modules/.bin/typescript-language-server.cmd'),
    '--stdio',
  },
  root_dir = require('lspconfig').util.root_pattern('.git', 'tsconfig.json'),
  init_options = { hostInfo = 'neovim' },
  autostart = true,
  single_file_support = false,
  filetypes = { 'typescript', 'javascript' },
  disable_formatting = true,
  settings = {
    javascript = {
      inlayHints = inlayHints,
    },
    typescript = {
      inlayHints = inlayHints,
    },
  },
}
