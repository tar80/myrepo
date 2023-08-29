-- vim:textwidth=0:foldmarker={@@,@@}:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

---@desc INITIAL
local setmap = vim.keymap.set

---@desc Telescope
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local conf = require('telescope.config').values
local builtin = require('telescope.builtin')

---@see https://scrapbox.io/vim-jp/mr.vim%E3%82%92%E5%A5%BD%E3%81%8D%E3%81%AAFuzzy_Finder%E3%81%8B%E3%82%89%E4%BD%BF%E3%81%86_%28telescope%29
builtin.mr = function(opts) -- {@@2
  local recent_file_sorter = function(list) -- {@@2
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
  local safe_opts = opts or {}
  local type = 'u'
  local mr = {
    r = { fn = 'mr#mrr#list', del = 'mr#mrr#delete', title = 'Most Recently Repository' },
    u = { fn = 'mr#mru#list', del = 'mr#mru#delete', title = 'Most Recently Use' },
    w = { fn = 'mr#mrw#list', del = 'mr#mrw#delete', title = 'Most Recently Written' },
  }
  local list = vim.fn[mr[type].fn]()
  pickers
    .new(safe_opts, {
      prompt_title = mr[type].title,
      finder = finders.new_table({
        results = list,
        entry_maker = make_entry.gen_from_file(safe_opts),
      }),
      previewer = conf.file_previewer(safe_opts),
      sorter = recent_file_sorter(list),
      mappings = {
        i = {
          ['<C-D>'] = function(_)
            local filename = action_state.get_selected_entry()[1]
            vim.print(string.format('[mr%s] delete %s', type, filename))
            vim.fn[mr[type].del](filename)
          end,
        },
      },
    })
    :find()
end -- @@}

---@desc SETUP {@@1
require('telescope').setup({
  defaults = { ---{@@2
    winblend = 10,
    previewer = false,
    cache_picker = false,
    color_devicons = false,
    file_ignore_patterns = { 'lazy-lock.json', '.git\\', '^node_modules\\', '^%.bundle\\', '^vendor\\', '^migemo\\' },
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
        ['<C-S>'] = actions.file_split,
        ['<C-K>'] = actions.preview_scrolling_up,
        ['<C-J>'] = actions.preview_scrolling_down,
        ['<C-G>'] = actions.close,
        ['<C-A>'] = { '<Home>', type = 'command' },
        ['<C-E>'] = { '<End>', type = 'command' },
        ['<C-D>'] = function(_)
          local filename = action_state.get_selected_entry()[1]
          vim.print(string.format('[mru] delete %s', filename))
          vim.fn['mr#mru#delete'](filename)
        end,
      },
      n = {
        ['<C-G>'] = actions.close,
      },
    },
  }, ---@@}
  pickers = { -- {@@2
    buffers = {
      sort_mru = true,
      mappings = { i = { ['<C-D>'] = actions.delete_buffer } },
    },
    live_grep = {
      max_results = 100,
      disable_coordinates = true,
    },
    current_buffer_fuzzy_find = {
      skip_empty_lines = true,
    },
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
  extensions = {
    extensions = {
      ['ui-select'] = {
        require('telescope.themes').get_dropdown({
          -- even more opts
        }),

        -- pseudo code / specification for writing custom displays, like the one
        -- for "codeactions"
        -- specific_opts = {
        --   [kind] = {
        --     make_indexed = function(items) -> indexed_items, width,
        --     make_displayer = function(widths) -> displayer
        --     make_display = function(displayer) -> function(e)
        --     make_ordinal = function(e) -> string
        --   },
        --   -- for example to disable the custom builtin "codeactions" display
        --      do the following
        --   codeactions = false,
        -- }
      },
    },
  },
})
require('telescope').load_extension('ui-select')
require('telescope').load_extension('kensaku') -- :Telescope kensaku

---@desc Previewer {@@2
local preset_no_preview = {
  results_title = false,
  previewer = false,
  layout_config = { height = 0.7, width = 0.6 },
}
local preset_preview_hor = {
  previewer = true,
  layout_config = {
    anchor = 'N',
    preview_cutoff = 1,
    prompt_position = 'top',
    height = 0.3,
    width = 0.6,
  },
  path_display = function(_, path)
    return string.format('%s', path)
  end,
}
local preset_preview_ver = {
  -- winblend = 9,
  results_title = false,
  path_display = function(_, path)
    return string.format('%s ', path)
  end,
}
local no_preview = function(add)
  return require('telescope.themes').get_dropdown(vim.tbl_deep_extend('force', preset_no_preview, add))
end
local preview_hor = function(add)
  return require('telescope.themes').get_dropdown(vim.tbl_deep_extend('force', preset_preview_hor, add))
end
local preview_ver = function(add)
  return vim.tbl_deep_extend('force', preset_preview_ver, add)
end

local load_telescope = function(picker, preview, add) -- {@@2
  local layout = {
    no = no_preview,
    hor = preview_hor,
    ver = preview_ver,
  }
  local sub_window = layout[preview]
  builtin[picker](sub_window(add))
end -- @@}

---@desc KEYMAP {@@2
setmap('n', '<Leader><Leader>', function()
  load_telescope('buffers', 'no', { ignore_current_buffer = true })
end, {})
setmap('n', '<leader>m', function()
  load_telescope('mr', 'no', {})
end, {})
setmap('n', '<leader>p', function()
  load_telescope('find_files', 'no', { cwd = vim.fn.expand('%:p:h'), hidden = true, no_ignore = true })
end, {})
setmap('n', '<leader>o', function()
  load_telescope('find_files', 'no', { hidden = true, no_ignore = true })
end, {})
setmap('n', '<leader>l', function()
  vim.cmd(
    'Telescope kensaku theme=dropdown previewer=true layout_strategy=center layout_config={anchor="N",prompt_position="top",height=0.3,width=0.7}'
  )
  -- load_telescope('live_grep', 'ver', { layout_config = { preview_width = 0.5, width = 0.9, height = 0.9 } })
end, {})
setmap('n', '<leader>h', function()
  local slash = vim.o.shellslash
  vim.o.shellslash = false
  load_telescope('help_tags', 'ver', { layout_config = { preview_width = 0.7, width = 0.8, height = 0.9 } })
  vim.o.shellslash = slash
end, {})
setmap('n', '<leader>:', function()
  load_telescope(
    'current_buffer_fuzzy_find',
    'ver',
    { layout_config = { preview_width = 0.5, width = 0.9, height = 0.9 } }
  )
end, {})
-- for git
setmap('n', '<Leader>b', function()
  load_telescope('git_branches', 'ver', {})
end, {})
setmap('n', '<Leader>c', function()
  load_telescope(
    'git_commits',
    'ver',
    { layout_config = { mirror = false, preview_width = 0.7, width = 0.9, height = 0.9 } }
  )
end, {})
setmap('n', '<Leader>C', function()
  load_telescope(
    'git_bcommits',
    'ver',
    { layout_config = { mirror = false, preview_width = 0.7, width = 0.9, height = 0.9 } }
  )
end, {})
---@desc for lsp
-- setmap('n', 'gld', function()
--   load_telescope('diagnostics', { layout_config = { mirror = true, preview_width = 0.5 } })
-- end, {})
-- setmap('n', 'glk', function()
--   load_telescope('lsp_references', { layout_config = { mirror = false, preview_width = 0.7 } })
-- end, {})
-- setmap('n', 'gld', function()
--   load_telescope('lsp_definitions', { layout_config = { mirror = true, preview_width = 0.5 } })
-- end, {})
setmap('n', 'glj', function()
  load_telescope('lsp_dynamic_workspace_symbols', 'ver', { layout_config = { mirror = true, preview_width = 0.5 } })
end, {})
