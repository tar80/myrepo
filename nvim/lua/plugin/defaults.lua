-- vim:textwidth=0:foldmethod=marker:foldlevel=1:

local api = vim.api
local keymap = vim.keymap

return { -- {{{2
  ---@library
  { 'nvim-lua/plenary.nvim', lazy = true },
  { -- {{{3 mini.icons
    'echasnovski/mini.icons',
    lazy = true,
    config = function()
      require('mini.icons').setup()
      require('mini.icons').mock_nvim_web_devicons()
    end,
  }, -- }}}
  { -- {{{3 tartar
    'tar80/tartar.nvim',
    priority = 1000,
    dev = true,
    lazy = false,
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          require('tartar')
          require('tartar.test').setup({
            localleader = '\\',
            test_key = '<LocalLeader><LocalLeader>',
          })
          local source = require('tartar.source')
          source.set_tartar_fold()
          source.map_smart_zc('treesitter')

          keymap.set('x', 'aa', source.tartar_align, { desc = 'Tartar align' })

          local operatable_q = source.plugkey('n', 'operatable_q', 'q')
          operatable_q({ ':', '/', '?' })
          keymap.set('n', '<Plug>(operatable_q)w', function()
            return vim.fn.reg_recording() == '' and 'qw' or 'q'
          end, { expr = true })
          local repeatable_g = source.plugkey('n', 'repeatable_g', 'g', true)
          repeatable_g({ 'j', 'k' })
          local repeatable_z = source.plugkey('n', 'repeatable_z', 'z', true)
          repeatable_z({ 'h', 'j', 'k', 'l' })
          local replaceable_space = source.plugkey('n', 'replaceable_space', '<Space>', true)
          replaceable_space({ { '-', '<C-w>-' }, { ';', '<C-w>+' }, { ',', '<C-w><' }, { '.', '<C-w>>' } })
          local argumentable_H = source.plugkey('n', 'argumentable_H', 'H', true)
          argumentable_H('H', '<PageUp>H')
          local argumentable_L = source.plugkey('n', 'argumentable_L', 'L', true)
          argumentable_L('L', '<PageDown>L')

          source.abbrev.tbl = { --- {{{4
            ia = {
              ['cache'] = { 'chace', 'chache' },
              ['export'] = { 'exprot', 'exoprt' },
              ['field'] = { 'filed' },
              ['string'] = { 'stirng' },
              ['function'] = { 'funcion', 'fuction' },
              ['return'] = { 'reutnr', 'reutrn', 'retrun' },
              ['true'] = { 'treu' },
            },
            ca = {
              bt = { { [[T deno task build <C-r>=expand(\"%\:\.\")<CR>]] } },
              bp = { { [[!npm run build:prod]] } },
              ms = { { 'MugShow' }, true },
              es = { { 'e<Space>++enc=cp932 ++ff=dos<CR>' } },
              e8 = { { 'e<Space>++enc=utf-8<CR>' } },
              eu = { { 'e<Space>++enc=utf-16le ++ff=dos<CR>' } },
              sc = { { 'set<Space>scb<Space><Bar><Space>wincmd<Space>p<Space><Bar><Space>set<Space>scb<CR>' } },
              scn = { { 'set<Space>noscb<CR>' } },
              del = { { [[call<Space>delete(expand('%'))]] } },
              cs = { { [[execute<Space>'50vsplit'g:repo.'/myrepo/nvim/.cheatsheet'<CR>]] } },
              dd = { { 'diffthis<Bar>wincmd<Space>p<Bar>diffthis<Bar>wincmd<Space>p<CR>' } },
              dof = { { 'syntax<Space>enable<Bar>diffoff!<CR>' } },
              dor = {
                {
                  'tab<Space>split<Bar>vert<Space>bel<Space>new<Space>difforg<Bar>set<Space>bt=nofile<Bar>r<Space>++edit<Space>#<Bar>0d_<Bar>windo<Space>diffthis<Bar>wincmd<Space>p<CR>',
                },
              },
              ht = { { 'so<Space>$VIMRUNTIME/syntax/hitest.vim' } },
              ct = { { 'so<Space>$VIMRUNTIME/syntax/colortest.vim' } },
              shadad = { { '!rm ~/.local/share/nvim-data/shada/main.shada.tmp*' } },
              s = { { '%s//<Left>', 's//<Left>' }, true },
              ss = { { '%s///<Left>', 's///<Left>' }, true },
              z = { { 'Z' } },
            },
          } ---}}}4
          source.abbrev:set('ia')
          source.abbrev:set('ca')
        end,
      })
    end,
  }, -- }}}

  ---@desc On event
  { -- {{{3 cellwidths
    'delphinus/cellwidths.nvim',
    event = 'VeryLazy',
    opts = {
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
          0x2026,
          0x2030,
          0x2039,
          0x203A,
          0x2640,
          0x25B6,
          0x25B8,
          0x25BE,
          0x2642,
          0x2660,
          0x2663,
          0xE0B4,
          0xE0B6,
          0xE0B8,
          0xE0B9,
          0xE0BA,
          0xE0BB,
          0xE0BC,
          0xE0BD,
          0xE0BE,
          0xE0BF,
          0xE0C5,
          0xE0C7,
          0xE216,
          0xE285,
          0xE725,
          0xEA71,
          0xEABC,
          0xEAAA,
          0xEAAB,
          0xF054,
          0xF102,
          0xF103,
          0xF126,
          0xF128,
          0xF444,
          0xF44A,
          0xF44B,
          0xF460,
          0xF47C,
          0xF0140,
          0xF0142,
          0xF035D,
          0xF035F,
          0xF0FF6,
          0xF1A09,
        })
        return cw
      end,
    },
    build = function()
      require('cellwidths').remove()
    end,
  }, -- }}}
  -- { 'folke/ts-comments.nvim', event = 'VeryLazy', opts = {} },
  { -- {{{3 staba
    'tar80/staba.nvim',
    dev = true,
    dependencies = { 'mini.icons', 'tartar.nvim' },
    event = 'UIEnter',
    config = function()
      local function git_branch() -- {{{
        local repo = vim.uv.cwd():gsub('^(.+[/\\])', '')
        local branch = vim.b.mug_branch_name or ''
        local detach = vim.b.mug_branch_info or ''
        detach = detach ~= '' and ('(%s) '):format(detach) or ' '
        local state = vim.b.mug_branch_stats
        state = state
            and ('%s+%s%s~%s%s!%s%s '):format(
              '%#DiagnosticSignOk#',
              state.s,
              '%#DiagnosticSignWarn#',
              state.u,
              '%#DiagnosticSignError#',
              state.c,
              '%*'
            )
          or ''
        local details = branch .. detach .. state
        return details == ' ' and '' or ('%s %s:%%#Special#%s '):format(require('icon').git.branch, repo, details)
      end -- }}}

      vim.keymap.set('n', 'gb', '<Plug>(staba-pick)')
      vim.keymap.set('n', '<Space>1', '<Plug>(staba-cleanup)')
      vim.keymap.set('n', '<Space>q', '<Plug>(staba-delete-select)')
      vim.keymap.set('n', '<Space>qq', '<Plug>(staba-delete-current)')
      vim.keymap.set('n', 'm', '<Plug>(staba-mark-operator)', {})
      vim.keymap.set('n', 'mm', '<Plug>(staba-mark-toggle)', {})
      vim.keymap.set('n', 'mD', '<Plug>(staba-mark-delete-all)', {})
      require('staba').setup({
        -- no_name = '[no name]',
        enable_fade = true,
        enable_underline = true,
        enable_sign_marks = true,
        enable_statuscolumn = true,
        enable_statusline = true,
        enable_tabline = true,
        mode_line = 'LineNr',
        ignore_filetypes = {
          statuscolumn = { 'qf', 'help', 'terminal', 'undotree' },
          statusline = { 'terminal', 'trouble', 'snacks_layout_box' },
        },
        -- nav_key = '',
        statusline = {
          active = {
            left = { 'search_count', 'snacks_profiler' },
            middle = {},
            -- left = { 'staba_logo', 'noice_mode' },
            -- middle = { 'search_count' },
            right = { '%<', 'diagnostics', ' ', git_branch, 'encoding', ' ', 'position' },
          },
          -- inactive = { left = {}, middle = { 'devicon', 'filename', '%*' }, right = {} },
        },
        tabline = {},
        -- icons = {},
      })
    end,
  }, -- }}}
  { -- {{{3 rereope
    'tar80/rereope.nvim',
    dev = true,
    opts = { map_cyclic_register_keys = {} },
    keys = {
      {
        '_',
        function()
          require('rereope').open('_', {
            end_point = false,
            beacon = { 'FretAlternative', 100, 30, 15 },
            hint = { winblend = 10, border = { '', '', '', '', '', '', '', '┃' } },
          })
        end,
        mode = { 'n', 'x' },
        desc = 'Rereope regular replace',
      },
    },
  }, -- }}}3
  { -- {{{3 mug
    'tar80/mug.nvim',
    dev = true,
    event = 'VeryLazy',
    keys = { -- {{{4
      { 'md', '<Cmd>MugDiff<CR>', mode = { 'n' }, desc = 'Mug diff' },
      { 'mi', '<Cmd>MugIndex<CR>', mode = { 'n' }, desc = 'Mug index' },
      { 'mc', '<Cmd>MugCommit<CR>', mode = { 'n' }, desc = 'Mug commit' },
    }, -- }}}
    opts = { -- {{{4
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
        root_patterns = { 'lazy-lock.json', '.gitignore', '.git/' },
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
    }, -- }}}
  }, ---}}}3
  { -- {{{3 fret
    'tar80/fret.nvim',
    dev = true,
    keys = { 'f', 'F', 't', 'T', 'd', 'v', 'V', 'y', 'c' },
    opts = {
      fret_enable_beacon = true,
      fret_enable_kana = true,
      fret_enable_symbol = true,
      fret_repeat_notify = false,
      fret_smart_fold = true,
      fret_timeout = 9000,
      fret_samekey_repeat = true,
      -- beacon_opts = { hl = 'LazyButtonActive', interval = 80, blend = 30, decay = 15 },
      mapkeys = { fret_f = 'f', fret_F = 'F', fret_t = 't', fret_T = 'T' },
    },
  }, ---}}}
  { -- {{{3 matchwith
    'tar80/matchwith.nvim',
    dev = true,
    event = 'VeryLazy',
    init = function()
      vim.keymap.set({ 'o', 'x' }, 'i%', '<Plug>(matchwith-operator-i)')
      vim.keymap.set({ 'o', 'x' }, 'a%', '<Plug>(matchwith-operator-a)')
      vim.keymap.set({ 'o', 'x' }, 'iP', '<Plug>(matchwith-operator-parent-i)')
      vim.keymap.set({ 'o', 'x' }, 'aP', '<Plug>(matchwith-operator-parent-a)')
    end,
    opts = {
      captures = {
        html = { 'tag.delimiter', 'punctuation.bracket' },
        javascript = {
          'tag.delimiter',
          'keyword.function',
          'keyword.repeat',
          'keyword.conditional',
          'punctuation.bracket',
        },
      },
      ignore_filetypes = {
        'cmp_menu',
        'cmp_docs',
        'fidget',
        'snacks_picker_input',
      },
      -- ignore_buftypes = {},
      jump_key = '%',
      indicator = 0,
      priority = 200,
      sign = false,
      show_parent = false,
      show_next = true,
    },
  }, -- }}}
  { -- {{{3 smartword
    'kana/vim-smartword',
    keys = {
      { 'w', '<Plug>(smartword-w)', mode = { 'n' } },
      { 'b', '<Plug>(smartword-b)', mode = { 'n' } },
      { 'e', '<Plug>(smartword-e)', mode = { 'n' } },
      { 'ge', '<Plug>(smartword-ge)', mode = { 'n' } },
    },
  }, -- }}}
  { -- {{{3 sandwich
    'machakann/vim-sandwich',
    keys = {
      { '<Leader>i', '<Plug>(operator-sandwich-add)i', mode = { 'n' } },
      { '<Leader>ii', '<Plug>(textobj-sandwich-auto-i)<Plug>(operator-sandwich-add)', mode = { 'n' } },
      { '<Leader>a', '<Plug>(operator-sandwich-add)a', mode = { 'n' } },
      { '<Leader>aa', '<Plug>(textobj-sandwich-auto-a)<Plug>(operator-sandwich-add)', mode = { 'n' } },
      { '<Leader>a', '<Plug>(operator-sandwich-add)', mode = { 'x' } },
      { '<Leader>r', '<Plug>(sandwich-replace)', mode = { 'n', 'x' } },
      { '<Leader>rr', '<Plug>(sandwich-replace-auto)', mode = { 'n', 'x' } },
      { '<Leader>d', '<Plug>(sandwich-delete)', mode = { 'n', 'x' } },
      { '<Leader>dd', '<Plug>(sandwich-delete-auto)', mode = { 'n', 'x' } },
    },
    init = function()
      vim.g.sandwich_no_default_key_mappings = true
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
        { header = [[\<\%(\h\k*\.\)*\h\k*]], bra = '(', ket = ')', footer = '' },
      }
    end,
  }, -- }}}
  { 'kana/vim-niceblock', event = 'ModeChanged' },

  ---@desc On key
  { -- {{{3 dial
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

      keymap.set('n', '<C-t>', require('dial.map').inc_normal('case'), { silent = true, noremap = true })
      keymap.set('n', '<C-a>', require('dial.map').inc_normal(), { silent = true, noremap = true })
      keymap.set('n', '<C-x>', require('dial.map').dec_normal(), { silent = true, noremap = true })
      keymap.set('v', '<C-a>', require('dial.map').inc_visual(), { silent = true, noremap = true })
      keymap.set('v', '<C-x>', require('dial.map').dec_visual(), { silent = true, noremap = true })
      keymap.set('v', 'g<C-a>', require('dial.map').inc_gvisual(), { silent = true, noremap = true })
      keymap.set('v', 'g<C-x>', require('dial.map').dec_gvisual(), { silent = true, noremap = true })
    end,
  }, -- }}}
  { -- {{{3 registers
    'tversteeg/registers.nvim',
    keys = { { '"R', mode = { 'n', 'x' } }, { '<C-r>', mode = 'i' } },
    config = function()
      local registers = require('registers')
      keymap.set({ 'n', 'x' }, '"R', registers.show_window({ mode = 'motion' }), { silent = true, noremap = true })
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
          border = vim.g.float_border,
          transparency = 12,
        },
      })
    end,
  }, ---}}}
  { -- {{{3 undotree
    'mbbill/undotree',
    keys = { { '<F7>', '<Cmd>UndotreeToggle<CR>', desc = 'Toggle undotree' } },
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
      -- keymap.set('n', '<F7>', '<Cmd>UndotreeToggle<CR>')
    end,
  }, -- }}}

  ---@desc On command
  { -- {{{3 conform
    'stevearc/conform.nvim',
    cmd = { 'ConformInfo' },
    opts = {
      default_format_opts = { timeout_ms = 3000 },
      formatters_by_ft = {
        lua = { 'stylua' },
        json = { 'biome' },
        javascript = { 'biome-check' },
        typescript = { 'biome-check' },
        markdown = { 'markdownlint', 'prettier' },
      },
    },
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
    },
  }, -- }}}
  {
    'smjonas/inc-rename.nvim',
    cmd = 'IncRename',
    opts = {
      -- cmd_name = 'IncRename',
    },
  },
  { -- {{{3 translate
    'uga-rosa/translate.nvim',
    cmd = 'Translate',
    init = function()
      keymap.set({ 'n', 'x' }, 'me', '<Cmd>Translate EN<CR><C-[>', { silent = true })
      keymap.set({ 'n', 'x' }, 'mj', '<Cmd>Translate JA<CR><C-[>', { silent = true })
      keymap.set({ 'n', 'x' }, 'mE', '<Cmd>Translate EN -output=replace<CR>', { silent = true })
      keymap.set({ 'n', 'x' }, 'mJ', '<Cmd>Translate JA -output=replace<CR>', { silent = true })
    end,
  }, -- }}}
  { 'norcalli/nvim-colorizer.lua', cmd = 'ColorizerAttachToBuffer' },

  ---@desc On filetype
  { -- {{{3 render-markdown
    'MeanderingProgrammer/markdown.nvim',
    name = 'render-markdown',
    ft = 'markdown',
    opts = {
      enabled = true,
      render_modes = { 'n', 'c', 't' },
      sign = { enabled = false },
      debounce = 200,
      preset = 'obsidian',
      completions = { lsp = { enabled = true } },
      bullet = { enabled = true, icons = { '', '', '', '' } },
      checkbox = {
        enabled = true,
        unchecked = { icon = '󰄱', highlight = '@markup.list.unchecked' },
        checked = { icon = '󰱒', highlight = '@markup.list.unchecked' },
        custom = { todo = { raw = '[-]', rendered = '󰥔', highlight = '@markup.link' } },
      },
      anti_conceal = {
        enabled = false,
      },
      on = {
        attach = function()
          if api.nvim_buf_get_name(0):find('futago://chat', 1, true) then
            require('render-markdown').buf_disable()
          end
        end,
        render = function()
          if api.nvim_buf_get_name(0):find('futago://chat', 1, true) then
            require('render-markdown').buf_disable()
          end
        end,
      },
      heading = {
        enabled = true,
        render_modes = false,
        sign = false,
        icons = function()
          return ''
        end,
        position = 'inline',
        width = 'block',
        left_pad = 1,
        min_width = 80,
      },
      code = {
        enabled = true,
        render_modes = false,
        sign = false,
        width = 'block',
        left_pad = 1,
        min_width = 80,
      },
      win_options = {
        -- See :h 'concealcursor'
        concealcursor = { default = vim.api.nvim_get_option_value('concealcursor', {}), rendered = 'n' },
      },
    },
  }, -- }}}
  { 'tar80/vim-PPxcfg', dev = true, ft = 'PPxcfg' },
  { 'vim-jp/vimdoc-ja' },
} -- }}}2
