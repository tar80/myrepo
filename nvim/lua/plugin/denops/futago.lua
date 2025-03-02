-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------
local api = vim.api
local augroup = api.nvim_create_augroup('rc_futago', { clear = true })
local _tmp_dir = os.getenv('tmp')
local result_path = function(path) -- {{{2
  return ('%s/futago/%s'):format(_tmp_dir, path)
end

local get_lines = function(opts) -- {{{2
  local has_selection = opts.range > 0
  local range = has_selection and { opts.line1 - 1, opts.line2 } or { 0, -1 }
  return api.nvim_buf_get_lines(0, range[1], range[2], false)
end

local start_chat = function(lines, futago_opts) -- {{{2
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
          vim.cmd.normal({ 'zz', bang = true })
        end)
        vim.cmd.write()
      end, 1000)
    end,
  })
  vim.fn['futago#start_chat'](futago_opts)
end --}}}

return { -- {{{1 futago
  {
    'yukimemi/futago.vim',
    event = 'VeryLazy',
    config = function()
      -- api.nvim_set_var('futago_debug', true)
      api.nvim_set_var('futago_chat_path', result_path('chat'))
      api.nvim_set_var('futago_log_file', result_path('log/futago.log'))
      api.nvim_set_var('futago_historu_db', result_path('db/history.db'))
      api.nvim_set_var('futago_safety_settings', {
        { category = 'HARM_CATEGORY_HATE_SPEECH', threshold = 'BLOCK_NONE' },
        { category = 'HARM_CATEGORY_SEXUALLY_EXPLICIT', threshold = 'BLOCK_NONE' },
        { category = 'HARM_CATEGORY_HARASSMENT', threshold = 'BLOCK_NONE' },
        { category = 'HARM_CATEGORY_DANGEROUS_CONTENT', threshold = 'BLOCK_NONE' },
      })
      api.nvim_create_user_command('Gemini', function(opts)
        start_chat({ opts.args }, { opener = 'split' })
      end, { nargs = '?', desc = 'Question to gemini' })
      api.nvim_create_user_command('GeminiAnnotate', function(opts)
        local ft = api.nvim_get_option_value('filetype', {})
        ft = ft == 'lua' and 'neovim v0.10.0 api lua' or ft
        start_chat(get_lines(opts), {
          opener = 'vsplit',
          history = {
            { role = 'user', parts = string.format('%sにアノテーションをつけてください', ft) },
          },
        })
      end, { range = true, desc = 'Add type annotations' })
      api.nvim_create_user_command('GeminiReview', function(opts)
        local ft = api.nvim_get_option_value('filetype', {})
        start_chat(get_lines(opts), {
          opener = 'vsplit',
          history = { { role = 'user', parts = string.format('%sをレビューしてください', ft) } },
        })
      end, { range = true, desc = 'Code review' })
      api.nvim_create_user_command('GeminiJest', function(opts)
        local ft = api.nvim_get_option_value('filetype', {})
        start_chat(get_lines(opts), {
          opener = 'vsplit',
          history = {
            { role = 'user', parts = string.format('%sのJest単体テストを提案してください', ft) },
          },
        })
      end, { range = true, desc = 'Code review' })
      api.nvim_create_user_command('GeminiBusted', function(opts)
        local ft = api.nvim_get_option_value('filetype', {})
        start_chat(get_lines(opts), {
          opener = 'vsplit',
          history = {
            { role = 'user', parts = string.format('%sのBusted単体テストを提案してください', ft) },
          },
        })
      end, { range = true, desc = 'Code review' })
      api.nvim_create_user_command('GeminiCommitMessage', function(opts)
        local _prompt = {
          'Please generate the following commit message using Conventional Commit notation',
          'using no uppercase letters and using up to 50 characters in english.',
          'If listed, add message from the contents of the git diff.',
          unpack(get_lines(opts)),
        }
        vim.fn['futago#git_commit']({
          prompt = vim.fn.join(_prompt, ''),
        })
      end, { range = true, desc = 'Commit message' })
      api.nvim_create_user_command('GeminiTranslateEnglish', function(opts)
        start_chat(
          get_lines(opts),
          { opener = 'edit', history = { { role = 'user', parts = '英訳してください' } } }
        )
      end, { range = true, desc = 'English translation' })
      api.nvim_create_user_command('GeminiTranslateJapanese', function(opts)
        start_chat(
          get_lines(opts),
          { opener = 'edit', history = { { role = 'user', parts = '和訳してください' } } }
        )
      end, { range = true, desc = 'Japanese translation' })
    end,
  },
}
