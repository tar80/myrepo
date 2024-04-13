-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------
---@desc Transparent background
---@type boolean|nil
local tr = vim.g.tr_bg
vim.g.tr_bg = nil

---@desc Colorscheme {{{2
local color_scheme = 'loose'
---@type string, string, string
local cursor_color, background, theme_name;
---Time manage {{{3
(function()
  local h = os.date('*t').hour
  if h > 6 and h < 18 then
    cursor_color = '#FA8699'
    background = 'light'
    theme_name = 'light'
  else
    cursor_color = '#A33856'
    background = 'dark'
    theme_name = 'mossco'
  end
end)()

local colors = require(string.format('feline.themes.%s', theme_name))
local palette = require('loose').colors(theme_name)

---ColorScheme Setup {{{3
---@cast color_scheme -nil
require(color_scheme).setup({
  background = background,
  theme = theme_name,
  borders = true,
  fade_nc = true,
  fade_tr = false,
  styles = {
    comments = 'italic',
    strings = 'NONE',
    keywords = 'bold',
    functions = 'NONE',
    variables = 'NONE',
    diagnostics = 'underline',
    references = 'NONE',
    virtualtext = 'italic',
  },
  disable = {
    background = tr,
    cursorline = false,
    eob_lines = true,
  },
  custom_highlights = {
    CursorLine = { fg = 'NONE', bg = cursor_color },
    -- LspReferenceText = { bg =  palette.nc},
    LspReferenceRead = { bg =  palette.nc},
    LspReferenceWrite = { bg =  palette.nc},
  },
  plugins = {
    lazy = true,
    lsp = true,
    lspsaga = true,
    lspconfig = true,
    treesitter = true,
    telescope = 'border_fade',
    fuzzy_motion = true,
    cmp = true,
    gitsigns = true,
    fret = true,
    skkeleton_indicator = true,
    sandwich = true,
    trouble = true,
    dap = true,
    dap_virtual_text = true,
    -- notify = true
  },
})


---@desc Nvim-Tabline {{{2
---@see https://github.com/crispgm
---Highlights {{{3
vim.api.nvim_set_hl(0, 'TabLine', { fg = colors.theme.green, bg = colors.theme.bg2, italic = true })
vim.api.nvim_set_hl(0, 'TabLineSel', { fg = colors.theme.cyan, bg = palette.bg, italic = false })
vim.api.nvim_set_hl(0, 'TabLineFill', { fg = colors.theme.fg, bg = colors.theme.bg2, italic = true })

---Options {{{3
local options = {
  show_index = true,
  show_modify = true,
  modify_indicator = '',
  no_name = '[No Name]',
}

---Tabline() {{{3
local function tabline(opts)
  local s = ''
  for index = 1, #vim.api.nvim_list_tabpages() do
    local winnr = vim.fn.tabpagewinnr(index)
    local buflist = vim.fn.tabpagebuflist(index)
    local bufnr = buflist[winnr]
    local bufname = vim.fn.bufname(bufnr)
    local bufmodified = vim.api.nvim_get_option_value('modified', { buf = bufnr })

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

---@desc Feline {{{2
if not pcall(require, 'feline') then
  return
end

local vm = require('feline.providers.vi_mode')

---Icons {{{3
local icon = {
  dos = { '', 'blue' },
  unix = { '', 'olive' },
  mac = { '', 'pink' },
  ERROR = { '', palette.error },
  WARN = { '', palette.warn },
  INFO = { '', palette.info },
  HINT = { '', palette.hint },
  git = { '', 'green' },
  stage = {},
  unstage = {},
}

---@desc Feline left
---Mode {{{3
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
---Diagnostics {{{3
local function diagnostics_count(severity)
  return vim.api.nvim_get_mode().mode == 'n'
      and vim.tbl_count(vim.diagnostic.get(0, { severity = vim.diagnostic.severity[severity] }))
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
---Edit status {{{3
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
        style = 'italic',
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

---Center {{{3
local search = {
  priority = -2,
  count = {
    provider = { name = 'search_count' },
    hl = { fg = 'olive' },
    truncate_hide = true,
  },
}

---Right {{{3
local sepalator = {
  str = '  ',
  hl = { fg = 'fg' },
}
---Git {{{4
local git = {
  priority = -2,
  branch = {
    provider = function()
      return vim.b.mug_branch_name and string.format('%s %s', icon.git[1], vim.b.mug_branch_name) or ''
    end,
    short_provider = icon.git[1],
    hl = {
      fg = icon.git[2],
      style = 'italic',
    },
  },
  info = {
    provider = function()
      local info = vim.b.mug_branch_info or ''
      return info ~= '' and string.format('(%s)', info) or ' '
    end,
    hl = {
      fg = icon.git[2],
      style = 'italic',
    },
  },
  status = {
    provider = function()
      local state = vim.b.mug_branch_stats
      return state and string.format('+%s ~%s !%s', state.s, state.u, state.c) or ''
    end,
    hl = {
      fg = icon.git[2],
      style = 'italic',
    },
    truncate_hide = true,
  },
}
---File info {{{4
local file = {
  priority = -2,
  type = {
    provider = function()
      return vim.api.nvim_get_option_value('filetype', {})
      -- return ft .. icon[ff][1]
      -- return vim.bo.filetype .. icon[vim.bo.fileformat][1]
    end,
    hl = { fg = 'cyan', style = 'italic' },
    left_sep = sepalator,
  },
  encode = {
    provider = function()
      local ff = vim.api.nvim_get_option_value('fileformat', {})
      return string.format('%s %s', vim.api.nvim_get_option_value('fileencoding', {}), icon[ff][1])
    end,
    hl = function()
      local bufnr = tonumber(vim.api.nvim_get_var('actual_curbuf'))
      return { fg = icon[vim.api.nvim_get_option_value('fileformat', { buf = bufnr })][2], style = 'italic' }
    end,
    left_sep = sepalator,
  },
  truncate_hide = true,
}
---Line {{{4
local line = {
  priority = -2,
  pos = {
    provider = function()
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
      before_cursor = before_cursor:gsub('\t', string.rep(' ', vim.bo.tabstop))
      col = vim.str_utfindex(before_cursor) + 1
      local linenr_min_width, colnr_min_width = 3, 3
      local line_str = string.rep(' ', linenr_min_width - math.floor(math.log10(row)) - 1) .. tostring(row)
      local col_str = string.rep(' ', colnr_min_width - math.floor(math.log10(col)) - 1) .. tostring(col)
      return string.format('%s:%s/%s', col_str, line_str, vim.fn.line('$'))
    end,
    hl = { fg = 'purple', style = 'italic' },
    left_sep = sepalator,
    truncate_hide = true,
  },
  -- percent = {
  --   provider = 'line_percentage',
  --   hl = { fg = 'purple' },
  --   left_sep = sepalator,
  --   truncate_hide = true,
  -- },
}

---Inactive {{{3
local filetype = {
  provider = function()
    return ' ' .. vim.bo.filetype .. ' '
  end,
  hl = { fg = 'bg', bg = 'fg' },
  sep = {
    provider = '',
    hl = function()
      return {
        fg = 'bg',
        bg = 'fg',
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

---Tables {{{3
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
  { search.count },
  { git.branch, git.info, git.status, file.type, file.encode, line.pos },
}
local inactive = {
  { filetype, filetype.sep, path },
  {},
  { line.pos },
}
---Setup {{{3
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
