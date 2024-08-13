--- vim:textwidth=0:foldmethod=marker:foldlevel=1:
-------------------------------------------------------------------------------
local fn = vim.fn
local api = vim.api
local setmap = vim.keymap.set
local augroup = api.nvim_create_augroup('rc_plugins', {})

vim.loader.enable()

---@desc Lazy.nvim bootstrap {{{2
do
  local lazypath = string.format('%s/lazy/lazy.nvim', fn.stdpath('data'))
  local cmdline =
    { 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath }
  if not vim.uv.fs_stat(lazypath) then
    fn.system(cmdline)
  end
  vim.opt.rtp:prepend(lazypath)
end

---@desc Setup {{{1
require('lazy').setup(
  { -- {{{ plugins

    ---@desc startup
    { -- {{{ cellwidths
      'delphinus/cellwidths.nvim',
      config = function()
        require('cellwidths').setup({
          -- log_level = "DEBUG",
          name = 'user/custom',
          fallback = function(cw)
            cw.load('sfmono_square')
            -- cw.add({ { 0xF000, 0xFD46, 2 }, })
            -- cw.add({ 0x1F424, 0x1F425, 3 })
            cw.add({ 0x2000, 0x2049, 2 })
            cw.add({ 0x25AA, 0x25FC, 2 })
            cw.add({ 0x2611, 0x263A, 2 })
            cw.add({ 0x2666, 0x2764, 2 })
            cw.add(0x27A1, 2)
            cw.add({ 0x2B05, 0x2B07, 2 })
            cw.delete({
              0x2640,
              0x2642,
              0x2660,
              0x2663,
              0xE0B4,
              0xE0B6,
              0xE0B8,
              0xE0BA,
              0xE0BC,
              0xE0BD,
              0xE0BE,
              0xE0BF,
              0xE285,
              0xE725,
              0xEA71,
              0xEABC,
              0xEAAA,
              0xEAAB,
            })
            return cw
          end,
        })
      end,
      build = function()
        require('cellwidths').remove()
      end,
    }, -- }}}

    ---@desc modules
    { 'nvim-lua/plenary.nvim', lazy = true },
    { 'kana/vim-operator-user', lazy = true },
    { 'nvim-tree/nvim-web-devicons', lazy = true },

    ---@desc display
    { -- {{{ feline
      'feline-nvim/feline.nvim',
      -- 'freddiehaddad/feline.nvim',
      event = 'UIEnter',
      dependencies = { { 'tar80/loose.nvim', dev = true } },
      config = function()
        require('config.display')
      end,
    }, -- }}}
    { -- {{{ render-markdown
      'MeanderingProgrammer/markdown.nvim',
      name = 'render-markdown',
      dependencies = { 'nvim-treesitter/nvim-treesitter' },
      config = function()
        require('render-markdown').setup({
          enabled = true,
          bullet = { enabled = true, icons = { '', '', '', '' } },
          sign = { enabled = false },
          checkbox = {
            enabled = true,
            unchecked = { icon = '󰄱 ', highlight = '@markup.list.unchecked' },
            checked = { icon = '󰱒 ', highlight = '@markup.list.unchecked' },
            custom = { todo = { raw = '[-]', rendered = '󰥔 ', highlight = '@markup.raw' } },
          },
        })
      end,
      ft = 'markdown',
    }, -- }}}

    ---@desc git
    { -- {{{ mug
      'tar80/mug.nvim',
      dev = true,
      event = 'VeryLazy',
      opts = {
        commit = true,
        conflict = true,
        diff = true,
        files = true,
        index = true,
        merge = true,
        mkrepo = true,
        rebase = true,
        show = true,
        subcommand = true,
        terminal = true,
        variables = {
          edit_command = 'E',
          file_command = 'F',
          write_command = 'W',
          sub_command = 'G',
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
      },
      config = function(_, opts)
        require('mug').setup(opts)
        setmap('n', 'md', '<Cmd>MugDiff<cr>')
        setmap('n', 'mi', '<Cmd>MugIndex<cr>')
        setmap('n', 'mc', '<Cmd>MugCommit<cr>')
      end,
    }, ---}}}
    { -- {{{ gitsigns
      'lewis6991/gitsigns.nvim',
      lazy = true,
      keys = { { 'gss', '<Cmd>GitsignsAttach<CR>', desc = 'Attach gitsigns' } },
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
            gs.nav_hunk('next', { foldopen = true, preview = true })
            return '<Ignore>'
          end, { expr = true })
          map('n', '[c', function()
            if vim.wo.diff then
              return '[c'
            end
            gs.nav_hunk('prev', { foldopen = true, preview = true })
            return '<Ignore>'
          end, { expr = true })
          -- Actions
          map({ 'n', 'x' }, 'gsa', function()
            local mode = api.nvim_get_mode().mode
            local range = mode:find('[vV]') == 1 and { vim.fn.line('v'), api.nvim_win_get_cursor(0)[1] } or nil
            gs.stage_hunk(range)
          end, { desc = 'Stage the hunk' })
          map({ 'n', 'x' }, 'gsr', gs.undo_stage_hunk, { desc = 'Undo the hunk' })
          map('n', 'gsR', gs.reset_buffer, { desc = 'Reset the buffer' })
          map('n', 'gsp', gs.preview_hunk, { desc = 'Preview the hunk' })
          map('n', 'gsb', function()
            gs.blame_line({ full = true })
          end, { desc = 'Blame line' })
          map('n', 'gsv', gs.select_hunk, { desc = 'Select the hunk' })
          map('n', 'gsq', gs.setloclist, { desc = 'Open loclist' })
          map('n', 'gsS', '<Cmd>GitsignsDetach<CR>', { desc = 'Detach gitsigns' })
        end, {})
        api.nvim_create_user_command('GitsignsDetach', function()
          require('gitsigns').detach_all()
          if fn.maparg('gsa', 'n') ~= '' then
            api.nvim_del_keymap('n', 'gsa')
            api.nvim_del_keymap('n', 'gsr')
            api.nvim_del_keymap('x', 'gsa')
            api.nvim_del_keymap('x', 'gsr')
            api.nvim_del_keymap('n', 'gsR')
            api.nvim_del_keymap('n', 'gsp')
            api.nvim_del_keymap('n', 'gsb')
            api.nvim_del_keymap('n', 'gsv')
            api.nvim_del_keymap('n', '[c')
            api.nvim_del_keymap('n', ']c')
          end
        end, {})
      end, -- }}}
      opts = {
        update_debounce = vim.g.update_time,
        word_diff = true,
        trouble = true,
        diff_opts = {
          algorithm = 'histogram',
          internal = true,
          indent_heuristic = true,
          vertical = true,
          linematch = 1,
          ignore_whitespace = false,
          ignore_whitespace_change_at_eol = true,
        },
        preview_config = { border = 'rounded' },
      },
    }, -- }}}

    ---@desc lsp
    { -- {{{ lspconfig
      'neovim/nvim-lspconfig',
      event = 'VeryLazy',
      dependencies = {
        { 'williamboman/mason.nvim', priority = 100 },
        'williamboman/mason-lspconfig.nvim',
        'nvimtools/none-ls.nvim',
        'hrsh7th/cmp-nvim-lsp',
      },
      config = function()
        require('config.lsp')
      end,
    }, ---}}}

    ---@desc treesitter
    { -- {{{ treesitter
      'nvim-treesitter/nvim-treesitter',
      event = 'VeryLazy',
      dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
      build = ':TSUpdate',
      config = function()
        require('config.treesitter')
      end,
    }, ---}}}
    -- { 'nvim-treesitter/nvim-treesitter-textobjects', lazy = true },

    ---@denops
    { -- {{{ denops
      'vim-denops/denops.vim',
      event = 'VeryLazy',
      dependencies = {
        'lambdalisue/kensaku.vim',
        'yuki-yano/fuzzy-motion.vim',
        { 'vim-skk/skkeleton' },
        'yukimemi/futago.vim',
      },
      init = function()
        api.nvim_set_var('denops_disable_version_check', 1)
        api.nvim_set_var('denops#deno', string.format('%s/apps/deno/current/deno.exe', vim.env.scoop))
        api.nvim_set_var('denops#server#deno_args', { '-q', '--no-lock', '-A', '--unstable-kv' })
        api.nvim_set_var('denops#server#retry_threshold', 1)
        api.nvim_set_var('denops#server#reconnect_threshold', 1)
      end,
      config = function()
        require('config.denops')
      end,
    }, ---}}}

    ---@desc motion
    { -- {{{ matchwith
      'tar80/matchwith.nvim',
      event = 'VeryLazy',
      dev = true,
      opts = {
        ignore_filetypes = { 'TelescopePrompt', 'cmp-menu' },
        -- ignore_buftypes = {},
        jump_key = '%',
        -- indicator = 200,
        -- sign = true,
      },
    }, -- }}}
    { -- {{{ smartword
      'kana/vim-smartword',
      event = 'VeryLazy',
      init = function()
        setmap('n', 'w', '<Plug>(smartword-w)')
        setmap('n', 'b', '<Plug>(smartword-b)')
        setmap('n', 'e', '<Plug>(smartword-e)')
        setmap('n', 'ge', '<Plug>(smartword-ge)')
      end,
    }, -- }}}
    { -- {{{ fret
      'tar80/fret.nvim',
      event = 'VeryLazy',
      dev = true,
      opts = {
        fret_enable_kana = true,
        fret_enable_symbol = true,
        fret_repeat_notify = true,
        fret_timeout = 9000,
        mapkeys = { fret_f = 'f', fret_F = 'F', fret_t = 't', fret_T = 'T' },
      },
    }, ---}}}
    { 'kana/vim-niceblock', event = 'ModeChanged' },

    ---@context
    { -- {{{ insx
      'hrsh7th/nvim-insx',
      event = { 'InsertEnter', 'CmdlineEnter' },
      config = function()
        vim.o.wrapscan = true
        setmap({ 'i', 'c' }, '<C-h>', '<BS>', { remap = true })
        require('config.insx'):setup({
          cmdline = false,
          fast_break = true,
          fast_wrap = true,
          lua = true,
          markdown = true,
          javascript = true,
          misc = true,
        })
      end,
    }, -- }}}
    --NOTE: use default keymap "gc"
    -- { -- {{{ comment
    --   'numToStr/Comment.nvim',
    --   event = 'VeryLazy',
    --   opts = { ignore = '^$' },
    -- }, -- }}}
    { -- {{{ dial
      'monaqa/dial.nvim',
      keys = { '<C-a>', '<C-x>', '<C-t>', { 'g<C-a>', mode = 'x' }, { 'g<C-x>', mode = 'x' } },
      config = function()
        local augend = require('dial.augend')
        local default_rules = {
          augend.semver.alias.semver,
          augend.integer.alias.decimal_int,
          augend.integer.alias.hex,
          augend.decimal_fraction.new({}),
          augend.date.alias['%Y/%m/%d'],
          augend.constant.alias.bool,
          -- augend.paren.alias.quote,
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
          -- markdown = { augend.misc.alias.markdown_header, },
        })

        setmap('n', '<C-t>', require('dial.map').inc_normal('case'), { silent = true, noremap = true })
        setmap('n', '<C-a>', require('dial.map').inc_normal(), { silent = true, noremap = true })
        setmap('n', '<C-x>', require('dial.map').dec_normal(), { silent = true, noremap = true })
        setmap('v', '<C-a>', require('dial.map').inc_visual(), { silent = true, noremap = true })
        setmap('v', '<C-x>', require('dial.map').dec_visual(), { silent = true, noremap = true })
        setmap('v', 'g<C-a>', require('dial.map').inc_gvisual(), { silent = true, noremap = true })
        setmap('v', 'g<C-x>', require('dial.map').dec_gvisual(), { silent = true, noremap = true })
      end,
    }, -- }}}
    { -- {{{ sandwich
      'machakann/vim-sandwich',
      event = 'VeryLazy',
      init = function()
        vim.g.sandwich_no_default_key_mappings = true
        setmap({ 'n' }, '<Leader>i', '<Plug>(operator-sandwich-add)i')
        setmap({ 'n' }, '<Leader>ii', 'v<Plug>(textobj-sandwich-auto-i)<Plug>(operator-sandwich-add)')
        -- setmap({ 'o', 'x' }, 'ib', '<Plug>(textobj-sandwich-auto-i)')
        setmap({ 'n' }, '<Leader>a', '<Plug>(operator-sandwich-add)2i')
        setmap({ 'n' }, '<Leader>aa', 'v<Plug>(textobj-sandwich-auto-a)<Plug>(operator-sandwich-add)')
        setmap({ 'x' }, '<Leader>a', '<Plug>(operator-sandwich-add)')
        -- setmap({ 'x' }, 'aa', '<Plug>(textobj-sandwich-auto-a)')
        setmap({ 'n', 'x' }, '<Leader>r', '<Plug>(sandwich-replace)')
        setmap({ 'n', 'x' }, '<Leader>rr', '<Plug>(sandwich-replace-auto)')
        setmap({ 'n', 'x' }, '<Leader>d', '<Plug>(sandwich-delete)')
        setmap({ 'n', 'x' }, '<Leader>dd', '<Plug>(sandwich-delete-auto)')
        -- setmap({ 'o', 'x' }, 'ib', '<Plug>(textobj-sandwich-auto-i)')
        -- setmap({ 'o', 'x' }, 'ab', '<Plug>(textobj-sandwich-auto-a)')
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
    }, -- }}}
    { -- {{{ operator-replace
      'yuki-yano/vim-operator-replace',
      event = 'VeryLazy',
      dependencies = { 'vim-operator-user' },
      init = function()
        local operator_replace = function(input)
          local mode = vim.api.nvim_get_mode().mode
          if mode == 'V' then
            return input
          end
          ---@diagnostic disable-next-line: redundant-parameter
          local reg_str = vim.fn.getreg(input, 1, 1)
          ---@cast reg_str -string
          if vim.tbl_isempty(reg_str) then
            input = '0'
            ---@diagnostic disable-next-line: redundant-parameter
            reg_str = vim.fn.getreg(input, 1, 1)
          end
          vim.schedule(function()
            local float = require('module.float')
            local bufnr = float.popup({
              border = 'rounded',
              data = reg_str,
              winblend = 0,
              hl = { link = 'SpecialKey' },
            })
            -- local bufnr, winid = unpack(float.popup({ data = reg_str }))
            api.nvim_create_autocmd({ 'ModeChanged' }, {
              group = augroup,
              pattern = 'no:[nc]*',
              once = true,
              callback = function()
                vim.cmd.bwipeout(bufnr)
              end,
            })
          end)
          return input
        end
        setmap({ 'n', 'x' }, '_', function()
          local input = '*'
          input = operator_replace(input)
          return string.format('"%s<Plug>(operator-replace)', input)
        end, { expr = true })
        setmap({ 'n', 'x' }, '\\', function()
          local input = vim.fn.nr2char(vim.fn.getchar())
          input = input == '\\' and '0' or input
          input = operator_replace(input)
          return string.format('"%s<Plug>(operator-replace)', input)
        end, { expr = true })
      end,
    }, -- }}}

    ---@complition
    { -- {{{ cmp
      'hrsh7th/nvim-cmp',
      event = { 'CursorMoved', 'InsertEnter', 'CmdlineEnter' },
      dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'hrsh7th/vim-vsnip',
        'hrsh7th/cmp-vsnip',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'dmitmel/cmp-cmdline-history',
        { 'uga-rosa/cmp-dictionary', opts = { first_case_insensitive = true } },
      },
      config = function()
        require('config.cmp')
      end,
    }, ---}}}

    ---@desc finder
    { -- {{{ telescope
      'nvim-telescope/telescope.nvim',
      keys = { '<Leader>', 'gl' },
      dependencies = {
        'hrsh7th/nvim-cmp',
        'plenary.nvim',
        'lambdalisue/kensaku.vim',
        'nvim-telescope/telescope-file-browser.nvim',
        'nvim-telescope/telescope-ui-select.nvim',
        'Allianaab2m/telescope-kensaku.nvim',
      },
      config = function()
        require('config.telescope')
      end,
      cmd = 'Telescope',
    }, ---}}}

    ---@desc util
    { -- {{{ mr
      'lambdalisue/vim-mr',
      event = 'VeryLazy',
      init = function()
        vim.g.mr_mru_disabled = false
        vim.g.mr_mrw_disabled = true
        vim.g.mr_mrr_disabled = true
        vim.g.mr_mrd_disabled = true
        vim.g['mr#threshold'] = 200
        vim.cmd(
          "let g:mr#mru#predicates=[{filename -> filename !~? '^c|\\\\\\|\\/doc\\/\\|\\/dist\\/\\|\\/dev\\/\\|\\/\\.git\\/\\|\\.cache'}]"
        )
      end,
    }, ---}}}
    { -- {{{ skkeleton_indicator
      'delphinus/skkeleton_indicator.nvim',
      event = 'InsertEnter',
      dependencies = {
        'vim-skk/skkeleton',
      },
      opts = {
        alwaysShown = false,
        fadeOutMs = 0,
        hiraText = '仮名',
      },
    }, -- }}}
    { -- {{{ registers
      'tversteeg/registers.nvim',
      lazy = true,
      keys = {
        { '""', mode = { 'n', 'x' } },
        { '<C-R>', mode = 'i' },
      },
      config = function()
        local registers = require('registers')
        setmap({ 'n', 'x' }, '""', registers.show_window({ mode = 'motion' }), { silent = true, noremap = true })
        registers.setup({
          show_empty = false,
          register_user_command = false,
          system_clipboard = false,
          show_register_types = true,
          symbols = { newline = '↲', tab = '~' },
          bind_keys = {
            normal = false,
            insert = registers.show_window({
              mode = 'insert',
              delay = 1,
            }),
          },
          window = {
            max_width = 100,
            highlight_cursorline = true,
            border = 'rounded',
            transparency = 12,
          },
        })
      end,
    }, ---}}}
    { -- {{{ trouble
      'folke/trouble.nvim',
      cmd = 'Trouble',
      config = function()
        require('config.trouble')
      end,
    }, -- }}}
    -- { -- {{{ lspsaga
    --   'nvimdev/lspsaga.nvim',
    --   cmd = 'Lspsaga',
    --   opts = {
    --     ui = {
    --       title = true,
    --       expand = '',
    --       collapse = '',
    --       code_action = '',
    --       lines = { '└', '├', '│', '─', '┌' },
    --     },
    --     beacon = { enable = false },
    --     lightbulb = { enable = false },
    --     symbol_in_winbar = { enable = false },
    --     finder = { keys = { split = 's', vsplit = 'v', tabe = 't' } },
    --   },
    -- }, -- }}}
    { -- {{{ translate
      'uga-rosa/translate.nvim',
      cmd = 'Translate',
      init = function()
        setmap({ 'n', 'x' }, 'me', '<Cmd>Translate EN<CR><C-[>', { silent = true })
        setmap({ 'n', 'x' }, 'mj', '<Cmd>Translate JA<CR><C-[>', { silent = true })
        setmap({ 'n', 'x' }, 'mE', '<Cmd>Translate EN -output=replace<CR>', { silent = true })
        setmap({ 'n', 'x' }, 'mJ', '<Cmd>Translate JA -output=replace<CR>', { silent = true })
      end,
    }, -- }}}
    { -- {{{ diffview
      'sindrets/diffview.nvim',
      cmd = { 'DiffviewOpen', 'DiffviewLog', 'DiffviewFocusFiles', 'DiffviewFileHistory' },
      opts = { use_icons = false },
    }, -- }}}
    { -- {{{ quickrun
      'thinca/vim-quickrun',
      cmd = 'QuickRun',
      dependencies = {
        { 'tar80/vim-quickrun-neovim-job', branch = 'win-nyagos' },
      },
      init = function()
        setmap({ 'n', 'v' }, 'mq', function()
          local prefix = ''
          local mode = api.nvim_get_mode().mode

          if mode:find('^[vV\x16]') then
            local start = vim.fn.line('v')
            local end_ = api.nvim_win_get_cursor(0)[1]

            if start > end_ then
              start, end_ = end_, start
            end

            prefix = string.format('%s,%s', start, end_)
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

                  vim.notify(string.format('[QuickRun] Running %s ...', session.config.command), vim.log.levels.WARN, {
                    title = ' QuickRun',
                  })
                end,
                on_success = function(_, _)
                  vim.cmd('echon "[QuickRun] Success"')
                end,
                on_failure = function(_, _)
                  vim.notify('[QuickRun] Error', vim.log.levels.ERROR, { title = ' QuickRun' })
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
            cmdopt = '--no-check --allow-all',
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
            exec = { '${PPX_DIR}/%C %o [PPx] %%*script(%S)' },
          },
          node = {
            command = 'node',
            tempfile = '%{tempname()}.js',
            exec = { '%c %S' },
          },
        }
      end,
    }, -- }}}
    { -- {{{ undotree
      'mbbill/undotree',
      keys = { { '<F7>', nil, desc = 'Toggle undotree' } },
      config = function()
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
    }, -- }}}
    --NOTE: use default keymap "gx"
    -- { -- {{{ open-browser
    --   'tyru/open-browser.vim',
    --   lazy = true,
    --   init = function()
    --     vim.g.openbrowser_open_vim_command = 'split'
    --     vim.g.openbrowser_use_vimproc = 0
    --     vim.g.openbrowser_no_default_menus = 1
    --     setmap('n', '<SPACE>/', "<Cmd>call openbrowser#_keymap_smart_search('n')<CR>")
    --     setmap('x', '<SPACE>/', "<Cmd>call openbrowser#_keymap_smart_search('v')<CR>")
    --     vim.opt.rtp:append(vim.fn.stdpath('data') .. '\\lazy\\open-browser.vim')
    --   end,
    -- }, -- }}}
    { 'norcalli/nvim-colorizer.lua', cmd = 'ColorizerAttachToBuffer' },

    ---@desc formatter
    { -- {{{ conform
      {
        'stevearc/conform.nvim',
        lazy = true,
        cmd = { 'ConformInfo' },
        keys = {
          {
            'gq',
            function(bufnr)
              require('conform').format({ async = true, bufnr = bufnr, lsp_format = 'fallback' })
            end,
            mode = { 'n' },
            desc = 'Format buffer',
          },
          {
            'gq',
            function(bufnr)
              require('conform').format({ async = true, bufnr = bufnr, lsp_format = 'prefer' }, function(err)
                if not err then
                  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
                end
              end)
            end,
            mode = { 'x' },
            desc = 'Range format buffer',
          },
          {
            'glf',
            function()
              vim.notify('It was changed to "gq"', vim.log.levels.WARN)
            end,
            mode = { 'n' },
          },
        },
        opts = {
          default_format_opts = { timeout_ms = 3000 },
          formatters_by_ft = {
            lua = { 'stylua' },
            json = { 'biome' },
            javascript = { 'biome-check' },
            typescript = { 'biome-check' },
            markdown = { 'markdownlint' },
          },
        },
      },
    }, -- }}}

    ---@desc dap
    { -- {{{ nvim-dap
      'mfussenegger/nvim-dap',
      -- lazy = true,
      key = { { '<F5>', nil, 'Load dap' } },
      dependencies = {
        'theHamsta/nvim-dap-virtual-text',
        'mxsdev/nvim-dap-vscode-js',
      },
      config = function()
        setmap('n', '<F5>', function()
          require('config.dap')
          vim.notify('[Dap] ready', 2)
        end)
      end,
    }, -- }}}

    ---@desc filetype
    { 'tar80/vim-PPxcfg', dev = true, ft = 'PPxcfg' },
    { 'vim-jp/vimdoc-ja' },
  }, -- }}}
  { -- {{{ options
    dev = {
      path = vim.g.repo,
      patterns = { 'tar80' },
      fallback = false,
    },
    install = {
      missing = false,
      colorscheme = { 'habamax' },
    },
    ui = { -- {{{
      size = { width = 0.8, height = 0.8 },
      wrap = true,
      border = 'single',
      custom_keys = {
        ['p'] = function(plugin)
          require('lazy.util').float_term({ 'tig' }, {
            cwd = plugin.dir,
          })
        end,
      },
      icons = {
        cmd = '',
        config = '',
        event = '',
        ft = '',
        init = '',
        import = '',
        keys = '',
        lazy = '',
        loaded = '',
        not_loaded = '',
        plugin = '',
        runtime = '',
        source = '',
        start = '',
        task = '',
        list = {
          '',
          '',
          '',
          '',
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
    {
      pkg = {
        enabled = false,
        cache = vim.fn.stdpath('state') .. '/lazy/pkg-cache.lua',
        -- the first package source that is found for a plugin will be used.
        sources = {
          'lazy',
          'rockspec', -- will only be used when rocks.enabled is true
          'packspec',
        },
      },
      rocks = {
        enabled = false,
        root = vim.fn.stdpath('data') .. '/lazy-rocks',
        server = 'https://nvim-neorocks.github.io/rocks-binaries/',
      },
    },
  } ---}}}2
)
