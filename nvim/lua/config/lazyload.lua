-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

---@desc Nvim-select-multi-line {{{2
vim.keymap.set('n', '<Leader>v', function()
  require('nvim-select-multi-line').start()
end)

---@desc OpenBrowser {{{2
vim.g.openbrowser_open_vim_command = 'split'
vim.g.openbrowser_use_vimproc = 0
vim.keymap.set('n', '<SPACE>/', "<Cmd>call openbrowser#_keymap_smart_search('n')<CR>")
vim.keymap.set('x', '<SPACE>/', "<Cmd>call openbrowser#_keymap_smart_search('v')<CR>")
-- vim.keymap.set({ "n", "x" }, "<SPACE>/", "<Plug>(openbrowser-smart-search)")

---@desc Operator-replace {{{2
vim.keymap.set('n', '_', '"*<Plug>(operator-replace)')
vim.keymap.set('n', '\\', '"0<Plug>(operator-replace)')

---@desc Vim-sandwich {{{2
if vim.g.loaded_sandwich then
  vim.keymap.set({ 'n' }, '<Leader>i', '<Plug>(operator-sandwich-add)i')
  vim.keymap.set({ 'n' }, '<Leader>a', '<Plug>(operator-sandwich-add)a')
  vim.keymap.set({ 'x' }, '<Leader>a', '<Plug>(operator-sandwich-add)')
  vim.keymap.set({ 'n', 'x' }, '<Leader>r', '<Plug>(sandwich-replace)')
  vim.keymap.set({ 'n' }, '<Leader>rr', '<Plug>(sandwich-replace-auto)')
  vim.keymap.set({ 'n', 'x' }, '<Leader>d', '<Plug>(sandwich-delete)')
  vim.keymap.set({ 'n' }, '<Leader>dd', '<Plug>(sandwich-delete-auto)')
  vim.keymap.set({ 'o', 'x' }, 'ib', '<Plug>(textobj-sandwich-auto-i)')
  vim.keymap.set({ 'o', 'x' }, 'ab', '<Plug>(textobj-sandwich-auto-a)')

  local recipes = vim.deepcopy(vim.g['sandwich#default_recipes'])
  recipes = vim.list_extend(recipes, {
    { buns = { "\\'", "\\'" }, input = { "\\'" } },
    { buns = { '\\"', '\\"' }, input = { '\\"' } },
    { buns = { '【', '】' }, input = { ']' }, filetype = { 'markdown' } },
    { buns = { '${', '}' }, input = { '$' }, filetype = { 'typescript', 'javascript' } },
    { buns = { '%(', '%)' }, input = { '%' }, filetype = { 'typescript', 'javascript' } },
  })
  vim.g['sandwich#recipes'] = recipes
  vim.g['sandwich#magicchar#f#patterns'] = {
    {
      header = [[\<\%(\h\k*\.\)*\h\k*]],
      bra = '(',
      ket = ')',
      footer = '',
    },
  }
end

---@desc Quickrun {{{2
vim.keymap.set({ 'n', 'v' }, 'mq', function()
  local prefix = ''
  local mode = vim.api.nvim_get_mode().mode

  if mode:find('^[vV\x16]') then
    local s = vim.fn.line('v')
    local e = vim.api.nvim_win_get_cursor(0)[1]

    if s > e then
      s, e = e, s
    end

    prefix = string.format('%s,%s', s, e)
  end

  vim.cmd(string.format('%sQuickRun', prefix))
end, {})

---@see https://github.com/yuki-yano/dotfiles/blob/main/.vim/lua/plugins/utils.lua
local jobs = {}
vim.g.quickrun_config = {
  ['_'] = {
    outputter = 'error',
    ['outputter/error/success'] = 'buffer',
    ['outputter/error/error'] = 'quickfix',
    ['outputter/buffer/opener'] = ':botright 5split',
    ['outputter/buffer/close_on_empty'] = 0,
    runner = 'neovim_job',
    hooks = {
      {
        on_ready = function(session, _)
          local job_id = nil
          if session._temp_names then
            job_id = session._temp_names[1]
            jobs[job_id] = { finish = false }
          end

          vim.notify(string.format('[QuickRun] Running %s ...', session.config.command), 'warn', {
            title = ' QuickRun',
          })
        end,
        on_success = function(_, _)
          vim.notify('[QuickRun] Success', 'info', { title = ' QuickRun' })
        end,
        on_failure = function(_, _)
          vim.notify('[QuickRun] Error', 'error', { title = ' QuickRun' })
        end,
        on_finish = function(session, _)
          if session._temp_names then
            local job_id = session._temp_names[1]
            jobs[job_id].finish = true
          end
        end,
      },
    },
  },
  typescript = { type = 'deno' },
  deno = {
    command = 'deno',
    cmdopt = '--no-check --allow-all --unstable',
    tempfile = '%{tempname()}.ts',
    exec = { '%c run %o %S' },
  },
  lua = {
    command = ':luafile',
    exec = { '%C %S' },
    runner = 'vimscript',
  },
  javascript = { type = 'ppx' },
  ppx = {
    command = 'ppbw',
    cmdopt = '-c *stdout',
    tempfile = '%{tempname()}.js',
    exec = { '${PPX_DIR}/%c %o [PPx] %%*script(%S)' },
  },
  node = {
    command = 'node',
    tempfile = '%{tempname()}.js',
    exec = { '%c %S' },
  },
}

---@desc Smartword {{{2
vim.keymap.set('n', 'w', '<Plug>(smartword-w)')
vim.keymap.set('n', 'b', '<Plug>(smartword-b)')
vim.keymap.set('n', 'e', '<Plug>(smartword-e)')
vim.keymap.set('n', 'ge', '<Plug>(smartword-ge)')

---@desc Translate {{{2
vim.keymap.set({ 'n', 'x' }, 'me', '<Cmd>Translate EN<CR>', { silent = true })
vim.keymap.set({ 'n', 'x' }, 'mj', '<Cmd>Translate JA<CR>', { silent = true })
vim.keymap.set({ 'n', 'x' }, 'mE', '<Cmd>Translate EN -output=replace<CR>', { silent = true })
vim.keymap.set({ 'n', 'x' }, 'mJ', '<Cmd>Translate JA -output=replace<CR>', { silent = true })

---@desc Undotree {{{2
vim.keymap.set('n', '<F7>', function()
  vim.fn['undotree#UndotreeToggle']()
end)
vim.g.undotree_WindowLayout = 2
vim.g.undotree_ShortIndicators = 1
vim.g.undotree_SplitWidth = 28
vim.g.undotree_DiffpanelHeight = 6
vim.g.undotree_DiffAutoOpen = 1
vim.g.undotree_SetFocusWhenToggle = 1
vim.g.undotree_TreeNodeShape = '*'
vim.g.undotree_TreeVertShape = '|'
vim.g.undotree_DiffCommand = 'diff'
vim.g.undotree_RelativeTimestamp = 1
vim.g.undotree_HighlightChangedText = 1
vim.g.undotree_HighlightChangedWithSign = 1
vim.g.undotree_HighlightSyntaxAdd = 'DiffAdd'
vim.g.undotree_HighlightSyntaxChange = 'DiffChange'
vim.g.undotree_HighlightSyntaxDel = 'DiffDelete'
vim.g.undotree_HelpLine = 1
vim.g.undotree_CursorLine = 1
