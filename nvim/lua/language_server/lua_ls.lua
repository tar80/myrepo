local helper = require('helper')

return {
  cmd = { helper.mason_apps('lua-language-server/bin/lua-language-server.exe') },
  -- root_dir = function(fname)
  --   return helper.get_project_root(fname, { '.git', '.luarc.json' })
  -- end,
  single_file_support = false,
  settings = {
    Lua = {
      completion = {
        enable = true,
        callSnippet = 'both',
        showWord = 'Enable',
        -- showWord = 'Disable',
      },
      runtime = {
        version = 'LuaJIT',
        pathStrict = true,
        path = { '?.lua', '?/init.lua' },
      },
      diagnostics = {
        globals = { 'vim', 'nyagos', 'describe', 'before_each', 'setup', 'teardown', 'it' },
      },
      hint = {
        enable = true,
        setType = false,
        arrayIndex = 'Disable',
      },
      workspace = {
        checkThirdParty = 'Disable',
        library = {
          'lua',
          '$VIMRUNTIME/lua/vim',
          '${3rd}/luv/library',
          '${3rd}/busted/library',
          '${3rd}/luassert/library',
        },
      },
    },
  },
}
