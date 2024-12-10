-- vim:textwidth=0:foldmethod=marker:foldlevel=1:

local is_alter = function(buffer)
  return vim.fn.bufnr('#') == buffer.number
end

-- local noice_stats = function()
--   if require('noice').api.status.mode.has() then
--     return require('noice').api.status.mode.get()
--   end
--   return ''
-- end

local branch_details = function()
  local repo = vim.uv.cwd():gsub('^(.+[/\\])', '')
  local branch = vim.b.mug_branch_name or ''
  local detach = vim.b.mug_branch_info or ''
  detach = detach ~= '' and ('(%s) '):format(detach) or ' '
  local state = vim.b.mug_branch_stats
  state = state
      and ('%s+%s%s~%s%s!%s '):format(
        '%#DiagnosticSignOk#',
        state.s,
        '%#DiagnosticSignWarn#',
        state.u,
        '%#DiagnosticSignError#',
        state.c
      )
    or ''
  local details = branch .. detach .. state
  return details == ' ' and ''
    or ('%%#Staline#%s%s:%s%s'):format(require('icon').git.branch, repo, '%#Special#', details)
end

local augroup = vim.api.nvim_create_augroup('rc_plugin', { clear = false })
vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Load color palette',
  group = augroup,
  callback = function(_)
    local theme = vim.g.loose_theme or vim.go.background
    local staline = require(('staline.themes.%s'):format(theme))
    local palette = require('loose').get_colors(theme)
    vim.api.nvim_set_hl(0, 'Statusline', { sp = palette.border, underline = true })
    local fg = vim.api.nvim_get_hl(0, { name = 'NormalFloat' }).bg
    local bg = vim.api.nvim_get_hl(0, { name = 'Normal' }).bg
    vim.api.nvim_set_hl(0, 'NormalFloatReverse', { fg = fg, bg = bg })

    vim.o.cmdheight = 0
    require('staline').setup({ -- {{{2
      sections = {
        left = { '+mode', 'sep', 'diagnostics', 'sep', ' ', 'file_icon', 'file_name', ' ', '+file_mod' },
        -- mid = { '%<', noice_stats },
        right = { branch_details, 'file_enc', 'line_column' },
      },
      mode_colors = staline.vi_mode,
      defaults = {
        skkeleton = true,
        true_colors = true,
        file_path = '%f',
        line_column = '%4l/%L:%-3.c',
        active_fg = palette.low_gray,
        inactive_fg = palette.purple,
        inactive_sp = palette.border,
      },
    }) -- }}}
    -- require('cokeline').setup({ -- {{{2
    --   show_if_buffers_are_at_least = 1,
    --   buffers = {
    --     filter_valid = false,
    --     filter_visible = false,
    --     focus_on_delete = 'prev',
    --     new_buffers_position = 'next',
    --     delete_on_right_click = false,
    --   },
    --   mappings = {
    --     cycle_prev_next = true,
    --     disable_mouse = true,
    --   },
    --   history = {
    --     enabled = false,
    --     size = 0,
    --   },
    --   rendering = {
    --     max_buffer_width = 100,
    --   },
    --   pick = {
    --     use_filename = false,
    --     letters = 'asdfjklnmghqwerpoiutyzxcv',
    --   },
    --   default_hl = {
    --     fg = palette.gray,
    --     bg = palette.nc,
    --   },
    --   fill_hl = 'Normal',
    --
    --   components = {
    --     {
    --       text = function(buffer)
    --         return (' %s '):format(buffer.pick_letter)
    --       end,
    --       fg = function(buffer)
    --         return buffer.is_focused and palette.high_blue or palette.blue
    --       end,
    --       bg = function(buffer)
    --         return (buffer.is_focused or is_alter(buffer)) and palette.bg or palette.nc
    --       end,
    --       bold = true,
    --     },
    --     {
    --       text = function(buffer)
    --         return buffer.unique_prefix .. buffer.filename .. ' '
    --       end,
    --       fg = function(buffer)
    --         ---@type string
    --         local hl
    --         if buffer.is_modified then
    --           hl = buffer.is_focused and palette.orange or palette.low_orange
    --         else
    --           hl = buffer.is_focused and palette.fg or palette.low_gray
    --         end
    --         return hl
    --       end,
    --       bg = function(buffer)
    --         return (buffer.is_focused or is_alter(buffer)) and palette.bg or palette.nc
    --       end,
    --       bold = function(buffer)
    --         return buffer.is_focused
    --       end,
    --       italic = function(buffer)
    --         return not (buffer.is_focused or is_alter(buffer))
    --       end,
    --     },
    --     {
    --       text = '┃',
    --       fg = palette.bg,
    --     },
    --   },
    --
    --   tabs = {
    --     placement = 'left',
    --     components = {
    --       {
    --         text = function(tabpage)
    --           return (' %s '):format(tabpage.number)
    --         end,
    --         fg = palette.bg,
    --         bg = function(tabpage)
    --           return tabpage.is_active and palette.purple or staline.theme.bg
    --         end,
    --         bold = true,
    --       },
    --     },
    --   },
    --
    --   sidebar = {
    --     filetype = {},
    --     components = {},
    --   },
    -- }) -- }}}
  end,
})

