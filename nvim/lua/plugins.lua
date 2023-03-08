--- vim:textwidth=0:foldmethod=marker:foldlevel=1:
-------------------------------------------------------------------------------

-- vim.pretty_print(vim.api.nvim_list_runtime_paths())
-- #Variables
vim.g.use_scheme = 'mossco'
local LAZY_PATH = vim.fn.stdpath('data') .. '\\lazy\\lazy.nvim'

-- ##lazy.nvim bootstrap {{{2
if not vim.loop.fs_stat(LAZY_PATH) then
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

-- #AutoGroup
vim.api.nvim_create_augroup('initLazy', {})

-- ##AutoCommand {{{2
if vim.fn.has('vim_starting') then
  vim.defer_fn(function()
    vim.api.nvim_command('doautocmd User LazyLoad')
  end, 100)

  vim.api.nvim_create_autocmd('User', {
    group = 'initLazy',
    pattern = 'LazyLoad',
    once = true,
    callback = function()
      vim.g.loaded_matchit = nil
      require('config.lazyload')
    end,
  })
end
--}}}2

-- #Plugins {{{1
require('lazy').setup(
  {
    { -- plugins {{{2
      'delphinus/cellwidths.nvim',
      config = function()
        require('cellwidths').setup({
          -- log_level = "DEBUG",
          name = 'user/custom',
          fallback = function(cw)
            cw.load('cica')
            cw.add({
              { 0xF000, 0xFD46, 2 },
            })
          end,
        })
      end,
      build = function()
        require('cellwidths').remove()
      end,
    },
    { 'nvim-lua/plenary.nvim', lazy = true },
    -- {
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
    -- },
    { dir = 'C:/bin/temp/edita.vim' },
    { dir = 'C:/bin/repository/tar80/mossco.nvim', lazy = true },
    {
      dir = 'C:/bin/repository/tar80/mug.nvim',
      config = function()
        require('mug').setup({
          commit = true,
          conflict = true,
          diff = true,
          files = true,
          index = true,
          merge = true,
          show = true,
          mkrepo = true,
          variables = {
            edit_command = 'E',
            file_command = 'F',
            write_command = 'W',
            commit_notation = 'conventional',
            remote_url = 'git@github.com:tar80',
            diff_position = 'right',
          },
        })
      end,
      event = 'UIEnter',
    },
    {
      'feline-nvim/feline.nvim',
      dependencies = { 'tar80/mossco.nvim' },
      config = function()
        require('config.indicate')
      end,
      event = 'UIEnter',
    },
    { 'williamboman/mason-lspconfig.nvim', lazy = true },
    {
      'williamboman/mason.nvim',
      lazy = true,
      config = function()
        require('mason').setup({
          ui = {
            border = 'single',
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
      end,
    },
    {
      'jose-elias-alvarez/null-ls.nvim',
      lazy = true,
    },
    {
      'neovim/nvim-lspconfig',
      dependencies = { 'williamboman/mason.nvim', 'jose-elias-alvarez/null-ls.nvim', 'hrsh7th/cmp-nvim-lsp' },
      config = function()
        require('config.lsp')
      end,
      event = 'UIEnter',
    },
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      config = function()
        require('config.ts')
      end,
      event = 'UIEnter',
    },
    {
      'nvim-treesitter/nvim-treesitter-textobjects',
      config = function()
        require('config.ts_textobj')
      end,
      event = 'User LazyLoad',
    },
    {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.0',
      dependencies = { 'hrsh7th/nvim-cmp', 'kana/vim-smartinput' },
      config = function()
        require('config.finder')
      end,
      cmd = 'Telescope',
      keys = { '<Leader>', 'gl' },
    },
    { 'kana/vim-smartword', event = 'User LazyLoad' },
    {
      dir = 'C:/bin/repository/tar80/nvim-select-multi-line',
      branch = 'tar80',
      event = 'User LazyLoad',
    },
    {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup({ ignore = '^$' })
      end,
      event = 'User LazyLoad',
    },
    -- 'lambdalisue/guise.vim',
    {
      'vim-denops/denops.vim',
      dependencies = {
        'yuki-yano/fuzzy-motion.vim',
        'vim-skk/skkeleton',
      },
      init = function()
        vim.g.denops_disable_version_check = 1
      end,
      config = function()
        require('config.denos')
      end,
      event = 'User LazyLoad',
    },
    {
      'lewis6991/gitsigns.nvim',
      -- config = [[require('config.gits')]],
      event = 'CursorMoved',
    },
    { 'hrsh7th/vim-eft', event = 'User LazyLoad' },
    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/vim-vsnip',
        'hrsh7th/cmp-vsnip',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        {
          'uga-rosa/cmp-dictionary',
          config = function()
            require('cmp_dictionary').setup({
              dic = {
                ['javascript'] = { vim.g.repo .. '/myrepo/nvim/after/dict/ppx.dict' },
                ['PPxcfg'] = { vim.g.repo .. '/myrepo/nvim/after/dict/xcfg.dict' },
              },
              -- exact = 2,
              first_case_insensitive = true,
              document = false,
              max_items = -1,
              capacity = 5,
            })
            require('cmp_dictionary').update()
          end,
        },
      },
      config = function()
        require('config.comp')
      end,
      event = { 'CursorMoved', 'InsertEnter', 'CmdlineEnter' },
    },
    {
      'kana/vim-operator-user',
      dependencies = {
        { 'kana/vim-operator-replace' },
        { 'rhysd/vim-operator-surround' },
      },
      event = 'VeryLazy',
    },
    {
      'kana/vim-smartinput',
      config = function()
        require('config.input')
      end,
      event = { 'InsertEnter', 'CmdlineEnter' },
    },
    {
      dir = 'C:/bin/repository/tar80/vim-parenmatch',
      config = function()
        require('parenmatch').setup({
          highlight = { fg = '#D6B87B', underline = true },
          ignore_filetypes = { 'TelescopePrompt', 'cmp-menu', 'help' },
          ignore_buftypes = { 'nofile' },
          itmatch = { enable = true },
        })
      end,
      event = 'CursorMoved',
    },
    {
      'uga-rosa/translate.nvim',
      cmd = 'Translate',
    },
    {
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
              delay = 0.5,
            }),
            insert = registers.show_window({
              mode = 'insert',
              delay = 0.5,
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
      keys = { '"', { '<c-r>', mode = 'i' } },
    },
    -- {
    --   'cohama/agit.vim',
    --   setup = function()
    --     vim.g.agit_no_default_mappings = 0
    --     vim.g.agit_enable_auto_show_commit = 0
    --   end,
    --   cmd = { 'Agit', 'Agitfile' },
    -- },
    { 'bfredl/nvim-luadev', cmd = 'Luadev' },
    { 'tyru/open-browser.vim', key = { '<Space>/', { '<Space>/', 'x' } } },
    {
      'sindrets/diffview.nvim',
      cmd = { 'DiffviewOpen', 'DiffviewLog', 'DiffviewFocusFiles', 'DiffviewFileHistory' },
    },
    { 'mbbill/undotree', key = '<F7>' },
    { 'norcalli/nvim-colorizer.lua', cmd = 'Colorizer' },
    { 'weilbith/nvim-code-action-menu', cmd = 'CodeActionMenu' },
    { 'vim-jp/vimdoc-ja' },
    { 'tar80/vim-PPxcfg', ft = 'cfg' },
  },
  { -- options {{{2
    ui = {
      size = { width = 0.8, height = 0.8 },
      wrap = true,
      border = 'single',
      icons = {
        cmd = '',
        config = '',
        event = '',
        ft = '',
        init = '',
        import = '',
        keys = ' ',
        lazy = '',
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
    },
    performance = {
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
    },
  } ---}}}2
)
