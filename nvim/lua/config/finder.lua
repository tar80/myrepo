-- vim:textwidth=0:foldmarker={@@,@@}:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

---@desc Telescope
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local conf = require('telescope.config').values
-- local action_state = require('telescope.actions.state')

---@desc SETUP {@@1
require('telescope').setup({
  defaults = { ---{@@2
    winblend = 10,
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
        ['<C-S>'] = require('telescope.actions').file_split,
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
  }, ---@@}
  pickers = { -- {@@2
    buffers = {
      sort_mru = true,
      mappings = { i = { ['<C-D>'] = require('telescope.actions').delete_buffer } },
    },
    live_grep = {
      max_results = 100,
      disable_coordinates = true,
    },
    -- current_buffer_fuzzy_find = {
    --   skip_empty_lines = true,
    -- },
    -- lsp_references = {
    --   fname_width = 30,
    --   show_line = false,
    --   trim_text = true,
    -- },
    -- diagnostics = {
    --   bufnr = 0,
    --   no_unlisted = true,
    --   line_width = 50,
    -- },
  }, -- @@}
})

---@desc FUNCTIONS {@@1
---@see https://scrapbox.io/vim-jp/mr.vim%E3%82%92%E5%A5%BD%E3%81%8D%E3%81%AAFuzzy_Finder%E3%81%8B%E3%82%89%E4%BD%BF%E3%81%86_%28telescope%29
local recent_file_sorter = function(opts, list) -- {@@2
  local indices = {}
  for i, line in ipairs(list) do
    indices[line] = i
  end
  local file_sorter = conf.file_sorter(opts)
  local base_scorer = file_sorter.scoring_function
  file_sorter.scoring_function = function(self, prompt, line)
    local score = base_scorer(self, prompt, line)
    if score <= 0 then
      return -1
    else
      return indices[line]
    end
  end
  return file_sorter
end -- @@}
local mr_entries = function(type, opts) -- {@@2
  local safe_opts = opts or {}
  local mr = {
    r = { fn = 'mr#mrr#list', title = 'Most Recently Repository'},
    u = { fn = 'mr#mru#list', title = 'Most Recently Use'},
    w = { fn = 'mr#mrw#list', title = 'Most Recently Written'},
  }
  local list = vim.fn[mr[type].fn]()
  pickers
    .new(safe_opts, {
      prompt_title =mr[type].title,
      finder = finders.new_table({
        results = list,
        entry_maker = make_entry.gen_from_file(safe_opts),
      }),
      previewer = conf.file_previewer(safe_opts),
      sorter = recent_file_sorter(opts, list),
    })
    :find()
end -- @@}
-- local delete_mr_cached_file = function(prompt_bufnr)
--   local filename = action_state.get_selected_entry().filename
--   vim.fn['mr#mrw#delete'](filename)
-- end

---@desc function previewer {@@2
local preset_no_preview = {
  previewer = false,
  layout_config = { height = 0.7, width = 0.6 },
  mappings = {
    i = {
      ['<C-D>'] = require('telescope.actions').delete_buffer,
      ['<C-A>'] = { '<Home>', type = 'command' },
    },
  },
}

local preset_preview = {
  winblend = 9,
  results_title = false,
  path_display = function(_, path)
    local tail = require('telescope.utils').path_tail(path)
    return string.format('%s [%s]', tail, path)
  end,
}
local no_preview = function(add)
  return require('telescope.themes').get_dropdown(vim.tbl_deep_extend('force', preset_no_preview, add))
end
local preview = function(add)
  return vim.tbl_deep_extend('force', preset_preview, add)
end

local load_telescope = function(builtin, add) -- {@@2
  local has_preview = add.layout_config and add.layout_config.preview_width
  local sub_window = has_preview and has_preview > 0 and preview(add) or no_preview(add)
  require('telescope.builtin')[builtin](sub_window)
end -- @@}

---@desc KEYMAP {@@1
vim.keymap.set('n', '<Leader><Leader>', function()
  load_telescope('buffers', {})
end, {})
vim.keymap.set('n', '<leader>m', function()
  mr_entries('u', preset_no_preview)
end, {})
vim.keymap.set('n', '<leader>@', function()
  mr_entries('r', preset_no_preview)
end, {})
vim.keymap.set('n', '<leader>o', function()
  load_telescope('find_files', { cwd = vim.fn.expand('%:p:h'), hidden = true, no_ignore = true })
end, {})
vim.keymap.set('n', '<leader>p', function()
  load_telescope('find_files', { hidden = true, no_ignore = true })
end, {})
vim.keymap.set('n', '<leader>l', function()
  load_telescope('live_grep', { layout_config = { preview_width = 0.5, width = 0.9, height = 0.9 } })
end, {})
vim.keymap.set('n', '<leader>h', function()
  load_telescope('help_tags', {})
end, {})
-- vim.keymap.set('n', '<leader>:', function()
--   load_telescope('current_buffer_fuzzy_find', 0.4)
-- end, {})
-- for git
vim.keymap.set('n', '<Leader>b', function()
  load_telescope('git_branches', {})
end, {})
vim.keymap.set('n', '<Leader>c', function()
  load_telescope('git_commits', { layout_config = { mirror = false, preview_width = 0.7, width = 0.9, height = 0.9 } })
end, {})
---@desc for lsp
-- vim.keymap.set('n', 'gld', function()
--   load_telescope('diagnostics', { layout_config = { mirror = true, preview_width = 0.5 } })
-- end, {})
-- vim.keymap.set('n', 'glk', function()
--   load_telescope('lsp_references', { layout_config = { mirror = false, preview_width = 0.7 } })
-- end, {})
-- vim.keymap.set('n', 'gld', function()
--   load_telescope('lsp_definitions', { layout_config = { mirror = true, preview_width = 0.5 } })
-- end, {})
vim.keymap.set('n', 'glj', function()
  load_telescope('lsp_dynamic_workspace_symbols', { layout_config = { mirror = true, preview_width = 0.6 } })
end, {})
