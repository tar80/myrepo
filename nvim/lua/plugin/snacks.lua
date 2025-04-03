-- vim:textwidth=0:foldmethod=marker:foldlevel=1

local symbol = require('tartar.icon.symbol')
local bigfile_opts = { -- {{{2
  enabled = true,
  notify = true,
  size = 1.5 * 1024 * 1024, -- 1.5MB
  line_length = 1000,
  -- Enable or disable features when big file detected
  ---@param ctx {buf: number, ft:string}
  setup = function(ctx)
    if vim.fn.exists(':NoMatchParen') ~= 0 then
      vim.cmd('NoMatchParen')
    end
    Snacks.util.wo(0, { foldmethod = 'manual', statuscolumn = '', conceallevel = 0 })
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(ctx.buf) then
        vim.bo[ctx.buf].syntax = ctx.ft
      end
    end)
  end,
} -- }}}2
local picker_opts = { -- {{{2
  prompt = symbol.cmdline.input .. ' ',
  jump = { -- {{{4
    jumplist = true, -- save the current position in the jumplist
    tagstack = false, -- save the current position in the tagstack
    reuse_win = false, -- reuse an existing window if the buffer is already open
    close = true, -- close the picker when jumping/editing to a location (defaults to true)
    match = false, -- jump to the first match position. (useful for `lines`)
  }, -- }}}4
  layout = { -- {{{4
    cycle = false,
    preset = function()
      return vim.o.columns >= 120 and 'default' or 'vertical'
    end,
  }, -- }}}4
  matcher = { -- {{{4
    fuzzy = true,
    smartcase = true,
    ignorecase = true,
    sort_empty = false,
    filename_bonus = true,
    file_pos = false,
    cwd_bonus = false,
    frecency = false,
    history_bonus = false,
  }, -- }}}4
  sort = {
    fields = { 'score:desc', '#text', 'idx' },
  },
  ui_select = true,
  win = { -- {{{4
    input = {
      keys = {
        ['<Esc>'] = 'cancel',
        ['<C-g>'] = { 'close', mode = { 'n', 'i' } },
        ['<C-w>'] = { '<c-s-w>', mode = { 'i' }, expr = true, desc = 'delete word' },
        ['<CR>'] = { 'confirm', mode = { 'n', 'i' } },
        ['<S-CR>'] = { { 'pick_win', 'jump' }, mode = { 'n', 'i' } },
        ['<S-Tab>'] = { 'select_and_prev', mode = { 'i', 'n' } },
        ['<Tab>'] = { 'select_and_next', mode = { 'i', 'n' } },
        ['<C-Down>'] = { 'history_forward', mode = { 'i', 'n' } },
        ['<C-Up>'] = { 'history_back', mode = { 'i', 'n' } },
        ['<Up>'] = { 'list_up', mode = { 'i', 'n' } },
        ['<Down>'] = { 'list_down', mode = { 'i', 'n' } },
        -- ['<a-d>'] = { 'inspect', mode = { 'n', 'i' } },
        ['<A-j>'] = { 'flash', mode = { 'n', 'i' } },
        ['<A-f>'] = { 'toggle_follow', mode = { 'i', 'n' } },
        ['<A-h>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
        ['<A-i>'] = { 'toggle_ignored', mode = { 'i', 'n' } },
        ['<A-m>'] = { 'toggle_maximize', mode = { 'i', 'n' } },
        ['<A-p>'] = { 'toggle_preview', mode = { 'i', 'n' } },
        ['<A-l>'] = { 'cycle_win', mode = { 'i', 'n' } },
        ['<A-w>'] = false,
        ['<C-a>'] = { '<home>', mode = { 'i' }, expr = true },
        ['<C-e>'] = { '<End>', mode = { 'i' }, expr = true },
        ['<C-b>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
        ['<C-f>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
        ['<C-u>'] = { 'list_scroll_up', mode = { 'i', 'n' } },
        ['<C-d>'] = { 'list_scroll_down', mode = { 'i', 'n' } },
        ['<C-k>'] = { 'list_up', mode = { 'i', 'n' } },
        ['<C-j>'] = { 'list_down', mode = { 'i', 'n' } },
        ['<C-p>'] = { 'list_up', mode = { 'i', 'n' } },
        ['<C-n>'] = { 'list_down', mode = { 'i', 'n' } },
        ['<C-l>'] = { 'toggle_live', mode = { 'i', 'n' } },
        ['<C-q>'] = { 'qflist', mode = { 'i', 'n' } },
        ['<C-s>'] = { 'edit_split', mode = { 'i', 'n' } },
        ['<C-t>'] = { 'tab', mode = { 'n', 'i' } },
        ['<C-v>'] = { 'edit_vsplit', mode = { 'i', 'n' } },
        ['?'] = 'toggle_help_input',
        ['G'] = 'list_bottom',
        ['gg'] = 'list_top',
        ['j'] = 'list_down',
        ['k'] = 'list_up',
        ['q'] = 'close',
      },
    },
    list = {
      keys = {
        ['<Esc>'] = 'cancel',
        ['/'] = 'toggle_focus',
        ['<2-LeftMouse>'] = 'confirm',
        ['<CR>'] = 'confirm',
        ['<Up>'] = 'list_up',
        ['<Down>'] = 'list_down',
        ['<S-Tab>'] = { 'select_and_prev', mode = { 'n', 'x' } },
        ['<Tab>'] = { 'select_and_next', mode = { 'n', 'x' } },
        ['<Leader>f'] = 'flash',
        ['<A-f>'] = 'toggle_follow',
        ['<A-h>'] = 'toggle_hidden',
        ['<A-i>'] = 'toggle_ignored',
        ['<A-m>'] = 'toggle_maximize',
        ['<A-p>'] = 'toggle_preview',
        ['<A-l>'] = 'cycle_win',
        ['<A-w>'] = false,
        ['<C-a>'] = 'select_all',
        ['<C-f>'] = 'preview_scroll_down',
        ['<C-b>'] = 'preview_scroll_up',
        ['<C-u>'] = 'list_scroll_up',
        ['<C-d>'] = 'list_scroll_down',
        ['<C-j>'] = 'list_down',
        ['<C-k>'] = 'list_up',
        ['<C-n>'] = 'list_down',
        ['<C-p>'] = 'list_up',
        ['<C-q>'] = 'qflist',
        ['<C-s>'] = 'edit_split',
        ['<C-t>'] = 'tab',
        ['<C-v>'] = 'edit_vsplit',
        ['?'] = 'toggle_help_list',
        ['G'] = 'list_bottom',
        ['gg'] = 'list_top',
        ['i'] = 'focus_input',
        ['j'] = 'list_down',
        ['k'] = 'list_up',
        ['q'] = 'close',
      },
      wo = {
        conceallevel = 2,
        concealcursor = 'nvc',
      },
    },
    preview = {
      keys = {
        ['<Esc>'] = 'cancel',
        ['q'] = 'close',
        ['i'] = 'focus_input',
        ['<ScrollWheelDown>'] = 'list_scroll_wheel_down',
        ['<ScrollWheelUp>'] = 'list_scroll_wheel_up',
        ['<A-l>'] = 'cycle_win',
        ['<A-w>'] = false,
      },
    },
  }, -- }}}4
  actions = {
    flash = function(picker)
      require('flash').jump({
        pattern = '^',
        label = { after = { 0, 0 } },
        search = {
          mode = 'search',
          exclude = {
            function(win)
              return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'snacks_picker_list'
            end,
          },
        },
        action = function(match)
          local idx = picker.list:row2idx(match.pos[1])
          picker.list:_move(idx, true, true)
        end,
      })
    end,
  },
  formatters = { -- {{{4
    text = {
      ft = nil, ---@type string? filetype for highlighting
    },
    file = {
      filename_first = false,
      truncate = 40,
      filename_only = false,
      icon_width = 3,
      git_status_hl = true,
    },
    selected = {
      show_always = false,
      unselected = false,
    },
    severity = {
      icons = true,
      level = false,
      pos = 'left',
    },
  }, -- }}}4
  layouts = { -- {{{4
    default = {
      layout = {
        box = 'horizontal',
        width = 0.8,
        min_width = 120,
        height = 0.8,
        {
          box = 'vertical',
          border = 'single',
          title = '{title} {flags}',
          { win = 'input', height = 1, border = 'bottom' },
          { win = 'list', border = 'none' },
        },
        { win = 'preview', title = '{preview}', border = 'single', width = 0.6 },
      },
    },
    sideview = {
      preview = 'main',
      layout = {
        backdrop = false,
        width = 80,
        min_width = 80,
        height = 0,
        position = 'left',
        border = 'none',
        box = 'vertical',
        { win = 'list', border = 'none' },
        { win = 'preview', title = '{preview}', height = 0.4, border = 'top' },
      },
    },
    vscode = {
      preview = false,
      layout = {
        backdrop = false,
        row = 1,
        width = 0.4,
        min_width = 80,
        height = 0.6,
        border = 'none',
        box = 'vertical',
        { win = 'input', height = 1, border = 'single', title = '{title} {flags}', title_pos = 'center' },
        { win = 'list', border = 'none' },
        { win = 'preview', title = '{preview}', border = 'single' },
      },
    },
  }, -- }}}4
  previewers = { -- {{{4
    diff = {
      builtin = true,
      cmd = { 'delta' },
    },
    git = {
      builtin = true,
      args = {}, -- additional arguments passed to the git command. Useful to set pager options usin `-c ...`
    },
    file = {
      max_size = 1024 * 1024, -- 1MB
      max_line_length = 500, -- max line length
      ft = nil,
    },
    man_pager = nil,
  }, -- }}}4
  sources = { -- {{{4
    files = {
      cmd = 'fd',
      hidden = true,
      ignored = true,
      support_live = false,
      exclude = { '*.exe', '*.dll', '*.EXE', '*.DLL', 'node_modules/', 'dist/', 'themes/' },
    },
    kensaku = {
      format = 'file',
      regex = true,
      show_enpty = false,
      live = true,
      support_live = true,
    },
  }, -- }}}4
  toggles = { -- {{{4
    follow = 'f',
    hidden = 'h',
    ignored = 'i',
    modified = 'm',
    regex = { icon = 'R', value = false },
  }, -- }}}4
  icons = { -- {{{4
    ui = {
      live = '󰐰',
      hidden = 'h',
      ignored = 'i',
      follow = 'f',
      selected = '',
      -- selected = '●',
      -- unselected = '○',
    },
    git = {
      enabled = true,
      commit = '󰜘',
      staged = '●',
      added = '',
      deleted = '',
      ignored = '',
      modified = '○',
      renamed = '',
      unmerged = '?',
      untracked = '?',
    },
    diagnostics = symbol.severity,
    lsp = {
      unavailable = '',
      enabled = ' ',
      disabled = ' ',
      attached = '󰖩 ',
    },
    kinds = require('tartar.icon.kind'),
  }, --}}}4
  db = { sqlite3_path = nil },
  debug = { -- {{{4
    scores = false, -- show scores in the list
    leaks = false, -- show when pickers don't get garbage collected
    explorer = false, -- show explorer debug info
    files = false, -- show file debug info
    grep = false, -- show file debug info
    proc = false, -- show proc debug info
    extmarks = false, -- show extmarks errors
  }, -- }}}4
} -- }}}2
local style_opts = { -- {{{2
  float = {
    position = 'float',
    backdrop = false,
    height = 0.8,
    width = 0.8,
    zindex = 50,
    wo = { winhighlight = 'NormalFloat:Normal' },
  },
  help = {
    border = 'single',
    position = 'float',
    backdrop = false,
    row = -1,
    width = 0,
    height = 0.3,
  },
  minimal = {
    wo = {
      cursorcolumn = false,
      cursorline = false,
      cursorlineopt = 'both',
      colorcolumn = '',
      fillchars = 'eob: ,lastline:…',
      list = false,
      listchars = 'extends:…,tab:  ',
      number = false,
      relativenumber = false,
      signcolumn = 'no',
      spell = false,
      winbar = '',
      statuscolumn = '',
      wrap = false,
      sidescrolloff = 0,
    },
  },
} -- }}}2
local win_opts = { -- {{{2
  backdrop = false,
  show = true,
  fixbuf = true,
  relative = 'editor',
  position = 'float',
  minimal = true,
  wo = {
    winhighlight = 'Normal:StabaNormal',
  },
  keys = { q = 'close' },
} -- }}}2
local keys = { -- {{{2
  {
    '<Leader><Leader><Leader>',
    function()
      local mod = package.loaded['fidget']
      if mod then
        mod.notification.clear()
      end
    end,
    desc = 'Clear notifications',
  },
  -- {
  --   '<Leader>m',
  --   function()
  --     vim.cmd.wshada()
  --     Snacks.picker.recent({
  --       layout = 'vscode',
  --     })
  --   end,
  --   desc = 'Most Recently Used Files',
  -- },
  {
    '<Leader>:',
    function()
      Snacks.picker.buffers({
        layout = { preset = 'default' },
      })
    end,
    desc = 'Buffers',
  },
  {
    '<Leader>@',
    function()
      Snacks.picker.files({
        cwd = require('helper').myrepo_path('nvim/lua'),
        layout = 'vscode',
      })
    end,
    desc = 'Find Config File',
  },
  {
    '<Leader>o',
    function()
      Snacks.picker.files({
        cwd = vim.uv.cwd(),
        layout = 'vscode',
      })
    end,
    desc = 'Files',
  },
  {
    '<Leader>p',
    function()
      Snacks.picker.files({
        cwd = vim.api.nvim_buf_get_name(0):gsub('[^\\/]*$', ''),
        layout = 'vscode',
      })
    end,
    desc = 'Files',
  },
  -- {
  --   '<Leader>z',
  --   function()
  --     local opts = {
  --       prompt = 'zoxide query: ',
  --     }
  --     vim.ui.input(opts, function(input)
  --       if input and input ~= '' then
  --         vim.system({ 'zoxide', 'add', input }, { text = true })
  --         vim.system({ 'zoxide', 'query', input }, { text = true }, function(data)
  --           vim.schedule(function()
  --             if data.code == 0 and data.stdout then
  --               Snacks.picker.files({
  --                 cwd = data.stdout:gsub('\n', ''),
  --               })
  --             else
  --               vim.notify('zoxide: no match found', 3)
  --             end
  --           end)
  --         end)
  --       end
  --     end)
  --   end,
  --   desc = 'Zoxide',
  -- },
  -- {
  --   '<Leader>k',
  --   function()
  --     require('snacks.picker.config.sources').kensaku = require('plugin/source/snacks_kensaku')
  --     Snacks.picker.kensaku()
  --   end,
  --   desc = 'Kensaku',
  -- },
  {
    '<Leader>h',
    function()
      require('staba').wrap_no_fade_background(Snacks.picker.help, {
        finder = 'help',
        format = 'text',
        -- layout = { preset = 'left' },
        confirm = 'help',
      })
    end,
    desc = 'Help Pages',
  },
  {
    '<Space>/',
    function()
      require('staba').wrap_no_fade_background(Snacks.picker.lines, {
        focus = 'list',
        pattern = vim.fn.expand('<cword>'),
        matcher = { fuzzy = false, smartcase = true, ignorecase = true, sort_empty = false },
        layout = { preset = 'vscode' },
      })
    end,
    desc = 'Lines',
  },
  -- git
  -- {
  --   '<Leader>gb',
  --   function()
  --     Snacks.picker.git_branches({
  --       layout = { preset = 'left' },
  --     })
  --   end,
  --   desc = 'Git Branches',
  -- },
  {
    '<Leader>gd',
    function()
      Snacks.picker.git_diff({
        live = false,
      })
    end,
    desc = 'Git Diff (Hunks)',
  },
  {
    '<Leader>gl',
    function()
      Snacks.picker.git_log({
        layout = { preset = 'sideview' },
      })
    end,
    desc = 'Git Log',
  },
  {
    '<Leader>gs',
    function()
      Snacks.picker.git_stash()
    end,
    desc = 'Git Stash',
  },
  {
    '<Leader>ss',
    function()
      Snacks.picker()
    end,
    desc = 'Pickers',
  },
  {
    '<Leader>sr',
    function()
      Snacks.picker.registers()
    end,
    desc = 'Registers',
  },
  {
    '<Leader>sa',
    function()
      Snacks.picker.autocmds()
    end,
    desc = 'Autocmds',
  },
  {
    '<Leader>sh',
    function()
      Snacks.picker.highlights()
    end,
    desc = 'Highlights',
  },
  {
    '<Leader>si',
    function()
      Snacks.picker.icons()
    end,
    desc = 'Icons',
  },
  {
    '<Leader>sk',
    function()
      Snacks.picker.keymaps()
    end,
    desc = 'Keymaps',
  },
  {
    '<Leader>sl',
    function()
      Snacks.picker.lazy()
    end,
    desc = 'Search for Plugin Spec',
  },
  {
    '<Leader>sq',
    function()
      Snacks.picker.qflist()
    end,
    desc = 'Quickfix List',
  },
  {
    '<Leader>sc',
    function()
      Snacks.picker.colorschemes()
    end,
    desc = 'Colorschemes',
  },
  {
    'gls',
    function()
      Snacks.picker.lsp_symbols()
    end,
    desc = 'LSP Symbols',
  },
  {
    'glx',
    function()
      Snacks.gitbrowse()
    end,
    desc = 'Git Browse',
    mode = { 'n', 'v' },
  },
  {
    '<Leader>N',
    desc = 'Neovim News',
    function()
      Snacks.win({
        file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
        backdrop = 50,
        width = 0.8,
        height = 0.8,
        wo = {
          spell = false,
          wrap = false,
          signcolumn = 'auto',
          statuscolumn = ' ',
          conceallevel = 3,
        },
      })
    end,
  },
  {
    ']]',
    function()
      Snacks.words.jump(vim.v.count1)
    end,
    desc = 'Next Reference',
    mode = { 'n', 't' },
  },
  {
    '[[',
    function()
      Snacks.words.jump(-vim.v.count1)
    end,
    desc = 'Prev Reference',
    mode = { 'n', 't' },
  },
} -- }}}2

return {
  'folke/snacks.nvim',
  priority = 999,
  lazy = false,
  keys = keys,
  opts = { -- {{{2
    bigfile = bigfile_opts,
    picker = picker_opts,
    quickfile = { enabled = true },
    win = win_opts,
    styles = style_opts,
    -- dashboard = { enabled = true },
    -- explorer = { enabled = true },
    -- image = { enabled = true },
    -- indent = { enabled = true },
    -- input = { enabled = true },
    -- notifier = { enabled = true },
    -- scope = { enabled = true },
    -- scratch = { enabled = true },
    -- scroll = { enabled = true },
    -- statuscolumn = { enabled = true },
    -- words = { enabled = true },
  }, -- }}}2
  init = function() -- {{{2
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd
        vim.api.nvim_create_user_command('R', function(opts)
          Snacks.rename.rename_file({
            from = vim.api.nvim_buf_get_name(0),
            to = opts.args,
          })
        end, { nargs = '?', desc = 'Rename File' })
        -- Create some toggle mappings
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<Leader><Leader>w')
        Snacks.toggle
          .option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
          :map('<Leader><Leader>c')
        Snacks.toggle.inlay_hints():map('gli')
        Snacks.toggle.diagnostics():map('gld')
      end,
    })
  end, -- }}}2
}
