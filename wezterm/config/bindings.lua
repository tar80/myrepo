local wezterm = require('wezterm')
local util = require('config.util')
local act = wezterm.action

local NONE = 'NONE'
local S = 'SHIFT'
local C = 'CTRL'
local S_C = 'SHIFT|CTRL'
local S_C_A = 'SHIFT|CTRL|ALT'

return {
  disable_default_key_bindings = true,
  use_dead_keys = false,
  -- leader = { key = 'phys:Space', mods = S_C, timeout_milliseconds = 2000 },
  keys = {
    { key = 'F11', mods = NONE, action = act.ShowDebugOverlay },
    { key = 'Tab', mods = C, action = act.ActivateTabRelative(1) },
    { key = 'Tab', mods = S_C, action = act.ActivateTabRelative(-1) },
    {
      key = '|',
      mods = S_C,
      action = act.SplitHorizontal({ label = 'Nyagos', args = { util.scoop_apps('nyagos') } }),
    },
    {
      key = '_',
      mods = S_C,
      action = act.SplitVertical({ label = 'Nyagos', args = { util.scoop_apps('nyagos') } }),
    },
    {
      key = '!',
      mods = S_C,
      action = act.SpawnCommandInNewTab({ label = 'Nyagos', args = { util.scoop_apps('nyagos') } }),
    },
    {
      key = '"',
      mods = S_C,
      action = act.SpawnCommandInNewTab({
        label = 'Neovim',
        args = { util.scoop_apps('bin/nvim', 'neovim-nightly') },
      }),
    },
    -- { key = '#', mods = S_C, action = act.ActivateTab(2) },
    -- { key = '$', mods = S_C, action = act.ActivateTab(3) },
    -- { key = '%', mods = S_C, action = act.ActivateTab(4) },
    -- { key = '%', mods = S_C, action = act.ActivateTab(5) },
    -- { key = '&', mods = S_C, action = act.ActivateTab(6) },
    -- { key = "'", mods = S_C, action = act.ActivateTab(7) },
    -- { key = '(', mods = S_C, action = act.ActivateTab(8) },
    -- { key = ')', mods = S_C, action = act.ActivateTab(9) },
    { key = '`', mods = S_C, action = act.PaneSelect },
    { key = '+', mods = S_C, action = act.IncreaseFontSize },
    { key = '=', mods = S_C, action = act.DecreaseFontSize },
    { key = '0', mods = C, action = act.ResetFontSize },
    { key = 'mapped:?', mods = S_C, action = act.Search({ CaseInSensitiveString = '' }) },
    { key = 'H', mods = S_C, action = act.ActivatePaneDirection('Left') },
    { key = 'L', mods = S_C, action = act.ActivatePaneDirection('Right') },
    { key = 'K', mods = S_C, action = act.ActivatePaneDirection('Up') },
    { key = 'J', mods = S_C, action = act.ActivatePaneDirection('Down') },
    {
      key = 'L',
      mods = S_C_A,
      action = act.Multiple({
        act.ClearScrollback('ScrollbackAndViewport'),
        act.SendKey({ key = 'l', mods = C }),
      }),
    },

    { key = 'M', mods = S_C, action = act.Hide },
    { key = 'P', mods = S_C, action = act.ActivateCommandPalette },
    -- { key = 'Q', mods = S_C, action = act.CloseCurrentPane({ confirm = true }) },
    {
      key = 'Q',
      mods = S_C,
      action = wezterm.action_callback(function(win, pane)
        local panes = pane:tab():panes()
        local has_confirm = #panes == 1
        win:perform_action(act.CloseCurrentPane({ confirm = has_confirm }), pane)
      end),
    },
    { key = 'S', mods = S_C, action = act.QuickSelect },
    {
      key = 'U',
      mods = S_C,
      action = act.CharSelect({ copy_on_select = true, copy_to = 'ClipboardAndPrimarySelection' }),
    },
    { key = 'V', mods = S_C, action = act.ActivateCopyMode },
    { key = 'Z', mods = S_C, action = act.TogglePaneZoomState },
    { key = 'UpArrow', mods = S, action = act.ScrollByLine(-1) },
    { key = 'DownArrow', mods = S, action = act.ScrollByLine(1) },
    { key = 'UpArrow', mods = S_C, action = act.ScrollByPage(-1) },
    { key = 'DownArrow', mods = S_C, action = act.ScrollByPage(1) },
    { key = 'Insert', mods = S, action = act.PasteFrom('PrimarySelection') },
    { key = 'Insert', mods = C, action = act.CopyTo('PrimarySelection') },
    {
      key = 'phys:Space',
      mods = S_C,
      action = act.ActivateKeyTable({
        name = 'resize_pane',
        one_shot = false,
      }),
    },
  },

  key_tables = {
    copy_mode = {
      { key = 'Enter', mods = NONE, action = act.CopyMode('MoveToStartOfNextLine') },
      { key = 'Escape', mods = NONE, action = act.Multiple({ 'ScrollToBottom', { CopyMode = 'Close' } }) },
      { key = '[', mods = C, action = act.Multiple({ 'ScrollToBottom', { CopyMode = 'Close' } }) },
      { key = '$', mods = S, action = act.CopyMode('MoveToEndOfLineContent') },
      { key = ',', mods = NONE, action = act.CopyMode('JumpReverse') },
      { key = '0', mods = NONE, action = act.CopyMode('MoveToStartOfLine') },
      { key = ';', mods = NONE, action = act.CopyMode('JumpAgain') },
      { key = 'F', mods = S, action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
      { key = 'G', mods = S, action = act.CopyMode('MoveToScrollbackBottom') },
      { key = 'H', mods = S, action = act.CopyMode('MoveToViewportTop') },
      { key = 'L', mods = S, action = act.CopyMode('MoveToViewportBottom') },
      { key = 'M', mods = S, action = act.CopyMode('MoveToViewportMiddle') },
      { key = 'O', mods = S, action = act.CopyMode('MoveToSelectionOtherEndHoriz') },
      { key = 'T', mods = S, action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
      { key = 'V', mods = S, action = act.CopyMode({ SetSelectionMode = 'Line' }) },
      { key = '^', mods = S, action = act.CopyMode('MoveToStartOfLineContent') },
      { key = 'b', mods = NONE, action = act.CopyMode('MoveBackwardWord') },
      { key = 'b', mods = C, action = act.CopyMode('PageUp') },
      { key = 'c', mods = C, action = act.Multiple({ 'ScrollToBottom', { CopyMode = 'Close' } }) },
      { key = 'd', mods = C, action = act.CopyMode({ MoveByPage = 0.5 }) },
      { key = 'e', mods = NONE, action = act.CopyMode('MoveForwardWordEnd') },
      { key = 'f', mods = NONE, action = act.CopyMode({ JumpForward = { prev_char = false } }) },
      { key = 'f', mods = C, action = act.CopyMode('PageDown') },
      { key = 'g', mods = NONE, action = act.CopyMode('MoveToScrollbackTop') },
      { key = 'g', mods = C, action = act.Multiple({ 'ScrollToBottom', { CopyMode = 'Close' } }) },
      { key = 'h', mods = NONE, action = act.CopyMode('MoveLeft') },
      { key = 'j', mods = NONE, action = act.CopyMode('MoveDown') },
      { key = 'k', mods = NONE, action = act.CopyMode('MoveUp') },
      { key = 'l', mods = NONE, action = act.CopyMode('MoveRight') },
      { key = 'o', mods = NONE, action = act.CopyMode('MoveToSelectionOtherEnd') },
      { key = 'q', mods = NONE, action = act.Multiple({ 'ScrollToBottom', { CopyMode = 'Close' } }) },
      { key = 't', mods = NONE, action = act.CopyMode({ JumpForward = { prev_char = true } }) },
      { key = 'u', mods = C, action = act.CopyMode({ MoveByPage = -0.5 }) },
      { key = 'v', mods = NONE, action = act.CopyMode({ SetSelectionMode = 'Cell' }) },
      { key = 'v', mods = C, action = act.CopyMode({ SetSelectionMode = 'Block' }) },
      { key = 'w', mods = NONE, action = act.CopyMode('MoveForwardWord') },
      {
        key = 'y',
        mods = NONE,
        action = act.Multiple({
          { CopyTo = 'ClipboardAndPrimarySelection' },
          { Multiple = { 'ScrollToBottom', { CopyMode = 'Close' } } },
          act.ClearSelection,
        }),
      },
      { key = 'PageUp', mods = NONE, action = act.CopyMode('PageUp') },
      { key = 'PageDown', mods = NONE, action = act.CopyMode('PageDown') },
      { key = 'Home', mods = NONE, action = act.CopyMode('MoveToStartOfLine') },
      { key = 'End', mods = NONE, action = act.CopyMode('MoveToEndOfLineContent') },
      { key = 'LeftArrow', mods = NONE, action = act.CopyMode('MoveLeft') },
      { key = 'LeftArrow', mods = 'ALT', action = act.CopyMode('MoveBackwardWord') },
      { key = 'RightArrow', mods = NONE, action = act.CopyMode('MoveRight') },
      { key = 'RightArrow', mods = 'ALT', action = act.CopyMode('MoveForwardWord') },
      { key = 'UpArrow', mods = NONE, action = act.CopyMode('MoveUp') },
      { key = 'DownArrow', mods = NONE, action = act.CopyMode('MoveDown') },
    },

    search_mode = {
      { key = 'Enter', mods = NONE, action = act.CopyMode('PriorMatch') },
      { key = 'Escape', mods = NONE, action = act.CopyMode('Close') },
      {
        key = '[',
        mods = C,
        action = act.Multiple({
          act.CopyMode('ClearPattern'),
          act.CopyMode('Close'),
        }),
      },
      { key = 'd', mods = C, action = act.SendKey({ key = 'Delete' }) },
      { key = 'h', mods = C, action = act.SendKey({ key = 'Backspace' }) },
      { key = 'n', mods = C, action = act.CopyMode('NextMatch') },
      { key = 'p', mods = C, action = act.CopyMode('PriorMatch') },
      { key = 'r', mods = C, action = act.CopyMode('CycleMatchType') },
      { key = 'u', mods = C, action = act.CopyMode('ClearPattern') },
      { key = 'k', mods = C, action = act.CopyMode('PriorMatchPage') },
      { key = 'l', mods = C, action = act.CopyMode('NextMatchPage') },
    },

    resize_pane = {
      { key = 'h', action = act.AdjustPaneSize({ 'Left', 1 }) },
      { key = 'l', action = act.AdjustPaneSize({ 'Right', 1 }) },
      { key = 'k', action = act.AdjustPaneSize({ 'Up', 1 }) },
      { key = 'j', action = act.AdjustPaneSize({ 'Down', 1 }) },
      { key = 'LeftArrow', action = act.AdjustPaneSize({ 'Left', 1 }) },
      { key = 'RightArrow', action = act.AdjustPaneSize({ 'Right', 1 }) },
      { key = 'UpArrow', action = act.AdjustPaneSize({ 'Up', 1 }) },
      { key = 'DownArrow', action = act.AdjustPaneSize({ 'Down', 1 }) },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = '[', mods = C, action = 'PopKeyTable' },
    },
  },
}
