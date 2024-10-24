-- vim:textwidth=0:foldmethod=marker:foldlevel=1
--------------------------------------------------------------------------------
local api = vim.api
local lsp = vim.lsp
local keymap = vim.keymap
local util = require('module.util')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local BORDER = 'rounded'
local SIGNS = { Error = '', Warn = '', Hint = '', Info = '' }
local define_signs = (function()
  local o = { text = {}, linehl = {}, numhl = {} }
  for name, symbol in pairs(SIGNS) do
    local key = vim.diagnostic.severity[name:upper()]
    o.text[key] = symbol
    o.numhl[key] = string.format('DiagnosticSign%s', name)
    -- s.linehl[key] = 'NONE'
  end
  return o
end)()

---@desc Options
lsp.set_log_level = 'OFF'
lsp.handlers['textDocument/hover'] = lsp.with(lsp.handlers.hover, { border = BORDER })
lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, { border = BORDER })
vim.diagnostic.config({ -- {{{2
  virtual_text = false,
  severity_sort = true,
  float = {
    focusable = true,
    style = 'minimal',
    border = BORDER,
    source = false,
    header = '',
    prefix = '',
    suffix = '',
    format = function(diagnostic)
      local symbol = { [1] = SIGNS.Error, [2] = SIGNS.Warn, [3] = SIGNS.Info, [4] = SIGNS.Hint }
      return string.format('%s %s (%s)', symbol[diagnostic.severity], diagnostic.message, diagnostic.source)
    end,
  },
  signs = define_signs,
  update_in_insert = false,
})

---@desc Functions {{{1
local function has_client() -- {{{2
  if #lsp.get_clients({ bufnr = 0 }) == 0 then
    vim.notify_once('Language server is not attached this buffer', vim.log.levels.WARN)
    return false
  end
  return true
end

local function popup_rename() -- {{{2
  if not has_client() then
    return
  end
  local adjust_cursor = util.getchr():match('[^%w]')
  local title = 'Lsp-rename'
  if adjust_cursor then
    vim.cmd.normal('h')
  end
  local rename_old = vim.fn.expand('<cword>')
  if adjust_cursor or not util.has_words_before() then
    vim.cmd.normal('l')
  end
  local contents = function()
    return rename_old
  end
  local post = function()
    keymap.set('i', '<CR>', function()
      vim.cmd.stopinsert({ bang = true })
      local input = api.nvim_get_current_line()
      local msg = string.format('%s -> %s', rename_old, input)
      api.nvim_win_close(0, false)
      lsp.buf.rename(vim.trim(input))
      vim.notify(msg, 2, { title = title })
    end, { buffer = true })
  end
  require('mug.module.float').input({
    title = title,
    width = math.max(25, #rename_old + 8),
    border = 'double',
    relative = 'cursor',
    contents = contents,
    post = post,
  })
end

local augroup = api.nvim_create_augroup('rcLsp', {})

local au_id = {}
local function _on_attach(client, bufnr) --- {{{2
  ---@desc Under cursor Symbol highlight -- {{{
  au_id.hold = api.nvim_create_autocmd({ 'CursorHold' }, {
    desc = 'Set document highlighting',
    group = augroup,
    buffer = 0,
    callback = function()
      if has_client() then
        lsp.buf.document_highlight()
      end
    end,
  })
  au_id.moved = api.nvim_create_autocmd({ 'CursorMoved' }, {
    desc = 'Clear references highlighting',
    group = augroup,
    buffer = 0,
    callback = function()
      lsp.buf.clear_references()
    end,
  }) ---}}}
  ---@desc Keymap {{{3
  keymap.set('n', ']d', function()
    vim.diagnostic.jump({ count = 1, float = true })
  end)
  keymap.set('n', '[d', function()
    vim.diagnostic.jump({ count = -1, float = true })
  end)
  keymap.set('n', 'gla', lsp.buf.code_action, { desc = 'Lsp code action' })
  keymap.set('n', 'gld', function() -- {{{
    local opts = { bufnr = 0, focusable = false }
    local opts_cursor = vim.tbl_extend('force', opts, { scope = 'cursor' })
    local winblend = api.nvim_get_option_value('winblend', {})
    api.nvim_set_option_value('winblend', 0, {})
    local resp = vim.diagnostic.open_float(opts_cursor, {})
    if not resp then
      local opts_line = vim.tbl_extend('force', opts, { scope = 'line' })
      vim.diagnostic.open_float(opts_line, {})
    end

    api.nvim_set_option_value('winblend', winblend, {})
  end, { desc = 'Lsp diagnostic' }) -- }}}
  keymap.set('n', 'glh', lsp.buf.signature_help, { desc = 'Lsp signature help' })
  keymap.set('n', 'gli', function() -- {{{
    if not has_client() then
      return
    end
    if client.supports_method('textDocument/inlayHint') then
      local toggle = not lsp.inlay_hint.is_enabled({ bufnr = bufnr })
      lsp.inlay_hint.enable(toggle)
    end
  end, { desc = 'Lsp inlay hints' }) -- }}}
  keymap.set('n', 'gll', lsp.buf.hover, { desc = 'Lsp hover' })
  keymap.set('n', 'glr', popup_rename, { desc = 'Lsp popup rename' })
  keymap.set('n', 'glv', function() -- {{{
    if not has_client() then
      return
    end
    local toggle = not vim.diagnostic.config().virtual_text
    vim.diagnostic.config({ virtual_text = toggle })
  end, { desc = 'Lsp virtual text' }) -- }}}

  ---@desc trouble.nvim
  local trouble_api = require('trouble.api')

  keymap.set('n', 'gd', function() -- {{{lsp
    local pos = { api.nvim_win_get_cursor(0) }
    vim.cmd.normal({ 'gd', bang = true })
    if not vim.deep_equal(pos, { api.nvim_win_get_cursor(0) }) or not has_client() then
      return
    end
    lsp.buf.definition({
      reuse_win = true,
      on_list = function(opts)
        local item1 = opts.items[1]
        if #opts.items == 2 then
          local item2 = opts.items[2]

          if item1.filename == item2.filename and item1.lnum == item2.lnum then
            local filename = util.normalize(item1.filename)
            if filename ~= util.normalize(api.nvim_buf_get_name(0)) then
              vim.cmd.edit(filename)
            end

            api.nvim_win_set_cursor(0, { item1.lnum, item1.col })
            return
          end
        end
        trouble_api.open('lsp_definitions')
      end,
    })
  end, { desc = 'Trouble definitions' }) -- }}}
  keymap.set('n', 'gle', function()
    trouble_api.toggle('diagnostics_buffer')
  end, { desc = 'Trouble diagnostics' })
  keymap.set('n', 'glk', function()
    trouble_api.toggle('lsp_references')
  end, { desc = 'Trouble references' })

  ---@desc map automatically added by lsp
  ---@see https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp.lua (#lsp._set_defaults())
  keymap.del('n', 'K', { buffer = bufnr })
  ---}}}3
end

local function _on_detach() -- {{{2
  vim.schedule(function()
    api.nvim_del_autocmd(au_id.hold)
    api.nvim_del_autocmd(au_id.moved)
    keymap.del('n', 'gla')
    keymap.del('n', 'gld')
    keymap.del('n', 'glh')
    keymap.del('n', 'gli')
    keymap.del('n', 'gll')
    keymap.del('n', 'glr')
    keymap.del('n', 'glv')
    keymap.del('n', 'gle')
    keymap.del('n', 'glk')
    keymap.del('n', 'gd')
  end)
end -- }}}
---@desc lspconfig {{{2
local flags = {
  allow_incremental_sync = false,
  debounce_text_changes = 500,
}
local lspconfig = require('lspconfig')
require('lspconfig.ui.windows').default_options.border = 'rounded'
lspconfig.biome.setup({ -- {{{3
  cmd = { util.scoop_apps('apps/biome/current/biome.exe'), 'lsp-proxy' },
  autostart = true,
  flags = flags,
  single_file_support = false,
  root_dir = lspconfig.util.root_pattern('biome.json', 'biome.jsonc'),
  filetypes = { 'typescript', 'javascript', 'json', 'jsonc', 'css' },
  -- on_attach = function()
  --   local id
  --   id = api.nvim_create_autocmd('User', {
  --     desc = 'Stop lsp-proxy',
  --     group = augroup,
  --     pattern = 'LspStop',
  --     callback = function()
  --       -- vim.notify('Stop biome lsp-proxy', vim.log.levels.WARN)
  --       vim.cmd(string.format('!%s/bin/biome.CMD stop', vim.env.MASON))
  --       api.nvim_del_autocmd(id)
  --     end,
  --   })
  -- end,
}) -- }}}
local inlayHints = {-- ts_ls {{{3
  includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all';
  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  includeInlayEnumMemberValueHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayVariableTypeHints = false,
  includeInlayVariableTypeHintsWhenTypeMatchesName = true,
}
lspconfig.ts_ls.setup({
  cmd = {
    util.mason_apps('typescript-language-server/node_modules/.bin/typescript-language-server.cmd'),
    '--stdio',
  },
  init_options = { hostInfo = 'neovim' },
  flags = flags,
  autostart = true,
  single_file_support = false,
  root_dir = lspconfig.util.root_pattern('.git', 'tsconfig.json'),
  filetypes = { 'typescript', 'javascript' },
  on_attach = _on_attach,
  on_exit = _on_detach,
  capabilities = capabilities,
  disable_formatting = true,
  settings = {
    javascript = {
      inlayHints = inlayHints,
    },
    typescript = {
      inlayHints = inlayHints,
    },
  },
})-- }}}
-- lspconfig.denols.setup({ -- {{{3
--   cmd = { util.scoop_apps('apps/deno/current/deno.exe'), 'lsp' },
--   flags = flags,
--   autostart = true,
--   root_dir = lspconfig.util.root_pattern('.git', 'tsconfig.json', 'deno.json', 'deno.jsonc'),
--   filetypes = { 'typescript', 'javascript' },
--   on_attach = _on_attach,
--   on_exit = _on_detach,
--   capabilities = capabilities,
--   disable_formatting = true,
--   settings = {
--     deno = {
--       inlayHints = {
--         parameterNames = { enabled = 'all' },
--         parameterTypes = { enabled = true },
--         variableTypes = { enabled = false },
--         propertyDeclarationTypes = { enabled = true },
--         functionLikeReturnTypes = { enabled = true },
--         enumMemberValues = { enabled = true },
--       },
--     },
--   },
-- }) -- }}}
lspconfig.lua_ls.setup({ -- {{{3
  cmd = { util.mason_apps('lua-language-server/bin/lua-language-server.exe') },
  flags = flags,
  single_file_support = false,
  root_dir = lspconfig.util.root_pattern('.git', 'luarc.json'),
  on_attach = _on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      completion = {
        enable = true,
        callSnippet = 'both',
        showWord = 'Disable',
      },
      runtime = {
        version = 'LuaJIT',
        pathStrict = true,
        path = { '?.lua', '?/init.lua' },
      },
      diagnostics = {
        globals = { 'vim', 'nyagos' },
      },
      hint = {
        enable = true,
        setType = false,
        arrayIndex = 'Disable',
      },
      workspace = {
        checkThirdParty = 'Disable',
        library = {
          '$VIMRUNTIME/lua/vim',
          '${3rd}/luv/library',
          '${3rd}/busted/library',
          '${3rd}/luassert/library',
        },
      },
    },
  },
}) -- }}}
lspconfig.vimls.setup({ -- {{{3
  cmd = {
    util.mason_apps('vim-language-server/node_modules/.bin/vim-language-server.cmd'),
    '--stdio',
  },
  flags = flags,
  on_attach = _on_attach,
  on_exit = _on_detach,
  capabilities = capabilities,
}) -- }}}
---@desc None_ls {{{2
local null_ls = require('null-ls')
local attach_filetypes = { 'text', 'markdown' }
null_ls.setup({ -- {{{3
  debounce = 500,
  on_attach = function(client, bufnr)
    keymap.set('n', 'gla', function()
      lsp.buf.code_action({ apply = true, bufnr = bufnr })
    end, { desc = 'Lsp code action' })
  end,
  root_dir = lspconfig.util.find_git_ancestor,
  should_attach = function(bufnr)
    local ft = vim.bo[bufnr].filetype
    if ft == 'markdown' and api.nvim_buf_get_name(bufnr):find('futago://chat', 1, true) then
      return
    end
    return vim.tbl_contains(attach_filetypes, ft)
  end,
  temp_dir = vim.fn.tempname():gsub('^(.+)[/\\].*', '%1'),
  sources = {
    null_ls.builtins.diagnostics.markdownlint.with({
      filetypes = { 'markdown' },
      extra_args = { '--config', vim.fn.expand(vim.g.repo .. '/myrepo/.markdownlint.yaml') },
      diagnostic_config = {
        virtual_text = {
          format = function(diagnostic)
            return string.format('%s: %s', diagnostic.source, diagnostic.code)
          end,
        },
      },
    }),
    null_ls.builtins.diagnostics.textlint.with({
      filetypes = { 'text', 'markdown' },
      extra_args = { '--no-color', '--config', vim.fn.expand(vim.g.repo .. '/myrepo/.textlintrc.json') },
      diagnostic_config = {
        virtual_text = {
          format = function(diagnostic)
            return string.format('%s: [%s] %s', diagnostic.source, diagnostic.code, diagnostic.message)
          end,
        },
        signs = false,
      },
      method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
    }),
    null_ls.builtins.code_actions.textlint.with({
      extra_args = { '--no-color', '--config', vim.fn.expand(vim.g.repo .. '/myrepo/.textlintrc.json') },
    }),
  },
}) -- }}}2

---@desc Mason {{{2
require('mason').setup({
  ui = {
    border = BORDER,
    icons = {
      package_installed = '🟢',
      package_pending = '🟠',
      package_uninstalled = '🔘',
    },
    keymaps = { apply_language_filter = '<NOP>' },
  },
  -- install_root_dir = path.concat { vim.fn.stdpath "data", "mason" },
  pip = { install_args = {} },
  -- log_level = vim.log.levels.INFO,
  -- max_concurrent_installers = 4,
  github = {},
}) --}}}2

vim.cmd.LspStart()
