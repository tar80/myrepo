local M = {}

M.symbol = {
  input = '',
  search_down = '',
  search_up = '',
  bar = '┃',
  circle = '',
  circle2 = '',
  square = '',
  square2 = '■',
  square3 = '󱓻',
  square4 = '󰄮',
  star = '󰙴',
  lock = '',
  nvim = '',
  vim = '',
  lua = '',
  edit = '󰤌',
  modify = '󱅃',
}
M.state = {
  success = '',
  failure = '',
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
  Trace = '󱨈',
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
  branch2 = '',
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
  nvim_lua = '',
  nvim_lsp_signature_help = '',
  buffer = '󰆚',
  path = '',
  cmdline = '󰞷',
  Text = '',
  Method = '󰆧',
  Function = '󰊕',
  Constructor = '',
  Field = '',
  Variable = '󰂡',
  Class = '',
  Interface = '',
  Module = '',
  Property = '',
  Unit = '',
  Value = '󰎠',
  Enum = '',
  EnumMember = '',
  Keyword = '󰌋',
  Snippet = '',
  Color = '󰏘',
  File = '',
  Reference = '',
  Folder = '󰉋',
  Constant = '󰏿',
  Struct = ' ',
  Event = '',
  Operator = '',
  TypeParameter = '󰘦',
  Codeium = '',
  Version = '',
  Unknown = '  ',
  Calculator = '',
  Emoji = '󰞅',
}
M.border = {
  solid = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
  quotation = { '', '', '', '', '', '', '', '┃' },
  top_dash = { '', { '┄', '@comment' }, '', '', '', '', '', '' },
  bot_dash = { '', '', '', '', '', { '┄', '@comment' }, '', '' },
}
M.sep = {
  rect = { l = '', r = '' },
  bubble = { l = '', r = '' },
}

return M
