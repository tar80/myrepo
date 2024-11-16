-- vim:textwidth=0:foldmethod=marker:foldlevel=1

---@class Severities
---@field Error string
---@field Warn string
---@field Hint string
---@field Info string

---@class Autocmd_id
---@field hold integer
---@field release integer

local api = vim.api
local lsp = vim.lsp
local keymap = vim.keymap
local helper = require('helper')
local sign_icon = require('icon').symbol.square

local RENAME_TITLE = 'Lsp-rename'
local FLOAT_BORDER = vim.g.float_border
---@type Severities
local SEVERITIES = { Error = sign_icon, Warn = sign_icon, Hint = sign_icon, Info = sign_icon }

local augroup = api.nvim_create_augroup('rc_lsp', {})

---@desc Functions
---Check if the buffer is starting clients {{{2
---@return boolean
local function has_clients()
  local _has_clients = #lsp.get_clients({ bufnr = 0 }) > 0
  if not _has_clients then
    vim.notify_once('Language server is not attached this buffer', vim.log.levels.WARN)
  end
  return _has_clients
end -- }}}

---Get severity details {{{2
---@return {text?: Severities, numhl?: Severities, linehl?: Severities}
local function get_signs()
  local o = { text = {}, linehl = {}, numhl = {} }
  for name, symbol in pairs(SEVERITIES) do
    local key = vim.diagnostic.severity[name:upper()]
    o.text[key] = symbol
    -- o.numhl[key] = string.format('DiagnosticSign%s', name)
    -- s.linehl[key] = 'NONE'
  end
  return o
end -- }}}

---Get Lsp server capabilities {{{2
---@return lsp.ClientCapabilities
local function cmp_capabilities()
  local ok, mod = pcall(require, 'cmp_nvim_lsp')
  return ok and mod.default_capabilities() or {}
end -- }}}

