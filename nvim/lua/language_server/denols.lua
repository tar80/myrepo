return {
  cmd = { require('helper').scoop_apps('apps/deno/current/deno.exe'), 'lsp' },
  root_dir = require('lspconfig').util.root_pattern('.git', 'tsconfig.json', 'deno.json', 'deno.jsonc'),
  autostart = true,
  disable_formatting = true,
  filetypes = { 'typescript', 'javascript' },
  settings = {
    deno = {
      inlayHints = {
        parameterNames = { enabled = 'all' },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = false },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
  },
}
