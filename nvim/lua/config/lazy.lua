-- vim:textwidth=0:foldmethod=marker:foldlevel=1:

local helper = require('helper')

do -- {{{2 Bootstrap
  local lazypath = helper.xdg_path('data', 'lazy/lazy.nvim')
  if not vim.uv.fs_stat(lazypath) then
    local cmdline =
      { 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath }
    vim.system(cmdline, { text = true }):wait()
  end
  vim.opt.rtp:prepend(lazypath)
end --}}}2

local specs = { -- {{{1
  general = {
    { import = 'plugin.colorscheme' },
    { import = 'plugin.denops' },
    { import = 'plugin' },
  },
  extended = {
    { import = 'plugin.extended' },
  },
} -- }}}1
local icons = { -- {{{2
  cmd = '',
  config = '',
  event = '',
  ft = '',
  init = '',
  import = '',
  keys = '󰺷',
  lazy = '󰒲',
  loaded = '',
  not_loaded = '',
  plugin = '',
  runtime = '󰯁',
  require = '󰢱',
  source = '󱃲',
  start = '',
  task = '',
  list = { '●', '', '', '' },
} -- }}}
local options = { -- {{{2
  change_detection = {
    enabled = true,
    notify = false,
  },
  dev = {
    path = vim.g.repo,
    patterns = { 'tar80' },
    fallback = false,
  },
  diff = {
    cmd = 'git',
  },
  install = {
    missing = false,
    colorscheme = { vim.g.colors_name },
  },
  readme = {
    enabled = true,
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
  pkg = {
    enabled = true,
    cache = helper.xdg_path('state', 'lazy/pkg-cache.lua'),
    sources = {
      'lazy', -- 'rockspec', 'packspec', },
    },
  },
  rocks = {
    enabled = false,
    root = helper.xdg_path('data', 'lazy-rocks'),
    server = 'https://nvim-neorocks.github.io/rocks-binaries/',
  },
  ui = {
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
    icons = icons,
  },
} ---}}}

---Create an enable plugins list {{{
---@param level string
---@param lists table
---@return table[]
local function enable_plugins(level, lists)
  local result = {}
  if level then
    lists.extended = {}
  end
  for _, tbl in pairs(lists) do
    vim.list_extend(result, tbl)
  end
  return result
end -- }}}

return {
  ---@param level string
  setup = function(level)
    options.spec = enable_plugins(level, specs)
    require('lazy').setup(options)
    vim.api.nvim_create_autocmd('UIEnter', {
      once = true,
      callback = function()
        vim.cmd.colorscheme(vim.g.colors_name)
        -- local msg = ('Startup time: %s'):format(require('lazy').stats().startuptime)
        -- vim.notify(msg, 2, { title = '󱎫' })
      end,
    })
  end,
}