---Renames all references to the symbol under the cursor {{{2
local function popup_rename()
  local ok, mug_float = pcall(require, 'mug.module.float')
  if not ok then
    return
  end
  local adjust_cursor = helper.getchr():match('[^%w]')
  if adjust_cursor then
    vim.cmd.normal('h')
  end
  local rename_old = vim.fn.expand('<cword>')
  if adjust_cursor or not helper.has_words_before() then
    vim.cmd.normal('l')
  end
  mug_float.input({
    title = RENAME_TITLE,
    width = math.max(25, #rename_old + 8),
    border = 'double',
    relative = 'cursor',
    contents = function()
      return rename_old
    end,
    post = function()
      keymap.set('i', '<CR>', function()
        vim.cmd.stopinsert({ bang = true })
        local input = api.nvim_get_current_line()
        local msg = string.format('%s -> %s', rename_old, input)
        api.nvim_win_close(0, false)
        lsp.buf.rename(vim.trim(input))
        vim.notify(msg, 2, { title = RENAME_TITLE })
      end, { buffer = true })
    end,
  })
end -- }}}

---Highlight the symbol under the cursor {{{2
---@param _client vim.lsp.Client
---@param bufnr integer
---@return Autocmd_id
local function cursorword(_client, bufnr)
  local hold = api.nvim_create_autocmd({ 'CursorHold' }, {
    desc = 'Set document highlighting',
    group = augroup,
    buffer = bufnr,
    callback = function()
      lsp.buf.document_highlight()
    end,
  })
  local release = api.nvim_create_autocmd({ 'CursorMoved' }, {
    desc = 'Clear references highlighting',
    group = augroup,
    buffer = bufnr,
    callback = function()
      lsp.buf.clear_references()
    end,
  })

  return { hold = hold, release = release }
end -- }}}

---@desc Lsp options
vim.diagnostic.config({ -- {{{2
  virtual_text = false,
  severity_sort = true,
  update_in_insert = false,
  signs = get_signs(),
  float = {
    focusable = true,
    style = 'minimal',
    border = FLOAT_BORDER,
    source = false,
    header = '',
    prefix = '',
    suffix = '',
    format = function(diagnostic)
      local symbol = { [1] = SEVERITIES.Error, [2] = SEVERITIES.Warn, [3] = SEVERITIES.Info, [4] = SEVERITIES.Hint }
      return string.format('%s %s (%s)', symbol[diagnostic.severity], diagnostic.message, diagnostic.source)
    end,
  },
}) -- }}}

return {
  { -- {{{2 mason
    'williamboman/mason.nvim',
    event = 'VeryLazy',
    opts = {
      ui = {
        border = FLOAT_BORDER,
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
    },
  }, -- }}}2
  { -- {{{2 none-ls
    'nvimtools/none-ls.nvim',
    ft = { 'text', 'markdown' },
    config = function()
      local null_ls = require('null-ls')
      null_ls.setup({
        debounce = 500,
        root_dir = function()
          return vim.uv.cwd()
        end,
        temp_dir = vim.fn.tempname():gsub('^(.+)[/\\].*', '%1'),
        on_attach = function(_, bufnr)
          keymap.set('n', 'gla', function()
            lsp.buf.code_action({ apply = true, bufnr = bufnr })
          end, { desc = 'Lsp code action' })
        end,
        should_attach = function(bufnr)
          return not api.nvim_buf_get_name(bufnr):find('futago://chat', 1, true)
        end,
        sources = {
          null_ls.builtins.diagnostics.markdownlint.with({
            filetypes = { 'markdown' },
            extra_args = { '--config', helper.myrepo_path('nvim/.markdownlint.yaml') },
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
            extra_args = { '--no-color', '--config', helper.myrepo_path('nvim/.textlintrc.json') },
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
            extra_args = { '--no-color', '--config', helper.myrepo_path('nvim/.textlintrc.json') },
          }),
        },
      })
    end,
  }, -- }}}
  { -- {{{2 lspconfig
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = { 'hrsh7th/cmp-nvim-lsp' },
    config = function()
      local lspconfig = require('lspconfig')
      -- lspconfig.util.default_config = vim.tbl_extend('force', lspconfig.util.default_config, {
      --   set_log_level = 'OFF',
      -- })
      local capabilities = cmp_capabilities()
      local flags = {
        allow_incremental_sync = false,
        debounce_text_changes = 500,
      }
      ---@type Autocmd_id
      local au_id
      local function _on_attach(client, bufnr) -- {{{3
        local capa = client.server_capabilities
        if capa.documentHighlightProvider then
          au_id = cursorword(client, bufnr)
        end
        ---@desc Keymap
        keymap.set('n', ']d', function()
          vim.diagnostic.jump({ count = 1, float = true })
        end)
        keymap.set('n', '[d', function()
          vim.diagnostic.jump({ count = -1, float = true })
        end)
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
        keymap.set('n', 'glh', function()
          lsp.buf.signature_help({ border = FLOAT_BORDER })
        end, { desc = 'Lsp signature help' })
        if capa.inlayHintProvider then
          keymap.set('n', 'gli', function() -- {{{
            local toggle = not lsp.inlay_hint.is_enabled({ bufnr = bufnr })
            lsp.inlay_hint.enable(toggle)
          end, { desc = 'Lsp inlay hints' }) -- }}}
        end
        if capa.hoverProvider then
          keymap.set('n', 'gll', function()
            lsp.buf.hover({ border = FLOAT_BORDER })
          end, { desc = 'Lsp hover' })
        end
        if capa.renameProvider then
          keymap.set('n', 'glr', popup_rename, { desc = 'Lsp popup rename' })
        end
        keymap.set('n', 'glv', function() -- {{{
          local toggle = not vim.diagnostic.config().virtual_text
          vim.diagnostic.config({ virtual_text = toggle })
        end, { desc = 'Lsp virtual text' }) -- }}}

        ---@desc trouble.nvim
        local ok, trouble_api = pcall(require, 'trouble.api')
        if ok then
          keymap.set('n', 'gd', function() -- {{{
            local pos = { api.nvim_win_get_cursor(0) }
            vim.cmd.normal({ 'gd', bang = true })
            if not vim.deep_equal(pos, { api.nvim_win_get_cursor(0) }) or not has_clients() then
              return
            end
            lsp.buf.definition({
              reuse_win = true,
              on_list = function(opts)
                local item1 = opts.items[1]
                if #opts.items == 2 then
                  local item2 = opts.items[2]

                  if item1.filename == item2.filename and item1.lnum == item2.lnum then
                    local filename = helper.normalize(item1.filename)
                    if filename ~= helper.normalize(api.nvim_buf_get_name(0)) then
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
        end

        ---@desc map automatically added by lsp
        ---@see https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp.lua (#lsp._set_defaults())
        pcall(keymap.del, 'n', 'K', { buffer = bufnr })
      end

      local function _on_exit() -- {{{3
        vim.schedule(function()
          if au_id then
            api.nvim_del_autocmd(au_id.hold)
            api.nvim_del_autocmd(au_id.release)
          end
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
      local servers = {
        biome = require('language_server.biome'),
        -- denols = require('language_server.denols'),
        lua_ls = require('language_server.lua_ls'),
        ts_ls = require('language_server.ts_ls'),
        vimls = require('language_server.vimls'),
      }
      for name, value in pairs(servers) do
        value.flags = flags
        value.capabilities = not value.capabilities and capabilities or nil
        value.on_attach = _on_attach
        value.on_exit = _on_exit
        lspconfig[name].setup(value)
      end
    end,
  }, -- }}}2
}
