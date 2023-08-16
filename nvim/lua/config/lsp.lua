-- vim:textwidth=0:foldmethod=marker:foldlevel=1
--------------------------------------------------------------------------------

---@desc INITIAL {{{1
local border = 'rounded'
local signs = { Error = '', Warn = '', Hint = '', Info = '' }
local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.api.nvim_create_augroup('rcLsp', {})

for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = 'NONE' })
end

---@desc Options
vim.lsp.set_log_level = 'OFF'
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })
vim.diagnostic.config({ -- {{{2
  virtual_text = false,
  severity_sort = true,
  float = {
    focusable = true,
    style = 'minimal',
    border = border,
    source = 'always',
    header = '',
    prefix = '',
  },
  signs = true,
  update_in_insert = false,
}) -- }}}

---@desc FUNCTIONS {{{1
local popup_rename = function() -- {{{2
  local util = require('module.util')
  local adjust_cursor = util.getchr():match('[^%w]')
  local bufnr = vim.api.nvim_get_current_buf()
  local title = 'Lsp-rename'

  if vim.tbl_isempty(vim.lsp.get_clients({ bufnr = bufnr })) then
    vim.notify('Language server is not attached this buffer', 3, { title = title })
    return
  end

  if adjust_cursor then
    vim.api.nvim_command('normal h')
  end

  local rename_old = vim.fn.expand('<cword>')

  if adjust_cursor or not util.has_words_before() then
    vim.api.nvim_command('normal l')
  end

  local contents = function()
    return rename_old
  end

  local post = function()
    vim.keymap.set('i', '<CR>', function()
      local input = vim.api.nvim_get_current_line()
      vim.api.nvim_command('quit|stopinsert!')
      vim.lsp.buf.rename(vim.trim(input))
      vim.notify(rename_old .. ' -> ' .. input, 2, { title = title })
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
end -- }}}
local on_attach = function(client, bufnr) --- {{{2
  -- vim.lsp.inlay_hint(0, true)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  ---@desc Under cursor Symbol highlight -- {{{
  vim.api.nvim_create_autocmd({ 'CursorHold' }, {
    group = 'rcLsp',
    buffer = 0,
    callback = function()
      -- if client.config.root_dir ~= vim.fs.normalize(vim.uv.cwd()) then
      --   return
      -- end
      vim.lsp.buf.document_highlight()
    end,
  })
  vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
    group = 'rcLsp',
    buffer = 0,
    callback = function()
      -- if client.config.root_dir ~= vim.fs.normalize(vim.uv.cwd()) then
      --   return
      -- end
      vim.lsp.buf.clear_references()
    end,
  }) ---}}}
  ---@desc Show inlay_hints when not in insert mode {{{
  -- vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
  --   group = 'rcLsp',
  --   buffer = 0,
  --   callback = function()
  --     vim.lsp.inlay_hint(0, false)
  --   end,
  -- })
  -- vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
  --   group = 'rcLsp',
  --   buffer = 0,
  --   callback = function()
  --     vim.lsp.inlay_hint(0, true)
  --   end,
  -- }) ---}}}
  ---@desc Keymap {{{3
  vim.keymap.set('n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>')
  vim.keymap.set('n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>')
  vim.keymap.set('n', 'gla', '<Cmd>CodeActionMenu<CR>')
  vim.keymap.set('n', 'gld', function() -- {{{
    local opts = { focusable = false }
    local winblend = vim.o.winblend
    local scope_c = vim.tbl_extend('force', opts, { scope = 'cursor' })
    vim.api.nvim_win_set_option(0, 'winblend', 0)
    local resp = vim.diagnostic.open_float(0, scope_c)

    if not resp then
      local scope_l = vim.tbl_extend('force', opts, { scope = 'line' })
      vim.diagnostic.open_float(0, scope_l)
    end

    vim.api.nvim_win_set_option(0, 'winblend', winblend)
  end) -- }}}
  vim.keymap.set('n', 'glh', vim.lsp.buf.signature_help)
  vim.keymap.set('n', 'gli', function()
    vim.lsp.inlay_hint(0)
  end)
  vim.keymap.set('n', 'gll', vim.lsp.buf.hover)
  vim.keymap.set('n', 'glr', function()
    popup_rename()
  end)
  vim.keymap.set('n', 'glv', function()
    local toggle_vt = not vim.diagnostic.config().virtual_text
    vim.diagnostic.config({ virtual_text = toggle_vt })
  end)
  -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
  -- vim.keymap.set('n', 'gD', vim.lsp.buf.definition)
  -- vim.keymap.set("n", "gli", vim.lsp.buf.implementation)
  -- vim.keymap.set("n", "glt", vim.lsp.buf.type_definition)
  -- vim.keymap.set("n", "glj", vim.lsp.buf.references)
  ---}}}3
end ---}}}

