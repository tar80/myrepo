local helper = require('helper')
local wd = helper.mason_apps('lua-language-server/bin')

return {
  cmd = { wd .. '/lua-language-server.exe' },
  cmd_cwd = wd,
  root_dir = function(fname)
    return helper.get_project_root(fname, { '.git', '.luarc.json', 'stylua.toml' })
  end,
  single_file_support = false,
  settings = {
    Lua = {
      completion = {
        enable = true,
        callSnippet = 'Replace',
        showWord = 'Enable',
        -- showWord = 'Disable',
      },
      runtime = {
        version = 'LuaJIT',
        pathStrict = true,
        path = { '?.lua', '?/init.lua' },
      },
      diagnostics = {
        enable = true,
        globals = { 'vim', 'nyagos', 'describe', 'before_each', 'setup', 'teardown', 'it' },
      },
      format = { enable = false },
      hover = { enable = true },
      semantic = { enable = true },
      signature_help = { enable = true },
      window = { progressBar = true, statusBar = false },
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