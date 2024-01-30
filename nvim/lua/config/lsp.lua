-- vim:textwidth=0:foldmethod=marker:foldlevel=1
--------------------------------------------------------------------------------

---@desc INITIAL {{{1
local util = require('module.util')
local api = vim.api
local keymap = vim.keymap
local lsp = vim.lsp
local border = 'rounded'
local signs = { Error = '', Warn = '', Hint = '', Info = '' }
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local augroup = api.nvim_create_augroup('rcLsp', {})

for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = 'NONE' })
end

---@desc Options
lsp.set_log_level = 'OFF'
lsp.handlers['textDocument/hover'] = lsp.with(lsp.handlers.hover, { border = border })
lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, { border = border })
vim.diagnostic.config({ -- {{{2
  virtual_text = false,
  severity_sort = true,
  float = {
    focusable = true,
    style = 'minimal',
    border = border,
    source = false,
    header = '',
    prefix = '',
    suffix = '',
    format = function(diagnostic)
      local symbol = { [1] = signs.Error, [2] = signs.Warn, [3] = signs.Info, [4] = signs.Hint }
      return string.format('%s %s (%s)', symbol[diagnostic.severity], diagnostic.message, diagnostic.source)
    end,
  },
  signs = true,
  update_in_insert = false,
}) -- }}}

