-- vim:textwidth=0:foldmarker={@@,@@}:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

---Telescope
---#Setup {@@2
require('telescope').setup({
  defaults = {
    winblend = 8,
    previewer = false,
    cache_picker = false,
    color_devicons = false,
    file_ignore_patterns = { '.git\\', '^node_modules\\', '^%.bundle\\', '^vendor\\', '^migemo\\' },
    prompt_title = false,
    prompt_prefix = ' ',
    selection_caret = ' ',
    -- multi_icon = " ",
    sorting_strategy = 'ascending',
    layout_strategy = 'horizontal',
    layout_config = {
      -- anchor = "S",
      preview_cutoff = 1,
      prompt_position = 'top',
      height = 0.7,
      width = 0.7,
    },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--trim',
      '--glob=!{node_modules,vendor,migemo,.bundle,.git}/',
    },
    mappings = {
      i = {
        ['<C-D>'] = require('telescope.actions').delete_buffer,
        ['<C-K>'] = require('telescope.actions').preview_scrolling_up,
        ['<C-J>'] = require('telescope.actions').preview_scrolling_down,
        ['<C-G>'] = require('telescope.actions').close,
        ['<C-A>'] = { '<Home>', type = 'command' },
        ['<C-E>'] = { '<End>', type = 'command' },
      },
      n = {
        ['<C-G>'] = require('telescope.actions').close,
      },
    },
  },
  pickers = {
    buffers = {
      sort_mru = true,
    },
    live_grep = {
      max_results = 100,
      disable_coordinates = true,
    },
    current_buffer_fuzzy_find = {
      skip_empty_lines = true,
    },
    lsp_references = {
      fname_width = 20,
      trim_text = true,
    },
    diagnostics = {
      bufnr = 0,
      no_unlisted = true,
      line_width = 50,
    },
  },
})

-- ##Functions {@@2
local no_preview = function(add)
  local preset = {
    previewer = false,
    layout_config = {
      height = 0.7,
      width = 0.6,
    },
  }

  return require('telescope.themes').get_dropdown(vim.tbl_deep_extend('force', preset, add))
end

local preview = function(add)
  local preset = {
    winblend = 8,
    results_title = false,
    path_display = function(_, path)
      local tail = require('telescope.utils').path_tail(path)
      return string.format('%s [%s]', tail, path)
    end,
  }

  return vim.tbl_deep_extend('force', preset, add)
end

local load_telescope = function(builtin, add)
  local has_preview = add.layout_config and add.layout_config.preview_width
  local sub_window = has_preview and has_preview > 0 and preview(add) or no_preview(add)
  require('telescope.builtin')[builtin](sub_window)
end

-- ##Keymap {@@2
vim.keymap.set('n', '<Leader><Leader>', function()
  load_telescope('buffers', {})
end)
vim.keymap.set('n', '<leader>m', function()
  load_telescope('oldfiles', {})
end, {})
vim.keymap.set('n', '<leader>o', function()
  load_telescope('find_files', {cwd = vim.fn.expand('%:p:h'), hidden = true, no_ignore = true})
end, {})
vim.keymap.set('n', '<leader>@', function()
  load_telescope('find_files', {hidden = true, no_ignore = true})
end, {})
vim.keymap.set('n', '<leader>l', function()
  load_telescope('live_grep', { layout_config = { preview_width = 0.5, width = 0.9, height = 0.9 } })
end, {})
-- vim.keymap.set('n', '<leader>h', function()
--   load_telescope('help_tags', 0.7)
-- end, {})
-- vim.keymap.set('n', '<leader>:', function()
--   load_telescope('current_buffer_fuzzy_find', 0.4)
-- end, {})
-- for git
vim.keymap.set('n', '<Leader>b', function()
  load_telescope('git_branches', {})
end, {})
vim.keymap.set('n', '<Leader>c', function()
  load_telescope('git_commits', { layout_config = { mirror = false, preview_width = 0.7, width = 0.9, height = 0.9} })
end, {})
-- for lsp
vim.keymap.set('n', 'glE', function()
  load_telescope('diagnostics', { layout_config = { mirror = true, preview_width = 0.5 } })
end, {})
vim.keymap.set('n', 'glk', function()
  load_telescope('lsp_references', { layout_config = { mirror = true, preview_width = 0.5 } })
end, {})
vim.keymap.set('n', 'gld', function()
  load_telescope('lsp_definitions', { layout_config = { mirror = true, preview_width = 0.5 } })
end, {})
vim.keymap.set('n', 'glj', function()
  load_telescope('lsp_dynamic_workspace_symbols', { layout_config = { mirror = true, preview_width = 0.5 } })
end, {})
