-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

local color_scheme = vim.api.nvim_get_var('use_scheme')
local colors = require(string.format('feline.themes.%s', color_scheme))

---@desc Colorscheme {{{1
---@desc time-manage {{{2
local time_manage = (function()
  local h = os.date('*t').hour
  local tbl = {}
  if h > 6 and h < 19 then
    tbl = {
      theme = 'decay',
      fade = false,
      hl = {
        Normal = { bg = '#103030' },
        NormalNC = { bg = '#133939' },
        NormalFloat = { bg = '#102929' },
        CursorLine = { fg = 'NONE', bg = '#A33865' },
      },
    }
  else
    tbl = {
      theme = 'decay',
      fade = true,
      hl = {
        CursorLine = { fg = 'NONE', bg = '#A33865' },
      },
    }
  end
  return tbl
end)()

---@desc ColorScheme Setup {{{2
---@cast color_scheme -nil
require(color_scheme).setup({
  theme = time_manage.theme,
  borders = true, -- Split window borders
  fade_nc = true, -- Fade non-current windows, making them more distinguishable
  fade_no_bg = time_manage.fade,
  -- fade_no_bg = true, -- Enable fade_nc but disable current pane background
  styles = {
    comments = 'NONE',
    strings = 'NONE',
    keywords = 'NONE',
    functions = 'NONE',
    variables = 'NONE',
    diagnostics = 'underline',
    references = 'NONE',
  },
  disable = {
    background = false,
    cursorline = false,
    eob_lines = true,
  },
  custom_highlights = time_manage.hl,
  plugins = {
    lsp = true,
    treesitter = true,
    telescope = true,
    fuzzy_motion = true,
    cmp = true,
    gitsigns = true,
    fret = true,
    skkeleton_indicator = true,
    -- notify = true
  },
})
---}}}2

---@desc Nvim-Tabline {{{1
---@see https://github.com/crispgm
---@desc highlights {{{2
vim.api.nvim_set_hl(0, 'TabLineFill', { fg = colors.theme.fg, bg = colors.theme.bg })
vim.api.nvim_set_hl(0, 'TabLineSel', { fg = colors.theme.cyan, bg = colors.theme.bg2 })
vim.api.nvim_set_hl(0, 'TabLine', { fg = colors.theme.green, bg = colors.theme.bg })

---@desc options {{{2
local options = {
  show_index = true,
  show_modify = true,
  modify_indicator = '',
  no_name = '[No Name]',
}

---@desc tabline() {{{2
local function tabline(opts)
  local s = ''
  for index = 1, #vim.api.nvim_list_tabpages() do
    local winnr = vim.fn.tabpagewinnr(index)
    local buflist = vim.fn.tabpagebuflist(index)
    local bufnr = buflist[winnr]
    local bufname = vim.fn.bufname(bufnr)
    local bufmodified = vim.api.nvim_buf_get_option(bufnr, 'modified')

    local color = index == vim.fn.tabpagenr() and '%#TabLineSel#' or '%#TabLineFill#'
    local idx = opts.show_index and index or ''
    local name = bufname ~= '' and vim.fn.fnamemodify(bufname, ':t') or opts.no_name
    local modifier = bufmodified and opts.show_modify and opts.modify_indicator ~= nil and opts.modify_indicator or ''
    s = string.format('%s%%%sT%s %s %s %s', s, index, color, idx, name, modifier)
  end

  s = string.format('%s%%#TabLineFill#%%T%%=%%#TabLine#%%{getcwd()} ', s)
  return s
end

function _G.nvim_tabline()
  return tabline(options)
end

vim.o.tabline = '%!v:lua.nvim_tabline()'
---}}}2

---@desc Feline {{{1
if not pcall(require, 'feline') then
  return
end

---@desc Initial {{{2
local vm = require('feline.providers.vi_mode')

---@desc icon {{{2
local icon = {
  dos = { '', 'blue' },
  unix = { '', 'olive' },
  mac = { '', 'pink' },
  ERROR = { '', 'pink' },
  WARN = { '', 'olive' },
  INFO = { '', 'blue' },
  HINT = { '', 'purple' },
  git = { '', 'green' },
  stage = {},
  unstage = {},
}
---}}}2

---@desc Feline left
---@desc Mode {{{2
local mode = {
  priority = 2,
  vim = {
    provider = {
      name = 'vi_mode',
      opts = {
        show_mode_name = true,
        padding = 'center',
      },
    },
    short_provider = function()
      return string.format(' %s', string.sub(vm.get_vim_mode(), 1, 1))
    end,
    icon = '',
    hl = function()
      return {
        fg = 'bg',
        bg = require('feline.providers.vi_mode').get_mode_color(),
      }
    end,
  },
  skkeleton = {
    provider = function()
      local mode = {
        hira = 'あ ',
        kata = 'ア ',
        hankata = 'ｱ  ',
        zenkaku = 'Ａ ',
        abbrev = 'ab ',
        [''] = '',
      }
      return vim.g.loaded_skkeleton == true and mode[vim.fn['skkeleton#mode']()] or ''
    end,
    enabled = function()
      return vim.api.nvim_get_mode().mode == 'i'
    end,
    hl = function()
      return {
        fg = 'bg2',
        bg = require('feline.providers.vi_mode').get_mode_color(),
      }
    end,
  },
  sep = {
    provider = '',
    hl = function()
      return {
        fg = require('feline.providers.vi_mode').get_mode_color(),
        bg = 'bg2',
      }
    end,
  },
}
---@desc Diagnostics {{{2
local function diagnostics_count(severity)
  return vim.fn.mode() == 'n' and vim.tbl_count(vim.diagnostic.get(0, { severity = vim.diagnostic.severity[severity] }))
    or 0
  -- return vim.tbl_count(vim.diagnostic.get(0, { severity = vim.diagnostic.severity[severity] }))
end
local function diagnostics_provider(severity)
  return function()
    local count = diagnostics_count(severity)
    return string.format(' %s%s ', icon[severity][1], count)
  end
end
local function diagnostics_enable(severity)
  return function()
    return diagnostics_count(severity) ~= 0
  end
end
local diag_signs = function(severity)
  return {
    provider = diagnostics_provider(severity),
    enabled = diagnostics_enable(severity),
    hl = {
      fg = icon[severity][2],
      bg = 'bg2',
    },
  }
end
local diag = {
  err = diag_signs('ERROR'),
  warn = diag_signs('WARN'),
  info = diag_signs('INFO'),
  hint = diag_signs('HINT'),
  sep = {
    left_sep = { str = ' ', hl = { fg = 'bg2' }, always_visible = true },
  },
}
---@desc Edit status {{{2
local edit = {
  priority = 1,
  readonly = {
    provider = function()
      return vim.bo.readonly and '' or ''
    end,
    hl = {
      fg = 'purple',
    },
  },
  name = {
    provider = function()
      local path = vim.api.nvim_buf_get_name(0)

      return path == '' and 'no name' or vim.fn.fnamemodify(path, ':.')
    end,
    hl = function()
      return {
        fg = require('feline.providers.vi_mode').get_mode_color(),
      }
    end,
  },
  modified = {
    provider = function()
      return vim.bo.modified and ' ' or ''
    end,
    hl = { fg = 'cyan' },
  },
  -- sep = {
  --   right_sep = { str = "  ", always_visible = true },
  --   hl = { bg = "fg" },
  -- },
}
---}}}2

---@desc Feline Center

---@desc Feline Right
---@desc sepalator {{{2
local sepalator = {
  str = '  ',
  hl = { fg = 'bg2' },
}
---@desc Git {{{2
local git = {
  priority = -2,
  branch = {
    provider = function()
      return vim.b.mug_branch_name and string.format('%s %s', icon.git[1], vim.b.mug_branch_name) or ''
    end,
    short_provider = icon.git[1],
    hl = {
      fg = icon.git[2],
    },
  },
  info = {
    provider = function()
      local info = vim.b.mug_branch_info or ''
      return info ~= '' and string.format('(%s)', info) or ' '
      -- return info ~= '' and '(' .. info .. ') ' or ' '
    end,
    hl = {
      fg = icon.git[2],
    },
  },
  status = {
    provider = function()
      local state = vim.b.mug_branch_stats
      return state and string.format('+%s ~%s !%s', state.s, state.u, state.c) or ''
      -- return state and '+' .. state.s .. ' ~' .. state.u .. ' !' .. state.c or ''
    end,
    hl = {
      fg = icon.git[2],
    },
    truncate_hide = true,
  },
}
---@desc File info {{{2
local file = {
  priority = -2,
  type = {
    provider = function()
      return vim.api.nvim_buf_get_option(0, 'filetype')
      -- return ft .. icon[ff][1]
      -- return vim.bo.filetype .. icon[vim.bo.fileformat][1]
    end,
    hl = { fg = 'cyan' },
    left_sep = sepalator,
  },
  encode = {
    provider = function()
      local ff = vim.api.nvim_buf_get_option(0, 'fileformat')
      return string.format('%s %s', vim.api.nvim_buf_get_option(0, 'fileencoding'), icon[ff][1])
    end,
    hl = function()
      local bufnr = tonumber(vim.api.nvim_get_var('actual_curbuf'))
      return { fg = icon[vim.api.nvim_get_option_value('fileformat', { buf = bufnr })][2] }
    end,
    left_sep = sepalator,
  },
  truncate_hide = true,
}
---@desc Line {{{2
local line = {
  priority = -2,
  pos = {
    provider = {
      name = 'position',
      opts = {
        padding = {
          col = 3,
          line = 3,
        },
      },
    },
    hl = { fg = 'purple' },
    left_sep = sepalator,
    truncate_hide = true,
  },
  percent = {
    provider = 'line_percentage',
    hl = { fg = 'purple' },
    left_sep = sepalator,
    truncate_hide = true,
  },
}

--@desc Feline inactive {{{2
local filetype = {
  provider = function()
    return ' ' .. vim.bo.filetype .. ' '
  end,
  hl = { fg = 'cyan', bg = 'bg2' },
  sep = {
    provider = '',
    hl = function()
      return {
        fg = 'bg',
        bg = 'bg2',
      }
    end,
  },
}
local path = {
  provider = function()
    return ' ' .. vim.api.nvim_buf_get_name(0)
  end,
  hl = { fg = 'fg' },
}

---@desc Setup
---@desc Table {{{2
local active = {
  {
    mode.vim,
    mode.skkeleton,
    mode.sep,
    diag.err,
    diag.warn,
    diag.info,
    diag.hint,
    diag.sep,
    edit.readonly,
    edit.name,
    edit.modified,
    edit.sep,
  },
  {},
  { git.branch, git.info, git.status, file.type, file.encode, line.pos, line.percent },
}
local inactive = {
  { filetype, filetype.sep, path },
  {},
  { line.percent },
}
---@desc Feline Setup {{{2
require('feline').setup({
  theme = colors.theme,
  vi_mode_colors = colors.vi_mode,
  components = { active = active, inactive = inactive },
  highlight_reset_triggers = { 'SessionLoadPost', 'ColorScheme' },
  force_inactive = {
    filetypes = {
      'qf',
      'help',
      'diff',
    },
    buftypes = { 'terminal' },
    bufnames = {},
  },
  disable = {
    filetypes = {},
  },
})
--}}}

color_scheme = nil
