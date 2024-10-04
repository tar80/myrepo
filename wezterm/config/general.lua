local wezterm = require('wezterm')
local util = require('config.util')

local PALETTE = {
  CURSOR = { BG = '#33AAFF', FG = '#FFFFFF' },
  SELECTION = { BG = '#446688', FG = '#EEEEEE' },
  MENU = { BG = '#444466', FG = '#CCCCDD', FONT_SIZE = 13 },
}

return {
  ---@desc font
  font = wezterm.font_with_fallback({
    { family = 'JetBrains Mono', weight = 'Regular' },
    { family = 'Symbols Nerd Font Mono', scale = 1.0 },
    -- { family = 'PlemolJP Console NF', weight = 'Regular' },
    { family = 'UDEV Gothic NFLG', weight = 'Regular' },
    { family = 'Segoe UI Emoji' },
  }),
  font_size = 11.5,
  cell_width = 1.0,
  line_height = 1.0,
  freetype_load_target = 'Light',
  freetype_render_target = 'HorizontalLcd',
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
  anti_alias_custom_block_glyphs = true,
  bold_brightens_ansi_colors = false,
  custom_block_glyphs = true,
  use_cap_height_to_scale_fallback_fonts = true,

  ---@desc programs
  default_prog = { 'nyagos' },
  launch_menu = {
    { label = 'Nyagos', args = { util.scoop_apps('nyagos') } },
    { label = 'Neovim', args = { util.scoop_apps('bin/nvim', 'neovim-nightly') } },
  },

  ---@desc general
  -- adjust_window_size_when_changing_font_size = true,
  allow_square_glyphs_to_overflow_width = 'WhenFollowedBySpace',
  allow_win32_input_mode = true,
  alternate_buffer_wheel_scroll_speed = 3,
  animation_fps = 10,
  max_fps = 60,
  audible_bell = 'Disabled',
  bypass_mouse_reporting_modifiers = 'SHIFT',
  canonicalize_pasted_newlines = 'None',
  check_for_updates = false,
  clean_exit_codes = { 130 },
  -- default_domain = "local",
  -- default_workspace = 'default',
  disable_default_quick_select_patterns = false,
  -- enable_csi_u_key_encoding = false,
  -- enable_kitty_keyboard = false,
  exit_behavior = 'Close',
  exit_behavior_messaging = 'Terse',
  enable_scroll_bar = false,
  hide_mouse_cursor_when_typing = true,
  -- prefer_egl = true,
  prefer_to_spawn_tabs = true,
  quit_when_all_windows_are_closed = true,
  scroll_to_bottom_on_input = true,
  scrollback_lines = 10000,
  set_environment_variables = {},
  skip_close_confirmation_for_processes_named = {
    'cmd.exe',
    'pwsh.exe',
    'powershell.exe',
    'nvim.exe',
  },
  -- status_update_interval = 1000,
  -- swallow_mouse_click_on_pane_focus = false,
  -- swallow_mouse_click_on_window_focus = false,
  -- switch_to_last_active_tab_when_closing_tab = false,
  -- underline_position = -2,
  -- underline_thickness = 1.0,
  unzoom_on_switch_pane = true,
  use_fancy_tab_bar = true,

  ---@desc interface
  hide_tab_bar_if_only_one_tab = false,
  show_tabs_in_tab_bar = true,
  show_tab_index_in_tab_bar = true,
  show_new_tab_button_in_tab_bar = false,
  show_close_tab_button_in_tabs = false,
  tab_bar_at_bottom = false,
  text_background_opacity = 1.0,
  win32_system_backdrop = 'Acrylic',
  window_decorations = 'RESIZE',
  window_background_opacity = 0.9,
  window_background_gradient = {
    orientation = 'Vertical',
    colors = { '#001000', '#112222', '#001010' },
    interpolation = 'Linear',
    blend = 'Rgb',
    noise = 0,
  },
  window_frame = {
    font = wezterm.font('Roboto'),
    font_size = 11,
    inactive_titlebar_bg = 'none',
    active_titlebar_bg = 'none',
  },
  window_padding = { left = 3, right = 0, top = 4, bottom = 0 },
  -- foreground_text_hsb = { hue = 1.02, saturation = 1.1, brightness = 1.1, },
  inactive_pane_hsb = { saturation = 0.9, brightness = 0.6 },

  ---@desc cursor
  cursor_blink_ease_in = 'Linear',
  cursor_blink_ease_out = 'Linear',
  cursor_blink_rate = 0,
  cursor_thickness = 1.0,
  default_cursor_style = 'SteadyBar',

  ---@desc mouse
  mouse_wheel_scrolls_tabs = false,
  pane_focus_follows_mouse = false,

  ---@desc colors
  char_select_bg_color = PALETTE.MENU.BG,
  char_select_fg_color = PALETTE.MENU.FG,
  char_select_font_size = PALETTE.MENU.FONT_SIZE,
  command_palette_bg_color = PALETTE.MENU.BG,
  command_palette_fg_color = PALETTE.MENU.FG,
  command_palette_font_size = PALETTE.MENU.FONT_SIZE,
  command_palette_rows = 14,
  colors = {
    cursor_bg = PALETTE.CURSOR.BG,
    cursor_border = PALETTE.CURSOR.BG,
    cursor_fg = PALETTE.CURSOR.FG,
    selection_bg = PALETTE.SELECTION.BG,
    selection_fg = PALETTE.SELECTION.FG,
    tab_bar = { inactive_tab_edge = 'none' },
    quick_select_label_bg = { Color = PALETTE.CURSOR.BG },
    quick_select_label_fg = { Color = PALETTE.CURSOR.FG },
    quick_select_match_bg = { Color = PALETTE.SELECTION.BG },
    quick_select_match_fg = { Color = PALETTE.SELECTION.FG },
  },
}
