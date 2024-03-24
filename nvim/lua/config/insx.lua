-- vim:textwidth=0:foldmarker={@@,@@}:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

local insx = require('insx')
local esc = require('insx.helper.regex').esc

local user = {
  config = {
    cmdline = false,
    fast_break = false,
    fast_wrap = false,
    quote = { '"', "'", '`' },
    pair = { ['('] = ')', ['['] = ']', ['{'] = '}' },
    lua = false,
    markdown = false,
    javascript = false,
    misc = false,
  },
}

user.setup = function(config) -- {@@2
  user.config.quote = vim.tbl_extend('force', user.config.quote, config.quote or {})
  user.config.pair = vim.tbl_extend('force', user.config.pair, config.pair or {})
  config.quote, config.pair = nil, nil
  user.config = vim.tbl_extend('force', user.config, config or {})

  user:setup_insert_mode(10)
  user:setup_cmdline_mode(10)
  user:setup_lua(11)
  user:setup_markdown(11)
  user:setup_javascript(11)
  user:setup_misc(11)
end -- @@}

local general_pair = function(option, open, close, withs) -- {@@2
  -- jump_out
  insx.add(
    close,
    insx.with(
      require('insx.recipe.jump_next')({
        jump_pat = {
          [[\%#\s*]] .. esc(close) .. [[\zs]],
        },
      }),
      withs
    ),
    option
  )

  -- auto_pair
  insx.add(
    open,
    insx.with(
      require('insx.recipe.auto_pair')({
        open = open,
        close = close,
        ignore_pat = [[\%#@]],
      }),
      withs
    ),
    option
  )

  -- delete_pair
  insx.add(
    '<BS>',
    insx.with(
      require('insx.recipe.delete_pair')({
        open_pat = esc(open),
        close_pat = esc(close),
      }),
      withs
    ),
    option
  )
end -- @@}

local set_quote = function(mode, quote, priority) -- {@@2
  local withs = {
    insx.with.nomatch([=[\%#[a-zA-Z0-9]]=]),
    insx.with.priority(priority),
  }
  local option = { mode = mode }

  general_pair(option, quote, quote, withs)
end -- @@}

local set_pair = function(mode, open, close, priority) -- {@@2
  local withs = { insx.with.priority(priority) }
  local option = { mode = mode }

  general_pair(option, open, close, withs)

  insx.add(
    '<Tab>',
    insx.with(
      require('insx.recipe.pair_spacing').increase({
        open_pat = esc(open),
        close_pat = esc(close),
      }),
      withs
    ),
    option
  )

  insx.add(
    '<BS>',
    insx.with(
      require('insx.recipe.pair_spacing').decrease({
        open_pat = esc(open),
        close_pat = esc(close),
      }),
      withs
    ),
    option
  )

  if option.mode == 'i' then
    -- fast_break
    if user.config.fast_break then
      insx.add(
        '<CR>',
        insx.with(
          require('insx.recipe.fast_break')({
            open_pat = esc(open),
            close_pat = esc(close),
            html_attrs = false,
            arguments = true,
          }),
          withs
        ),
        option
      )
    end

    -- fast_wrap
    if user.config.fast_wrap then
      insx.add(
        '<C-]>',
        insx.with(
          require('insx.recipe.fast_wrap')({
            close = close,
          }),
          withs
        ),
        option
      )
    end
  end
end -- @@}

user.setup_insert_mode = function(self, priority) -- {@@2
  for _, quote in ipairs(self.config.quote) do
    set_quote('i', quote, priority)
  end

  for open, close in pairs(self.config.pair) do
    set_pair('i', open, close, priority)
  end
end -- @@}

user.setup_cmdline_mode = function(self, priority) -- {@@2
  if not self.config.cmdline then
    return
  end

  for _, quote in ipairs(self.config.quote) do
    set_quote('c', quote, priority)
  end

  for open, close in pairs(self.config.pair) do
    set_pair('c', open, close, priority)
  end
end -- @@}

user.setup_markdown = function(self, priority) -- {@@2
  if not self.config.markdown then
    return
  end

  insx.add('`', {
    priority = priority,
    enabled = function(ctx)
      return ctx.match([[`\%#`]]) and ctx.filetype == 'markdown'
    end,
    action = function(ctx)
      ctx.send('``<Left>')
      ctx.send('``<Left>')
    end,
  })

  insx.add(
    '<CR>',
    require('insx.recipe.fast_break')({
      open_pat = [[```\w*]],
      close_pat = '```',
      indent = 0,
    })
  )
end -- @@}

user.setup_lua = function(self, priority) -- {@@2
  if not self.config.lua then
    return
  end

  local option = { mode = 'i' }

  insx.add(
    '<C-f>',
    insx.with(
      require('insx.recipe.jump_next')({
        jump_pat = {
          [[\%#.\zs]],
        },
      }),
      { insx.with.priority(priority) }
    ),
    option
  )
  insx.add(
    '<C-f>',
    insx.with(
      require('insx.recipe.jump_next')({
        jump_pat = {
          [[\[\[.*\%#\]\]\zs]],
        },
      }),
      { insx.with.priority(priority + 1), insx.with.match([=[\%#\]]=]), insx.with.undopoint(false) }
    ),
    option
  )

  -- annotation
  insx.add('<Tab>', {
    priority = priority,
    enabled = function(ctx)
      return ctx.match([[^\s*@\%#]])
    end,
    action = function(ctx)
      ctx.send('<BS>---@')
    end,
  }, option)

  -- fold
  insx.add('{', {
    priority = priority,
    enabled = function(ctx)
      return ctx.match([[{{\%#]])
    end,
    action = function(ctx)
      if ctx.match([[\S{{\%#]]) then
        ctx.send('<BS><BS><Del><Del><Space>{{{')
      else
        ctx.send('<Del><Del>{')
      end
    end,
  }, option)
end -- @@}

user.setup_javascript = function(self, priority) -- {@@2
  if not self.config.javascript then
    return
  end

  local option = { mode = 'i' }

  insx.add('.', {
    priority = priority,
    enabled = function(ctx)
      return ctx.match([[\%(^\|\s\|(\)con\%#]]) and (ctx.filetype == 'javascript' or ctx.filetype == 'typescript')
    end,
    action = function(ctx)
      ctx.send('<BS><BS><BS>console.log()<Left>')
    end,
  }, option)
  insx.add('.', {
    priority = priority,
    enabled = function(ctx)
      return ctx.match([=[\%(^\|\s\|(\)pp[aeqtwx]\%#]=])
        and (ctx.filetype == 'javascript' or ctx.filetype == 'typescript')
    end,
    action = function(ctx)
      local row, col = ctx.row(), ctx.col()
      local chr = vim.api.nvim_buf_get_text(0, row, col - 1, row, col, {})[1]

      if chr == 'a' then
        ctx.send('<C-w>PPx.Arguments')
      elseif chr == 'e' then
        ctx.send('<C-w>PPx.Execute()<Left>')
      elseif chr == 't' then
        ctx.send('<C-w>PPx.Extract()<Left>')
      elseif chr == 'q' then
        ctx.send('<C-w>PPx.Quit(1);<Left><Left><Left>')
      elseif chr == 'x' then
        ctx.send('<C-w>PPx.')
      elseif chr == 'w' then
        ctx.send('<C-w>PPx.Echo()<Left>')
      end
    end,
  }, option)
end -- @@}

user.setup_misc = function(self, priority) -- {@@2
  if not self.config.misc then
    return
  end

  local option = { mode = 'i' }

  insx.add(
    '<C-f>',
    insx.with(
      require('insx.recipe.jump_next')({
        jump_pat = {
          [=[\%#['"`]\+[)}\]]\zs]=],
          [=[\%#\s*[)}\]]\+\zs]=],
        },
      }),
      { insx.with.priority(priority + 1), insx.with.match([=[\%#\s*['"`)}\]]\+]=]), insx.with.undopoint(false) }
    ),
    option
  )

  insx.add(
    '<C-f>',
    insx.with(
      require('insx.recipe.jump_next')({
        jump_pat = {
          [=[\%#\s*=>\?\zs]=],
        },
      }),
      { insx.with.priority(priority + 1), insx.with.match([=[\%#\s*=]=]), insx.with.undopoint(false) }
    ),
    option
  )

  insx.add('<Tab>', {
    action = function(ctx)
      if ctx.match([[/\w\+/\w*\%#$]]) then
        -- path completion
        ctx.send('<C-g>u<C-x><C-f>')
        return
      elseif ctx.match([[^\s\+\%#]]) and (ctx.filetype == 'cfg' or ctx.filetype == 'text') then
        -- convert indent spaces to tabs
        local line = vim.api.nvim_get_current_line():sub(0, vim.api.nvim_win_get_cursor(0)[2])
        local col = vim.fn.strdisplaywidth(line)
        local ts = vim.o.tabstop
        local n = math.floor(col / ts)
        if n > 0 then
          ctx.send('<C-u>' .. ('<C-v><Tab>'):rep(n))
          return
        end
      end
      ctx.send('<Tab>')
    end,
  }, option)
end -- @@}

return user
