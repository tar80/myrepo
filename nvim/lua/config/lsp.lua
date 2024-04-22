-- vim:textwidth=0:foldmethod=marker:foldlevel=1
--------------------------------------------------------------------------------
local api = vim.api
local uv = vim.uv
local lsp = vim.lsp
local keymap = vim.keymap
local util = require('module.util')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local BORDER = 'rounded'
local SIGNS = { Error = '', Warn = '', Hint = '', Info = '' }
for name, symbol in pairs(SIGNS) do
  local hl = string.format('DiagnosticSign%s', name)
  vim.fn.sign_define(hl, { text = symbol, texthl = hl, numhl = 'NONE' })
end

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
  signs = true,
  update_in_insert = false,
})

---@desc Functions {{{1
local function _no_clients() -- {{{2
  if #lsp.get_clients({ bufnr = 0 }) == 0 then
    vim.notify('Language server is not attached this buffer', 3)
    return true
  end
  return false
end
local function popup_rename() -- {{{2
  if _no_clients() then
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

---@diagnostic disable-next-line: unused-local
local function on_attach(client, bufnr) --- {{{2
  -- api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })
  ---@desc Under cursor Symbol highlight -- {{{
  api.nvim_create_autocmd({ 'CursorHold' }, {
    group = augroup,
    buffer = 0,
    callback = function()
      lsp.buf.document_highlight()
    end,
  })
  api.nvim_create_autocmd({ 'CursorMoved' }, {
    group = augroup,
    buffer = 0,
    callback = function()
      lsp.buf.clear_references()
    end,
  }) ---}}}
  ---@desc Keymap {{{3
  keymap.set('n', ']d', vim.diagnostic.goto_next)
  keymap.set('n', '[d', vim.diagnostic.goto_prev)
  keymap.set('n', 'gla', lsp.buf.code_action)
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
  end) -- }}}
  keymap.set('n', 'glh', lsp.buf.signature_help)
  keymap.set('n', 'gli', function() -- {{{
    if _no_clients() then
      return
    end
    local toggle = lsp.inlay_hint.is_enabled() == false
    lsp.inlay_hint.enable(0, toggle)
  end) -- }}}
  keymap.set('n', 'gll', lsp.buf.hover)
  keymap.set('n', 'glr', popup_rename)
  keymap.set('n', 'glv', function() -- {{{
    if _no_clients() then
      return
    end
    local toggle = not vim.diagnostic.config().virtual_text
    vim.diagnostic.config({ virtual_text = toggle })
  end) -- }}}
  -- keymap.set('n', 'gd', lsp.buf.definition)
  -- keymap.set("n", "gD", lsp.buf.type_definition)
  -- keymap.set("n", "glj", lsp.buf.references)

  ---@desc trouble.nvim
  -- keymap.set('n', 'gd', function() -- {{{
  --   local pos = { api.nvim_win_get_cursor(0) }
  --   vim.cmd.normal({ 'gd', bang = true })
  --   if not vim.deep_equal(pos, { api.nvim_win_get_cursor(0) }) or _no_clients() then
  --     return
  --   end
  --   lsp.buf.definition({
  --     reuse_win = true,
  --     on_list = function(opts)
  --       local item1 = opts.items[1]
  --       if #opts.items == 2 then
  --         local item2 = opts.items[2]

  --         if item1.filename == item2.filename and item1.lnum == item2.lnum then
  --           local filename = util.normalize(item1.filename)
  --           if filename ~= util.normalize(api.nvim_buf_get_name(0)) then
  --             vim.cmd.edit(filename)
  --           end

  --           api.nvim_win_set_cursor(0, { item1.lnum, item1.col })
  --           return
  --         end
  --       end
  --       vim.cmd.Trouble('lsp_definitions')
  --     end,
  --   })
  -- end) -- }}}
  -- keymap.set('n', 'gD', function() -- {{{
  --   if _no_clients() then
  --     vim.cmd.normal({ 'gD', bang = true })
  --     return
  --   end
  --   vim.cmd.Trouble('lsp_implementations')
  -- end) -- }}}
  keymap.set('n', 'gle', '<Cmd>Trouble document_diagnostics<CR>', {})
  keymap.set('n', 'glk', '<Cmd>Trouble lsp_references<CR>', {})
  -- keymap.set('n', 'glt', '<Cmd>Trouble lsp_type_definitions<CR>', {})

  ---@desc lspsaga.nvim
  -- keymap.set('n', ']d', '<Cmd>Lspsaga diagnostic_jump_next<CR>', {})
  -- keymap.set('n', '[d', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', {})
  keymap.set('n', 'gd', '<Cmd>Lspsaga goto_definition<CR>', {})
  -- keymap.set('n', 'gD', '<Cmd>Lspsaga goto_type_definition<CR>', {})
  -- keymap.set('n', 'glk', '<Cmd>Lspsaga finder<CR>', {})
  keymap.set('n', 'glt', '<Cmd>Lspsaga peek_type_definition<CR>', {})

  ---@desc map automatically added by lsp
  ---@see https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp.lua (#lsp._set_defaults())
  keymap.del('n', 'K', { buffer = bufnr })
  ---}}}3
end

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
})

---@desc Mason-lspconfig {{{2
local flags = {
  allow_incremental_sync = false,
  debounce_text_changes = 500,
}
local lspconfig = require('lspconfig')
require('lspconfig.ui.windows').default_options.border = 'rounded'
require('mason-lspconfig').setup_handlers({
  function(server_name) -- {{{
    lspconfig[server_name].setup({
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
    lspconfig.tsserver.setup({
      flags = flags,
      autostart = true,
      single_file_support = false,
      root_dir = lspconfig.util.root_pattern('.git', 'tsconfig.json'),
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
  --   lspconfig.denols.setup({
  --     flags = flags,
  --     root_dir = lspconfig.util.root_pattern('.git', 'tsconfig.json', 'deno.json', 'deno.jsonc'),
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
    lspconfig.lua_ls.setup({
      flags = flags,
      single_file_support = false,
      root_dir = lspconfig.util.find_git_ancestor(uv.cwd()),
      -- root_dir = lspconfig.util.root_pattern('.git', 'luarc.json'),
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
            },
          },
          -- telemetry = {
          --   enable = false,
          -- },
        },
      },
    })
  end, -- }}}
})

---@desc None_ls {{{2
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
local attach_filetypes = { 'lua', 'javascript', 'typescript', 'text', 'markdown' }
null_ls.setup({ -- {{{3
  debounce = 500,
  root_dir = function()
    return uv.cwd()
  end,
  should_attach = function(bufnr)
    return vim.tbl_contains(attach_filetypes, vim.bo[bufnr].filetype)
  end,
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
    -- null_ls.builtins.diagnostics.jsonlint.with({
    --   filetypes = { 'json', 'jsonc' },
    --   diagnostic_config = {
    --     virtual_text = true,
    --     signs = false,
    --   },
    -- }),
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
}) -- }}}1

vim.cmd.LspStart()
