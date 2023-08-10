-- vim:textwidth=0:foldmethod=marker:foldlevel=1
--------------------------------------------------------------------------------

local signs = { Error = '', Warn = '', Hint = '', Info = '' }

---@desc AUTOGROUP
vim.api.nvim_create_augroup('rcLsp', {})

---@desc FUNCTIONS {{{1
---VScode like rename function
local popup_rename = function()
  local util = require('module.util')
  local title = 'Lsp-rename'
  local adjust_cursor = util.getchr():match('[^%w]')

  if adjust_cursor then
    vim.api.nvim_command('normal h')
  end

  local rename_old = vim.fn.expand('<cword>')

  if adjust_cursor or not util.has_words_before() then
    vim.api.nvim_command('normal l')
  end

  -- if vim.lsp.buf.server_ready() then
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
    border = 'single',
    relative = 'cursor',
    contents = contents,
    post = post,
  })
  -- else
  --   vim.notify('LSP Not ready yet!', 3, { title = title })
  -- end
end

---@desc OPTIONS {{{1
vim.lsp.set_log_level = 'OFF'
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single' })

---@desc DIAGNOSTIC {{{1
vim.diagnostic.config({
  virtual_text = false,
  severity_sort = true,
  float = {
    focusable = true,
    style = 'minimal',
    border = 'single',
    source = 'always',
    header = '',
    prefix = '',
  },
  signs = true,
  update_in_insert = false,
})

for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = 'NONE' })
end

---@desc KEYMAPS {{{1
vim.keymap.set('n', 'gle', "<Cmd>lua vim.diagnostic.open_float(0,{border='rounded'})<CR>")
vim.keymap.set('n', 'glv', function()
  local vt_set = not vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = vt_set })
end)
vim.keymap.set('n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>')
vim.keymap.set('n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>')

---@desc On_attach {{{1
local on_attach = function(client, bufnr)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
  vim.keymap.set('n', 'glh', vim.lsp.buf.signature_help)
  vim.keymap.set('n', 'gll', vim.lsp.buf.hover)
  -- vim.keymap.set("n", "gli", vim.lsp.buf.implementation)
  -- vim.keymap.set("n", "glt", vim.lsp.buf.type_definition)
  vim.keymap.set('n', 'glr', function()
    popup_rename()
  end)
  vim.keymap.set('n', 'gla', '<Cmd>CodeActionMenu<CR>')
  -- vim.keymap.set("n", "glj", vim.lsp.buf.references)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  ---##Under cursor Symbol highlight -- {{{2
  vim.api.nvim_create_autocmd({ 'CursorHold' }, {
    group = 'rcLsp',
    buffer = 0,
    callback = function()
      if client.config.root_dir ~= vim.fs.normalize(vim.uv.cwd()) then
        return
      end
      vim.lsp.buf.document_highlight()
    end,
  })
  vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
    group = 'rcLsp',
    buffer = 0,
    callback = function()
      -- if vim.lsp.buf.server_ready() == false and client.config.root_dir ~= vim.fs.normalize(vim.fn.getcwd()) then
      if client.config.root_dir ~= vim.fs.normalize(vim.uv.cwd()) then
        return
      end
      vim.lsp.buf.clear_references()
    end,
  })
end

---@desc MASON-LSPCONFIG {{{1
-- require("mason-lspconfig").setup({
--   ensure_installed = { "sumneko_lua" },
--   automatic_installation = true,
-- })

local flags = {
  allow_incremental_sync = false,
  debounce_text_changes = 700,
}
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('mason-lspconfig').setup_handlers({
  function(server_name)
    require('lspconfig')[server_name].setup({
      flags = flags,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
      end,
      capabilities = capabilities,
    })
  end,
  ['tsserver'] = function()
    require('lspconfig').tsserver.setup({
      flags = flags,
      root_dir = require('lspconfig').util.root_pattern('tsconfig.json'),
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
      end,
      capabilities = capabilities,
    })
  end,
  -- ['denols'] = function()
  --   require('lspconfig').denols.setup({
  --     flags = flags,
  --     root_dir = require('lspconfig').util.root_pattern('tsconfig.json', 'deno.json', 'deno.jsonc'),
  --     on_attach = function(client, bufnr)
  --       on_attach(client, bufnr)
  --     end,
  --     capabilities = capabilities,
  --   })
  -- end,
  ['lua_ls'] = function()
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
            showWord = 'Disable',
          },
          runtime = {
            version = 'LuaJIT',
          },
          diagnostics = {
            globals = { 'vim', 'nyagos', 'packer_plugins', 'describe', 'it', 'before_each', 'after_each' },
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
  end,
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
null_ls.setup({
  debounce = 500,
  sources = {
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.markdownlint.with({
      extra_args = { '--config', vim.fn.expand(vim.g.repo .. '/myrepo/.markdownlint.yaml') },
    }),
    null_ls.builtins.diagnostics.markdownlint.with({
      extra_args = { '--config', vim.fn.expand(vim.g.repo .. '/myrepo/.markdownlint.yaml') },
    }),
    null_ls.builtins.formatting.textlint.with({
      extra_args = { '--config', vim.fn.expand(vim.g.repo .. '/myrepo/.textlintrc.json') },
    }),
    null_ls.builtins.diagnostics.textlint.with({
      extra_args = { '--config', vim.fn.expand(vim.g.repo .. '/myrepo/.textlintrc.json') },
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
})
---}}}1

vim.api.nvim_command('LspStart')
