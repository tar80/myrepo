-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------
local api = vim.api
local augroup = api.nvim_create_augroup('rc_futago', { clear = true })
local cache_dir = os.getenv('XDG_CACHE_HOME')
local result_path = function(path) -- {{{2
  return ('%s/futago/%s'):format(cache_dir, path)
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
      api.nvim_set_var('futago_log_file', result_path('log'))
      api.nvim_set_var('futago_history_db', result_path('db/history.db'))
      api.nvim_set_var('futago_safety_settings', {
        { category = 'HARM_CATEGORY_HATE_SPEECH', threshold = 'BLOCK_NONE' },
        { category = 'HARM_CATEGORY_SEXUALLY_EXPLICIT', threshold = 'BLOCK_NONE' },
        { category = 'HARM_CATEGORY_HARASSMENT', threshold = 'BLOCK_NONE' },
        { category = 'HARM_CATEGORY_DANGEROUS_CONTENT', threshold = 'BLOCK_NONE' },
      })
      api.nvim_create_user_command('Gemini', function(opts)
        start_chat({ opts.args }, {
          opener = 'split',
          history = {
            {
              role = 'user',
              parts = {
                {
                  text = [[質問文を注意深く読み、質問者の意図を正確に理解する。
                    ハルシネーションを起こさないよう、最新のドキュメントや情報を参照する。
                    回答に自信がない場合は、正直にその旨を伝える。]]
                  ,
                },
              },
            },
            { role = 'model', parts = { { text = '心得ました。質問をどうぞ' } } },
          },
        })
      end, { nargs = '?', desc = 'Question to gemini' })
      api.nvim_create_user_command('GeminiAnnotate', function(opts)
        local ft = api.nvim_get_option_value('filetype', {})
        ft = ft == 'lua' and 'neovim v0.10.0 api lua' or ft
        start_chat(get_lines(opts), {
          opener = 'vsplit',
          history = {
            { role = 'user', parts = { { text = string.format('Please annotate %s', ft) } } },
          },
        })
      end, { range = true, desc = 'Add type annotations' })
      api.nvim_create_user_command('GeminiReview', function(opts)
        local ft = api.nvim_get_option_value('filetype', {})
        start_chat(get_lines(opts), {
          opener = 'vsplit',
          history = {
            { role = 'user', parts = { { text = string.format('%sをレビューしてください', ft) } } },
          },
        })
      end, { range = true, desc = 'Code review' })
      api.nvim_create_user_command('GeminiJest', function(opts)
        local ft = api.nvim_get_option_value('filetype', {})
        start_chat(get_lines(opts), {
          opener = 'vsplit',
          history = {
            {
              role = 'user',
              parts = { { text = string.format('%sのJest単体テストを提案してください', ft) } },
            },
          },
        })
      end, { range = true, desc = 'Create jest test' })
      api.nvim_create_user_command('GeminiBusted', function(opts)
        local ft = api.nvim_get_option_value('filetype', {})
        start_chat(get_lines(opts), {
          opener = 'vsplit',
          history = {
            {
              role = 'user',
              parts = { { text = string.format('%sのBusted単体テストを提案してください', ft) } },
            },
          },
        })
      end, { range = true, desc = 'Create busted test' })
      api.nvim_create_user_command('GeminiCommitMessage', function(opts)
        local _prompt = {
          'あなたはgit commit message作成のエキスパートです',
          'あなたの目的はコンベンショナルコミット記法に従ったコミットメッセージの作成です。',
          '行動規範:',
          '1.見出し行の作成: ユーザーからのインプットに基づいて、以下のルールに従って見出し行を作成します。 前置詞を含め、全体で50文字以内に収めます。 大文字を使用しない英文で記述します。',
          '2.内容の作成: ユーザーからの詳細な説明に基づいて、コミットメッセージの内容を作成します。全体を英文で記述します。 各行は80文字以内で折り返します。',
          '3.diffの要約: git diffのリザルトを提供された場合、その内容を理解し英文で簡潔に要約します。',
          '4.フォーマット: 作成したコミットメッセージ全体をコードブロックで囲まないでください。',
          '5.できあがったコミットメッセージを提示します',
          'これ以降にインプットとgit diffが提示される場合があります。',
          unpack(get_lines(opts)),
        }
        vim.fn['futago#git_commit']({
          prompt = vim.fn.join(_prompt, ''),
        })
      end, { range = true, desc = 'Commit message' })
      api.nvim_create_user_command('GeminiTranslateEnglish', function(opts)
        start_chat(get_lines(opts), {
          opener = 'vsplit',
          history = {
            { role = 'user', parts = { { text = '英訳してください' } } },
          },
        })
      end, { range = true, desc = 'English translation' })
      api.nvim_create_user_command('GeminiTranslateJapanese', function(opts)
        start_chat(get_lines(opts), {
          opener = 'vsplit',
          history = {
            { role = 'user', parts = { { text = '和訳してください' } } },
          },
        })
      end, { range = true, desc = 'Japanese translation' })
    end,
  },
}
