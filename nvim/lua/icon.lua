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
M.diagnostics = {
  Error = '',
  Warn = '',
  Hint = '',
  Info = '',
}
M.log_levels = {
  trace = '',
  debug = '',
  info = '',
  warn = '',
  error = '',
  off = ' ',
}
M.git = {
  branch = '',
  branch2 = '',
}

return M
