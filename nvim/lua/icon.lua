local M = {}

M.symbol = {
  input = '',
  search_down = '',
  search_up = '',
  bar = '┃',
  bar2 = '▋',
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
M.border = {
  solid = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
  quotation = { '', '', '', '', '', '', '', { M.symbol.bar2, 'SpecialKey' } },
  top_dash = { '', { '┄', '@comment' }, '', '', '', '', '', '' },
  bot_dash = { '', '', '', '', '', { '┄', '@comment' }, '', '' },
}
M.sep = {
  rect = { l = '', r = '' },
  bubble = { l = '', r = '' },
}

return M
