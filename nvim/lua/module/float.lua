--- vim:textwidth=0:foldmethod=marker:foldlevel=1:
-------------------------------------------------------------------------------
local api = vim.api

local float_popup = api.nvim_create_namespace('float_popup')

---@class FloatWindowOptions
---@field row integer
---@field col integer
---@field style 'minimal'
---@field border 'none'|'single'|'double'|'rounded'|'solid'|'shadow'
---@field relative 'editor'|'win'|'cursor'|'mouse'
---@field anchor 'NW'|'NE'|'SW'|'SE'
---@field focusable boolean
---@field noautocmd boolean
---@field data any
---@field hl vim.api.keyset.highlight
local _float = {
  row = 1,
  col = 1,
  style = 'minimal',
  border = 'single',
  relative = 'cursor',
  anchor = 'NW',
  focusable = false,
  noautocmd = true,
}

return setmetatable(_float, {
  __index = {
    ---@param self self
    ---@param opts FloatWindowOptions
    ---@return {bufnr:integer,winid:integer}|nil
    popup = function(self, opts)
      local winblend = self.get_option('winblend', { win = 0 })
      local row = vim.fn.winline()
      local col = api.nvim_win_get_cursor(0)[2]
      local limit_width, limit_height = self:max_height(row, col)
      local buf_height
      self.border = opts.border or self.border
      self.anchor = 'NW'
      api.nvim_set_option_value('winblend', 0, {})
      local bufnr = api.nvim_create_buf(false, true)
      if type(opts.data) ~= 'table' then
        api.nvim_buf_set_lines(bufnr, 0, 1, false, { opts.data })
        self.width = #opts.data
      else
        if vim.tbl_isempty(opts.data) == 0 then
          return
        end
        if vim.tbl_count(opts.data) <= 1 and table.concat(opts.data, ''):match('^%s*$') then
          return
        end
        local max_digit = 1
        for _, value in pairs(opts.data) do
          max_digit = math.max(max_digit, api.nvim_strwidth(value) + 1)
        end
        self.width = math.min(max_digit, limit_width)
        buf_height = vim.tbl_count(opts.data)
        api.nvim_buf_set_lines(bufnr, 0, buf_height, false, opts.data)
      end
      if (limit_height - buf_height) < 0 then
        self.height = buf_height
        self.anchor = 'SW'
        self.row = 0
      else
        self.height = math.min(buf_height, limit_height)
      end
      local winid = vim.api.nvim_open_win(bufnr, false, self)
      self.set_hl(opts.hl)
      vim.api.nvim_win_set_hl_ns(winid, float_popup)
      api.nvim_set_option_value('winblend', winblend, {})
      return { bufnr, winid }
    end,

    get_option = function(name, opt)
      return api.nvim_get_option_value(name, opt)
    end,

    max_height = function(self, row, col)
      local lastline = self.get_option('cmdheight', { scope = 'global' })
        + (self.get_option('laststatus', { scope = 'global' }) == 0 and 0 or 1)
        + (self.get_option('showtabline', { scope = 'global' }) == 0 and 0 or 1)
        + 2
      local w = self.get_option('columns', { scope = 'global' }) - col
      local h = self.get_option('lines', { scope = 'global' }) - lastline - row
      return w, h
    end,

    set_hl = function(hl)
      hl = hl or { link = 'Normal' }
      do
        local items = { 'NormalNC', 'NormalFloat', 'FloatBorder' }
        for _, v in ipairs(items) do
          api.nvim_set_hl(float_popup, v, hl)
        end
      end
    end,
  },
})
