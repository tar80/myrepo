-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

---@desc Abbreviate
---@see https://zenn.dev/vim_jp/articles/2023-06-30-vim-substitute-tips
local cmd_abbrev = function(i, o, s)
  local ignore_space = s and '[getchar(), ""][1].' or ''
  local fmt =
    string.format('<expr> %s getcmdtype().getcmdline() ==# ":%s" ? %s"%s" : "%s"', i, i, ignore_space, o, i)
  vim.cmd.cnoreabbrev(fmt)
end

vim.cmd.abbreviate('exoprt', 'export')
vim.cmd.abbreviate('exoper', 'export')
vim.cmd.abbreviate('funcion', 'function')
vim.cmd.abbreviate('fuction', 'function')
vim.cmd.abbreviate('stirng', 'string')

cmd_abbrev("'<,'>", [['<,'>s/\\//\\\\\\\\/|nohlsearch]], true)
cmd_abbrev('s', '%s///<Left>', true)
cmd_abbrev('ms', 'MugShow', true)
cmd_abbrev('e8', 'e<Space>++enc=utf-8<CR>')
cmd_abbrev('e16', 'e<Space>++enc=utf-16le<CR>')
cmd_abbrev('gs', 'lua<Space>require("config.gits")<CR>')
cmd_abbrev('sc', 'set<Space>scb<Space><Bar><Space>wincmd<Space>p<Space><Bar><Space>set<Space>scb<CR>')
cmd_abbrev('scn', 'set<Space>noscb<CR>')
cmd_abbrev('del', [[call<Space>delete(expand('%'))]])
cmd_abbrev('cs', [[execute<Space>'50vsplit'g:repo.'/myrepo/nvim/.cheatsheet'<CR>]])
cmd_abbrev('dd', 'diffthis<Bar>wincmd<Space>p<Bar>diffthis<Bar>wincmd<Space>p<CR>')
cmd_abbrev('dof', 'syntax<Space>enable<Bar>diffoff<CR>')
cmd_abbrev('dor', 'vert<Space>bel<Space>new<Space>difforg<Bar>set<Space>bt=nofile<Bar>r<Space>++edit<Space>#<Bar>0d_<Bar>windo<Space>diffthis<Bar>wincmd<Space>p<CR>')
cmd_abbrev('ht', 'so<Space>$VIMRUNTIME/syntax/hitest.vim', true)
cmd_abbrev('ct', 'so<Space>$VIMRUNTIME/syntax/colortest.vim', true)
cmd_abbrev('hl', "lua<Space>print(require('module.util').hl_at_cursor())<CR>")

---@desc Smartinput
---@template: rule({ at = '', char = '', input = '', mode = '', filetype = '', syntax = '' })

-- #Triggers {{{2
local trigger = vim.fn['smartinput#map_to_trigger']

trigger('i', '<Plug>(smartinput_CR)', '<Enter>', '<Enter>')
trigger('i', '<Plug>(smartinput_C-h)', '<BS>', '<C-h>')
-- trigger('i', '<Plug>(smartinput_Space)', '<Space>', '<C-g>U<Space>')
-- trigger('i', '<Space>', '<Space>', '<C-g>U<Space>')
trigger('i', '<Tab>', '<Tab>', '<Tab>')
trigger('i', '<C-f>', '<C-f>', '<C-f>')
-- trigger("i", ";", ";", ";")
trigger('i', '=', '=', '=')
trigger('i', '.', '.', '.')
trigger('c', '<CR>', '<CR>', '<CR>')
-- trigger('c', '<Space>', '<Space>', '<Space>')

-- #Rules {{{2
local rule = vim.fn['smartinput#define_rule']

local multi_at = function(at, rulespec)
  for _, value in pairs(at) do
    rulespec['at'] = value
    rule(rulespec)
  end
end

-- Auto completion path
rule({ at = [[/\w\+/\%#$]], char = '<Tab>', input = '<C-g>u<C-x><C-f>' })

-- Replace indent of spaces to tab
rule({ at = '^\\s\\+\\%#$', char = '<Tab>', input = '<C-u><C-v><Tab>' })

-- Leave Tab
rule({ at = '\\%#', char = '<C-f>', input = '<Right>' })
multi_at({ '\\%#[\'`"])', '\\%#[\'`"]}' }, { char = '<C-f>', input = '<C-g>U<Right><Right>' })
-- Leave Semicolon
-- multi_at({ "\\%#['`\"])$", "\\%#['`\"]}$" }, { char = ";", input = "<C-g>U<Right><Right>;" })
-- rule({ at = "\\%#[)}]$", char = ";", input = "<C-g>U<Right>;" })
-- Leave Equal
rule({ at = '\\%#[\'`"]]$', char = '=', input = '<C-g>U<Right><Right><Space>=<Space>' })
rule({ at = '\\%#]$', char = '=', input = '<C-g>U<Right><Space>=<Space>' })

-- #nodejs {{{3
rule({ at = 'log\\%#', char = '.', input = '<C-w>console.log()<Left>', filetype = { 'javascript', 'typescript' } })

-- ##PPx {{{3
-- ppx -> . -> PPx.
rule({
  at = '\\(^\\|\\s\\|(\\)ppx\\%#',
  char = '.',
  input = '<BS><BS><BS>PPx.',
  filetype = { 'lua', 'javascript', 'typescript' },
})
-- ppa| -> . -> PPx.Arguments(|);
rule({ at = 'ppa\\%#', char = '.', input = '<C-w>PPx.Arguments', filetype = { 'javascript', 'typescript' } })
-- ppe| -> . -> PPx.Execute(|);
rule({ at = 'ppe\\%#', char = '.', input = '<C-w>PPx.Execute()<Left>', filetype = { 'javascript', 'typescript' } })
-- ppt| -> . -> PPx.Extract(|);
rule({ at = 'ppt\\%#', char = '.', input = '<C-w>PPx.Extract()<Left>', filetype = { 'javascript', 'typescript' } })
-- ppq| -> . -> PPx.Quit(|1);
rule({
  at = 'ppq\\%#',
  char = '.',
  input = '<C-w>PPx.Quit(1);<Left><Left><Left>',
  filetype = { 'javascript', 'typescript' },
})
-- ppw| -> . -> PPx.Echo(|);
rule({ at = 'ppw\\%#', char = '.', input = '<C-w>PPx.Echo();<Left><Left>', filetype = { 'javascript', 'typescript' } })
-- mmw| -> . -> msg.echo(|);
rule({ at = 'mmw\\%#', char = '.', input = '<C-w>msg.echo();<Left><Left>', filetype = { 'javascript', 'typescript' } })

-- ##Lua {{{3
-- ^| @ -> <Space> -> ---@
rule({ at = '^\\s*@\\%#$', char = '<Tab>', input = '<BS>---@', filetype = { 'lua' } })
rule({ at = '^\\s*--\\[\\%#\\]$', char = '[', input = '[<Del><CR>--<Space><CR>--]]<Home><Left>', filetype = { 'lua' } })
-- pp -> . -> vim.print(|)
rule({ at = 'vp\\%#', char = '.', input = '<BS><BS>vim.print()<Left>', filetype = { 'lua' } })
-- va -> . -> vim.api.nvim_|
rule({ at = 'va\\%#', char = '.', input = '<BS><BS>vim.api.nvim_', filetype = { 'lua' } })

-- ##Folding {{{3
rule({ at = '\\s"{{\\%#"', char = '{', input = '{2<Del>', mode = 'i', filetype = { 'vim', 'lua' } })
rule({ at = '\\S{{\\%#}}', char = '{', input = '<BS><BS><Space>{{{<Del><Del>', filetype = { 'vim', 'lua' } })
rule({ at = '\\s{{\\%#}}', char = '{', input = '{<Del><Del>', filetype = { 'vim', 'lua' } })

-- ##Bracket {{{3
local bracketList = { { '(', ')' }, { '{', '}' }, { '[', ']' } }

for _, v in ipairs(bracketList) do
  -- Behavior when there are letters behind
  rule({ at = '\\%#\\()\\|}\\|]\\|\\s\\|$\\)\\@!', char = v[1], input = v[1] })
  -- Input bracket without Leave-Block
  rule({ at = '\\%#\\n\\s*', char = v[2], input = v[2] })
end

-- Individualized responses
--  (|) -> <Space> -> ( | )
multi_at({ '(\\s*\\%#\\s*)', '{\\s*\\%#\\s*}', '\\[\\s*\\%#\\s*]' }, { char = '<Tab>', input = '<Space><Space><Left>' })
-- ( | ) -> <BS> -> (|)
multi_at({ '(\\s*\\%#\\s*)', '{\\s*\\%#\\s*}', '\\[\\s*\\%#\\s*]' }, { char = '<BS>', input = '<BS><Del>' })

-- ##Quote {{{3
local quoteList = { '"', '`', "'" }

for _, quote in ipairs(quoteList) do
  multi_at(
    { '\\s\\%#\\(\\s\\|$\\)', '(\\%#)', '{\\%#}', '\\[\\%#]' },
    { char = quote, input = quote .. quote .. '<left>' }
  )
  rule({ at = '\\%#', char = quote, input = quote })
end
--}}}2
