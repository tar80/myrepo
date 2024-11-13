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
  dos = { '', 'blue' },
  unix = { '', 'olive' },
  mac = { '', 'pink' },
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
M.kind = {
  Text = '',
  Method = '',
  Function = '󰊕',
  Constructor = '',
  Field = '',
  Variable = '',
  Class = '',
  Interface = '',
  Module = '󰏓',
  Property = '',
  Unit = '',
  Value = '󰎠',
  Enum = '',
  EnumMember = '',
  Keyword = '󰌋',
  Snippet = '',
  Color = ' ',
  File = '󰈙',
  Reference = '󰈇',
  Folder = '',
  Constant = '󰏿',
  Struct = '󰙅',
  Event = '',
  Operator = '',
  TypeParameter = '󰘦',
  Codeium = '',
  Version = '',
  Unknown = ' ',
  Calculator = '',
  Emoji = '󰞅',
}

return M
