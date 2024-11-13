--[[vim:textwidth=0:foldmethod=marker:foldlevel=1:]]--

local api = vim.api
local fn = vim.fn
local ns = api.nvim_create_namespace('user_float')

local _default = {
  relative = 'cursor',
  anchor = 'NW',
  width = 1,
  height = 1,
  row = 0,
  col = 1,
  focusable = true,
  zindex = 200,
  style = 'minimal',
  border = 'single',
  noautocmd = true,
  -- win = integer,
  -- bufpos = tuple[line, column],
  -- title = tuple[text, highlight],
  -- title_pos = 'left',
  -- footer = tulbe[text, highlight],
  -- footer_pos = 'left',
  -- fixed = false,
  -- hide = false,
}

---@package
---@param data string|string[]
---@return integer? height, integer? width, string[]? lines
local function _get_lines(data)
  if not data then
    return
  end
  local t = type(data)
  if t == 'string' then
    return 1, api.nvim_strwidth(data), { data }
  elseif t == 'table' then
    if vim.tbl_isempty(data) then
      return
    elseif table.concat(data, ''):match('^%s*$') then
      return
    end
    local width = 1
    local height = 0
    for _, value in pairs(data) do
      width = math.max(width, api.nvim_strwidth(value))
      height = height + 1
    end
    return height, width, data
  end
end

---@package
---@param height integer
---@return string anchor,integer row
local function _get_direction(height)
  local place_ns, place_we, row = 'N', 'W', 1
  local s_row = height + fn.screenrow()
  local e_row = api.nvim_get_option_value('lines', { scope = 'global' })
  local laststatus = api.nvim_get_option_value('laststatus', { scope = 'global' }) == 0 and 0 or 1
  local showtabline = api.nvim_get_option_value('showtabline', { scope = 'global' }) == 0 and 0 or 1
  local cmdheight = api.nvim_get_option_value('cmdheight', { scope = 'global' })
  e_row = e_row - laststatus - showtabline - cmdheight - 2
  if (e_row - s_row) < 0 then
    place_ns, row = 'S', 0
  end
  return ('%s%s'):format(place_ns, place_we), row
end

---@package
---@param config? vim.api.keyset.highlight
local function _set_hl(config)
  config = config or { link = 'Normal' }
  do
    local hlgroups = { 'NormalNC', 'NormalFloat', 'FloatBorder' }
    for _, hlgroup in ipairs(hlgroups) do
      api.nvim_set_hl(ns, hlgroup, config)
    end
  end
end

local M = {}

---@class FloatWindowOptions
---@field public data? string|string[]
---@field public hl? vim.api.keyset.highlight
---@field public winblend? integer

---@param opts FloatWindowOptions|vim.api.keyset.win_config
M.popup = function(opts)
  local height, width, lines = _get_lines(opts.data)
  if not height then
    return
  end
  local winblend = opts.winblend or api.nvim_get_option_value('winblend', { scope = 'global' })
  local highlight = opts.hl
  if highlight then
    _set_hl(highlight)
  end
  ---@cast width -nil
  ---@cast lines -nil
  opts.data = nil
  opts.winblend = nil
  opts.hl = nil
  local win_config = vim.tbl_extend('force', _default, opts)
  win_config.height = height
  win_config.width = width
  if not opts.anchor then
    local anchor, row = _get_direction(height)
    win_config.row = row
    win_config.anchor = anchor
  end
  local bufnr = api.nvim_create_buf(false, true)
  api.nvim_buf_set_lines(bufnr, 0, height, false, lines)
  local winid = api.nvim_open_win(bufnr, false, win_config)
  api.nvim_win_set_hl_ns(winid, ns)
  api.nvim_set_option_value('winblend', winblend, { win = winid })
  return { bufnr, winid }
end

-- _set_hl()

return M
