local M = {}

M.symbol = {
  circle = '',
  square = '■',
  square2 = '󱓻',
  square3 = '󰄮',
  star = '󰙴',
  lock = '',
  logo = '',
  edit2 = '󰤌',
  edit3 = '󱅃',
}
M.state = {
  success = '󰄬',
  failure = '󰅖',
  pending = '',
}
M.os = {
  dos = '',
  unix = '',
  mac = '',
}
M.severity = {
  Error = '',
  Warn = '',
  Hint = '',
  Info = '',
}
M.ime = {
  hira = '󱌴',
  kata = '󱌵',
  hankata = '󱌶',
  zenkaku = '󰚞',
  abbrev = '󱌯',
  [''] = '',
}
M.git = {
  branch = '',
}
M.lazy = {
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
}
M.cmp = {
  vsnip = '',
  dictionary = '󰗚',
  nvim_lsp = '󰆧',
  nvim_lua = '',
  nvim_lsp_signature_help = '',
  buffer = '󰆚',
  path = '',
  cmdline = '󰞷',
}
M.border = {
  solid = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
}

return M
