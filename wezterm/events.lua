local wezterm = require('wezterm')
local mux = wezterm.mux

-- Show which key table is active in the status area
wezterm.on('update-right-status', function(window, pane)
  local name = window:active_key_table()
  if name then
    name = string.format(' %s ', name)
    window:set_right_status(wezterm.format({
      { Attribute = { Intensity = 'Bold' } },
      { Foreground = { AnsiColor = 'Lime' } },
      { Background = { Color = 'NONE' } },
      { Text = name },
    }))
  else
    window:set_right_status('')
  end
end)

---@desc maximize all displayed windows on startup
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if not title or #title == 0 then
    title = string.format(' %s ', tab_info.active_pane.title:gsub('^([^%s%.]+).*$', '%1'))
    mux.get_tab(tab_info.tab_id):set_title(title)
  end
  return title
end

---@desc tab decorations
wezterm.on('format-tab-title', function(tab, tabs, panes, conf, hover, max_width)
  local fg = tab.is_active and '#AADD22' or '#558866'
  local bg = 'NONE'
  return {
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = tab_title(tab) },
  }
end)

---@desc decorated title
-- wezterm.on('format-tab-title', function(tab, tabs, panes, conf, hover, max_width)
--   local GLYPH_BRACKET_LEFT = wezterm.nerdfonts.ple_left_half_circle_thick
--   local GLYPH_BRACKET_RIGHT = wezterm.nerdfonts.ple_right_half_circle_thick
--   local bg, fg
--   if tab.is_active then
--     bg, fg = '#44AAFF', '#FFFFFF'
--   else
--     bg, fg = '#445588', '#AABBCC'
--   end
--   local edge_fg, edge_bg = bg, 'none'
--   return {
--     { Background = { Color = edge_bg } },
--     { Foreground = { Color = edge_fg } },
--     { Text = GLYPH_BRACKET_LEFT },
--     { Background = { Color = bg } },
--     { Foreground = { Color = fg } },
--     { Text = tab_title(tab) },
--     { Background = { Color = edge_bg } },
--     { Foreground = { Color = edge_fg } },
--     { Text = GLYPH_BRACKET_RIGHT },
--   }
-- end)
