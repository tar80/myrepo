--- vim:textwidth=0:foldmethod=marker:foldlevel=1:
-------------------------------------------------------------------------------

---@desc INITIAL
local api = vim.api
local setmap = vim.keymap.set
vim.g.use_scheme = 'mossco'
vim.loader.enable()
local augroup = api.nvim_create_augroup('rcPlugins', {})

do -- {{{2 Lazy.nvim bootstrap
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
end -- }}}

---@desc AutoCommand
if vim.fn.has('vim_starting') then -- {{{2
  vim.defer_fn(function()
    api.nvim_command('doautocmd User LazyLoad')
  end, 100)

  api.nvim_create_autocmd('User', {
    group = augroup,
    pattern = 'LazyLoad',
    once = true,
    callback = function()
      vim.g.loaded_matchit = nil
    end,
  })
end -- }}}

---@desc Setup {{{1
require('lazy').setup(
  { -- {{{ plugins

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
    --     api.nvim_set_hl(0, 'ConflictMarkerBegin', { bg = '#2f7366' })
    --     api.nvim_set_hl(0, 'ConflictMarkerOurs', { bg = '#2e5049' })
    --     api.nvim_set_hl(0, 'ConflictMarkerTheirs', { bg = '#344f69' })
    --     api.nvim_set_hl(0, 'ConflictMarkerEnd', { bg = '#2f628e' })
    --     api.nvim_set_hl(0, 'ConflictMarkerCommonAncestorsHunk', { bg = '#754a81' })
    --   end,
    -- }, --}}}
    -- { -- {{{ select-multi-line
    --   dir = 'C:/bin/repository/tar80/nvim-select-multi-line',
    --   branch = 'tar80',
    --   name = 'nvim-select-multi-line',
    --   config = function()
    --     setmap('n', '<Leader>v', function()
    --       require('nvim-select-multi-line').start()
    --     end)
    --   end,
    --   keys = { '<Leader>v', mode = { 'n' } },
    -- }, ---}}}

    ---@desc startup
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

    ---@desc modules
    { 'nvim-lua/plenary.nvim', module = true },
    { 'kana/vim-operator-user', module = true },
    -- { 'nvim-tree/nvim-web-devicons', module = true },

    ---@desc scheme
    { dir = 'C:/bin/repository/tar80/mossco.nvim', name = 'mossco.nvim', lazy = true },
    { -- {{{ feline
      'feline-nvim/feline.nvim',
      dependencies = { 'mossco.nvim' },
      config = function()
        require('config.indicate')
      end,
      event = 'UIEnter',
    }, -- }}}

    ---@desc UIEnter
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
        setmap('n', 'md', '<Cmd>MugDiff<cr>')
        setmap('n', 'mi', '<Cmd>MugIndex<cr>')
        setmap('n', 'mc', '<Cmd>MugCommit<cr>')
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
        require('nvim-treesitter.configs').setup({
          -- ensure_installed = {"lua", "javascript", "markdown"},
          sync_install = false,
          auto_install = false,
          ignore_install = { 'text', 'help' },
          highlight = {
            enable = true,
            disable = { 'help', 'text' },
            additional_vim_regex_highlighting = false,
          },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = '<Space><CR>',
              scope_incremental = '<Space><CR>',
              node_incremental = '<C-j>',
              node_decremental = '<C-k>',
            },
          },
        })
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

    ---@desc lazy(direct read)
    { -- {{{ open-browser
      'tyru/open-browser.vim',
      init = function()
        vim.g.openbrowser_open_vim_command = 'split'
        vim.g.openbrowser_use_vimproc = 0
        vim.g.openbrowser_no_default_menus = 1
        setmap('n', '<SPACE>/', "<Cmd>call openbrowser#_keymap_smart_search('n')<CR>")
        setmap('x', '<SPACE>/', "<Cmd>call openbrowser#_keymap_smart_search('v')<CR>")
        vim.opt.rtp:append(vim.fn.stdpath('data') .. '\\lazy\\open-browser.vim')
      end,
      lazy = true,
    }, -- }}}

    ---@desc User LazyLoad
    { 'kana/vim-niceblock', event = 'ModeChanged' },
    { -- {{{ smartword
      'kana/vim-smartword',
      init = function()
        setmap('n', 'w', '<Plug>(smartword-w)')
        setmap('n', 'b', '<Plug>(smartword-b)')
        setmap('n', 'e', '<Plug>(smartword-e)')
        setmap('n', 'ge', '<Plug>(smartword-ge)')
      end,
      event = 'User LazyLoad',
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
      event = 'User LazyLoad',
    }, ---}}}
    { -- {{{ sandwich
      'machakann/vim-sandwich',
      init = function()
        vim.g.sandwich_no_default_key_mappings = true
        setmap({ 'n' }, '<Leader>i', '<Plug>(operator-sandwich-add)i')
        setmap({ 'n' }, '<Leader>a', '<Plug>(operator-sandwich-add)a')
        setmap({ 'x' }, '<Leader>a', '<Plug>(operator-sandwich-add)')
        setmap({ 'n', 'x' }, '<Leader>r', '<Plug>(sandwich-replace)')
        setmap({ 'n' }, '<Leader>rr', '<Plug>(sandwich-replace-auto)')
        setmap({ 'n', 'x' }, '<Leader>d', '<Plug>(sandwich-delete)')
        setmap({ 'n' }, '<Leader>dd', '<Plug>(sandwich-delete-auto)')
        setmap({ 'o', 'x' }, 'ib', '<Plug>(textobj-sandwich-auto-i)')
        setmap({ 'o', 'x' }, 'ab', '<Plug>(textobj-sandwich-auto-a)')
      end,
      config = function()
        local recipes = vim.deepcopy(vim.g['sandwich#default_recipes'])
        local esc_quote = { s = [[\']], d = [[\"]] }
        recipes = vim.list_extend(recipes, {
          { buns = { esc_quote.s, esc_quote.s }, input = { esc_quote.s } },
          { buns = { esc_quote.d, esc_quote.d }, input = { esc_quote.d } },
          { buns = { '【', '】' }, input = { ']' }, filetype = { 'markdown' } },
          { buns = { '${', '}' }, input = { '$' }, filetype = { 'typescript', 'javascript' } },
          { buns = { '%(', '%)' }, input = { '%' }, filetype = { 'typescript', 'javascript' } },
        })
        vim.g['sandwich#recipes'] = recipes
        vim.g['sandwich#magicchar#f#patterns'] = {
          {
            header = [[\<\%(\h\k*\.\)*\h\k*]],
            bra = '(',
            ket = ')',
            footer = '',
          },
        }
      end,
      event = 'User LazyLoad',
    }, -- }}}
    { -- {{{ comment
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup({ ignore = '^$' })
      end,
      event = 'User LazyLoad',
    }, -- }}}
    { -- {{{ operator-replace
      'yuki-yano/vim-operator-replace',
      dependencies = { 'vim-operator-user' },
      init = function()
        setmap('n', '_', '"*<Plug>(operator-replace)')
        setmap('n', '\\', '"0<Plug>(operator-replace)')
      end,
      event = 'User LazyLoad',
    }, -- }}}
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
    { -- {{{ denops
      'vim-denops/denops.vim',
      dependencies = {
        'lambdalisue/kensaku.vim',
        'yuki-yano/fuzzy-motion.vim',
        'vim-skk/skkeleton',
      },
      init = function()
        api.nvim_set_var('denops_disable_version_check', 1)
        api.nvim_set_var('denops#server#retry_threshold', 1)
        api.nvim_set_var('denops#server#reconnect_threshold', 1)
      end,
      config = function()
        require('config.denos')
      end,
      event = 'User LazyLoad',
    }, ---}}}

    ---@desc CursorMoved
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

    ---@desc InsertEnter, CmdlineEnter
    { -- {{{ skkeleton_indicator
      'delphinus/skkeleton_indicator.nvim',
      dependencies = {
        'vim-skk/skkeleton',
      },
      config = function()
        require('skkeleton_indicator').setup({
          alwaysShown = false,
          fadeOutMs = 0,
        })
      end,
      event = 'InsertEnter',
    }, -- }}}
    { -- {{{ insx
      'hrsh7th/nvim-insx',
      config = function()
        vim.o.wrapscan = true
        setmap({ 'i', 'c' }, '<C-h>', '<BS>', { remap = true })

        require('config.insx').setup({
          cmdline = false,
          fast_break = true,
          fast_wrap = true,
          lua = true,
          markdown = true,
          javascript = true,
          misc = true,
        })
      end,
      event = { 'InsertEnter', 'CmdlineEnter' },
    }, -- }}}

    ---@desc keys
    { -- {{{ telescope
      'nvim-telescope/telescope.nvim',
      tag = '0.1.2',
      dependencies = {
        'hrsh7th/nvim-cmp',
        'plenary.nvim',
        {
          'Allianaab2m/telescope-kensaku.nvim',
          config = function()
            require('telescope').load_extension('kensaku') -- :Telescope kensaku
          end,
        },
      },
      config = function()
        require('config.finder')
      end,
      cmd = 'Telescope',
      keys = { '<Leader>', 'gl' },
    }, ---}}}
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
        { '"', mode = { 'n', 'x' } },
        { '<C-R>', mode = 'i' },
      },
    }, ---}}}
    { -- {{{ dial
      'monaqa/dial.nvim',
      config = function()
        local augend = require('dial.augend')
        local default_rules = {
          augend.semver.alias.semver,
          augend.integer.alias.decimal_int,
          augend.integer.alias.hex,
          augend.decimal_fraction.new({}),
          augend.date.alias['%Y/%m/%d'],
          augend.constant.alias.bool,
          augend.paren.alias.quote,
        }
        local js_rules = {
          augend.constant.new({ elements = { 'let', 'const' } }),
        }
        require('dial.config').augends:register_group({
          default = default_rules,
          case = {
            augend.case.new({
              types = { 'camelCase', 'snake_case' },
              cyclic = true,
            }),
          },
        })
        require('dial.config').augends:on_filetype({
          typescript = vim.tbl_extend('force', default_rules, js_rules),
          javascript = vim.tbl_extend('force', default_rules, js_rules),
          -- lua = {},
          -- markdown = {
          --   augend.misc.alias.markdown_header,
          -- },
        })

        setmap('n', '<C-t>', require('dial.map').inc_normal('case'), { silent = true, noremap = true })
        setmap('n', '<C-a>', require('dial.map').inc_normal(), { silent = true, noremap = true })
        setmap('n', '<C-x>', require('dial.map').dec_normal(), { silent = true, noremap = true })
        setmap('v', '<C-a>', require('dial.map').inc_visual(), { silent = true, noremap = true })
        setmap('v', '<C.x>', require('dial.map').dec_visual(), { silent = true, noremap = true })
        setmap('v', 'g<C-a>', require('dial.map').inc_gvisual(), { silent = true, noremap = true })
        setmap('v', 'g<C-x>', require('dial.map').dec_gvisual(), { silent = true, noremap = true })
      end,
      keys = { '<C-a>', '<C-x>', '<C-t>', { 'g<C-a>', mode = 'x' }, { 'g<C-x>', mode = 'x' } },
    }, -- }}}
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
      cmd = 'Trouble',
    }, ---}}}

    ---@desc cmd
    { -- {{{ gitsigns
      'lewis6991/gitsigns.nvim',
      init = function() -- {{{
        api.nvim_create_user_command('GitsignsAttach', function()
          local gs = require('gitsigns')
          gs.attach()

          local function map(mode, l, r, opts)
            opts = opts or {}
            setmap(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then
              return ']c'
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return '<Ignore>'
          end, { expr = true })

          map('n', '[c', function()
            if vim.wo.diff then
              return '[c'
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return '<Ignore>'
          end, { expr = true })

          -- Actions
          map({ 'n', 'x' }, 'gsa', gs.stage_hunk)
          map({ 'n', 'x' }, 'gsr', gs.reset_hunk)
          map('n', 'gsR', gs.reset_buffer)
          map('n', 'gsp', gs.preview_hunk)
          map('n', 'gsb', function()
            gs.blame_line({ full = true })
          end)
          map('n', 'gsv', gs.toggle_current_line_blame)
          map('n', 'gsq', gs.setloclist)
          map('n', 'gsS', '<Cmd>GitsignsDetach<CR>')

          -- Text object
          map({ 'o', 'x' }, 'ih', gs.select_hunk)
        end, {})
        api.nvim_create_user_command('GitsignsDetach', function()
          require('gitsigns').detach_all()

          api.nvim_del_keymap('o', 'ih')
          api.nvim_del_keymap('n', 'gsa')
          api.nvim_del_keymap('n', 'gsr')
          api.nvim_del_keymap('x', 'ih')
          api.nvim_del_keymap('x', 'gsa')
          api.nvim_del_keymap('x', 'gsr')
          api.nvim_del_keymap('n', 'gsR')
          api.nvim_del_keymap('n', 'gsp')
          api.nvim_del_keymap('n', 'gsb')
          api.nvim_del_keymap('n', 'gsv')
          api.nvim_del_keymap('n', '[c')
          api.nvim_del_keymap('n', ']c')
        end, {})
      end, -- }}}
      opts = {
        update_debounce = vim.g.update_time,
        word_diff = true,
        trouble = true,
      },
      keys = { { 'gss', '<Cmd>GitsignsAttach<CR>' } },
    }, -- }}}
    { -- {{{ translate
      'uga-rosa/translate.nvim',
      init = function()
        setmap({ 'n', 'x' }, 'me', '<Cmd>Translate EN<CR>', { silent = true })
        setmap({ 'n', 'x' }, 'mj', '<Cmd>Translate JA<CR>', { silent = true })
        setmap({ 'n', 'x' }, 'mE', '<Cmd>Translate EN -output=replace<CR>', { silent = true })
        setmap({ 'n', 'x' }, 'mJ', '<Cmd>Translate JA -output=replace<CR>', { silent = true })
      end,
      cmd = 'Translate',
    }, -- }}}
    { -- {{{ diffview
      'sindrets/diffview.nvim',
      opts = { use_icons = false },
      cmd = { 'DiffviewOpen', 'DiffviewLog', 'DiffviewFocusFiles', 'DiffviewFileHistory' },
    }, -- }}}
    { -- {{{ quickrun
      'thinca/vim-quickrun',
      dependencies = {
        { 'tar80/vim-quickrun-neovim-job', branch = 'win-nyagos' },
      },
      init = function()
        setmap({ 'n', 'v' }, 'mq', function()
          local prefix = ''
          local mode = api.nvim_get_mode().mode

          if mode:find('^[vV\x16]') then
            local s = vim.fn.line('v')
            local e = api.nvim_win_get_cursor(0)[1]

            if s > e then
              s, e = e, s
            end

            prefix = string.format('%s,%s', s, e)
          end

          vim.cmd(string.format('%sQuickRun', prefix))
        end, {})

        ---@see https://github.com/yuki-yano/dotfiles/blob/main/.vim/lua/plugins/utils.lua
        local jobs = {}
        vim.g.quickrun_config = {
          ['_'] = {
            outputter = 'error',
            ['outputter/error/success'] = 'buffer',
            ['outputter/error/error'] = 'quickfix',
            ['outputter/buffer/opener'] = ':botright 5split',
            ['outputter/buffer/close_on_empty'] = 0,
            runner = 'neovim_job',
            hooks = {
              {
                on_ready = function(session, _)
                  local job_id = nil
                  if session._temp_names then
                    job_id = session._temp_names[1]
                    jobs[job_id] = { finish = false }
                  end

                  vim.notify(string.format('[QuickRun] Running %s ...', session.config.command), 'warn', {
                    title = ' QuickRun',
                  })
                end,
                on_success = function(_, _)
                  vim.notify('[QuickRun] Success', 'info', { title = ' QuickRun' })
                end,
                on_failure = function(_, _)
                  vim.notify('[QuickRun] Error', 'error', { title = ' QuickRun' })
                end,
                on_finish = function(session, _)
                  if session._temp_names then
                    local job_id = session._temp_names[1]
                    jobs[job_id].finish = true
                  end
                end,
              },
            },
          },
          typescript = { type = 'deno' },
          deno = {
            command = 'deno',
            cmdopt = '--no-check --allow-all --unstable',
            tempfile = '%{tempname()}.ts',
            exec = { '%c run %o %S' },
          },
          lua = {
            command = ':luafile',
            exec = { '%C %S' },
            runner = 'vimscript',
          },
          javascript = { type = 'ppx' },
          ppx = {
            command = 'ppbw',
            cmdopt = '-c *stdout',
            tempfile = '%{tempname()}.js',
            exec = { '${PPX_DIR}/%c %o [PPx] %%*script(%S)' },
          },
          node = {
            command = 'node',
            tempfile = '%{tempname()}.js',
            exec = { '%c %S' },
          },
        }
      end,
      cmd = 'QuickRun',
    }, -- }}}
    { -- {{{ undotree
      'mbbill/undotree',
      init = function()
        vim.g.undotree_WindowLayout = 2
        vim.g.undotree_ShortIndicators = 1
        vim.g.undotree_SplitWidth = 28
        vim.g.undotree_DiffpanelHeight = 6
        vim.g.undotree_DiffAutoOpen = 1
        vim.g.undotree_SetFocusWhenToggle = 1
        vim.g.undotree_TreeNodeShape = '*'
        vim.g.undotree_TreeVertShape = '|'
        vim.g.undotree_DiffCommand = 'diff'
        vim.g.undotree_RelativeTimestamp = 1
        vim.g.undotree_HighlightChangedText = 1
        vim.g.undotree_HighlightChangedWithSign = 1
        vim.g.undotree_HighlightSyntaxAdd = 'DiffAdd'
        vim.g.undotree_HighlightSyntaxChange = 'DiffChange'
        vim.g.undotree_HighlightSyntaxDel = 'DiffDelete'
        vim.g.undotree_HelpLine = 1
        vim.g.undotree_CursorLine = 1

        setmap('n', '<F7>', '<Cmd>UndotreeToggle<CR>')
      end,
      cmd = 'UndotreeToggle',
    }, -- }}}
    { 'norcalli/nvim-colorizer.lua', cmd = 'ColorizerAttachToBuffer' },
    { 'weilbith/nvim-code-action-menu', cmd = 'CodeActionMenu' },

    ---@desc filetype
    { 'tar80/vim-PPxcfg', ft = 'PPxcfg' },
    { 'vim-jp/vimdoc-ja' },
  }, -- }}}
  { -- {{{ options
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
