-- vim:textwidth=0:foldmethod=marker:foldlevel=1:

local api = vim.api
local keymap = vim.keymap
local helper = require('helper')

local augroup = api.nvim_create_augroup('rc_plugin', {})
vim.api.nvim_create_autocmd('UIEnter', {
  group = augroup,
  once = true,
  callback = function()
    local msg = ('Startup time: %s'):format(require('lazy').stats().startuptime)
    vim.notify(msg, vim.log.levels.INFO)
    vim.cmd.colorscheme(vim.g.colors_name)
  end,
})

return { -- {{{2
  ---@library
  { 'nvim-lua/plenary.nvim', lazy = true },
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
          0xE0C7,
          0xE285,
          0xE725,
          0xEA71,
          0xEABC,
          0xEAAA,
          0xEAAB,
        })
        return cw
      end,
    },
    build = function()
      require('cellwidths').remove()
    end,
  }, -- }}}
  { 'folke/ts-comments.nvim', event = 'VeryLazy', opts = {} },
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
    keys = { 'f', 'F', 't', 'T', 'd', 'v' },
    dev = true,
    opts = {
      fret_enable_kana = true,
      fret_enable_symbol = true,
      fret_repeat_notify = false,
      fret_smart_fold = true,
      fret_timeout = 9000,
      fret_beacon = true,
      -- beacon_opts = { hl = 'LazyButtonActive', blend = 30, freq = 15 },
      mapkeys = { fret_f = 'f', fret_F = 'F', fret_t = 't', fret_T = 'T' },
    },
  }, ---}}}
  { -- {{{3 matchwith
    'tar80/matchwith.nvim',
    event = 'VeryLazy',
    dev = true,
    opts = {
      ignore_filetypes = { 'TelescopePrompt', 'cmp-menu', 'cmp-docs' },
      -- ignore_buftypes = {},
      jump_key = '%',
      -- indicator = 200,
      -- sign = true,
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
  { -- {{{3 operator-replace
    'yuki-yano/vim-operator-replace',
    dependencies = { 'vim-operator-user' },
    init = function()
      local popup_register = function(input) -- {{{
        if vim.fn.reg_executing() ~= '' then
          return input
        end
        local mode = vim.api.nvim_get_mode().mode:lower()
        if mode:find('v', 1, true) then
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
          local float = require('float').popup({
            border = vim.g.float_border,
            data = reg_str,
            winblend = 0,
            hl = { link = 'SpecialKey' },
          })
          api.nvim_create_autocmd({ 'ModeChanged' }, {
            group = augroup,
            -- pattern = '*',
            pattern = 'no:[nc]*',
            once = true,
            callback = function()
              print(vim.api.nvim_get_mode().mode)
              if float and api.nvim_buf_is_valid(float[1]) then
                api.nvim_buf_delete(float[1], { force = true })
              end
            end,
          })
        end)
        return input
      end -- }}}
      keymap.set({ 'n', 'x' }, '_', function()
        local input = '*'
        input = popup_register(input)
        return string.format('"%s<Plug>(operator-replace)', input)
      end, { expr = true })
      keymap.set({ 'n', 'x' }, '\\', function()
        local input = vim.fn.nr2char(vim.fn.getchar())
        input = input == '\\' and '0' or input
        input = popup_register(input)
        return string.format('"%s<Plug>(operator-replace)', input)
      end, { expr = true })
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
    keys = {
      { '""', mode = { 'n', 'x' } },
      { '<C-R>', mode = 'i' },
    },
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
      enabled = true,
      bullet = { enabled = true, icons = { '', '', '', '' } },
      sign = { enabled = false },
      checkbox = {
        enabled = true,
        unchecked = { icon = '󰄱', highlight = '@markup.list.unchecked' },
        checked = { icon = '󰱒', highlight = '@markup.list.unchecked' },
        custom = { todo = { raw = '[-]', rendered = '󰥔', highlight = '@markup.raw' } },
      },
      on = {
        attach = function()
          if api.nvim_buf_get_name(0):find('futago://chat', 1, true) then
            require('render-markdown').disable()
          end
        end,
      },
    },
  }, -- }}}
  { 'tar80/vim-PPxcfg', dev = true, ft = 'PPxcfg' },
  { 'vim-jp/vimdoc-ja' },
} -- }}}