---@desc FUNCTIONS {{{1
local popup_rename = function() -- {{{2
  local adjust_cursor = util.getchr():match('[^%w]')
  local bufnr = api.nvim_get_current_buf()
  local title = 'Lsp-rename'

  if vim.tbl_isempty(lsp.get_clients({ bufnr = bufnr })) then
    vim.notify('Language server is not attached this buffer', 3, { title = title })
    return
  end

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
end -- }}}

local on_attach = function(client, bufnr) --- {{{2
  -- lsp.inlay_hint(0, true)
  api.nvim_set_option_value('omnifunc', 'v:lua.ivm.lsp.omnifunc', { buf = bufnr })
  ---@desc Under cursor Symbol highlight -- {{{
  api.nvim_create_autocmd({ 'CursorHold' }, {
    group = augroup,
    buffer = 0,
    callback = function()
      -- if client.config.root_dir ~= vim.fs.normalize(vim.uv.cwd()) then
      --   return
      -- end
      lsp.buf.document_highlight()
    end,
  })
  api.nvim_create_autocmd({ 'CursorMoved' }, {
    group = augroup,
    buffer = 0,
    callback = function()
      -- if client.config.root_dir ~= vim.fs.normalize(vim.uv.cwd()) then
      --   return
      -- end
      lsp.buf.clear_references()
    end,
  }) ---}}}
  ---@desc Show inlay_hints when not in insert mode {{{
  -- api.nvim_create_autocmd({ 'InsertEnter' }, {
  --   group = augroup,
  --   buffer = 0,
  --   callback = function()
  --     lsp.inlay_hint(0, false)
  --   end,
  -- })
  -- api.nvim_create_autocmd({ 'InsertLeave' }, {
  --   group = augroup,
  --   buffer = 0,
  --   callback = function()
  --     lsp.inlay_hint(0, true)
  --   end,
  -- }) ---}}}
  ---@desc Keymap {{{3
  keymap.set('n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>')
  keymap.set('n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>')
  keymap.set('n', 'gla', '<Cmd>CodeActionMenu<CR>')
  keymap.set('n', 'gld', function() -- {{{
    local opts = { bufnr = 0, focusable = false }
    local opts_cursor = vim.tbl_extend('force', opts, { scope = 'cursor' })
    local winblend = vim.o.winblend
    api.nvim_set_option_value('winblend', 0, {})
    local resp = vim.diagnostic.open_float(opts_cursor, {})

    if not resp then
      local opts_line = vim.tbl_extend('force', opts, { scope = 'line' })
      vim.diagnostic.open_float(opts_line, {})
    end

    api.nvim_set_option_value('winblend', winblend, {})
  end) -- }}}
  keymap.set('n', 'glh', lsp.buf.signature_help)
  keymap.set('n', 'gli', function()
    local bool = lsp.inlay_hint.is_enabled() == false
    lsp.inlay_hint.enable(0, bool)
  end)
  keymap.set('n', 'gll', lsp.buf.hover)
  keymap.set('n', 'glr', function()
    popup_rename()
  end)
  keymap.set('n', 'glv', function()
    local toggle_vt = not vim.diagnostic.config().virtual_text
    vim.diagnostic.config({ virtual_text = toggle_vt })
  end)
  keymap.set('n', 'gd', function()
    lsp.buf.definition({
      reuse_win = true,
      on_list = function(opts)
        if #opts.items == 2 then
          local item1 = opts.items[1]
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

        vim.cmd.Trouble('lsp_definitions')
        -- vim.cmd([[Trouble lsp_definitions]])
      end,
    })
  end)
  -- keymap.set('n', 'gd', lsp.buf.definition)
  -- keymap.set('n', 'gD', lsp.buf.declaration)
  -- keymap.set("n", "gli", lsp.buf.implementation)
  -- keymap.set("n", "glt", lsp.buf.type_definition)
  -- keymap.set("n", "glj", lsp.buf.references)

  ---@desc trouble.nvim
  -- keymap.set('n', 'gd', '<Cmd>Trouble lsp_definitions<CR>', {})
  keymap.set('n', 'gle', '<Cmd>Trouble document_diagnostics<CR>', {})
  keymap.set('n', 'glk', '<Cmd>Trouble lsp_references<CR>', {})

  ---@desc map automatically added by lsp
  ---@source nvim/runtime/lua/vim/lsp.lua:1208
  keymap.del('n', 'K', { buffer = bufnr })
  ---}}}3
end ---}}}

---@desc MASON {{{1
require('mason').setup({ -- {{{2
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
}) -- }}}

---@desc MASON-LSPCONFIG {{{1
local flags = {
  allow_incremental_sync = false,
  debounce_text_changes = 700,
}
require('lspconfig.ui.windows').default_options.border = 'rounded'

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
    require('lspconfig').tsserver.setup({
      flags = flags,
      autostart = true,
      single_file_support = false,
      root_dir = require('lspconfig').util.root_pattern('.git', 'tsconfig.json'),
      filetypes = { 'typescript', 'javascript' },
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
      end,
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
    })
  end, -- }}}
  -- ['denols'] = function() -- {{{
  --   require('lspconfig').denols.setup({
  --     flags = flags,
  --     root_dir = require('lspconfig').util.root_pattern('.git', 'tsconfig.json', 'deno.json', 'deno.jsonc'),
  --     autostart = false,
  --     filetypes = { 'javascript' },
  --     on_attach = function(client, bufnr)
  --       on_attach(client, bufnr)
  --     end,
  --     capabilities = capabilities,
  --     settings = {
  --       deno = {
  --         -- inlayHints = {
  --         --   parameterNames = { enabled = 'all' },
  --         --   parameterTypes = { enabled = true },
  --         --   variableTypes = { enabled = false },
  --         --   propertyDeclarationTypes = { enabled = true },
  --         --   functionLikeReturnTypes = { enabled = true },
  --         --   enumMemberValues = { enabled = true },
  --         -- },
  --       },
  --     },
  --   })
  -- end, -- }}}
  ['lua_ls'] = function() -- {{{
    require('lspconfig').lua_ls.setup({
      flags = flags,
      single_file_support = false,
      root_dir = require('lspconfig').util.root_pattern('.git'),
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
            pathStrict = true,
            path = { '?.lua', '?/init.lua' },
          },
          diagnostics = {
            globals = { 'vim', 'nyagos', 'describe', 'it', 'before_each', 'after_each' },
          },
          hint = {
            enable = true,
            setType = false,
            arrayIndex = 'Disable',
          },
          workspace = {
            checkThirdParty = 'Disable',
            library = { vim.fs.joinpath(vim.env.VIMRUNTIME, '${3rd}/luassert/library') },
          },
          telemetry = {
            enable = false,
          },
        },
      },
    })
  end, -- }}}
})

---@desc NULL_LS {{{1
keymap.set('n', 'glf', function(bufnr)
  lsp.buf.format({
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
  temp_dir = vim.fn.tempname():gsub('^(.+)[/\\].*', '%1'),
  sources = {
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.markdownlint.with({
      extra_args = { '--config', vim.fn.expand(vim.g.repo .. '/myrepo/.markdownlint.yaml') },
    }),
    -- null_ls.builtins.formatting.textlint.with({
    --   extra_args = { '--no-color', '--config', vim.fn.expand(vim.g.repo .. '/myrepo/.textlintrc.json') },
    -- }),
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

vim.cmd.LspStart()
