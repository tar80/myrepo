--- vim:textwidth=0:foldmethod=marker:foldlevel=1:
-------------------------------------------------------------------------------

vim.loader.enable()

---@desc INITIAL
vim.g.use_scheme = 'mossco'
vim.api.nvim_create_augroup('rcPlugin', {})

---@desc Lazy.nvim bootstrap {{{2
local LAZY_PATH = vim.fn.stdpath('data') .. '\\lazy\\lazy.nvim'

if vim.fn.isdirectory(LAZY_PATH) == 0 then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    LAZY_PATH,
  })
end

vim.opt.rtp:prepend(LAZY_PATH)

---@desc AutoCommand {{{2
if vim.fn.has('vim_starting') then
  vim.defer_fn(function()
    vim.api.nvim_command('doautocmd User LazyLoad')
  end, 100)

  vim.api.nvim_create_autocmd('User', {
    group = 'rcPlugin',
    pattern = 'LazyLoad',
    once = true,
    callback = function()
      vim.g.loaded_matchit = nil
      require('config.lazyload')
    end,
  })
end

---@desc Plugins {{{1
require('lazy').setup(
  {
    { -- {{{ cellwidths
      'delphinus/cellwidths.nvim',
      config = function()
        require('cellwidths').setup({
          -- log_level = "DEBUG",
          name = 'user/custom',
          fallback = function(cw)
            cw.load('sfmono_square')
            -- cw.add({
            --   { 0xF000, 0xFD46, 2 },
            -- })
            cw.delete({ 0xE0B4, 0xE0B6, 0xE0B8, 0xE0BA, 0xE0BC, 0xE0BD, 0xE0BE, 0xE0BF, 0xE285, 0xE725 })
          end,
        })
      end,
      build = function()
        require('cellwidths').remove()
      end,
    }, -- }}}
    { 'nvim-lua/plenary.nvim', lazy = true },
    -- { -- {{{ notify
    --   "rcarriga/nvim-notify",
    --   event = "User LazyLoad",
    --   dependencies = { "telescope.nvim" },
    --   config = function()
    --     vim.notify = require("notify")
    --     require("notify").setup({
    --       fps = 30,
    --       level = 2,
    --       minimum_width = 50,
    --       timeout = 5000,
    --       render = "default",
    --       top_down = false,
    --       -- stages = "slide",
    --     })
    --   end,
    -- }, --}}}
    -- { -- {{{ conflict-marker
    --   dir = 'C:/bin/temp/backup/conflict-marker.vim',
    --   config = function()
    --     vim.api.nvim_set_hl(0, 'ConflictMarkerBegin', { bg = '#2f7366' })
    --     vim.api.nvim_set_hl(0, 'ConflictMarkerOurs', { bg = '#2e5049' })
    --     vim.api.nvim_set_hl(0, 'ConflictMarkerTheirs', { bg = '#344f69' })
    --     vim.api.nvim_set_hl(0, 'ConflictMarkerEnd', { bg = '#2f628e' })
    --     vim.api.nvim_set_hl(0, 'ConflictMarkerCommonAncestorsHunk', { bg = '#754a81' })
    --   end,
    -- }, --}}}
    { dir = 'C:/bin/repository/tar80/mossco.nvim', name = 'mossco.nvim', lazy = true },
    { -- {{{ feline
      'feline-nvim/feline.nvim',
      dependencies = { 'mossco.nvim' },
      config = function()
        require('config.indicate')
      end,
      event = 'UIEnter',
    }, --}}}
    { -- {{{ mug
      dir = 'C:/bin/repository/tar80/mug.nvim',
      name = 'mug.nvim',
      config = function()
        require('mug').setup({
          commit = true,
          conflict = true,
          diff = true,
          files = true,
          index = true,
          merge = true,
          mkrepo = true,
          rebase = true,
          show = true,
          terminal = true,
          variables = {
            edit_command = 'E',
            file_command = 'F',
            write_command = 'W',
            -- symbol_not_repository = '',
            root_patterns = { '.gitignore', '.git/' },
            index_auto_update = true,
            commit_notation = 'conventional',
            remote_url = 'git@github.com:tar80',
            diff_position = 'right',
            term_command = 'T',
            -- term_shell = 'nyagos',
            term_position = 'bottom',
            term_disable_columns = true,
            term_nvim_pseudo = true,
          },
          highlights = {},
        })
        vim.keymap.set('n', 'md', '<Cmd>MugDiff<cr>')
        vim.keymap.set('n', 'mi', '<Cmd>MugIndex<cr>')
        vim.keymap.set('n', 'mc', '<Cmd>MugCommit<cr>')
      end,
      event = 'UIEnter',
    }, ---}}}
    { 'williamboman/mason-lspconfig.nvim', lazy = true },
    { 'williamboman/mason.nvim', lazy = true },
    { 'jose-elias-alvarez/null-ls.nvim', lazy = true },
    { -- {{{ lspconfig
      'neovim/nvim-lspconfig',
      dependencies = { 'williamboman/mason.nvim', 'jose-elias-alvarez/null-ls.nvim', 'hrsh7th/cmp-nvim-lsp' },
      config = function()
        require('config.lsp')
      end,
      event = 'UIEnter',
    }, ---}}}
    { -- {{{ treesitter
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      config = function()
        require('config.ts')
      end,
      event = 'UIEnter',
    }, ---}}}
    { -- {{{ ts-textobjects
      'nvim-treesitter/nvim-treesitter-textobjects',
      dependencies = { 'nvim-treesitter' },
      config = function()
        require('config.ts_textobj')
      end,
      event = 'UIEnter',
    }, ---}}}
    { -- {{{ telescope
      'nvim-telescope/telescope.nvim',
      tag = '0.1.0',
      dependencies = { 'hrsh7th/nvim-cmp', 'kana/vim-smartinput' },
      config = function()
        require('config.finder')
      end,
      cmd = 'Telescope',
      keys = { '<Leader>', 'gl' },
    }, ---}}}
    { 'kana/vim-smartword', event = 'User LazyLoad' },
    { 'kana/vim-niceblock', event = 'User LazyLoad' },
    --    { 'monaqa/dial.nvim', event = 'User LazyLoad' },
    -- { -- {{{ select-multi-line
    --   dir = 'C:/bin/repository/tar80/nvim-select-multi-line',
    --   branch = 'tar80',
    --   name = 'nvim-select-multi-line',
    --   event = 'User LazyLoad',
    -- }, ---}}}
    { -- {{{ comment
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup({ ignore = '^$' })
      end,
      event = 'User LazyLoad',
    }, -- }}}
    { -- {{{ denops
      'vim-denops/denops.vim',
      dependencies = {
        'lambdalisue/kensaku.vim',
        -- 'lambdalisue/kensaku-search.vim',
        'yuki-yano/fuzzy-motion.vim',
        'vim-skk/skkeleton',
      },
      init = function()
        vim.api.nvim_set_var('denops_disable_version_check', 1)
        vim.api.nvim_set_var('denops#server#retry_threshold', 1)
        vim.api.nvim_set_var('denops#server#reconnect_threshold', 1)
      end,
      config = function()
        require('config.denos')
      end,
      event = 'User LazyLoad',
    }, ---}}}
    { -- {{{ skkeleton_indicator
      'delphinus/skkeleton_indicator.nvim',
      config = function()
        require('skkeleton_indicator').setup({
          alwaysShown = false,
          fadeOutMs = 0,
        })
      end,
      event = 'InsertEnter',
    }, -- }}}
    { -- {{{ fret
      dir = 'C:/bin/repository/tar80/fret.nvim',
      name = 'fret.nvim',
      opts = {
        fret_enable_kana = true,
        fret_timeout = 9000,
        mapkeys = {
          fret_f = 'f',
          fret_F = 'F',
          fret_t = 't',
          fret_T = 'T',
        },
      },
      event = 'UIEnter',
    }, ---}}}
    { -- {{{ cmp
      'hrsh7th/nvim-cmp',
      dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'hrsh7th/vim-vsnip',
        'hrsh7th/cmp-vsnip',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        { 'uga-rosa/cmp-dictionary', opts = { first_case_insensitive = true } },
      },
      config = function()
        require('config.comp')
      end,
      event = { 'CursorMoved', 'InsertEnter', 'CmdlineEnter' },
    }, ---}}}
    { -- {{{ operator-user
      'kana/vim-operator-user',
      dependencies = {
        { 'yuki-yano/vim-operator-replace' },
        { 'rhysd/vim-operator-surround' },
      },
      event = 'VeryLazy',
    }, -- }}}
    { -- {{{ smart-input
      'kana/vim-smartinput',
      config = function()
        require('config.input')
      end,
      event = { 'InsertEnter', 'CmdlineEnter' },
    }, -- }}}
    { -- {{{ parenmatch
      dir = 'C:/bin/repository/tar80/vim-parenmatch',
      name = 'parenmatch',
      config = function()
        require('parenmatch.config').setup({
          highlight = { fg = '#D6B87B', underline = true },
          ignore_filetypes = { 'TelescopePrompt', 'cmp-menu', 'help' },
          ignore_buftypes = { 'nofile' },
          itmatch = { enable = true },
        })
      end,
      event = 'CursorMoved',
    }, -- }}}
    { -- {{{ registers
      'tversteeg/registers.nvim',
      config = function()
        local registers = require('registers')
        registers.setup({
          show_empty = false,
          register_user_command = false,
          system_clipboard = false,
          show_register_types = false,
          symbols = { tab = '~' },
          bind_keys = {
            registers = registers.apply_register({ delay = 0.1 }),
            normal = registers.show_window({
              mode = 'motion',
              delay = 1,
            }),
            insert = registers.show_window({
              mode = 'insert',
              delay = 1,
            }),
          },
          window = {
            max_width = 100,
            highlight_cursorline = true,
            border = 'rounded',
            transparency = 9,
          },
        })
      end,
      keys = {
        { '"', mode = { 'n', 'v' } },
        { '<C-R>', mode = 'i' },
      },
    }, ---}}}
    { -- {{{ trouble
      'folke/trouble.nvim',
      opts = {
        position = 'bottom',
        height = 10,
        width = 50,
        icons = false,
        mode = 'workspace_diagnostics',
        fold_open = '',
        fold_closed = '',
        group = true,
        padding = false,
        cycle_results = false,
        action_keys = {
          cancel = '<Tab>',
          refresh = '<F5>',
          jump = { 'o', '<2-leftmouse>' },
          jump_close = '<CR>',
          toggle_mode = 'm',
          switch_severity = 's',
          open_code_href = 'c',
          close_folds = { 'zM', 'zm', '<C-h>' },
          open_folds = { 'zR', 'zr', '<C-l>' },
          toggle_fold = { 'zA', 'za' },
          help = 'g?',
        },
        multiline = true,
        indent_lines = true,
        win_config = { border = 'rounded' },
        auto_open = false,
        auto_close = false,
        auto_preview = false,
        auto_fold = false,
        auto_jump = { 'lsp_definitions' },
        include_declaration = { 'lsp_references', 'lsp_implementations', 'lsp_definitions' },
        use_diagnostic_signs = true,
      },
      keys = {
        { 'gle', '<Cmd>Trouble document_diagnostics<CR>' },
        { 'gd', '<Cmd>Trouble lsp_definitions<CR>' },
        { 'glk', '<Cmd>Trouble lsp_references<CR>' },
      },
      cmd = 'Trouble',
    }, ---}}}
    { -- {{{ mr
      'lambdalisue/mr.vim',
      init = function()
        vim.g.mr_mru_disabled = false
        vim.g.mr_mrw_disabled = true
        vim.g.mr_mrr_disabled = true
        vim.g['mr#threshold'] = 200
        vim.cmd("let g:mr#mru#predicates=[{filename -> filename !~? '\\\\\\|\\/doc\\/\\|\\/\\.git\\/\\|\\.cache'}]")
      end,
      event = 'User Lazyload',
    }, ---}}}
    { 'uga-rosa/translate.nvim', cmd = 'Translate' },
    { 'lewis6991/gitsigns.nvim', event = 'CursorMoved' },
    { -- {{{ quickrun
      'thinca/vim-quickrun',
      dependencies = {
        { 'tar80/vim-quickrun-neovim-job', branch = 'win-nyagos' },
      },
      cmd = 'QuickRun',
    }, -- }}}
    { 'tyru/open-browser.vim', key = { '<Space>/', { '<Space>/', 'x' } } },
    { -- {{{ diffview
      'sindrets/diffview.nvim',
      opts = { use_icons = false },
      cmd = { 'DiffviewOpen', 'DiffviewLog', 'DiffviewFocusFiles', 'DiffviewFileHistory' },
    }, -- }}}
    { 'mbbill/undotree', key = '<F7>' },
    { 'norcalli/nvim-colorizer.lua', cmd = 'ColorizerAttachToBuffer' },
    { 'weilbith/nvim-code-action-menu', cmd = 'CodeActionMenu' },
    { 'vim-jp/vimdoc-ja' },
    { 'tar80/vim-PPxcfg', ft = 'PPxcfg' },
  },
  { -- {{{2 options
    ui = { -- {{{
      size = { width = 0.8, height = 0.8 },
      wrap = true,
      border = 'single',
      custom_keys = {
        ['<leader>g'] = function(plugin)
          require('lazy.util').float_term({ 'tig' }, {
            cwd = plugin.dir,
          })
        end,
      },
      icons = {
        cmd = '',
        config = '',
        event = '',
        ft = '',
        init = '',
        import = '',
        keys = ' ',
        lazy = '',
        loaded = '●',
        not_loaded = '○',
        plugin = '',
        runtime = '',
        source = '',
        start = '',
        task = '✔',
        list = {
          '●',
          '➜',
          '★',
          '‒',
        },
      },
    }, -- }}}
    performance = { -- {{{
      rtp = {
        reset = true,
        paths = {},
        disabled_plugins = {
          'gzip',
          'matchit',
          'matchparen',
          'netrwPlugin',
          'tarPlugin',
          'tohtml',
          'tutor',
          'zipPlugin',
        },
      },
    }, -- }}}
    diff = {
      cmd = 'git',
    },
    readme = {
      enabled = true,
    },
  } ---}}}2
)
