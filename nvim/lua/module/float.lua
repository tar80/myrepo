--- vim:textwidth=0:foldmethod=marker:foldlevel=1:
-------------------------------------------------------------------------------
local M = {}

local api = vim.api
local get_global = function(name)
  return api.nvim_get_option_value(name, { scope = 'global' })
end
local float_popup = api.nvim_create_namespace('float_popup')

do
  local items = {
    'NormalNC',
    'NormalFloat',
    'FloatBorder',
  }

  for _, v in ipairs(items) do
    api.nvim_set_hl(float_popup, v, { link = 'WarningMsg' })
  end
end

local function max_height(row, col)
  local lastline = get_global('cmdheight')
    + (get_global('laststatus') == 0 and 0 or 1)
    + (get_global('showtabline') == 0 and 0 or 1)
    + 2
  local w = get_global('columns') - col
  local h = get_global('lines') - lastline - row

  return w, h
end

local float = {
  row = 1,
  col = 1,
  style = 'minimal',
  border = 'rounded',
  relative = 'cursor',
  anchor = 'NW',
  -- forcusable = false,
  noautocmd = true,
}

M.popup = function(contents)
  local winblend = api.nvim_get_option_value('winblend', {})
  local row = vim.fn.winline()
  local col = api.nvim_win_get_cursor(0)[2]
  local limit_width, limit_height = max_height(row, col)
  local buf_height
  float.anchor = 'NW'

  api.nvim_set_option_value('winblend', 0, {})
  local bufnr = api.nvim_create_buf(false, true)

  if type(contents) ~= 'table' then
    api.nvim_buf_set_lines(bufnr, 0, 1, false, { contents })
    float.width = #contents
  else
    if vim.tbl_isempty(contents) == 0 then
      return
    end

    if vim.tbl_count(contents) <= 1 and table.concat(contents, ''):match('^%s*$') then
      return
    end

    local max_digit = 1

    for _, value in pairs(contents) do
      max_digit = math.max(max_digit, api.nvim_strwidth(value) + 1)
    end

    float.width = math.min(max_digit, limit_width)
    buf_height = vim.tbl_count(contents)
    api.nvim_buf_set_lines(bufnr, 0, buf_height, false, contents)
  end

  if (limit_height - buf_height) < 0 then
    float.height = buf_height
    float.anchor = 'SW'
    float.row = 0
  else
    float.height = math.min(buf_height, limit_height)
  end

  local handle = vim.api.nvim_open_win(bufnr, false, float)
  vim.api.nvim_win_set_hl_ns(handle, float_popup)
  api.nvim_set_option_value('winblend', winblend, {})

  return bufnr
end

return M
