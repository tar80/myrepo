local wezterm = require('wezterm')
local colors = require('colors')
local launcher = require('launcher')

return {
  automatically_reload_config = true,

  ---@desc programs
  default_prog = launcher.clients.nyagos.args,
  launch_menu = launcher.menu,

  ---@desc font
  font = wezterm.font_with_fallback({
    { family = 'UDEV Gothic NF', weight = 'Regular' },
    { family = 'Segoe UI Emoji' },
  }),
  font_size = 12.5,
  cell_width = 1.0,
  line_height = 1.0,
  freetype_load_target = 'Light',
  freetype_render_target = 'HorizontalLcd',
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
  allow_square_glyphs_to_overflow_width = 'WhenFollowedBySpace',
  anti_alias_custom_block_glyphs = true,
  bold_brightens_ansi_colors = false,
  custom_block_glyphs = true,
  use_cap_height_to_scale_fallback_fonts = true,
  underline_position = -2,
  -- underline_thickness = 1.0,

  ---@desc general
  -- adjust_window_size_when_changing_font_size = true,
  allow_win32_input_mode = true,
  alternate_buffer_wheel_scroll_speed = 3,
  animation_fps = 10,
  max_fps = 60,
  audible_bell = 'Disabled',
  bypass_mouse_reporting_modifiers = 'SHIFT',
  canonicalize_pasted_newlines = 'None',
  check_for_updates = false,
  check_for_updates_interval_seconds = 864000000,
  clean_exit_codes = { 130 },
  -- default_domain = 'local',
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
  set_environment_variables = {
    PATH = string.format('%s;%s/apps/git/current/usr/bin', os.getenv('PATH'), os.getenv('SCOOP')),
  },

  skip_close_confirmation_for_processes_named = {
    'bash.exe',
    'cmd.exe',
    'nvim.exe',
    'nyagos.exe',
    'ppbw.exe',
    'pwsh.exe',
    'powershell.exe',
  },
  -- status_update_interval = 1000,
  -- swallow_mouse_click_on_pane_focus = false,
  -- swallow_mouse_click_on_window_focus = false,
  -- switch_to_last_active_tab_when_closing_tab = false,
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
  window_background_opacity = 0.8,
  window_background_gradient = {
    orientation = 'Vertical',
    colors = colors.gradient,
    interpolation = 'Linear',
    blend = 'Rgb',
    noise = 0,
  },
  window_frame = {
    font = wezterm.font('JetBrains Mono', { weight = 'Bold' }),
    font_size = 11.0,
    inactive_titlebar_bg = 'none',
    active_titlebar_bg = 'none',
  },
  window_padding = { left = 3, right = 0, top = 12, bottom = 0 },
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
  char_select_bg_color = colors.menu.bg,
  char_select_fg_color = colors.menu.fg,
  char_select_font_size = 13,
  command_palette_bg_color = colors.menu.bg,
  command_palette_fg_color = colors.menu.fg,
  command_palette_font_size = 13,
  command_palette_rows = 14,
  colors = {
    cursor_bg = colors.cursor.bg,
    cursor_border = colors.cursor.bg,
    cursor_fg = colors.cursor.fg,
    selection_bg = colors.selection.bg,
    selection_fg = colors.selection.fg,
    tab_bar = { inactive_tab_edge = 'none' },
    quick_select_label_bg = { Color = colors.cursor.bg },
    quick_select_label_fg = { Color = colors.cursor.fg },
    quick_select_match_bg = { Color = colors.selection.bg },
    quick_select_match_fg = { Color = colors.selection.fg },
  },
}