require('mason').setup({
  ui = {
    border = border,
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
})

---@desc MASON-LSPCONFIG {{{1
local flags = {
  allow_incremental_sync = false,
  debounce_text_changes = 700,
}

require('mason-lspconfig').setup_handlers({
  function(server_name) -- {{{
    require('lspconfig')[server_name].setup({
      flags = flags,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
      end,
      capabilities = capabilities,
    })
  end, -- }}}
  ['tsserver'] = function() -- {{{
    require('lspconfig').tsserver.setup({
      flags = flags,
      root_dir = require('lspconfig').util.root_pattern('tsconfig.json'),
      filetypes = { 'typescript' },
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
      end,
      capabilities = capabilities,
      disable_formatting = true,
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = 'none', -- 'none' | 'literals' | 'all';
            includeInlayParameterNameHintsWhenArgumentMatchesName = true, -- ???
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = false,
            includeInlayVariableTypeHintsWhenTypeMatchesName = true, -- ???
          },
        },
      },
    })
  end, -- }}}
  ['denols'] = function() -- {{{
    require('lspconfig').denols.setup({
      flags = flags,
      root_dir = require('lspconfig').util.root_pattern('.git', 'tsconfig.json', 'deno.json', 'deno.jsonc'),
      filetypes = { 'javascript' },
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
      end,
      capabilities = capabilities,
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
    })
  end, -- }}}
  ['lua_ls'] = function() -- {{{
    require('lspconfig').lua_ls.setup({
      flags = flags,
      root_dir = require('lspconfig').util.root_pattern('.git'),
      -- single_file_support = false,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
      end,
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
          },
          diagnostics = {
            globals = { 'vim', 'nyagos', 'describe', 'it', 'before_each', 'after_each' },
          },
          hint = {
            enable = true,
            setType = false,
            arrayIndex = 'disable',
          },
          -- workspace = {
          --   library = vim.api.nvim_get_runtime_file("", true),
          -- },
          telemetry = {
            enable = false,
          },
        },
      },
    })
  end, -- }}}
})

---@desc NULL_LS {{{1
vim.keymap.set('n', 'glf', function(bufnr)
  vim.lsp.buf.format({
    async = true,
    timeout_ms = 3000,
    filter = function(client)
      return client.name == 'null-ls'
    end,
    bufnr = bufnr,
  })
end)

local null_ls = require('null-ls')
null_ls.setup({ -- {{{2
  debounce = 500,
  sources = {
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.markdownlint.with({
      extra_args = { '--config', vim.fn.expand(vim.g.repo .. '/myrepo/.markdownlint.yaml') },
    }),
    null_ls.builtins.formatting.textlint.with({
      extra_args = { '--no-color', '--config', vim.fn.expand(vim.g.repo .. '/myrepo/.textlintrc.json') },
    }),
    null_ls.builtins.diagnostics.jsonlint.with({
      filetypes = { 'json', 'jsonc' },
      diagnostic_config = {
        virtual_text = true,
        signs = false,
      },
    }),
    null_ls.builtins.diagnostics.markdownlint.with({
      extra_args = { '--config', vim.fn.expand(vim.g.repo .. '/myrepo/.markdownlint.yaml') },
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
  },
}) -- }}}
---}}}1

vim.api.nvim_command('LspStart')
