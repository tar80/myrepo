-- vim:textwidth=0:foldmarker={@@,@@}:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

---Telescope
---#Setup {@@2
require('telescope').setup({
  defaults = {
    winblend = 8,
    previewer = false,
    file_ignore_patterns = { '^node_modules\\', '^%.bundle\\', '^vendor\\', '^migemo\\' },
    prompt_title = false,
    prompt_prefix = ' ',
    selection_caret = ' ',
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
    color_devicons = false,
    mappings = {
      i = {
        ['<C-S-D>'] = require('telescope.actions').delete_buffer,
        ['<C-UP>'] = require('telescope.actions').preview_scrolling_up,
        ['<C-DOWN>'] = require('telescope.actions').preview_scrolling_down,
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
local no_preview = require('telescope.themes').get_dropdown({
  previewer = false,
  layout_config = {
    height = 0.7,
    width = 0.8,
  },
})

local preview = function(width, mirror)
  return {
    winblend = 8,
    results_title = false,
    path_display = function(opts, path)
      local tail = require('telescope.utils').path_tail(path)
      return string.format('%s [%s]', tail, path)
    end,
    layout_config = {
      mirror = mirror or false,
      preview_width = width,
    },
  }
end

local load_telescope = function(builtin, prev, mirror)
  local sub_window = prev and prev > 0 and preview(prev, mirror) or no_preview
  require('telescope.builtin')[builtin](sub_window)
end

-- ##Keymap {@@2
vim.keymap.set('n', '<Leader><Leader>', function()
  load_telescope('buffers')
end)
vim.keymap.set('n', '<leader>m', function()
  load_telescope('oldfiles')
end, {})
vim.keymap.set('n', '<leader>o', function()
  load_telescope('find_files')
end, {})
vim.keymap.set('n', '<leader>l', function()
  load_telescope('live_grep', 0.4)
end, {})
vim.keymap.set('n', '<leader>k', function()
  load_telescope('help_tags', 0.7)
end, {})
vim.keymap.set('n', '<leader>:', function()
  load_telescope('current_buffer_fuzzy_find', 0.4)
end, {})
-- for git
vim.keymap.set('n', '<Leader>b', function()
  load_telescope('git_branches')
end, {})
-- for lsp
vim.keymap.set('n', 'gle', function()
  load_telescope('diagnostics', 0.5, true)
end, {})
vim.keymap.set('n', 'glk', function()
  load_telescope('lsp_references', 0.5, true)
end, {})
vim.keymap.set('n', 'gld', function()
  load_telescope('lsp_definitions', 0.5, true)
end, {})
vim.keymap.set('n', 'glj', function()
  load_telescope('lsp_dynamic_workspace_symbols', 0.5, true)
end, {})
