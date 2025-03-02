-- vim:textwidth=0:foldmethod=marker:foldlevel=1:

local api = vim.api
local keymap = vim.keymap
local helper = require('helper')

local augroup = api.nvim_create_augroup('rc_plugin', {})
vim.api.nvim_create_autocmd('UIEnter', {
  group = augroup,
  once = true,
  callback = function()
    vim.cmd.colorscheme(vim.g.colors_name)
    -- local msg = ('Startup time: %s'):format(require('lazy').stats().startuptime)
    -- vim.notify(msg)
  end,
})

local function git_branch() -- {{{3
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

return { -- {{{2
  ---@library
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'MunifTanjim/nui.nvim', lazy = true },
  { 'nvim-tree/nvim-web-devicons', lazy = true },
  { -- {{{3 tiny-devicons-auto-colors
    'rachartier/tiny-devicons-auto-colors.nvim',
    -- lazy = true,
    event = 'VeryLazy',
    config = function()
      local ok, loose = pcall(require, 'loose')
      local opts = {
        cache = {
          enabled = true,
          path = helper.xdg_path('cache', 'tiny-devicons-auto-colors-cache.json'),
        },
        autoreload = true,
      }
      if ok then
        opts.colors = loose.get_palette()
        require('tiny-devicons-auto-colors').setup(opts)
      end
    end,
  }, -- }}}
  -- { 'tar80/tartare.nvim', event = 'UIEnter', opts = {}, },

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
    dependencies = { 'nvim-web-devicons' },
    config = function()
      vim.keymap.set('n', 'gb', '<Plug>(staba-pick)')
      vim.keymap.set('n', '<Space>1', '<Plug>(staba-cleanup)')
      vim.keymap.set('n', '<Space>q', '<Plug>(staba-delete-select)')
      vim.keymap.set('n', '<Space>qq', '<Plug>(staba-delete-current)')
      require('staba').setup({
        -- no_name = '^blank',
        enable_fade = true,
        enable_underline = true,
        enable_statuscolumn = true,
        enable_statusline = true,
        enable_tabline = true,
        mode_line = 'LineNr',
        ignore_filetypes = {
          statusline = { 'terminal', 'trouble' },
        },
        -- nav_key = '',
        statusline = {
          active = {
            left = { 'staba_logo', 'noice_mode' },
            middle = { 'search_count' },
            right = { '%<', 'diagnostics', ' ', git_branch, 'encoding', ' ', 'position' },
          },
          -- inactive = { left = {}, middle = { 'devicon', 'filename', '%*' }, right = {} },
        },
        tabline = {},
        -- icons = {},
      })
    end,
    event = 'UIEnter',
    dev = true,
  }, -- }}}
  { -- {{{ rereope
    'tar80/rereope.nvim',
    opts = {},
    dev = true,
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
  }, -- }}}
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
    -- event = 'VeryLazy',
    keys = { 'f', 'F', 't', 'T', 'd', 'v', 'y' },
    dev = true,
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
    event = 'VeryLazy',
    dev = true,
    opts = {
      ignore_filetypes = { 'TelescopePrompt', 'TelescopeResults', 'cmp-menu', 'cmp-docs' },
      -- ignore_buftypes = {},
      jump_key = '%',
      indicator = 0,
      sign = false,
      show_parent = true,
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
    keys = { { '""', mode = { 'n', 'x' } }, { '<C-r>', mode = 'i' } },
    config = function()
      local registers = require('registers')
      keymap.set({ 'n', 'x' }, '""', registers.show_window({ mode = 'motion' }), { silent = true, noremap = true })
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
      enabled = false,
      render_modes = { 'n', 'c', 't' },
      debounce = 200,
      preset = 'obsidian',
      bullet = { enabled = true, icons = { '', '', '', '' } },
      sign = { enabled = false },
      checkbox = {
        enabled = true,
        unchecked = { icon = '󰄱', highlight = '@markup.list.unchecked' },
        checked = { icon = '󰱒', highlight = '@markup.list.unchecked' },
        custom = { todo = { raw = '[-]', rendered = '󰥔', highlight = '@markup.raw' } },
      },
      anti_conceal = {
        enabled = false,
      },
      on = {
        attach = function()
          if api.nvim_buf_get_name(0):find('futago://chat', 1, true) then
            require('render-markdown').disable()
          end
        end,
      },
      win_options = {
        -- See :h 'concealcursor'
        concealcursor = {
          default = vim.api.nvim_get_option_value('concealcursor', {}),
          rendered = 'n',
        },
      },
    },
  }, -- }}}
  { 'tar80/vim-PPxcfg', dev = true, ft = 'PPxcfg' },
  { 'vim-jp/vimdoc-ja' },
} -- }}}
