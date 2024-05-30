-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------
local api = vim.api

---@desc Autocommand {{{2
local augroup = api.nvim_create_augroup('rcDeno', {})
api.nvim_create_autocmd('User', {
  group = augroup,
  pattern = 'skkeleton-initialize-pre',
  callback = function()
    Skkeleton_init()
  end,
})

---@desc Futago.vim {{{2
if vim.g.loaded_futago then
  local get_lines = function(opts)
    local has_selection = opts.range > 0
    local range = has_selection and { opts.line1 - 1, opts.line2 } or { 0, -1 }
    return api.nvim_buf_get_lines(0, range[1], range[2], false)
  end
  local gemini_chat = function(lines, futago_opts)
    api.nvim_create_autocmd('CursorMoved', {
      group = augroup,
      pattern = 'futago://*',
      once = true,
      callback = function()
        vim.defer_fn(function()
          if #lines == 1 and lines[1] == '' then
            return
          end
          vim.fn.append(2, lines)
          vim.api.nvim_win_call(0, function()
            vim.cmd.normal({'zz', bang = true})
          end)
          vim.cmd.write()
        end, 1000)
      end,
    })
    vim.fn['futago#start_chat'](futago_opts)
  end

  vim.g.futago_chat_path = string.format('%s\\%s', vim.env.tmp, 'vim_futago_log')
  vim.g.futago_safety_settings = {
    { category = 'HARM_CATEGORY_HATE_SPEECH', threshold = 'BLOCK_NONE' },
    { category = 'HARM_CATEGORY_SEXUALLY_EXPLICIT', threshold = 'BLOCK_NONE' },
    { category = 'HARM_CATEGORY_HARASSMENT', threshold = 'BLOCK_NONE' },
    { category = 'HARM_CATEGORY_DANGEROUS_CONTENT', threshold = 'BLOCK_NONE' },
  }
  api.nvim_create_user_command('Gemini', function(opts)
    gemini_chat({ opts.args }, { opener = 'split' })
  end, { nargs = '?', desc = 'Question to gemini' })
  api.nvim_create_user_command('GeminiAnnotate', function(opts)
    local ft = api.nvim_get_option_value('filetype', {})
    ft = ft == 'lua' and 'neovim v0.10.0 api lua' or ft
    gemini_chat(get_lines(opts), {
      opener = 'vsplit',
      history = { { role = 'user', parts = string.format('%sにアノテーションをつけてください', ft) } },
    })
  end, { range = true, desc = 'Add type annotations' })
  api.nvim_create_user_command('GeminiReview', function(opts)
    local ft = api.nvim_get_option_value('filetype', {})
    gemini_chat(get_lines(opts), {
      opener = 'vsplit',
      history = { { role = 'user', parts = string.format('%sをコードレビューしてください', ft) } },
    })
  end, { range = true, desc = 'Code review' })
  api.nvim_create_user_command('GeminiJestUnitTest', function(opts)
    local ft = api.nvim_get_option_value('filetype', {})
    gemini_chat(get_lines(opts), {
      opener = 'vsplit',
      history = { { role = 'user', parts = string.format('%sのJest単体テストを提案してください', ft) } },
    })
  end, { range = true, desc = 'Code review' })
  api.nvim_create_user_command('GeminiTranslateEnglish', function(opts)
    gemini_chat(
      get_lines(opts),
      { opener = 'vsplit', history = { { role = 'user', parts = '英訳してください' } } }
    )
  end, { range = true, desc = 'English translation' })
  api.nvim_create_user_command('GeminiTranslateJapanese', function(opts)
    gemini_chat(
      get_lines(opts),
      { opener = 'vsplit', history = { { role = 'user', parts = '和訳してください' } } }
    )
  end, { range = true, desc = 'Japanese translation' })
end

---@desc FuzzyMotion {{{2
if vim.g.fuzzy_motion_labels then
  vim.g.fuzzy_motion_matchers = { 'fzf', 'kensaku' }
  vim.g.fuzzy_motion_labels = { 'A', 'S', 'D', 'F', 'G', 'W', 'E', 'R', 'Z', 'X', 'C', 'V', 'B', 'T', 'Q' }
  -- vim.g.fuzzy_motion_word_filter_regexp_list = { '^[a-zA-Z0-9]' }
  -- vim.g.fuzzy_motion_word_regexp_list = [ '[0-9a-zA-Z_-]+', '([0-9a-zA-Z_-]|[.])+', '([0-9a-zA-Z_-]|[().#])+' ]
  -- vim.g.fuzzy_motion_auto_jump = false
  vim.keymap.set('n', '<Leader><leader>', function()
    if vim.fn['denops#plugin#is_loaded']('fuzzy-motion') == 0 then
      vim.fn['denops#plugin#load']('fuzzy-motion')
    end
    vim.cmd('FuzzyMotion')
  end)
end

---@desc Skkeleton {{{2
if vim.g.loaded_skkeleton then
  ---Keymaps {{{3
  local feedkey = require('module.util').feedkey
  vim.keymap.set({ 'i', 'c', 't' }, '<C-l>', '<Plug>(skkeleton-enable)')
  vim.keymap.set({ 'n' }, '<Space>i', function()
    vim.fn['skkeleton#handle']('enable', {})
    vim.cmd.startinsert()
  end)
  vim.keymap.set({ 'n' }, '<Space>I', function()
    vim.fn['skkeleton#handle']('enable', {})
    feedkey('I', 'n')
  end)
  vim.keymap.set({ 'n' }, '<Space>a', function()
    vim.fn['skkeleton#handle']('enable', {})
    feedkey('a', 'n')
  end)
  vim.keymap.set({ 'n' }, '<Space>A', function()
    vim.fn['skkeleton#handle']('enable', {})
    vim.cmd.startinsert({ bang = true })
  end)

  function Skkeleton_init() -- {{{3
    vim.fn['skkeleton#config']({
      databasePath = '~/.skk/db/jisyo.db',
      globalDictionaries = { '~/.skk/SKK-JISYO.L', '~/.skk/SKK-JISYO.emoji' },
      globalKanaTableFiles = { vim.g.repo .. '/myrepo/nvim/skk/azik_us.rule' },
      eggLikeNewline = true,
      usePopup = true,
      showCandidatesCount = 2,
      markerHenkan = '🐤 ',
      markerHenkanSelect = '🐥 ',
      sources = { 'deno_kv' },
      -- sources = { 'deno_kv', 'skk_dictionary' },
    })
    vim.fn['skkeleton#register_keymap']('input', '@', 'cancel')
    vim.fn['skkeleton#register_keymap']('input', '<Up>', 'disable')
    vim.fn['skkeleton#register_keymap']('input', '<Down>', 'disable')
    vim.fn['skkeleton#register_kanatable']('rom', {
      [':'] = { 'っ', '' },
      ['xq'] = 'hankatakana',
      ['vh'] = { '←', '' },
      ['vj'] = { '↓', '' },
      ['vk'] = { '↑', '' },
      ['vl'] = { '→', '' },
      ['z\x20'] = { '\u{3000}', '' },
      ['z-'] = { '-', '' },
      ['z~'] = { '〜', '' },
      ['z;'] = { ';', '' },
      ['z:'] = { ':', '' },
      ['z,'] = { ',', '' },
      ['z.'] = { '.', '' },
      ['z['] = { '【', '' },
      ['z]'] = { '】', '' },
    })
  end
end
