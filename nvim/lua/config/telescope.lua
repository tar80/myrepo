-- vim:textwidth=0:foldmarker={@@,@@}:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------
local setmap = vim.keymap.set
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local conf = require('telescope.config').values
local builtin = require('telescope.builtin')
local fb_actions = require('telescope').extensions.file_browser.actions

---@see https://scrapbox.io/vim-jp/mr.vim%E3%82%92%E5%A5%BD%E3%81%8D%E3%81%AAFuzzy_Finder%E3%81%8B%E3%82%89%E4%BD%BF%E3%81%86_%28telescope%29
local function simple_sorter(opts) -- {@@2
  local file_sorter = conf.file_sorter(opts)
  local base_scorer = file_sorter.scoring_function
  local score_match = require('telescope.sorters').empty().scoring_function()
  file_sorter.scoring_function = function(self, prompt, line)
    local score = base_scorer(self, prompt, line)
    if score <= 0 then
      return -1
    else
      return score_match
    end
  end
  return file_sorter
end

function builtin.mr(opts) -- {@@2
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
      sorter = simple_sorter(safe_opts),
      -- sorter = require('telescope.sorters').get_fzy_sorter(list),
    })
    :find()
end

---@desc Setup {@@1
require('telescope').setup({
  defaults = { ---{@@2
    path_display = { truncate = 1 },
    winblend = 10,
    previewer = false,
    cache_picker = false,
    color_devicons = false,
    file_ignore_patterns = { -- {@@3
      'lazy-lock.json',
      '^%.git[/\\]',
      '[/\\]%.git[/\\]',
      '^%.bundle[/\\]',
      '[/\\]%.bundle[/\\]',
      'node_modules[/\\]',
      'vendor[/\\]',
      'migemo[/\\]',
    }, -- @@}
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
    vimgrep_arguments = { -- {@@3
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--trim',
      '--glob=!{node_modules,vendor,migemo,.bundle,.git}/',
    }, -- @@}
    mappings = { -- {@@3
      i = {
        ['<C-s>'] = actions.file_split,
        ['<C-k>'] = actions.preview_scrolling_up,
        ['<C-j>'] = actions.preview_scrolling_down,
        ['<C-g>'] = actions.close,
        ['<C-a>'] = { '<Home>', type = 'command' },
        ['<C-e>'] = { '<End>', type = 'command' },
        ['<C-d>'] = function(prompt_bufnr)
          local current_picker = action_state.get_current_picker(prompt_bufnr)
          if current_picker.prompt_title == 'Most Recently Use' then
            local filename = action_state.get_selected_entry()[1]
            current_picker:remove_selection(current_picker:get_selection_row())
            vim.notify(string.format('[mru] cache deleted "%s"', filename), 3)
            vim.fn['mr#mru#delete'](filename)
          end
        end,
      },
      n = {
        ['<C-g>'] = actions.close,
      },
    }, -- @@}
  }, ---@@}
  pickers = { -- {@@2
    buffers = {
      sort_mru = true,
      mappings = { i = { ['<C-D>'] = actions.delete_buffer } },
    },
    -- find_files = {
    --   find_command = function()
    --     return { 'rg', '--files', '--color', 'never' }
    --     --   return { 'fd', '--type', 'f', '--color', 'never' }
    --   end,
    -- },
    live_grep = {
      max_results = 100,
      disable_coordinates = true,
    },
    current_buffer_fuzzy_find = {
      skip_empty_lines = true,
    },
    git_bcommits = {
      mappings = {
        i = {
          ['<C-x>'] = function(bufnr)
            local hash = action_state.get_selected_entry().value
            vim.schedule(function()
              vim.cmd('MugDiff bottom ' .. hash)
            end)
            return actions.close(bufnr)
          end,
          ['<C-v>'] = function(bufnr)
            local hash = action_state.get_selected_entry().value
            vim.schedule(function()
              vim.cmd('MugDiff right ' .. hash)
            end)
            return actions.close(bufnr)
          end,
        },
      },
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
  extensions = { -- {@@2
    file_browser = {
      grouped = true,
      hidden = { file_browser = true, folder_browser = true },
      respect_gitignore = false,
      follow_symlinks = false,
      -- quiet = false,
      -- dir_icon = '',
      dir_icon_hl = 'Directory',
      display_stat = false,
      use_fd = true,
      git_status = false,
      prompt_path = true,
      mappings = {
        ['i'] = {
          ['<C-h>'] = fb_actions.goto_parent_dir,
          ['<C-t>'] = actions.file_tab,
          ['<C-k>'] = actions.preview_scrolling_up,
          ['<C-j>'] = actions.preview_scrolling_down,
        },
        ['n'] = {},
      },
    },
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
  }, -- @@}
})
require('telescope').load_extension('file_browser')
require('telescope').load_extension('ui-select')
require('telescope').load_extension('kensaku')

---@desc Previewer {@@1
local preset_no_preview = { -- {@@2
  results_title = false,
  previewer = false,
  layout_config = { height = 0.7, width = 0.6 },
}

local preset_preview_hor = { -- {@@2
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

local preset_preview_ver = { -- {@@2
  -- winblend = 9,
  results_title = false,
  path_display = function(_, path)
    return string.format('%s ', path)
  end,
}

local function no_preview(add) -- {@@2
  return require('telescope.themes').get_dropdown(vim.tbl_deep_extend('force', preset_no_preview, add))
end

local function preview_hor(add) -- {@@2
  return require('telescope.themes').get_dropdown(vim.tbl_deep_extend('force', preset_preview_hor, add))
end

local function preview_ver(add) -- {@@2
  return vim.tbl_deep_extend('force', preset_preview_ver, add)
end --@@}
local layout = { no = no_preview, hor = preview_hor, ver = preview_ver }
local function load_builtin(picker, preview, add) -- {@@2
  local sub_window = layout[preview]
  builtin[picker](sub_window(add))
end
local function load_ext(picker, preview, add) -- {@@2
  local sub_window = layout[preview]
  require('telescope').extensions[picker][picker](sub_window(add))
end

---@desc Keymap {@@2
setmap('n', '<Leader>:', function()
  load_builtin('buffers', 'no', { ignore_current_buffer = true })
end, {})
setmap('n', '<leader>m', function()
  load_builtin('mr', 'no', {})
end, {})
setmap('n', '<leader>p', function()
  local path = vim.fn.expand('%:h:p')
  load_ext('file_browser', 'no', { path = path })
end, {})
setmap('n', '<leader>o', function()
  load_builtin('find_files', 'no', { hidden = true, no_ignore = true })
end, {})
setmap('n', '<leader>k', function()
  local path = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
  load_ext('kensaku', 'hor', { cwd = path })
end, {})
setmap('n', '<leader>K', function()
  load_ext('kensaku', 'hor', {})
end, {})
setmap('n', '<leader>h', function()
  local slash = vim.o.shellslash
  vim.o.shellslash = false
  load_builtin('help_tags', 'ver', { layout_config = { preview_width = 0.7, width = 0.8, height = 0.9 } })
  vim.o.shellslash = slash
end, {})
setmap('n', '<leader>l', function()
  load_builtin(
    'current_buffer_fuzzy_find',
    'ver',
    { layout_config = { preview_width = 0.5, width = 0.9, height = 0.9 } }
  )
end, {})

---@desc For git {@@1
local function is_repo()
  local name = vim.b.mug_branch_name
  ---@diagnostic disable-next-line: undefined-field
  if name == _G.Mug.symbol_not_repository then
    vim.notify('Not repository', 3)
    return false
  end
  return true
end
setmap('n', '<Leader>gb', function()
  if is_repo() then
    load_builtin('git_branches', 'ver', {})
  end
end, {})
setmap('n', '<Leader>gC', function()
  if is_repo() then
    load_builtin('git_commits', 'ver', {
      git_command = { 'git', 'log', '--oneline', '-20', '--abbrev-commit', '--', '.' },
      layout_config = { mirror = false, preview_width = 0.55, width = 0.9, height = 0.9 },
    })
  end
end, {})
setmap('n', '<Leader>gc', function()
  if is_repo() then
    load_builtin('git_bcommits', 'ver', {
      git_command = { 'git', 'log', '--oneline', '-20' },
      layout_config = { mirror = false, preview_width = 0.55, width = 0.9, height = 0.9 },
    })
  end
end, {})

---"Z <filepath>" zoxide query
vim.api.nvim_create_user_command('Z', function(opts)
  vim.system({ 'zoxide', 'query', opts.args }, { text = true }, function(data)
    vim.schedule(function()
      if data.code == 0 and data.stdout then
        local path = data.stdout:gsub('\n', '')
        load_ext('file_browser', 'no', { path = path })
      else
        vim.notify('[zoxide] no match found', 3)
      end
    end)
  end)
end, { nargs = 1 })