local quit = function()
  local tabs = #vim.api.nvim_tabpage_list_wins(0)
  if tabs ~= 1 then
    vim.api.nvim_win_close(0, false)
  else
    -- vim.api.nvim_buf_delete(0, {})
    vim.cmd.bdelete()
  end
end

return {
  { 'tar80/staline.nvim', event = 'UIEnter', dev = true },
  -- { -- {{{2 nvim-cokeline
  --   'willothy/nvim-cokeline',
  --   event = 'UiEnter',
  --   keys = {
  --     { '<Plug>(quit)', quit, desc = 'Function close buffer' },
  --     { '<Space>q', '<Plug>(quit)<Plug>(sq)', desc = 'Close a buffer' },
  --     { '<Plug>(sq)q', '<Cmd>quit<CR>', desc = 'Quit neovim' },
  --     {
  --       '<Plug>(q)1',
  --       function()
  --         local current = vim.api.nvim_get_current_buf()
  --         vim.iter(vim.api.nvim_list_bufs()):each(function(bufnr)
  --           if current ~= bufnr and not vim.bo[bufnr].modified then
  --             vim.api.nvim_buf_delete(bufnr, {})
  --           end
  --         end)
  --         vim.notify('Clean buffers', vim.log.levels.INFO)
  --       end,
  --       desc = 'Clean buffers',
  --     },
  --     { 'gb', '<Plug>(cokeline-pick-focus)', desc = 'Cokeline focus operater' },
  --     { 'gbb', '<Plug>(cokeline-focus-next)<Plug>(gb)', desc = 'Cokeline focus next' },
  --     { 'gbB', '<Plug>(cokeline-focus-prev)<Plug>(gb)', desc = 'Cokeline focus prev' },
  --     { '<Plug>(gb)b', '<Plug>(cokeline-focus-next)<Plug>(gb)', desc = 'Cokeline focus next(continuous)' },
  --     { '<Plug>(gb)B', '<Plug>(cokeline-focus-prev)<Plug>(gb)', desc = 'Cokeline focus prev(continuous)' },
  --     { 'gBb', '<Plug>(cokeline-switch-next)<Plug>(gB)', desc = 'Cokeline switch next' },
  --     { 'gBB', '<Plug>(cokeline-switch-prev)<Plug>(gB)', desc = 'Cokeline switch prev' },
  --     { '<Plug>(gB)b', '<Plug>(cokeline-switch-next)<Plug>(gB)', 'Cokeline switch next(continuous)' },
  --     { '<Plug>(gB)B', '<Plug>(cokeline-switch-prev)<Plug>(gB)', 'Cokeline switch prev(continuous)' },
  --   },
  -- }, -- }}}
}
