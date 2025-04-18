local helper = require('helper')
local root = helper.mason_apps('lua-language-server')
local lazy_plugins = helper.xdg_path('data', 'lazy')

return {
  cmd = { root .. '/bin/lua-language-server.exe' },
  cmd_cwd = root .. '/bin',
  root_dir = function(fname)
    return helper.get_project_root(fname, { '.git', '.luarc.json', 'stylua.toml' })
  end,
  single_file_support = false,
  settings = { Lua = {} },
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      completion = {
        enable = true,
        callSnippet = 'Replace',
        showWord = 'Enable',
        -- showWord = 'Disable',
      },
      runtime = {
        version = 'LuaJIT',
        pathStrict = false,
        path = { '?.lua', '?/init.lua', '?/types.lua' },
      },
      diagnostics = {
        enable = true,
        globals = { 'vim', 'nyagos', 'describe', 'before_each', 'setup', 'teardown', 'it', 'Snacks', 'dd' },
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
        maxPreload = 2500,
        checkThirdParty = 'Disable',
        ignoreDir = { 'test', 'spec' },
        library = {
          root .. '/locale/ja-jp/meta.lua',
          lazy_plugins .. '/snacks.nvim/lua/snacks/meta',
          '$VIMRUNTIME/lua/vim',
          '$VIMRUNTIME/lua/vim/shared.lua',
          '$VIMRUNTIME/lua/vim/lsp',
          '$VIMRUNTIME/lua/vim/treesitter',
          '${3rd}/luv/library',
          '${3rd}/busted/library',
          '${3rd}/luassert/library',
        },
      },
    })
  end,
}
