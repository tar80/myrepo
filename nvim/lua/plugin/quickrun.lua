--- vim:textwidth=0:foldmethod=marker:foldlevel=1:
-------------------------------------------------------------------------------
local api = vim.api
local keymap = vim.keymap

return {
  { 'tar80/vim-quickrun-neovim-job', branch = 'win-nyagos', lazy = true },
  { -- {{{ quickrun
    'thinca/vim-quickrun',
    cmd = 'QuickRun',
    keys = {
      {
        'mq',
        function()
          local prefix = ''
          local mode = api.nvim_get_mode().mode

          if mode:find('^[vV\x16]') then
            local start = vim.fn.line('v')
            local end_ = api.nvim_win_get_cursor(0)[1]

            if start > end_ then
              start, end_ = end_, start
            end

            prefix = string.format('%s,%s', start, end_)
          end

          vim.cmd(string.format('%sQuickRun', prefix))
        end,
        mode = { 'n', 'v' },
        desc = 'QuickRun',
      },
    },
    init = function()
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

                vim.notify(string.format('[QuickRun] Running %s ...', session.config.command), vim.log.levels.WARN, {
                  title = ' QuickRun',
                })
              end,
              on_success = function(_, _)
                vim.cmd('echon "[QuickRun] Success"')
              end,
              on_failure = function(_, _)
                vim.notify('[QuickRun] Error', vim.log.levels.ERROR, { title = ' QuickRun' })
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
          cmdopt = '--no-check --allow-all',
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
          exec = { '${PPX_DIR}/%C %o [PPx] %%*script(%S)' },
        },
        node = {
          command = 'node',
          tempfile = '%{tempname()}.js',
          exec = { '%c %S' },
        },
      }
    end,
  }, -- }}}
}
